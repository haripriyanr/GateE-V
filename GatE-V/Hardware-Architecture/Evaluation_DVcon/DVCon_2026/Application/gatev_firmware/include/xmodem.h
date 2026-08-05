#ifndef INCLUDE_XMODEM_H_
#define INCLUDE_XMODEM_H_

//#include	<stdio.h>
//#include	<stdint.h>
//#include	<stdlib.h>
//#include	<string.h>
#include	"xmodem-crc.h"

#define XMODEM_SUCCESS 0
#define XMODEM_FAILED 	1

#define		SOH		0x01	//start of heading
#define		STX		0x02	//start of text
#define		ETX		0x03	//end of text
#define		EOT		0x04	//end of transmission
#define 	ACK		0x06
#define		LF		0x0A
#define		CR		0x0D
#define		NAK		0x15	//nACK
#define		CAN		0x18	//cancel
#define		SUB		0x1A	//SUBstitute
#define		C		0x43	//used for sending info as to the CRC used
#define 	PACKET_LENGTH_DATA	128 //for XMODEM
#define		PACKET_LENGTH	(1 + 1 + 1 + PACKET_LENGTH_DATA + 2) //133 bytes for XMODEM
#define		BAD_PACKET			 	-1
#define		DUPLICATE_PACKET	 	-2
#define 	PACKET_NUM_ERROR		-3
#define		EOK						 0x1
#define 	END_OF_TRANS			 1


//********************************************************************************************
/***********************************Header Declarations***************************************/
UI receive_file_uart(UI pMemoryLoc);
UI 	xmodem_receive_file(UC *p_buffer,UI packet_renum,UI WLocation,UI pLoc);

UI 	validate_packet(UC *pPacket, UI nPacket_renum);
//static	void	Concatenate_Xmodem_Buffers(UC *pArrayBuffer,UI nPackNum,UI pMemory);




#endif /* INCLUDE_XMODEM_H_ */
