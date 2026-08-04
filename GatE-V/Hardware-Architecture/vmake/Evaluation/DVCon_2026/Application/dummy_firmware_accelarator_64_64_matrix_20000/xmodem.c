
 /* Including Section
  *
**************************************************************************************/
#include	"xmodem.h"
#include	"uart.h"
#include	"config.h"

extern UI 	crc_table_computed;                          //Verify as to the availability of crc tab;e

extern US  	g_gen_poly ;

 UC   packetarray[133];    			// for 128 data packet + 3 byte header + 2 byte CRC

/************************************************************************************************
 * Description				:	receive_file
 * Parameters				:	Memory write location
 * Globals					:	xmodem standard characters
 * Returns					:	Success/Failed
 * Notes					:	This function will  receive uart file using xmodem protocol
 *								// for 50mHz and baudrate 115200 - loop count should be greater than 12000 [Out-of-order processor testing -riscv]
 ***********************************************************************************************
 */

 /************************************************************************************************
 * Description				:	receive_packet
 * Parameters				:	charcter pointer to hold the packet
 * Globals					:
 * Returns					:	Success/Failed
 * Notes					:	This function will  receive a packet of 132 bytes
 *
 ************************************************************************************************
 */

static UI receive_packet(UC *pPacket)
 {
	UI nCharacter;



	for (UC bByteCount = 1; bByteCount < PACKET_LENGTH; ++bByteCount) { //receive 132 bytes
		nCharacter = rx_uart();   				 //receive byte from uart
		pPacket[bByteCount] = nCharacter;

	   }
	return XMODEM_SUCCESS;
 }

 /************************************************************************************************
 * Description				:	WriteData2Memory
 * Parameters				:	charcter pointer to hold the packet,Word Location,Memory address
 * Globals					:
 * Returns					:	Success/Failed
 * Notes					:	This function will  receive a packet of 132 bytes
 *
 ***********************************************************************************************
 */

static	void WriteData2Memory(UC *pArrayBuffer,UL	pMemory)
{

	UC *pbData = (UC *)pMemory;

	for(UC	bWordCount = 0;bWordCount < 128 ;bWordCount++)     	//Total data byte is 128
	{
		*pbData = *pArrayBuffer;
		pArrayBuffer++;
		pbData++;


	}


 	return;
}

UI receive_file_uart(UI pMemoryLoc)
{
	 UI  nWLoc = 0,npack = 1,nLoc = 0,nActualSize = 0x0,i;
 	 char bRxFlag = 0;
	 UC lsr;

	 crc_table_computed = 0;                          //Verify as to the availability of crc table
	 g_gen_poly = 0x1021U;

     while (bRxFlag == 0)
     {
		 tx_uart(C);  //To indicate that rx is ready
		 for(i = 0; i < 6000000; i++) // for 50mHz and baudrate 115200 - loop count should be greater than 12000 [Out-of-order processor testing -riscv]
		 {
			 lsr=uart_regs.UART_LSR;
			 if((lsr & 0x1)==1)
			 {////Data transmission started from PC
				bRxFlag = 1;
				break;
			 }
		 }
     }


	 	while (1) {
			packetarray[0] = rx_uart();
			if(packetarray[0]!= SOH)
				break;					//receive all packets until EOT
	 		receive_packet(packetarray);                             				//receive all bytes within a packet
	 		nLoc = xmodem_receive_file(packetarray,npack,nWLoc,pMemoryLoc);    		//validate packet and write to memory
	 		if(nLoc!= nWLoc)                                             			//check whether bytes written to memory
	 		{
	 			nWLoc = nLoc;
	 			npack = npack + 1;
	 			nActualSize += 128;
	 			if (npack  > 0xFF)                                        		//packetnum cannot be exceed 256
	 				npack  = 0;
	 		}
	 	}
	 	if(packetarray[0] == EOT){
	 		tx_uart(ACK);
			return nActualSize;
		}
    return XMODEM_FAILED;
}


/********************************************************************************************
 * Description				:	xmodem_receive_file
 * Parameters				:	character array,packet number,Word location,Memory write Location
 * Globals					:	xmodem standard characters
 * Returns					:	Success/Failed
 * Notes					:	This function will  receive uart file using xmodem protocol
 *
 *********************************************************************************************
 */


UI xmodem_receive_file(UC *p_buffer,UI packet_renum,UI WLocation,UI pLoc)
{
	UI nStatus;
	nStatus = validate_packet(p_buffer, packet_renum);		//validate the received packet

	switch (nStatus) {
		case EOK:                                    		//case received packet:ok
			WriteData2Memory(p_buffer+3,WLocation + pLoc);    //write 128 data byte to memory
			WLocation = WLocation + 128;               		//increment Byte index
			tx_uart(ACK);                     		//send the acknowledgement
			break;

		case BAD_PACKET:                       				//error in packet
			tx_uart(NAK);                   		//send NAK
			break;

		case PACKET_NUM_ERROR:               				//error in packet due to packet number
			tx_uart(CAN);               			//send cancel
			break;

		case DUPLICATE_PACKET:              			 	//error because current packet is duplicate to previous                 			                     //but data not written to memory
			tx_uart(ACK);                 			 //send ack
			break;
		}
	return WLocation;
}





/************************************************************************************************
 * Description				:	Concatenate_Xmodem_Buffers
 * Parameters				:	charcter pointer to hold the packet,packetnum,Memory address to which data to be written
 * Globals					:
 * Returns					:	None
 * Notes					:	This function will  write 256 Bytes to the SPI FLASH
 ***********************************************************************************************
 */


/*static	void	Concatenate_Xmodem_Buffers(UC *pArrayBuffer,UI nPackNum,UI pMemory){
	static char bArray[256];
	if(nPackNum % 2){
		strcat(bArray,pArrayBuffer);
		pMemory -= 128;
		Write_SPI_Flash(bArray,256,pMemory);
		memset(bArray,0,256);
	}
	else
	{
		strcpy(bArray,pArrayBuffer);
	}
	return;
}*/

/***********************************************************************************************
 * Description				:	validate_packet
 * Parameters				:	charcter pointer to hold the packet,packet number
 * Globals					:
 * Returns					:	Success/Failed
 * Notes					:	This function will check the received packet using CRC 16 bit algorithm
 *
 ***********************************************************************************************
 */

UI validate_packet(UC *pPacket, UI nPacket_renum)
 {
	UI nRemender = 0;
		if (pPacket[1] == nPacket_renum) {
		if ( (pPacket[1] + pPacket[2]) == 0xFF) {
			nRemender = Compute_CRC(pPacket + 3, PACKET_LENGTH -  3);    //Check the CRC
			if(nRemender == 0) {
				return EOK;         //Valid packet
			}
			else {
				return BAD_PACKET;  //CRC failed
			}
		}
		else {
		return BAD_PACKET;
		}
	} /*packet checksum completed*/
	else if (pPacket[1] == (nPacket_renum - 1)) { //duplicate packet
		return DUPLICATE_PACKET;
	}
	else { //incorrect packet number

		return PACKET_NUM_ERROR;
	}
	return XMODEM_SUCCESS;
 }
