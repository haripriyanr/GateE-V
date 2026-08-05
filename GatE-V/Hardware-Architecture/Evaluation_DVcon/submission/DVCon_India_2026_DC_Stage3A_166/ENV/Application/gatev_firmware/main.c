#include "uart.h"
#include "stdlib.h"

UL g_program_entry;
volatile UL core_flag;
UL g_dtb_address;

#define write_csr(reg, val) ({ \
  asm volatile ("csrw " #reg ", %0" :: "rK"(val)); })

#define GATEV_BASE      0x20040000UL
#define REG_CTRL        0x00
#define REG_STATUS      0x04
#define REG_TASK_ID     0x08
#define REG_MODE        0x0C
#define REG_IMG_BASE    0x10
#define REG_WT_BASE     0x14
#define REG_OUT_BASE    0x18
#define REG_TILES_NUM   0x1C
#define REG_BURST_TYPE  0x30
#define REG_BURST_LEN   0x34
#define REG_PERF_CYCLE_LOW    0x40
#define REG_PERF_READ_BYTES   0x48
#define REG_PERF_WRITE_BYTES  0x4C
#define REG_PERF_MAC_CYCLES   0x50
#define REG_PERF_STALL_CYCLES 0x54

#define STATUS_DONE_BIT 0

#define SRAM_IMG_BASE   0x00020000UL
#define SRAM_WT_BASE    0x00021000UL
#define SRAM_OUT_BASE   0x00022000UL

#define NUM_TILES       4
#define TILES_PER_LAYER 4

volatile unsigned int * const gatev = (volatile unsigned int *)(GATEV_BASE);

void Flush_Cache_data(void)
{
    write_csr(0x5c8, 1);
    write_csr(0x5c0, 1);
}

void fill_ones(volatile unsigned char *p, unsigned int bytes)
{
    for (unsigned int i = 0; i < bytes; i++)
        p[i] = 0x01;
}

void reg_write(unsigned int off, unsigned int val)
{
    unsigned int tmp;
    *(gatev + (off >> 2)) = val;
    tmp = *gatev;
    (void)tmp;
}

unsigned int reg_read(unsigned int off)
{
    return *(gatev + (off >> 2));
}

int main(void)
{
    unsigned int tmp;
    int overall_fail = 0;

    /* Initialize UART immediately */
    init_uart(0x02);   /* baud divisor for 50 MHz: ~1.5625 Mbaud */
    printf("\n\r====================================================\n\r");
    printf("GatE-V Accelerator Firmware Multi-Test Suite (Team 166)\n\r");
    printf("====================================================\n\r");

    for (unsigned int run_cnt = 1; ; run_cnt++) {
        unsigned int tiles = (run_cnt == 1) ? 4 : (((run_cnt % 4) == 0) ? 8 : (((run_cnt % 3) == 0) ? 2 : (((run_cnt % 2) == 0) ? 1 : 4)));
        unsigned int task_id = 0x000000A0 + (run_cnt & 0x0F);
        int run_fail = 0;

        /* Fill activations & weights */
        fill_ones((volatile unsigned char *)SRAM_IMG_BASE, tiles * 32);
        fill_ones((volatile unsigned char *)SRAM_WT_BASE, 512);
        Flush_Cache_data();

        /* Register configuration */
        reg_write(REG_TASK_ID, task_id);
        reg_write(REG_MODE,    0x00000042);
        reg_write(REG_TILES_NUM, tiles);
        reg_write(REG_IMG_BASE,  SRAM_IMG_BASE);
        reg_write(REG_WT_BASE,   SRAM_WT_BASE);
        reg_write(REG_OUT_BASE,  SRAM_OUT_BASE);
        reg_write(REG_BURST_TYPE, 0x00000001);  /* INCR */
        reg_write(REG_BURST_LEN,  0x0000003F);  /* 64 beats */

        /* Start accelerator */
        reg_write(REG_CTRL, 0x00000001);

        if (run_cnt == 1) {
            printf("Accelerator started (Run 1), waiting for done...\n\r");
        }

        tmp = 0;
        while (!(reg_read(REG_STATUS) & (1 << STATUS_DONE_BIT))) {
            if (++tmp > 10000000UL) {
                printf("TIMEOUT waiting for acc_done on Run %u!\n\r", run_cnt);
                run_fail = 1;
                break;
            }
        }

        if (run_fail) {
            overall_fail = 1;
            break;
        }

        /* Verify layer outputs */
        int l, w, b;
        volatile unsigned char *out = (volatile unsigned char *)SRAM_OUT_BASE;
        int run_err = 0;

        for (l = 0; l < 6; l++) {
            int exp = (l == 5) ? 127 : 93;
            unsigned int layer_bytes = l * tiles * 16;
            for (w = 0; w < (int)(tiles * 2); w++) {
                unsigned int off = layer_bytes + (w << 3);
                for (b = 0; b < 8; b++) {
                    if (out[off + b] != exp)
                        run_err++;
                }
            }
        }

        if (run_err > 0) {
            printf("Run %u output error detected! (%d mismatches)\n\r", run_cnt, run_err);
            run_fail = 1;
            overall_fail = 1;
            break;
        }

        if (run_cnt == 1) {
            printf("acc_done asserted. Verifying layer outputs...\n\r");
            for (l = 0; l < 6; l++) {
                int exp = (l == 5) ? 127 : 93;
                unsigned int layer_bytes = l * tiles * 16;
                printf("  Layer %d @ 0x%lx = %d (%d tiles x 16 ch) [OK]\n\r",
                       l, (unsigned long)(SRAM_OUT_BASE + layer_bytes), exp, tiles);
            }
            printf("Performance counters:\n\r");
            printf("  Cycles(lo):  %u\n\r", reg_read(REG_PERF_CYCLE_LOW));
            printf("  Read bytes:  %u\n\r", reg_read(REG_PERF_READ_BYTES));
            printf("  Write bytes: %u\n\r", reg_read(REG_PERF_WRITE_BYTES));
            printf("  MAC cycles:  %u\n\r", reg_read(REG_PERF_MAC_CYCLES));
            printf("  Stall cycles:%u\n\r", reg_read(REG_PERF_STALL_CYCLES));
            printf("\n\r===== GATE-V ACCELERATOR TEST PASSED =====\n\r");
        } else {
            printf("[RUN %u] Tiles=%u TaskID=0x%x status=PASS (Cycles=%u)\n\r",
                   run_cnt, tiles, task_id, reg_read(REG_PERF_CYCLE_LOW));
        }
    }

    if (overall_fail) {
        printf("\n\r===== GATE-V ACCELERATOR TEST FAILED =====\n\r");
    }

    while (1);
}
