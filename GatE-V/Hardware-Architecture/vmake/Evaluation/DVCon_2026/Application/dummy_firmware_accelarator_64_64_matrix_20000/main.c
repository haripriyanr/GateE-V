#include "uart.h"
#include "xmodem.h"
#include "stdlib.h"

UL g_program_entry;
volatile UL core_flag;
UL g_dtb_address;

volatile unsigned int * accelarator_base, * accelarator_dst_addr_lsb_matrix_a, * accelarator_dst_addr_msb_matrix_a;
volatile unsigned int  * accelarator_dst_addr_lsb_matrix_b, * accelarator_dst_addr_msb_matrix_b;
volatile unsigned int  * accelarator_dst_addr_lsb_matrix_c, * accelarator_dst_addr_msb_matrix_c;
volatile int * matrix_a,* matrix_b, * matrix_c;


#define write_csr(reg, val) ({ \
  asm volatile ("csrw " #reg ", %0" :: "rK"(val)); }) 


void Flush_Cache_data(void)
{
    write_csr(0x5c8,1);
	write_csr(0x5c0,1);
}
 
 


int main(void) {

	init_uart(0x1b);
printf("S>\n");

	/*unsigned int matrix_a= 0xBF000000;
	unsigned int matrix_b= 0xBF001100;
	unsigned int matrix_c= 0xBF002200;

*/

#ifndef TEST
	matrix_a = (volatile int *) (0x20000);
	matrix_b = (volatile int *) (0x22000);
	matrix_c = (volatile int *) (0x24000);
	//test_mem = (volatile int *) (0x20800);
	accelarator_base = (volatile unsigned int *) (0x20040000);
	accelarator_dst_addr_lsb_matrix_a = (volatile unsigned int *) (0x20040010);
	accelarator_dst_addr_msb_matrix_a = (volatile unsigned int *) (0x20040014);
	accelarator_dst_addr_lsb_matrix_b = (volatile unsigned int *) (0x2004001c);
	accelarator_dst_addr_msb_matrix_b = (volatile unsigned int *) (0x20040020);
	accelarator_dst_addr_lsb_matrix_c = (volatile unsigned int *) (0x20040028);
	accelarator_dst_addr_msb_matrix_c = (volatile unsigned int *) (0x2004002c);

	int temp=0;

	unsigned int data_hex[4100]={0,};
	
	for(int i=0;i<4096;i++)
	{
		data_hex[i]=0x40400000;
	}


	for(int i=0;i<4096;i++)
	{
		*matrix_a = data_hex[i];		
		//printf("%d:%x\n\r", i, *matrix_a);	
		matrix_a++;
	}
	for(int i=0;i<4096;i++)
	{
		*matrix_b = data_hex[i];		
		//printf("%d:%x\n\r", i, *matrix_b);
		matrix_b++;
	}


	Flush_Cache_data();

	rx_uart();

	temp = *accelarator_base;
	*(accelarator_dst_addr_lsb_matrix_a) = 0x20000;
	temp = *accelarator_base;
	*(accelarator_dst_addr_msb_matrix_a) = 0x0;
	temp = *accelarator_base;	
	*(accelarator_dst_addr_lsb_matrix_b) = 0x22000;
	temp = *accelarator_base;
	*(accelarator_dst_addr_msb_matrix_b) = 0x0;
	temp = *accelarator_base;
	*(accelarator_dst_addr_lsb_matrix_c) = 0x24000;
	temp = *accelarator_base;
	*(accelarator_dst_addr_msb_matrix_c) = 0x0;
	temp = *accelarator_base;
	*accelarator_base = 0x1;

			

	while(1)
	{
		temp = *accelarator_base;
		if((temp&0x2)==0x2)
		{
			//printf("S\n\r");
			break;
		}
	}

	matrix_c = (volatile int *) (0x24000);
	for(int i=0;i<4096;i++)
	{			
			printf("%d:%x\n\r", i, *matrix_c);			
		matrix_c++;
	}
	printf("matrix c:%x\n\r",  *(accelarator_dst_addr_lsb_matrix_c));
#endif

	while(1);

}
