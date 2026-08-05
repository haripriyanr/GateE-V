
 /* Including Section
  *
***********************************************************************************/
#include	"xmodem-crc.h"

UI 	crc_table_computed;                          //Verify as to the availability of crc tab;e
US  	crc_table[256];
US  	g_gen_poly;

/**************************************************************************************************
 * Description				:	Compute_CRC
 * Parameters				:	message,number of bytes in message
 * Globals					:	CRC-CCITT general polynomial
 * Returns					:	CRC of the message
 * Notes					:	This function will calculate the CRC of the given message
 *
 ************************************************************************************************
 */
US  Compute_CRC(UC  bMessage[], int nBytes){
    US          sRemainder = INITIAL_REMAINDER;        		////Modified in accordance with standard crc implemetation in xmodem protocol
    for (UI nByte = 0; nByte < nBytes; ++nByte)
    {
    	sRemainder ^=  ((bMessage[nByte])  <<  (WIDTH - 8));     	//Bring the next byte into the remainder
    		for (UC  bit = 8; bit > 0; --bit)
    			{
    																// Try to divide the current data bit.
    			if (sRemainder & TOPBIT)
    				{
    				sRemainder = (sRemainder << 1) ^ g_gen_poly;
    				}
    			else
    				{
    				sRemainder = (sRemainder << 1);
    				}
    			}
    }
    return ((sRemainder) ^ 0x0000);                        			 //Modified in accordance with standard crc implemetation in xmodem protocol
}

