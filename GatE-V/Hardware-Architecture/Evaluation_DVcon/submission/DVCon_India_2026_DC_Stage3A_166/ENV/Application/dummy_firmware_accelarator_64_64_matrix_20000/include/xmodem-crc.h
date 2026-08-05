#ifndef INCLUDE_XMODEM_CRC_H_
#define INCLUDE_XMODEM_CRC_H_
#include "stdlib.h"



#define 	WIDTH  16
#define  	INITIAL_REMAINDER	0x0000
#define 	TOPBIT   (1 << (WIDTH - 1))
//**************************************************Headers***********************************
US  	Compute_CRC(UC  bMessage[], int nBytes);

#endif /* INCLUDE_XMODEM_CRC_H_ */
