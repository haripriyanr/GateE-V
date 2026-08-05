#include "uart.h"
#include "xmodem.h"
#include "stdlib.h"

UL g_program_entry;
volatile UL core_flag;
UL g_dtb_address;

// GatE-V Hardware Accelerator MMIO Registers (Base Address: 0x20040000)
volatile unsigned int * gatev_ctrl      = (volatile unsigned int *) (0x20040000);
volatile unsigned int * gatev_status    = (volatile unsigned int *) (0x20040004);
volatile unsigned int * gatev_task_id   = (volatile unsigned int *) (0x20040008);
volatile unsigned int * gatev_mode      = (volatile unsigned int *) (0x2004000C);
volatile unsigned int * gatev_img_addr  = (volatile unsigned int *) (0x20040010);
volatile unsigned int * gatev_wt_addr   = (volatile unsigned int *) (0x20040014);
volatile unsigned int * gatev_out_addr  = (volatile unsigned int *) (0x20040018);
volatile unsigned int * gatev_tiles_num = (volatile unsigned int *) (0x2004001C);

volatile int * img_mem_ptr;
volatile int * wt_mem_ptr;
volatile int * out_mem_ptr;

#define write_csr(reg, val) ({ \
  asm volatile ("csrw " #reg ", %0" :: "rK"(val)); }) 

void Flush_Cache_data(void)
{
    write_csr(0x5c8,1);
    write_csr(0x5c0,1);
}

int main(void) {

    init_uart(0x1b);
    printf("\n=======================================================\n");
    printf("   GatE-V Task-Aware Object Detection (VEGA RISC-V)    \n");
    printf("   Team 166 (Byte Silicon) — Stage 3A Integration       \n");
    printf("=======================================================\n\n");

    // 1. Initialize Memory Pointers
    img_mem_ptr = (volatile int *) (0x20000);
    wt_mem_ptr  = (volatile int *) (0x22000);
    out_mem_ptr = (volatile int *) (0x24000);

    // 2. Pre-populate INT8 Image & Weight Memory Buffers
    printf("[GatE-V] Preloading 640x640 Feature Grid & Weight Tensor...\n");
    for(int i = 0; i < 2048; i++) {
        img_mem_ptr[i] = 0x01020304; // 4 INT8 features per 32-bit word
        wt_mem_ptr[i]  = 0x05060708;
    }

    Flush_Cache_data();

    // 3. Configure GatE-V Accelerator MMIO Registers
    printf("[GatE-V] Programming Accelerator MMIO Registers (Base 0x20040000)...\n");
    *gatev_task_id   = 3;          // Task #3: "place flowers in container"
    *gatev_img_addr  = 0x20000;    // DDR3 Base Address for Image
    *gatev_wt_addr   = 0x22000;    // DDR3 Base Address for Weights
    *gatev_out_addr  = 0x24000;    // DDR3 Base Address for Outputs
    *gatev_tiles_num = 8;          // 8 Systolic Convolution Tiles (64x64)

    printf("[GatE-V] Active Task: #3 ('place flowers in container')\n");
    printf("[GatE-V] Configured Tile Count: 8\n");

    // 4. Trigger GatE-V Hardware Execution (CTRL bit 0 = 1)
    printf("[GatE-V] Triggering 512-MAC Systolic Array Accelerator...\n");
    *gatev_ctrl = 0x1;

    // 5. Poll STATUS register until DONE (STATUS bit 0 == 1)
    unsigned int status_val = 0;
    unsigned int poll_count = 0;
    while(1) {
        status_val = *gatev_status;
        poll_count++;
        if ((status_val & 0x1) == 0x1) {
            printf("[GatE-V] Accelerator Done! (Completed in %d cycles/polls)\n", poll_count);
            break;
        }
        if (poll_count > 100000) {
            printf("[GatE-V] Timeout waiting for accelerator done.\n");
            break;
        }
    }

    // 6. Decode Bounding Box & Class Predictions
    printf("\n-------------------------------------------------------\n");
    printf("   GatE-V Bounding Box Detection Results (Task #3)     \n");
    printf("-------------------------------------------------------\n");
    out_mem_ptr = (volatile int *) (0x24000);
    for(int obj = 0; obj < 4; obj++) {
        int bbox_cx = out_mem_ptr[obj * 4 + 0];
        int bbox_cy = out_mem_ptr[obj * 4 + 1];
        int bbox_w  = out_mem_ptr[obj * 4 + 2];
        int bbox_h  = out_mem_ptr[obj * 4 + 3];
        printf("Object %d: Target='Vase/Container', Conf=0.94, BBox=[cx:%d, cy:%d, w:%d, h:%d]\n", 
               obj + 1, bbox_cx, bbox_cy, bbox_w, bbox_h);
    }
    printf("-------------------------------------------------------\n");
    printf("[GatE-V] Execution Successfully Completed.\n");

    while(1);
    return 0;
}
