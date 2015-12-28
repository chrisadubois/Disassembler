***************************************************
*address registers and data registers being used and their purposes start
*for start and ending addressing stage
*A0 -
*A1 -
*A2 -
*A3 - 
*A4 - Starting address holder
*A5 - Ending address holder
*A5 -
*A6 -
*A6 -
*D0 - Printing
*D1 - 
*D2 -
*D3 -
*D4 -
*D5 -
*D6 -
*D7 -
*for decoding stage
*A0 - Used to hold various jump tables (opcode, ea, etc)
*A1 - Printer / good buffer & bad buffer
*A2 - used after x instructions have been printed 
*A3 - 
*A4 - Starting address holder (gets incremented to the end)
*A5 - Ending address holder (stays the same)
*A6 - Holds the ending address of the instruction in the buffer for clearing the buffer purposes (and then moving to the next instruction address and it's associated instruction)
*A6 - Used to decode the instruction address and instruction into ascii from hex, while also being used for the toggler[what's incremented based on the toggle] (in the same purpose)
*D0 - Printing
*D1 - Reading the word data of the instruction
*D2 - D2 is used for toggling for hex to ascii
*D3 - decode address into ascii
*D4 - Keep track of bytes to add to the current starting address to determine what the next start address INSTRUCTION will be 
*D5 - d5 is used for holding the shift amount of the isntruction to decode the opcode / also, used for converting absolute addressing and immediate data instructions to hex to ascii
*D6 - Used to remember the opcode while decoding an instruction specified at a longword address
*D7 - Used somewhat to check destination modes (associated with an opcode) against destination register bits
*address registers and data registers being used and their purposes end
***************************************************


***************************************************
*the opcodes and their correlates start
*4 bits						
*0000	SUBI	ORI	EORI	BTST	CMPI	
*0001	MOVE.B				
*0010	MOVEA.L	MOVE.L				
*0011	MOVEA.W	MOVE.W				
*0100	MOVEM	LEA	NEG	NOT	JSR	RTS *we have to change the jump table logic here because right now it automatically jumps to NOP OpCODE0100 will have diff logic 
*0101	ADDQ					
*0110	BEQ	BNE	BLT	BHI	BRA	
*0111						
*1000	DIVS					
*1001	SUB	SUBA				
*1010						
*1011	EOR	CMP	CMPA			
*1100	MULS	AND				
*1101	ADD	ADDA				
*1110	LSD	ASD	ROD			
*1111				
*the opcodes and their correlates end
***************************************************

*-----------------------------------------------------------
* Title      : Disassembler 
* Written by : The Three Stooges
* Date       : November 10, 2015
* Description: Beginning of project
*-----------------------------------------------------------
CR                  EQU    $0D
LF                  EQU    $0A
GOOD_BUFFER         EQU    $5000
COUNTINSTRPRINT     EQU    $6000
HEXTOASCIIMEM       EQU    $4500
HEXTOASCIIFLAG      EQU    $4550
EADNEAANFLAG        EQU    $4560
DISPLACEMENTADDR    EQU    $4580


    ORG    $1000
START:                  ; first instruction of program
***************************************************************************************************************** 
* Introduction to Disassembler
                LEA         INTROMSG,A1                 *Load INTROMSG into address register 1
                MOVE.B      #14, D0                     *Put the number 14 into data register 0
                TRAP        #15                         *Print INTROMSG out of A1
                LEA         HEXTOASCIIFLAG,A6           *set the toggle to nothing at the beginning
                MOVE.B      #$00,(A6)                   *for hex to ascii
                
GETSTARTADDR    
                MOVE.B      #0, D7           
                LEA         REQUSTARTADDR, A1           *Loads REQUSTARTADDR into address register 1
                MOVE.B      #14,D0                      *Puts number 14 into data register 0
                TRAP        #15                         *Print REQUESTARTADDR
                MOVE.B      #2,D0                       *Put the number 2 into data register 0 TRAP TASK 2
                MOVEA.L     #$4000, A1                  *Places $4000 into address register 1
                TRAP        #15                         *Read user input  as NULL terminated string from keyboard into address reg 1 and stores length in d1
                BSR         CHECKSTRLEN                 *Make sure the address is between 1 and 32 (inclusive) bits
                MOVEA.L     A1, A2                      *A2 Points to what A1 points to
                MOVEA.L     A2, A3                      *A3 points to what a2 points to
                BRA         ASCIIHEXCONV                *Convert input to HEX
GETENDINGADDR
                MOVE.B      #1, D7
                LEA         REQUESTENDINGADDR, A1       *LOADS REQUESTADDR INTO ADDRESS REG 1
                MOVE.B      #14, D0                     *Puts number 14 into data register 0
                TRAP        #15                         *print requestendingaddr
                MOVE.B      #2,D0                       *Put the number 2 into data register 0 TRAP TASK 2
                MOVEA.L     #$4000, A1                  *Places $4000 into address register 1
                TRAP        #15                         *Read user input  as NULL terminated string from keyboard into address reg 1 and stores length in d1
                BSR         CHECKSTRLEN                 *Make sure the address is between 1 and 32 (inclusive) bits
                MOVEA.L     A1, A2                      *A2 Points to what A1 points to
                MOVEA.L     A2, A3                      *A3 points to what a2 points to
                BRA         ASCIIHEXCONV                *Convert input to HEX
                

              
                BRA     BADDATA             ; halt simulator
***************************************************************************************************************** 
*Start of I/O start and end* reusable checks
*Check to see if starting address is valid
CHECKSTARTADDR
                CLR.L       D0                          *Clear Long value in data register 0
                CMPI.L      #$00007000, D3              *Compare the starting address to $7000
                BLT         ADDRLOW                     *Branch to ADDRLOW if starting address is less than $7000
                MOVEA.L     D3, A4                      *Make Address register 4 point to the address equivalent to the value in D3
                BSR         CHECKEVENADDR               *Make sure the address starts and ends on an even boundary
                CLR.L       D3                          *Clear data register 3
                BRA         GETENDINGADDR               *Get ending addr
                
CHECKENDADDR
                CLR.L       D0                          *Clear long value in data register 0
                CMP.L       A4, D3                      *Compare the ending address to the starting address
                BLT         ADDRLOW                     *Branch to ADDRLOW if ending address is less than starting address
                CMPI.L      #$0000FFFF, D3              *Compare ending address to $FFFF
                BGT         ADDRHI                      *Branch to ADDRHI if ending address is greater than FFFF
                MOVEA.L     D3,A5                       *Make Address register 5 point to the address equivalent to the value in D3
                BSR         CHECKEVENADDR               *Make sure the address starts and ends on an even boundary
                CLR.L       D3                          *Clear long value in data register 3                                                                                            
                LEA         GOOD_BUFFER,A1              *Place $00050000 into address register 6
                LEA         HEXTOASCIIMEM, A6           *Place $4500 into address register 7
                MOVE.L      A4,(A6)                     *Place the starting address (A4) into A6
                BRA         HEX_TO_ASCII                  

FIRST4BITS
                MOVE.B      #$01, (A6)                  *this is a flag for hex to ascii to make sure that it goes into first 4 bits when converting instruction addresses rather than the instruction itself (for flags #$01, and #$02)
                MOVE.W      (A4),D1                     *Move the first word of the starting address into data register 1
                MOVE.B      #12, D5                     *move the amount of shifting into d5 to get around the problem that you cant shift more rthan 8 with immediate data
                LSR.W       D5,D1                       *SHIFT right 12 bits to look at 4 MSB
                LEA         OPCODETABLE,A0              *hold the jump table in A0
                MOVE.B      D1, D6                      *D6 will hold the opcode while we decode the rest of the instruction (the source and the destination)
                MULU        #6, D1                      *multiply the bits in D1 by 6 to form the offset?
                JSR         0(A0,D1)                    *jump indirect with indexing?                                   

HEX_TO_ASCII   
                CMPI.B      #$07, D1                    *if the number 7 is greater than the length stored in d1, then we're done looping
                BGT         CHECKHEXFLAG                *so we grab the first 4 bits from the data
                ADDI.B      #$01, D1                    *and keep looping 
                MOVE.B      (A6),D3                     *A6 contains the byte of the actual address, and d3 is used to decode that hex address into ascii
                BRA         DECIDESHIFT                 *decide if the shift is going to look at the first nibble of the byte or the last nibble of the byte to convert it to ascii
CHECKHEXFLAG
                LEA         HEXTOASCIIFLAG, A6          *the hex to ascii flag is used for determining if we are converting a starting address, ending address, instruction word, and what step to take next
                CMPI.B      #$00, (A6)                  *compare to flag, 00, is for starting address of instruction grabbing opcode, 01, is for source part, 02 is for dest, and 3 is when done with dest so print buffer
                BEQ         FIRST4BITS                  *time to look at the first four bits
                CMPI.B      #$01, (A6)                  *if the flag is equal to 1, then we are "done with the source part" (source doesn't always actually mean source, it is code reused for other opcodes as well, grabbing certain bits)
                BEQ         DONEWITHSOURCE              *done with the source
                CMPI.B      #$02, (A6)                  *if the flag is equal to 1, then we are "done with the dest part" (source doesn't always actually mean source, it is code reused for other opcodes as well, grabbing certain bits)
                BEQ         DONEWITHDEST                *done with the destination
                CMPI.B      #$03, (A6)                  *number 3 is a flag for when we are ready to print out the full instruction
                BEQ         PRINTGOODBUFFER             *print the stuff (good or bad)
                CMPI.B      #$04, (A6)                  *number 4 is a flag for operations that use an ea table that we need to verify against the opcode and other bits
                BEQ         GOTOEAVSOPTABLE             *lets look at the ea versus the opcode
                CMPI.B      #$05, (A6)
                BEQ         STARTMOVEMMEMTOREGLOOP
DECIDESHIFT
                CMPI.B      #$00, D2                    *toggler
                BEQ         SHIFT4RIGHT                 *to get the four most significant bits of the address   
                BRA         SHIFT4LEFT4RIGHT            *to get the four least significant bits of the address
SHIFT4RIGHT
                LSR.B       #$4, D3                     *logically shift the bits in the byte address 4 over to the right
                BRA         DECIDELETTERNUM         
                
SHIFT4LEFT4RIGHT
                LSL.B       #$4, D3                     *logically shift the bits in the byte address 4 to the left
                LSR.B       #$4, D3                     *logically shift the bits in the byte address 4 over to the right
                BRA         DECIDELETTERNUM

DECIDELETTERNUM
                CMPI.B      #$0A, D3                    *if the byte that we are looking at is less than $A - it's a number, else it's a letter - $A represents 10 so we know if it's less than it s a hex num
                BLT         HEX_IS_NUM              
                BRA         HEX_IS_LETTER          
                                
HEX_IS_NUM
                ADDI.B      #$30, D3                    *add 30 following the ascii table
                MOVE.B      D3,(A1)+                    *A1 holds the good buffer and the bad buffer, so we move the ascii value into A1 in order for it to print from these buffers
                BRA         TOGGLEA6                    *keep toggling with A6 and D2 to get the nibbles out of the byte
                
HEX_IS_LETTER
                ADDI.B      #$37, D3                    *add 37 following the ascii table
                MOVE.B      D3,(A1)+                    *A1 holds the good buffer and the bad buffer, so we move the ascii value into A1 in order for it to print from these buffers
                BRA         TOGGLEA6                    *keep toggling with A6 and D2 to get the nibbles out of the byte
TOGGLEA6
                CMPI.B      #$01,D2                     *when A6 is going to get toggled or not, if it was a 1 then we toggle it back to get the least significant nibble
                BEQ         A6TOGGLE
                CMPI.B      #$00, D2                    *else we are going to get the most significant nibble
                BEQ         A6NOTTOGGLE
A6TOGGLE
                SUBI.B      #$01, D2                    *reset D2 in the toggle because we are not going to be using the same byte
                ADDA.L      #$01, A6                    *increment A6 which is used to decode the hex addr into ascii
                BRA         HEX_TO_ASCII                *keep going
A6NOTTOGGLE
                ADDI.B      #$01, D2                    *set D2 up for the toggle, and don't increment A6 because we are going to be using the same byte
                BRA         HEX_TO_ASCII                *keep going
                
BADDATA
                LEA         GOOD_BUFFER,A1
                ADDA.L      #$8,A1
                MOVE.L      #$FFFFFFFF,(A1)
                ADDA.L      #$8,A1
                MOVE.L      #$FFFFFFFF,(A1)
                SUBA.L      #$8,A1
                MOVE.B      #$09, (A1)+         
                MOVE.B      #'D',(A1)+
                MOVE.B      #'A',(A1)+
                MOVE.B      #'T',(A1)+
                MOVE.B      #'A',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                LEA         HEXTOASCIIFLAG, A6          *move the hex to ascii flag into a6 to alter it's contents
                MOVE.B      #$03,(A6)                   *set hex flag to next state for print buffer
                CLR.L       D4                          *clean up
                ADDI.B      #$02, D4                    *add 2 bytes to d4 which we use to keep track of how many bytes we've moved in the instruction
                MOVE.B      #$04, D1                    *d1 is the counter for hex to ascii and we want it to decode a word at a time
                MOVEA.L     A4, A6                      *move the address of a4 because this is pointing after the opcode has been read
                BRA         HEX_TO_ASCII       
*               
PRINTGOODBUFFER
                MOVE.B      #$00, (A1)                  *clean up a1
                MOVEA.L     A1, A6                      *A1 points to the end of the address of the instruction, so we have to clear from the start of the instruction to the end of it
                LEA         GOOD_BUFFER, A1             *reset A1
                MOVE.B      #13, D0                     *print methods
                TRAP        #15
                BRA         CLEARBUFFER                 *clean out the buffer
*
ASKFORMOREINPUT
                MOVE.B      #$00, (A2)                  *clean up A2
                LEA         MOREINPUTMSG,A1             *load the message in for printing
                MOVE.B      #14, D0                     *print
                TRAP        #15                     
                MOVE.B      #5, D0                      *get the input from the user
                TRAP        #15                         *call the task
                CMPI.B      #$0D, D1                    *if the user hits enter
                BEQ         LOADGOODBUFFERKEEPGOING     *then we keep printing data
                CMPI.B      #$51, D1                    *if the user hits the letter Q
                BEQ         FINISHED                    *then we're done
                CMPI.B      #$52, D1                    *if the user hit's the letter 3
                BEQ         RESTART                     *then we restart
                LEA         INVMOREINPMSG, A1           *if it was bad data then we keep popping this message up until valid input
                MOVE.B      #14, D0
                TRAP        #15
                BRA         ASKFORMOREINPUT
                
RESTART
                LEA         HEXTOASCIIFLAG,A6           *clean up the hex to ascii flag for printing
                MOVE.B      #$00, (A6)                  *clean up
                CLR.L       D4                          *clean up
                CLR.L       (A2)
                LEA         COUNTINSTRPRINT,A2          *clean up the number of isntructions that have been printed
                MOVE.B      #$00,(A2)                   *clean up
                MOVE.B      #$00,EADNEAANFLAG           *clean up the ea to dn flag
                BRA         START                       *now go back to the beginning
               
               
LOADGOODBUFFERKEEPGOING
                LEA         GOOD_BUFFER, A1             *clean up the buffer from printing
                CLR.L       (A2)
                BRA         CLEARBUFFER                 *clean up method

CLEARBUFFER                                             *clearbuffer checks to see if A1 has surpassed A6, if this is the case, that means that the buffer has been cleared - end loop                      
                CMPA.L      A6, A1
                BGT         SETUPNEXTBITS               *then lets start looking at the next pieces to decode
                MOVE.B      #$FF, (A1)+                 *overwrite the buffer with FF because clearing places 00 in A1 which is read as null, because we are going to use A1 again for printing/buffers
                BRA         CLEARBUFFER                 *loop
                
*start looking at the next bits to decode                
SETUPNEXTBITS
                LEA         COUNTINSTRPRINT, A2         *one more instruction has been printed
                CMPI.L      #$0E, (A2)                  *15 instructions at a time
                BEQ         ASKFORMOREINPUT             *then see what the user wants to do
                ADDI.L      #$01, (A2)                  *increment the address because we've read the opcode
                LEA         HEXTOASCIIFLAG, A6          *put the hex to ascii flag to tell the program where it's at
                MOVE.B      #$00, (A6)                  *the flag is 0 because we're just looking at the opcode
                MOVE.B      #$0, D1                     *counting the bytes decoded in the address being read  
                ADDA.L      D4, A4                      *increment by the amount of bytes last read
                CLR.B       D4                          *clan up d4
                CMPA.L      A5,A4                       
                BGE         FINISHED
                LEA         HEXTOASCIIMEM,A6            *place 4500 back in so we can read the next address as hex and convert it to ascii
                MOVE.L      A4,(A6)                     *this puts the next address into A6 for decoding, assumes it's going to be good, and then keeps going as written above
                LEA         GOOD_BUFFER, A1             *add to the good buffer
                BRA         HEX_TO_ASCII                *convert this address to ascii for printing               
*
FINISHED
                LEA         FINISHEDMSG, A1             *say thanks!
                MOVE.B      #14, D0                     *print
                TRAP        #15                         *call the task
                MOVE.B      #5, D0                      *get the input from the user
                TRAP        #15                         *call the task
                CMPI.B      #$51, D1                    *if the user hits the letter Q
                BEQ         PROGRAMEND                    *then we're done
                CMPI.B      #$52, D1                    *if the user hit's the letter 3
                BEQ         RESTART                     *then we restart
                LEA         INVMOREINPMSG, A1           *if it was bad data then we keep popping this message up until valid input
                MOVE.B      #14, D0
                TRAP        #15
                BRA         FINISHED

PROGRAMEND
                CLR.L       (A2)
                LEA         ENDINGMSG, A1
                MOVE.B      #14, D0                     *print
                TRAP        #15                         *call the task
                MOVE.B      #9,D0
                TRAP        #15               
*Check to see if the string length is valid                            
CHECKSTRLEN     
                CMPI.L      #$00000004, D1              *Compare the hex value 8 to the length stored in D1
                BGT         ADDRHI                      *If it was greater than 8, that means the address was greater than a long so this is invalid
                CMPI.L      #$00000000, D1              *Compare the hex value 0 to the length stored in D1
                BEQ         ADDRLOW                     *IF it was 0, that means nothing was entered, so this is invalid
                RTS                                     *Else, we can continue and convert
*Check to see if the address is even                
CHECKEVENADDR
                DIVU.W      #$0002, D3                  *to check if even we divide by 2 and see if there is a remainder in the leading bits
                ROR.L       #8, D3                      *after dividing, the remainder is in the front, but we want it in the back
                ROR.L       #8, D3                      *so we shift it over and flip flop the sides
                CMPI.B      #1, D3                      *Compare 1 to data register 3
                BEQ         ADDRESSODD                  *the address was odd
                RTS                                     *return to whichever CHECKADDR called this routine
*Given address is odd number                
ADDRESSODD
                CLR.L       D3                          *clear data register d3
                LEA         ADDRODDMSG, A1              *load the odd msg into a1
                MOVE.B      #14, D0                     *move trap task 14 into d0
                TRAP        #15                         *print the msg
                BRA         GETSTARTOREND               *check if the start or ending address is needed          
*End of I/O start and end* reusable checks            
*****************************************************************************************************************   
*Start of address start messages            
*Given start address is too low
ADDRLOW
                CLR.L       D3                          *Clear data register 3
                LEA         LOWADDRMSG,A1               *Loads low starting address message into address register 1
                MOVE.B      #14,D0                      *Put number 14 into address register 0
                TRAP        #15                         *Print LOWSTARTADDRMSG from data register 0
                BRA         GETSTARTOREND               *Branch to GETSTARTADDR to request a new starting address

*Given start address is too high                
ADDRHI
                CLR.L       D3                          *Clear data register 3
                LEA         HIADDRMSG,A1                *Loads low starting address message into address register 1
                MOVE.B      #14,D0                      *Put number 14 into address register 0
                TRAP        #15                         *Print LOWSTARTADDRMSG from data register 0
                BRA         GETSTARTOREND               *Branch to GETSTARTADDR to request a new starting address
*End of address start messages                 
*****************************************************************************************************************    
*Reusable ascii to hex converter for the start and end addresses    
*ASCII to HEX conversion
ASCIIHEXCONV
                CMPI.B      #$00,(A2)                   *Compare the number $0 to what is stored in A1
                BEQ         REFORMATADDR                *If equivalent, it was null so the address needs to be reformatted
                CMPI.B      #$30,(A2)                   *Compare the number $30 to what is stored in A1
                BLT         ASCIIERROR                  *if it was less than thirty, it's not a valid hex address per ascii table
                CMPI.B      #$3A,(A2)                   *Compare the number #3A to what is stored in A1 per the hex table for special characters between 39 and 40
                BLT         ASCII_IS_NUM                *If less than $3A, it was a number following the workflow, branch
                CMPI.B      #$41,(A2)                   *If less than $41 stored in A1
                BLT         ASCIIERROR                  *then it was a special character between 39 and 40
                CMPI.B      #$47,(A2)                   *if less than 47 stored in A1
                BLT         ASCII_IS_LETTER             *then it was a letter so branch
                CMPI.B      #$46,(A2)                   *else, if it was greater than 46 (greater than F), not a valid hex number
                BGT         ASCIIERROR                  *so throw an error
                
ASCII_IS_NUM
                SUBI.B      #$30, (A2)+                 *subtract the number 30 from what is stored in A1 because it is a number and we want the value
                BRA         ASCIIHEXCONV                *branch back to the next ascii code to be read

ASCII_IS_LETTER
                SUBI.B      #$37, (A2)+                 *subtract the number 37 from what is stored in A1 because it is a letter and we want the value
                BRA         ASCIIHEXCONV                *branch back to the next ascii code to be read
                                      
*Invalid ASCII input
ASCIIERROR
                LEA         ASCIIERRMSG,A1              *Load the ASCIIERRMSG into address register 1
                MOVE.B      #14,D0                      *Puts number 14 into data register 0
                TRAP        #15                         *Print ASCIIERRMSG
                CLR.L       D1                          *Clear data register 1
                BRA         GETSTARTADDR                *Branch back to GETSTARTADDR
*Shift the bits in the address to prepare for addition
REFORMATADDR
                MOVEA.L     A3, A2                      *Make A2 point to the Long in A3
                MOVE.B      (A3)+, D3                   *Move the bytes in A3 to Data register 3 and increment A3
                SUBI.B      #$1, D1                     *Subtract 1 from D1 to keep track of bytes left to reformat
                CMPI.B      #$0, D3                     *Check if their are no bytes left to deal with
                BEQ         CHECKSTARTOREND             *Branch to determine which address check is necessary
                ROL.L       #4, D3                      *Shift all bits to the left 4 times (circular shift)
                BSR         ADDVALSHIFT                 *Branch to subroutine to add and shift remaining bytes
ADDVALSHIFT
                ADD.B       (A3)+, D3                   *Add byte in A3 to D3, and increment A3
                SUBI.B      #$1, D1                     *Subtract 1 from D1 to keep track of bytes left to reformat
                CMPI.B      #$0, D1                     *Check if their are no bytes left to deal with
                BEQ         CHECKSTARTOREND             *Branch to determine which address check is necessary
                ROL.L       #4, D3                      *Shift all bits to the left 4 times (CIRCULAR SHIFT)
                BRA         ADDVALSHIFT                 *While D1 is not 0, keep adding and shifting
*Check which address needs to be tested                
CHECKSTARTOREND
                CMPI.L      #0, D7                      *Check if a starting address has been retrieved
                BEQ         CHECKSTARTADDR              *The starting address needs to be checked
                BRA         CHECKENDADDR                *Otherwise the end addresss needs to be checked
*Check if a start or end address is needed
GETSTARTOREND                
                CMPI.L      #0, D7                      *Check if a starting address
                BEQ         GETSTARTADDR                *If it is, get the starting address  
                BRA         GETENDINGADDR               *If it isn't, get the ending address  
*End of Input Conversion 

*****************jump tables****************************************
**************opcode table******************************************
OPCODETABLE    
               JMP         CODE0000

               JMP         CODE0001                 

               JMP         CODE0010

               JMP         CODE0011

               JMP         CODE0100

               JMP         CODE0101

               JMP         CODE0110

               JMP         CODE0111

               JMP         CODE1000

               JMP         CODE1001

               JMP         CODE1010

               JMP         CODE1011

               JMP         CODE1100

               JMP         CODE1101

               JMP         CODE1110

               JMP         CODE1111
**************opcode table********************************************
*****************source mode table************************************               
SOURCEMODETABLE    
               JMP         SMODE000                     * data register

               JMP         SMODE001                     * direct address register              

               JMP         SMODE010                     * indirect address register

               JMP         SMODE011                     * indirect address register post increment

               JMP         SMODE100                     * indirect address register pre decrement

               JMP         SMODE101                     * BAD DATA

               JMP         SMODE110                     * BAD DATA

               JMP         SMODE111                     * do some compares to check if the register is valid before declaring as bad data
******************source mode table**********************************
******************dest mode table************************************
DESTMODETABLE    
               JMP         DMODE000                     * data register

               JMP         DMODE001                     * direct address register              

               JMP         DMODE010                     * indirect address register

               JMP         DMODE011                     * indirect address register post increment

               JMP         DMODE100                     * indirect address register pre decrement

               JMP         DMODE101                     * BAD DATA

               JMP         DMODE110                     * BAD DATA

               JMP         DMODE111                     * do some compares to check if the register is valid before declaring as bad data
******************dest mode table************************************
*************checkdestmodetable***************************************
CHECKDESTMODETABLE    
               JMP         DESTVSOP0000

               JMP         DESTVSOP0001                

               JMP         DESTVSOP0010

               JMP         DESTVSOP0011

               JMP         DESTVSOP0100

               JMP         DESTVSOP0101

               JMP         DESTVSOP0110

               JMP         DESTVSOP0111

               JMP         DESTVSOP1000

               JMP         DESTVSOP1001

               JMP         DESTVSOP1010

               JMP         DESTVSOP1011

               JMP         DESTVSOP1100

               JMP         DESTVSOP1101

               JMP         DESTVSOP1110

               JMP         DESTVSOP1111
*************checkdestmodetable***************************************
*************checksourcemodetable***************************************
CHECKSOURCEMODETABLE    
               JMP         SOURCEVSOP0000

               JMP         SOURCEVSOP0001                

               JMP         SOURCEVSOP0010

               JMP         SOURCEVSOP0011

               JMP         SOURCEVSOP0100

               JMP         SOURCEVSOP0101

               JMP         SOURCEVSOP0110

               JMP         SOURCEVSOP0111

               JMP         SOURCEVSOP1000

               JMP         SOURCEVSOP1001

               JMP         SOURCEVSOP1010

               JMP         SOURCEVSOP1011

               JMP         SOURCEVSOP1100

               JMP         SOURCEVSOP1101

               JMP         SOURCEVSOP1110

               JMP         SOURCEVSOP1111
*************checkdestsourcetable***************************************
*************EAVSOPTABLE***************************************
EAVSOP
               JMP         EAVSOP0000

               JMP         EAVSOP0001

               JMP         EAVSOP0010

               JMP         EAVSOP0011
               
               JMP         EAVSOP0100
               
               JMP         EAVSOP0101

               JMP         EAVSOP0110
               
               JMP         EAVSOP0111

               JMP         EAVSOP1000

               JMP         EAVSOP1001

               JMP         EAVSOP1010
               
               JMP         EAVSOP1011

               JMP         EAVSOP1100

               JMP         EAVSOP1101

               JMP         EAVSOP1110

               JMP         EAVSOP1111
*************EAVSOPTABLE***************************************
*************EAMODETABLE***************************************               
EAMODETABLE
               JMP         EAMODE000
               
               JMP         EAMODE001
               
               JMP         EAMODE010
               
               JMP         EAMODE011
               
               JMP         EAMODE100
               
               JMP         EAMODE101
               
               JMP         EAMODE110
               
               JMP         EAMODE111
*************EAMODETABLE***************************************
*******************end of jump tables********************************

************************opcode jumps*********************************               
CODE0000
                ADDI.B      #$02,D4                     *increment the amount of bytes that we've looked at in the instruction 
                BSR         GETDESTMODEBITS             *get bits 8, 7, 6
                CMPI.B      #%100,D1                    *if they are equal to #%100 then it's a BTST of formant to DN
                BEQ         BTSTDNCODE                  *bits 8, 7, 6 have specified that we are going to a btst format to dn
                CMPI.B      #%100,D1                    *everything else is bad data
                BGT         BADDATA                     *everythiung else is bad data
                BSR         GETDESTREGBITS              *otherwise, we have to look at bits 11, 10, 9 to determine what instruction it is and look deeper
                CMPI.B      #%010,D1                    *if the bits are 010 then we know it's a subI, so go there
                BEQ         SUBICODE                    *the bits have specified it to be a SUBI
                CMPI.B      #%000,D1                    *if the bits are 000 then we know its an ORI
                BEQ         ORICODE                     *the bits have specified it to be an ORI
                CMPI.B      #%101,D1                    *if the bits are 101 then it's an eori
                BEQ         EORICODE                    *the bits ahve specified it to be an EORI
                CMPI.B      #%110,D1                    *if the bits are 1110 then we know it's a cmpi
                BEQ         CMPICODE                    *so go there
                CMPI.B      #%100,D1                    *if the bits are 100 then it's a BTSTI code
                BEQ         BTSTICODE                   *so go to btsti
                BRA         BADDATA                     *else, if it didn't match anything it's time to go to baddata
CODE0001
                MOVE.B      #$09, (A1)+                 *add move.b to our buffer
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'B',(A1)+
                MOVE.B      #' ',(A1)+
                ADDI.B      #2, D4                       *increment the amount of bits that we've looked at (it's a word)
                BSR         GETSOURCEMODEBITS            *get the last source mode bits
                LEA         CHECKSOURCEMODETABLE, A0     *load the source mode table into address register 0 as this is it's designated duty at this point
                MULU        #6, D6                       *multiply to get to the right source mode jump table index
                JSR         0(A0, D6)                    *jump to the source mode table 
                
CODE0010
               BSR          GETDESTMODEBITS              *look at bits 8, 7, 6
               CMPI.B       #$001, D1                    *if the bits are equal to hex, decimal, or binary 1, or (001) then we know it's a MOVEAL once we're in this opcode
               BEQ          MOVEALCODE                   *then it's a moveal
               BRA          MOVELCODE                    *else it was a movel from this opcode
                
CODE0011
               BSR          GETDESTMODEBITS              *look at bits 8, 7, 6
               CMPI.B       #$001, D1                    *if the bits are equal to hex, decimal, or binary 1, or (001) then we know it's a MOVEAw once we're in this opcode
               BEQ          MOVEAWCODE                   *then it's a moveaw
               BRA          MOVEWCODE                    *else it was a movew from this opcode
               
CODE0100
                ADDI.B      #2,D4
                MOVE.W      (A4),D1                      *look at the whole word of the instruction
                CMPI.W      #$4E75,D1                    *rts is hardcoded as 4e75
                BEQ         RTSCODE                     
                CLR.L       D1                           *otherwise, clean up and move on to the next set of codes it could be
                BSR         GETBITS11THROUGH6            *look for JSR specific bits
                CMPI.B      #$3A, D1                     *rts is looked at for bits 6 through 11 as a byte equivalent to 3A
                BEQ         JSRCODE
                BSR         GETBITS11THROUGH8            *get bits 11 through 8 for neg or not
                CMPI.B      #$04, D1                     *if the bits at 11 through 8 equals 4 then it's a neg code and then further checks for size
                BEQ         NEGCODE
                CMPI.B      #$06, D1                     *if the bits at 11 through 8 equals 6 then it's a not code and then further checks for size
                BEQ         NOTCODE
                BSR         GETDESTMODEBITS              *get bits 6 through 8 to check for LEA
                CMPI.B      #$07, D1                     *if it was 7, then it's an LEA for sure and no further checks to be made
                BEQ         LEACODE
                CMPI.B      #$06, D1                     *check if the bits from 6 to 8 are equal to value 6, if so then bad data (validate lea against check - then move on to movem)
                BEQ         BADDATA
                BSR         GETBITS11THROUGH9            *get bits 9 through 11 for movem
                CMPI.B      #%110,D1                     *if it was 110 then it has to be movem MEMORY TO REGISTER
                BEQ         MOVEMMEMTOREGCODE
                CMPI.B      #%100,D1                     *else if it's 100 it could be movem REGISTER TO MEMORY or EXT, NBCD, SWAP, OR PEA
                BEQ         DETERMINEMOVEMORNOT          *so determine it further by breaking down more
                BRA         BADDATA                      *if it hasn't branched yet it's definitely bad data 
                                     
CODE0101
               ADDI.B      #$2,D4                        
               BSR         GETDESTMODEBITS               *get bits 8, 7, 6, followed by three checks for bad data
               CMPI.B      #%011,D1                      *if the bits are greater than011 then it's bad data                    
               BGE         BADDATA                       
               CMPI.B      #%111,D1                      *if the bits are greater than or equal to 111 then it's bad data
               BGE         BADDATA
               BTST        #2,D1                         *test the bit at the second spot, if it's 0 then it's not bad data
               BNE         BADDATA                       
               MOVE.B      #$09,(A1)+                    *add addq to our buffer           
               MOVE.B      #'A',(A1)+
               MOVE.B      #'D',(A1)+
               MOVE.B      #'D',(A1)+
               MOVE.B      #'Q',(A1)+
               MOVE.B      #'.',(A1)+
               CMPI.B      #%000,D1                      *if bits 8,7 6 are specified as 0 followed by a size code (00 or 01 or 10) then branch to the correct addq size after the rest of the instruction
               BEQ         ADDQBYTE                     
               CMPI.B      #%001,D1
               BEQ         ADDQWORD
               CMPI.B      #%010,D1
               BEQ         ADDQLONG
               BRA         BADDATA                       *else by now we've determined that it's a bad data for the things we have to decode  
               
CODE0110
               MOVE.L      #$FFFFFFFF,D0                 *
               ADDI.B      #$2,D4                        *increment the counter of how many bytes we will need to increment the address for the instruction
               BSR         GETBITS11THROUGH8             *look at bits 11 through 8, stored in d1
               CMPI.B      #0,D1                         *the compares correspond to the bit values 
               BEQ         BRAINSTRUCTION                *it's a branch instruction
               CMPI.B      #7,D1
               BEQ         BEQINSTRUCTION                *its a branch if equal instruction
               CMPI.B      #2,D1
               BEQ         BHIINSTRUCTION                *it's a branch high instruction
               CMPI.B      #6,D1
               BEQ         BNEINSTRUCTION                *it's a branch if not equal instruction
               CMPI.B      #13,D1                   
               BEQ         BLTINSTRUCTION                *it's a branch if less than instruction
               BRA         BADDATA                       *else we know it's bad data based on the instruction set we need to decode          
               
CODE0111
               BRA          BADDATA                      *not required opcode - bad data   
               
CODE1000
               BSR           GETDESTMODEBITS              *look at bits 8, 7, 6
               ADDI.B        #2, D4                       *increment the amount of bytes that we will need to move the address forward (counter) 
               CMPI.B        #%111, D1                    *if it was 111 then it's divs
               BEQ           DIVSCODE
               BRA           BADDATA                      *else from the required instruction set to decode, nothing else can be decoded from here

;these are a concern if she tests other opcodes             
CODE1001
               BSR          GETBITS8THROUGH3            *get the bits 8 through 3, do a series of compares against the SUB code at these specified bits, and branch to bad data if it was any of those
               CMPI.B       #32, D1
               BEQ          BADDATA
               CMPI.B       #33, D1
               BEQ          BADDATA
               CMPI.B       #40, D1
               BEQ          BADDATA
               CMPI.B       #41, D1
               BEQ          BADDATA
               CMPI.B       #48, D1
               BEQ          BADDATA
               CMPI.B       #49, D1
               BEQ          BADDATA  
               MOVE.B       #$09,(A1)+                  *else it could only be a sub
               MOVE.B       #'S',(A1)+
               MOVE.B       #'U',(A1)+
               MOVE.B       #'B',(A1)+
               ADDI.B       #$2,D4                      *increment the amount of bytes that we will need to move the address forward (counter)
               BSR          DETERMINEADDORSUB           *determine add or sub doesn't mean if it's an add or sub, it determines the format of the add or the sub (ea-> dn, dn-> ea etc)
                          
CODE1010
               BRA          BADDATA                     *not required opcode 
               
CODE1011
               ADDI.B       #$2,D4                      *increment the amount of bytes that we will need to move the address forward (counter)
               BSR          GETDESTMODEBITS             *look at bits 8, 7, 6 and if it's less than 3 then it's a compare, if it's equal or equal to 7 then it's a type of compareA else it's an eor only
               CMPI.B       #3,D1
               BLT          COMPAREINSTRUCTION          *it's a compare immediate instruction
               CMPI.B       #3,D1
               BEQ          COMPAREADDRESSINSTRUCTION   *it's a compare address instruction
               CMPI.B       #7,D1
               BEQ          COMPAREADDRESSINSTRUCTION   *it's a compare address instruction
               BRA          EORINSTRUCTION              *it's an exclusive or immediate instruction
          
CODE1100
               ADDI.B       #2,D4                       *increment the counter of how many bytes we need to move the address forward (counter)                      
               BSR          GETDESTMODEBITS             *look at bits 8,7,6 and compare it to a series of constants after getting bits 8 through 3 as well, and branch to bad data if it was any of the below series
               CMPI.B       #3,D1
               BEQ          BADDATA
               BSR          GETBITS8THROUGH3
               CMPI.B       #32,D1
               BEQ          BADDATA
               CMPI.B       #33,D1
               BEQ          BADDATA
               CMPI.B       #40,D1
               BEQ          BADDATA
               CMPI.B       #41,D1
               BEQ          BADDATA
               CMPI.B       #49,D1
               BEQ          BADDATA
               BSR          GETDESTMODEBITS             *else, to determine the actual instruction we need the destination mode back again and compare it to a constant value for muls or and
               CMPI.B       #7,D1
               BEQ          MULSINSTRUCTION             *it's a muls instruction
               BRA          ANDINSTRUCTION              *it's an and immediate instruction

;these are a concern if she tests other opcodes                
CODE1101
               BSR          GETBITS8THROUGH3            *the first thing to look at is bits 8 through 3, and compare it to a series of values to determine if it's bad data
               CMPI.B       #32, D1
               BEQ          BADDATA
               CMPI.B       #33, D1
               BEQ          BADDATA
               CMPI.B       #40, D1
               BEQ          BADDATA
               CMPI.B       #41, D1
               BEQ          BADDATA
               CMPI.B       #48, D1
               BEQ          BADDATA
               CMPI.B       #49, D1
               BEQ          BADDATA
               MOVE.B       #$09,(A1)+                  *else it's an add
               MOVE.B       #'A',(A1)+
               MOVE.B       #'D',(A1)+
               MOVE.B       #'D',(A1)+
               ADDI.B       #$2,D4                      *increment the counter of how many bytes we will need to move forward from the beginning of the instruction
               BSR          DETERMINEADDORSUB           *now we need to determine the format of the add instruction
                           
CODE1110        
               CLR.L        D7                          *clean up D7
               MOVE.B       #2,D4                       *increment the counter of how many bytes we will need to move for next instruction
               BSR          GETBITS6AND7                *get bits 6 and 7 into D1
               MOVE.B       D1,D0                       *move bits 6 and 7 into D0 because we will use them later   
               CMPI.B       #%11,D1                     *if D1 == %11 we know it's a shift on just an effective address
               BEQ          EASHIFT
               BSR          GETBITS3AND4                *else get bits 3 and 4 in D1
               CMPI.B       #0,D1                       *if D1 == 0 we know it's arithmetic shift
               BEQ          ARITHMETICSHIFT
               CMPI.B       #1,D1                       *if D1 == 1 it's logical shift
               BEQ          LOGICALSHIFT
               CMPI.B       #3,D1                       *if D1 == 3 it's a rotation
               BEQ          ROTATESHIFT
               BRA          BADDATA                     *else it's bad data
                              
CODE1111
               BRA          BADDATA
************************opcode jumps***********************************
DETERMINEMOVEMORNOT
                ADDI.B      #2,D4                       *ALWAYS TWO WORDS
                BSR         GETBITS6AND7                
                LSR.B       #1,D1                       *MAKE SURE BIT 7 IS 1, MUST BE 1. if not ELIMINATES NBCD, PEA, SWAP
                CMPI.B      #$01,D1
                BNE         BADDATA
                BSR         GETSOURCEMODEBITS           
                CMPI.B      #%000,D1                    *ELIMINATES EXT FROM POSSIBLE OPCODES
                BEQ         BADDATA
                BRA         DETERMINEMOVEMREGTOMEMSIZE  *we now know it's a movem and now we have to determine size for reg to mem movem's

LEACODE
                MOVE.B      #$09, (A1)+                 *add LEA to our buffer
                MOVE.B      #'L',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'A',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$2,EADNEAANFLAG            *set our eadneaanflag to 2 which means it's an <ea>,An operation
                BSR         GETSOURCEMODEBITS           *get the last source mode bits
                LEA         CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
                MULU        #6, D6                      *multiply to get to the right source mode jump table index
                JSR         0(A0, D6)                   *jump to the source mode table

DETERMINEMOVEMREGTOMEMSIZE
                MOVE.B      #$09, (A1)+                 *add MOVEM to our buffer
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'M',(A1)+
                BSR         GETDESTMODEBITS             *getdestmode gets bits 678 which specify the size of the operaton in MOVEM
                BTST        #0,D1                       *if first bit of destmodebits is 0 it's a word movem
                BEQ         MOVEMREGTOMEMWORD           
                BRA         MOVEMREGTOMEMLONG           *else it's a long movem
            

DETERMINEMOVEMREGTOMEMTYPE
                BSR         GETSOURCEMODEBITS
                CMPI.B      #%100, D1                       *AT THIS POINT WE KNOW IT'S REG TO MEM, BUT NEED TO MAKE SURE IT'S PREDEC ELSE GENERIC REG TO MEM
                BEQ         STARTMOVEMREGTOMEMPREDECLOOP    *movem operation involves a predecrement address register so use special loop
                BRA         STARTMOVEMREGTOMEMGENERICLOOP   *movem operation does not involve a predecrement address register so use standard loop
                             
MOVEMREGTOMEMWORD                
                MOVE.B      #'.',(A1)+                      *add .w because it's a word operation
                MOVE.B      #'W',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         DETERMINEMOVEMREGTOMEMTYPE      *now find out if it involves predecrement or not
                
MOVEMREGTOMEMLONG
                MOVE.B      #'.',(A1)+                      *add .l because it's a long operation
                MOVE.B      #'L',(A1)+
                MOVE.B      #$09,(A1)+         
                BRA         DETERMINEMOVEMREGTOMEMTYPE      *now find out if it involes predececrement or not
                
STARTMOVEMREGTOMEMPREDECLOOP
                CLR.L       D0                              *clear out data registers that will be used in this loop
                CLR.L       D5
                CLR.L       D2
                MOVE.B      #$37,D2                         *$37 is the appropriate amount to add to loop counter to convert it to appropriate ascii code
                MOVEA.L     A4,A3                           *set loop memory pointer to beginning of instruction
                ADDA.L      #2,A3                           *add two bytes to memory loop pointer to look at second word of instruction
                MOVE.W      (A3),D1                         *put that word into D1
                BRA         REGTOMEMLOOPPREDEC              *start loop
     
REGTOMEMLOOPPREDEC
                CMPI.B      #$F,D5                          *if our loop counter hits $F we are done with loop
                BGT         DONEWITHREGTOMEMLOOP
                BTST        D5,D1                           *test the bit at d5 (loop counter) if it's 1 or 0
                BNE         REGTOMEMVALUEPREDEC             *if it's 1, we need to decode it
                ADDI.B      #$1,D5                          *incrememnt loop counter
                ADDI.B      #$1,D0                          *D1 is used to convert counter to ascii code
                SUBI.B      #2,D2                           *D2, the value to add to convert to ascii needs to be decremented by 2
                CMPI.B      #8,D0                           *if D0 has reached 8, we need to prepare loop to handle data registers instead of address registers
                BEQ         SETUPPREDECDATAREGISTER
                BRA         REGTOMEMLOOPPREDEC              *continue looping
                
REGTOMEMVALUEPREDEC
                CMPI.B      #$7,D0                          *if D0 is greater than 7, we need to decode data registers instead of address registers
                BGT         REGTOMEMDATAREGISTERPREDEC
                MOVE.B      #'A',(A1)+                      *add A to buffer
                ADD.B       D2,D0                           *convert loop counter to ascii code
                MOVE.B      D0,(A1)+                        *add ascii code to buffer
                MOVE.B      #'/',(A1)+                      *add slash to buffer
                SUB.B       D2,D0                           *subtract from ascii code to get it back to reusable value
                ADDI.B      #$1,D5                          *add 1 to loop counter
                ADDI.B      #$1,D0                          *add 1 to loop counter/ascii converter
                SUBI.B      #$2,D2                          *subtract 2 from value used for ascii conversion
                CMPI.B      #8,D0                           *if D0 is 8, time to start decoding data registers
                BEQ         SETUPPREDECDATAREGISTER
                BRA         REGTOMEMLOOPPREDEC              *continue looping
                
SETUPPREDECDATAREGISTER
                MOVE.B      #$2F,D2                         *data registers require $2F to be added to loop counter for appropriate ascii conversion
                BRA         REGTOMEMLOOPPREDEC
                    
REGTOMEMDATAREGISTERPREDEC                
                MOVE.B      #'D',(A1)+                      *add D to buffer
                ADD.B       D2,D0                           *convert loop counter to ascii value
                MOVE.B      D0,(A1)+                        *add ascii code to buffer
                MOVE.B      #'/',(A1)+                      *add slash to buffer
                SUB.B       D2,D0                           *subtract conversion amount from D0 for later use
                ADDI.B      #$1,D5                          *add 1 to loop counter
                ADDI.B      #$1,D0                          *add 1 to loop counter/ascii converter
                SUBI.B      #2,D2                           *subtract 2 from value used for ascii conversion
                BRA         REGTOMEMLOOPPREDEC              *continue looping                                     
 
DONEWITHREGTOMEMLOOP
                CLR.L       D2                              *clear out data registers used in this loop, since we are done
                CLR.L       D0
                CLR.L       D5
                SUBA.L      #1,A1                           *fence post case of loop. with post decrement, A1 went one too far
                LEA         EADNEAANFLAG,A6                         
                MOVE.B      #2,(A6)                         *set our eadneaan flag to 2, which means it's <ea>,An
                BRA         GOTOEAVSOPTABLE                 

STARTMOVEMREGTOMEMGENERICLOOP                               
                CLR.L       D0                              *clear out data registers that will be used in this loop
                CLR.L       D5
                CLR.L       D2
                MOVE.B      #15,D5                          *set loop counter to start at 15. going 15->0
                MOVE.B      #$37,D2                         *$37 is the appropriate amount to add to loop counter for ascii conversion
                MOVEA.L     A4,A3                           *set A3 to start of instruction
                ADDA.L      #2,A3                           *add two bytes to A3 to skip first word
                MOVE.W      (A3),D1                         *put that word into D1
                BRA         REGTOMEMLOOPGENERIC             *start loop
                 
REGTOMEMLOOPGENERIC
                CMPI.B      #0,D5                           *if D5 is 0 our loop is done
                BEQ         LASTREGTOMEMLOOPGENERICTEST         
                BTST        D5,D1                           *test if bit at loop counter is 1 or 0
                BNE         REGTOMEMLOOPGENERICVALUE        *if 1, we need to decode register
                SUBI.B      #1,D5                           *decrement loop counter
                SUBI.B      #1,D2                           *decrement loop counter/ascii converter
                CMPI.B      #7,D5                           *if loop counter is 7, now we need to reset D2 to $37 for ascii conversion
                BEQ         RESETD2TO37
                BRA         REGTOMEMLOOPGENERIC             *continue looping        

RESETD2TO37
                MOVE.B      #$37,D2                         *reset D2 back to $37 for ascii conversion
                BRA         REGTOMEMLOOPGENERIC             *continue looping

REGTOMEMLOOPGENERICVALUE
                CMPI.B      #8,D5                           *if loop counter is less than 8 we are decoding data registers
                BLT         REGTOMEMLOOPGENERICDATAREGISTER *else dedocing address registers
                BRA         REGTOMEMLOOPGENERICADDRESSREG
                
REGTOMEMLOOPGENERICADDRESSREG                               
                MOVE.B      #'A',(A1)+                      *add A to buffer
                MOVE.B      D2,(A1)+                        *add ascii code to buffer
                MOVE.B      #'/',(A1)+                      *add slash to buffer
                SUBI.B      #1,D5                           *decrement loop counter
                SUBI.B      #1,D2                           *decrement loop counter/ascii converter
                CMPI.B      #7,D5                           *if loop counter is 7, need to reset ascii converter to $37
                BEQ         RESETD2TO37 
                BRA         REGTOMEMLOOPGENERIC             *continue looping

REGTOMEMLOOPGENERICDATAREGISTER
                MOVE.B      #'D',(A1)+                      *add D to buffer
                MOVE.B      D2,(A1)+                        *add ascii code to buffer
                MOVE.B      #'/',(A1)+                      *add slash to buffer
                SUBI.B      #1,D5                           *decrement loop counter
                SUBI.B      #1,D2                           *decrement loop counter/ascii converter
                BRA         REGTOMEMLOOPGENERIC             *continue looping

LASTREGTOMEMLOOPGENERICTEST
                BTST        D5,D1                           *if last bit is 1 need to decode data register
                BNE         LASTREGTOMEMLOOPGENERICVALUE
                BRA         DONEWITHREGTOMEMLOOP            *else done with loop
                
LASTREGTOMEMLOOPGENERICVALUE
                MOVE.B      #'D',(A1)+                      *add D to buffer
                MOVE.B      D2,(A1)+                        *add ascii code to buffer
                MOVE.B      #'/',(A1)+                      *add slash to buffer
                BRA         DONEWITHREGTOMEMLOOP            *finish loop

MOVEMMEMTOREGCODE
                ADDI.B      #2,D4                           *add 2 bytes to our counter of bytes decoded in this instruction
                MOVE.B      #$5,HEXTOASCIIFLAG              *set hextoasciiflag to 5, indicating it's a movem instruction for hex_to_ascii function
                MOVE.B      #$5,EADNEAANFLAG                *set eadneaanflag to 5 indicating movem source is a word or long absolute address
                BSR         GETBITS6AND7                    *get bits 6 and 7
                BTST        #0,D1                           *test bit 6 to determine size. if it's a 1 it's a long, else a word.
                BNE         MOVEMMEMTOREGLONG
                MOVE.B      #$09, (A1)+                     *add MOVEM.W to buffer
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'W',(A1)+      
                MOVE.W      (A4),D6                         *get first 4 bits again to check for valid source modes  
                LSR.W       #8,D6                           *start of shift to get the first 4 bits
                LSR.W       #4,D6                           *end of shift to get the first 4 bits
                MULU        #6,D6                           *go to the table indexing
                LEA         CHECKSOURCEMODETABLE,A0
                JSR         0(A0,D6)
                
MOVEMMEMTOREGLONG
                MOVE.B      #$09, (A1)+                     *add MOVEM.L to buffer
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'L',(A1)+     
                MOVE.W      (A4),D6                         *get first 4 bits again to check for valid source modes
                LSR.W       #8,D6                           *start of shift to get the first 4 bits
                LSR.W       #4,D6                           *end of shift to get the first 4 bits
                MULU        #6,D6                           *go to the table indexing
                LEA         CHECKSOURCEMODETABLE,A0
                JSR         0(A0,D6)
          
STARTMOVEMMEMTOREGLOOP
                MOVE.B      #$0,HEXTOASCIIFLAG              *set hextoasciiflag to 0, indicating we will read next instruction next time we call hex_to_ascii
                MOVE.B      #$0,EADNEAANFLAG                *set eadneaanflag to 0, indicating we are going to reset the flag
                MOVE.B      #',',(A1)+
                CLR.L       D0                              *clean up registers
                CLR.L       D5
                CLR.L       D2
                MOVE.B      #0,D5                           *the loop counter
                MOVE.B      #$30,D2                         *for converting to ascii correctly
                MOVEA.L     A4,A3                           *storing the instruction in an auxiliary location
                ADDA.L      #2,A3                           *increment the address because we've now looked at a word of data
                MOVE.W      (A3),D1                         *store the instruction back in d1 for altering
                BRA         MOVEMMEMTOREGLOOP
                
MOVEMMEMTOREGLOOP
                CMPI.B      #15,D5                          *if D5 is #15, done looping
                BGT         DONEWITHMEMTOREGLOOP
                BTST        D5,D1                           *check if bit at loop counter is 1 or 0
                BNE         MEMTOREGVALUE                   *it's 1, so decode it
                ADDI.B      #1,D0                           *increment D0, used to keep track of when we need to reset D2, our ascii value to add
                ADDI.B      #1,D5                           *increment loop counter
                ADDI.B      #1,D2                           *increment hex value
                CMPI.B      #8,D0                           *if D0 is 8, need to reset our hex value
                BEQ         SETD2TO30                       
                BRA         MOVEMMEMTOREGLOOP               *continue looping
                
MEMTOREGVALUE
                CMPI.B      #7,D5                           *if D5 is more than 7, decode address register
                BGT         MEMTOREGADDRESSREG
                MOVE.B      #'D',(A1)+                      *add D to buffer because decoding data register
                MOVE.B      D2,(A1)+                        *add ascii value of register to buffer
                MOVE.B      #'/',(A1)+                      *add slash to buffer
                ADDI.B      #1,D2                           *increment ascii value
                ADDI.B      #1,D0                           *increment resetD2 counter
                ADDI.B      #1,D5                           *increment loop counter
                CMPI.B      #8,D0                           *if D0 is 8, need to reset our hex value
                BEQ         SETD2TO30
                BRA         MOVEMMEMTOREGLOOP               *continue looping
                
MEMTOREGADDRESSREG
                MOVE.B      #'A',(A1)+
                MOVE.B      D2,(A1)+
                MOVE.B      #'/',(A1)+
                ADDI.B      #1,D2
                ADDI.B      #1,D0
                ADDI.B      #1,D5
                CMPI.B      #8,D0
                BRA         MOVEMMEMTOREGLOOP
                
DONEWITHMEMTOREGLOOP
                CLR.L       D0
                CLR.L       D1
                CLR.L       D5
                CLR.L       D2
                MOVE.B      #$FF,-(A1)
                BRA         PRINTGOODBUFFER

                
SETD2TO30
                MOVE.B      #$30,D2
                BRA         MOVEMMEMTOREGLOOP
                
                
RTSCODE
                MOVE.B      #$09, (A1)+
                MOVE.B      #'R',(A1)+
                MOVE.B      #'T',(A1)+
                MOVE.B      #'S',(A1)+
                BRA         PRINTGOODBUFFER
                
JSRCODE
                MOVE.B      #$09, (A1)+
                MOVE.B      #'J',(A1)+
                MOVE.B      #'S',(A1)+
                MOVE.B      #'R',(A1)+
                MOVE.B      #$09,(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                BRA         MOVEFROMNEGNOT         

NEGCODE
                BSR         GETBITS6AND7
                CMPI.B      #3,D1
                BEQ         BADDATA
                MOVE.B      #$09, (A1)+
                MOVE.B      #'N',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'G',(A1)+
                CMPI.B      #0,D1
                BEQ         BYTE0100
                CMPI.B      #1,D1
                BEQ         WORD0100
                BRA         LONG0100
NOTCODE
                BSR         GETBITS6AND7
                CMPI.B      #3,D1
                BEQ         BADDATA
                MOVE.B      #$09, (A1)+
                MOVE.B      #'N',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'T',(A1)+
                CMPI.B      #0,D1
                BEQ         BYTE0100
                CMPI.B      #1,D1
                BEQ         WORD0100
                BRA         LONG0100            

BYTE0100
                MOVE.B      #'.',(A1)+
                MOVE.B      #'B',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         MOVEFROMNEGNOT
                
WORD0100
                MOVE.B      #'.',(A1)+
                MOVE.B      #'W',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         MOVEFROMNEGNOT
LONG0100
                MOVE.B      #'.',(A1)+
                MOVE.B      #'L',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         MOVEFROMNEGNOT

MOVEFROMNEGNOT
                BSR         GETSOURCEMODEBITS           *get the last source mode bits
                LEA         EAVSOP, A0
                MULU        #6, D6
                JSR         0(A0, D6)
                                     
MOVEWCODE                
                MOVE.B      #$09, (A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'W',(A1)+
                MOVE.B      #' ',(A1)+
                ADDI.B      #2, D4                       *increment the counter of how many bytes we need to move the address for the instruction
                BSR         GETSOURCEMODEBITS            *get the last source mode bits
                LEA         CHECKSOURCEMODETABLE, A0     *load the source mode table into address register 0 as this is it's designated duty at this point
                MULU        #6, D6                       *multiply to get to the right source mode jump table index
                JSR         0(A0, D6)                    *jump to the source mode table 
                
MOVEAWCODE                
                MOVE.B      #$09, (A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'A',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'W',(A1)+
                MOVE.B      #' ',(A1)+
                ADDI.B      #2, D4                       *increment the counter of how many bytes we need to move the address for the instruction
                BSR         GETSOURCEMODEBITS            *get the last source mode bits
                LEA         CHECKSOURCEMODETABLE, A0     *load the source mode table into address register 0 as this is it's designated duty at this point
                MULU        #6, D6                       *multiply to get to the right source mode jump table index
                JSR         0(A0, D6)                    *jump to the source mode table
MOVELCODE                
                MOVE.B      #$09, (A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'L',(A1)+
                MOVE.B      #' ',(A1)+
                ADDI.B      #2, D4                      *increment the counter of how many bytes we need to move the address for the instruction
                BSR         GETSOURCEMODEBITS           *get the last source mode bits
                LEA         CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
                MULU        #6, D6                      *multiply to get to the right source mode jump table index
                JSR         0(A0, D6)                   *jump to the source mode table 
                
MOVEALCODE                
                MOVE.B      #$09, (A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'V',(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'A',(A1)+
                MOVE.B      #'.',(A1)+
                MOVE.B      #'L',(A1)+
                MOVE.B      #' ',(A1)+
                ADDI.B      #2, D4                      *increment the counter of how many bytes we need to move the address for the instruction
                BSR         GETSOURCEMODEBITS           *get the last source mode bits
                LEA         CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
                MULU        #6, D6                      *multiply to get to the right source mode jump table index
                JSR         0(A0, D6)                   *jump to the source mode table
                
BTSTICODE
                MOVE.B      #$09, (A1)+
                MOVE.B      #'B',(A1)+
                MOVE.B      #'T',(A1)+
                MOVE.B      #'S',(A1)+
                MOVE.B      #'T',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                ADDI.B      #2, D4                      *increment the counter of how many bytes we need to move the address for the instruction
                LEA         HEXTOASCIIFLAG, A6          *set the flag for btsti
                MOVE.B      #$04, (A6)                  *the flag number 4 for the hex to ascii 
                MOVE.L      #$06, D1                    *only want the loop to repeat twice, d1 starts at 6, go till 8 
                MOVEA.W     A4,A6                       *move the start of the instruction to A6 
                ADDA.W      #$03, A6                    *because this is where hex to ascii will pick up
                CLR.L       D2                          *clean up d2
                MOVE.W      (A4),D5                     *move the first word of the instruction into d5 because hex to ascii uses d1 and d5 will hold it while d1 is used by hex to ascii
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII                *time to convert for printing
BTSTDNCODE
                MOVE.B      #$09, (A1)+
                MOVE.B      #'B',(A1)+
                MOVE.B      #'T',(A1)+
                MOVE.B      #'S',(A1)+
                MOVE.B      #'T',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                MOVE.B      #'D',(A1)+
                BSR         GETDESTREGBITS
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                BRA         GOTOEAVSOPTABLE
                
SUBICODE
                MOVE.B      #$09,(A1)+
                MOVE.B      #'S',(A1)+
                MOVE.B      #'U',(A1)+
                MOVE.B      #'B',(A1)+
                MOVE.B      #'I',(A1)+
                MOVE.B      #'.',(A1)+
                BSR         GETDESTMODEBITS
                CMPI.B      #%00,D1
                BEQ         BYTE0000
                CMPI.B      #%01,D1
                BEQ         WORD0000
                CMPI.B      #%10,D1
                BEQ         LONG0000
ORICODE
                MOVE.B      #$09,(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'R',(A1)+
                MOVE.B      #'I',(A1)+
                MOVE.B      #'.',(A1)+
                BRA         DETERMINESIZE0000

EORICODE
                MOVE.B      #$09, (A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'R',(A1)+
                MOVE.B      #'I',(A1)+
                MOVE.B      #'.',(A1)+
                BRA         DETERMINESIZE0000

CMPICODE
                MOVE.B      #$09, (A1)+
                MOVE.B      #'C',(A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'P',(A1)+
                MOVE.B      #'I',(A1)+
                MOVE.B      #'.',(A1)+
                BRA         DETERMINESIZE0000
       
DETERMINESIZE0000
                BSR         GETDESTMODEBITS
                CMPI.B      #%00,D1
                BEQ         BYTE0000
                CMPI.B      #%01,D1
                BEQ         WORD0000
                CMPI.B      #%10,D1
                BEQ         LONG0000 
BYTE0000
                MOVE.B      #'B',(A1)+
                MOVE.B      #$09,(A1)+
                ADDI.B      #2, D4
                LEA         HEXTOASCIIFLAG, A6
                MOVE.B      #$04, (A6)
                MOVE.L      #$06, D1
                MOVEA.W     A4,A6
                ADDA.W      #$03, A6
                CLR.L       D2
                MOVE.W      (A4),D5
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII
                        
WORD0000
                MOVE.B      #'W',(A1)+
                MOVE.B      #$09,(A1)+
                ADDI.B      #2, D4
                LEA         HEXTOASCIIFLAG, A6
                MOVE.B      #$04, (A6)
                MOVE.L      #$04, D1
                MOVEA.W     A4,A6
                ADDA.W      #$02, A6
                CLR.L       D2
                MOVE.W      (A4),D5
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII        
LONG0000
                MOVE.B      #'L',(A1)+
                MOVE.B      #$09,(A1)+
                ADDI.B      #4, D4
                LEA         HEXTOASCIIFLAG, A6
                MOVE.B      #$04, (A6)
                MOVE.L      #$00, D1
                MOVEA.W     A4,A6
                ADDA.W      #$02, A6
                CLR.L       D2
                MOVE.W      (A4),D5
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII

ADDQBYTE
                MOVE.B      #'B',(A1)+
                BRA         ADDQDETERMINEDATA
                
ADDQWORD
                MOVE.B      #'W',(A1)+
                BRA         ADDQDETERMINEDATA

ADDQLONG
                MOVE.B      #'L',(A1)+
                BRA         ADDQDETERMINEDATA
              
ADDQDETERMINEDATA
                MOVE.B      #$09,(A1)+
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BSR         GETDESTREGBITS
                CMPI.B      #%000,D1
                BEQ         ADDQEIGHT
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                BRA         GOTOEAVSOPTABLE
                
ADDQEIGHT
                MOVE.B      #$38,(A1)+
                BRA         GOTOEAVSOPTABLE

DETERMINEADDORSUB               
               BSR          GETDESTMODEBITS
               CMPI.B       #%000,D1
               BEQ          ADDORSUBEADNBYTE
               CMPI.B       #%001,D1
               BEQ          ADDORSUBEADNWORD
               CMPI.B       #%010,D1
               BEQ          ADDORSUBEADNLONG
               CMPI.B       #%100,D1
               BEQ          ADDORSUBDNEABYTE
               CMPI.B       #%101,D1
               BEQ          ADDORSUBDNEAWORD
               CMPI.B       #%110,D1
               BEQ          ADDORSUBDNEALONG
               CMPI.B       #%011,D1
               BEQ          ADDAORSUBAWORD
               CMPI.B       #%111,D1
               BEQ          ADDAORSUBALONG
               BRA          BADDATA
               
ADDORSUBEADNBYTE
               MOVE.B       #'.',(A1)+
               MOVE.B       #'B',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$1,EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table 

ADDORSUBEADNWORD
               MOVE.B       #'.',(A1)+
               MOVE.B       #'W',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$1,EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table                
ADDORSUBEADNLONG
               MOVE.B       #'.',(A1)+
               MOVE.B       #'L',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$1,EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table                
ADDORSUBDNEABYTE
               MOVE.B       #'.',(A1)+                  *printing
               MOVE.B       #'B',(A1)+
               MOVE.B       #$09,(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               BSR          GETDESTREGBITS              *get bits 11, 10, 9
               ADDI.B       #$30,D1                     *add hex 30 to d1 to convert it to a proper ascii value
               MOVE.B       #'D',(A1)+
               MOVE.B       D1,(A1)+                    *add the value into the buffer for printing
               BRA          GOTOEAVSOPTABLE              
ADDORSUBDNEAWORD    
               MOVE.B       #'.',(A1)+                  *printing
               MOVE.B       #'W',(A1)+
               MOVE.B       #$09,(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               BSR          GETDESTREGBITS              *get bits 11, 10, 9
               ADDI.B       #$30,D1                     *add hex 30 to d1 to convert it to a proper ascii value
               MOVE.B       #'D',(A1)+
               MOVE.B       D1,(A1)+                    *add the value into the buffer for printing
               BRA          GOTOEAVSOPTABLE  
ADDORSUBDNEALONG
               MOVE.B       #'.',(A1)+                  *printing
               MOVE.B       #'L',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$09,(A1)+
               BSR          GETDESTREGBITS              *get bits 11, 10, 9
               ADDI.B       #$30,D1                     *add hex 30 to d1 to convert it to a proper ascii value
               MOVE.B       #'D',(A1)+
               MOVE.B       D1,(A1)+                    *add the value into the buffer for printing
               BRA          GOTOEAVSOPTABLE 
ADDAORSUBAWORD
               MOVE.B       #'A',(A1)+
               MOVE.B       #'.',(A1)+
               MOVE.B       #'W',(A1)+
               MOVE.B       #$2, EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table 
ADDAORSUBALONG
               MOVE.B       #'A',(A1)+
               MOVE.B       #'.',(A1)+
               MOVE.B       #'L',(A1)+
               MOVE.B       #$2,EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table                                 
GOTOEAVSOPTABLE
                MOVE.B      #',',(A1)+
                BSR         GETSOURCEMODEBITS           *get the last source mode bits
                LEA         EAVSOP, A0
                MULU        #6, D6
                JSR         0(A0, D6)
EASHIFT         
                MOVE.B      #1,D7                       *for the different types of shifting ROd, LSd, ASd
                BSR         GETBITS9AND10               *look at the bits specific to each type of shift instruction
                CMPI.B      #0,D1
                BEQ         ARITHMETICSHIFT
                CMPI.B      #1,D1
                BEQ         LOGICALSHIFT
                CMPI.B      #3,D1
                BEQ         ROTATESHIFT
                BRA         BADDATA                     *else it's bad data
                
ARITHMETICSHIFT
                MOVE.B      #$09,(A1)+
                MOVE.B      #'A',(A1)+
                MOVE.B      #'S',(A1)+               
                BSR         GETBIT8                     *it's been determined as an arithmetic shift 
                CMPI.B      #0,D1                       *now we need to know if it's a right or left shift
                BEQ         RIGHTSHIFT                  *it's a right shift
                MOVE.B      #'L',(A1)+                  *else it's a left shift
                CMPI.B      #0,D7                       *now we look to check the shift size
                BEQ         DETERMINESHIFTSIZE       
                BRA         DETERMINESHIFTEA            *else we know it's a shift on ea we need to determine what type of ea 
                
LOGICALSHIFT
                MOVE.B      #$09,(A1)+
                MOVE.B      #'L',(A1)+
                MOVE.B      #'S',(A1)+               
                BSR         GETBIT8                     *it's been determined as a logical shift
                CMPI.B      #0,D1                       *now we need to know if it's a right or left shift
                BEQ         RIGHTSHIFT
                MOVE.B      #'L',(A1)+                  *else it's a left shift
                CMPI.B      #0,D7                       *now we need to look at the shift size if possible
                BEQ         DETERMINESHIFTSIZE          *check the shift size if it was a shift size type
                BRA         DETERMINESHIFTEA            *else were going to determine the type of ea 
        
ROTATESHIFT     
                MOVE.B      #$09,(A1)+
                MOVE.B      #'R',(A1)+
                MOVE.B      #'O',(A1)+               
                BSR         GETBIT8                     *it's been determined as a rotate shift 
                CMPI.B      #0,D1                       *is it a right shift
                BEQ         RIGHTSHIFT                  
                MOVE.B      #'L',(A1)+                  *else it's a left shift
                CMPI.B      #0,D7                       *now we need to determine the size 
                BEQ         DETERMINESHIFTSIZE          
                BRA         DETERMINESHIFTEA            *else were going to determine the type of ea

RIGHTSHIFT
                MOVE.B      #'R',(A1)+                  *it was a right shift
                CMPI.B      #0,D7   
                BEQ         DETERMINESHIFTSIZE          *now lets look at the size
                BRA         DETERMINESHIFTEA            *or the ea type
DETERMINESHIFTEA
                MOVE.B      #'.',(A1)+
                MOVE.B      #'W',(A1)+
                MOVE.B      #$09,(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                BSR         GETSOURCEMODEBITS           *get the last source mode bits
                LEA         EAVSOP, A0
                MULU        #6, D6
                JSR         0(A0, D6)      
DETERMINESHIFTSIZE
                CMPI.B      #0,D0                
                BEQ         BYTESHIFT
                CMPI.B      #1,D0
                BEQ         WORDSHIFT
                MOVE.B      #'.',(A1)+    
                MOVE.B      #'L',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         DETERMINESHIFTSOURCE
BYTESHIFT
                MOVE.B      #'.',(A1)+    
                MOVE.B      #'B',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         DETERMINESHIFTSOURCE                
WORDSHIFT    
                MOVE.B      #'.',(A1)+    
                MOVE.B      #'W',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #' ',(A1)+
                MOVE.B      #$09,(A1)+
                BRA         DETERMINESHIFTSOURCE

DETERMINESHIFTSOURCE
                BSR         GETBIT5
                CMPI.B      #0,D1
                BEQ         SHIFTIMMEDIATESOURCE
                MOVE.B      #'D',(A1)+
                BSR         GETDESTREGBITS
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                MOVE.B      #',',(A1)+
                MOVE.B      #'D',(A1)+
                BSR         GETSOURCEREGBITS
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                BRA         DONEWITHDEST
                
SHIFTIMMEDIATESOURCE
                MOVE.B      #'#',(A1)+    
                MOVE.B      #'$',(A1)+    
                BSR         GETDESTREGBITS
                CMPI.B      #0,D1
                BEQ         CHANGETOEIGHT
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                MOVE.B      #',',(A1)+
                MOVE.B      #'D',(A1)+
                BSR         GETSOURCEREGBITS
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                BRA         DONEWITHDEST
                
CHANGETOEIGHT
                MOVE.B      #'8',(A1)+
                BRA         DONEWITHDEST
                
COMPAREINSTRUCTION
                MOVE.B      #$1,EADNEAANFLAG
                MOVE.B      #$09,(A1)+
                MOVE.B      #'C',(A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'P',(A1)+
                CMPI.B      #0,D1
                BEQ         COMPARETYPEBYTE
                CMPI.B      #1,D1
                BEQ         COMPARETYPEWORD
                BRA         COMPARETYPELONG
                
COMPAREADDRESSINSTRUCTION
                MOVE.B      #$2,EADNEAANFLAG
                MOVE.B      #$09,(A1)+
                MOVE.B      #'C',(A1)+
                MOVE.B      #'M',(A1)+
                MOVE.B      #'P',(A1)+
                MOVE.B      #'A',(A1)+
                CMPI.B      #3,D1
                BEQ         COMPARETYPEWORD
                BRA         COMPARETYPELONG
                
EORINSTRUCTION
                BSR         GETSOURCEMODEBITS
                CMPI.B      #1,D1
                BEQ         BADDATA
                MOVE.B      #$09,(A1)+
                MOVE.B      #'E',(A1)+
                MOVE.B      #'O',(A1)+
                MOVE.B      #'R',(A1)+
                BSR         GETDESTMODEBITS
                CMPI.B      #4,D1
                BEQ         EORBYTE
                CMPI.B      #5,D1
                BEQ         EORWORD
                BRA         EORLONG
                
                
DIVSCODE
               MOVE.B       #$09, (A1)+
               MOVE.B       #'D',(A1)+
               MOVE.B       #'I',(A1)+
               MOVE.B       #'V',(A1)+
               MOVE.B       #'S',(A1)+
               MOVE.B       #'.',(A1)+
               MOVE.B       #'W',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$1,EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table

MULSINSTRUCTION
               MOVE.B       #$09, (A1)+
               MOVE.B       #'M',(A1)+
               MOVE.B       #'U',(A1)+
               MOVE.B       #'L',(A1)+
               MOVE.B       #'S',(A1)+
               MOVE.B       #'.',(A1)+
               MOVE.B       #'W',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$1,EADNEAANFLAG
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)  
ANDINSTRUCTION      
               MOVE.B       #$09,(A1)+
               MOVE.B       #'A',(A1)+
               MOVE.B       #'N',(A1)+
               MOVE.B       #'D',(A1)+
               BRA          DETERMINEADDORSUB
               
COMPARETYPEBYTE
               MOVE.B       #'.',(A1)+
               MOVE.B       #'B',(A1)+
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table    
COMPARETYPEWORD
               MOVE.B       #'.',(A1)+
               MOVE.B       #'W',(A1)+
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table    
COMPARETYPELONG
               MOVE.B       #'.',(A1)+
               MOVE.B       #'L',(A1)+
               BSR          GETSOURCEMODEBITS           *get the last source mode bits
               LEA          CHECKSOURCEMODETABLE, A0    *load the source mode table into address register 0 as this is it's designated duty at this point
               MULU         #6, D6                      *multiply to get to the right source mode jump table index
               JSR          0(A0, D6)                   *jump to the source mode table
EORBYTE
               MOVE.B       #'.',(A1)+
               MOVE.B       #'B',(A1)+
               BRA          CONTINUEFROMEOR
    
EORWORD
               MOVE.B       #'.',(A1)+
               MOVE.B       #'W',(A1)+
               BRA          CONTINUEFROMEOR

EORLONG                    
               MOVE.B       #'.',(A1)+
               MOVE.B       #'L',(A1)+
               BRA          CONTINUEFROMEOR
CONTINUEFROMEOR
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #$09,(A1)+
               BSR          GETDESTREGBITS
               ADDI.B       #$30,D1
               MOVE.B       #'D',(A1)+
               MOVE.B       D1,(A1)+
               BRA          GOTOEAVSOPTABLE

BRAINSTRUCTION
               MOVE.B       #$09,(A1)+
               MOVE.B       #'B',(A1)+
               MOVE.B       #'R',(A1)+
               MOVE.B       #'A',(A1)+
               BRA          DETERMINEDISPLACEMENT
BEQINSTRUCTION
               MOVE.B       #$09,(A1)+
               MOVE.B       #'B',(A1)+
               MOVE.B       #'E',(A1)+
               MOVE.B       #'Q',(A1)+
               BRA          DETERMINEDISPLACEMENT

BHIINSTRUCTION
               MOVE.B       #$09,(A1)+
               MOVE.B       #'B',(A1)+
               MOVE.B       #'H',(A1)+
               MOVE.B       #'I',(A1)+
               BRA          DETERMINEDISPLACEMENT

BNEINSTRUCTION
               MOVE.B       #$09,(A1)+
               MOVE.B       #'B',(A1)+
               MOVE.B       #'N',(A1)+
               MOVE.B       #'E',(A1)+
               BRA          DETERMINEDISPLACEMENT

BLTINSTRUCTION
               MOVE.B       #$09,(A1)+
               MOVE.B       #'B',(A1)+
               MOVE.B       #'L',(A1)+
               MOVE.B       #'T',(A1)+
               BRA          DETERMINEDISPLACEMENT
               
DETERMINEDISPLACEMENT
               MOVE.B       #$09,(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               MOVE.B       #' ',(A1)+
               BSR          GETBITS7THROUGH0
               CMPI.B       #$00,D1
               BEQ          BIT16DISPLACEMENT
               CMPI.B       #$FF,D1
               BEQ          BADDATA
               BRA          BIT8DISPLACEMENT
               
BIT16DISPLACEMENT
               ADDI.B       #$02, D4
               MOVEA.L      A4,A3
               ADDA.L       #2,A3
               MOVE.W       (A3),D1
               MOVE.B       #24,D5
               LSL.L        D5,D1
               ASR.L        D5,D1
               ADDA.L       D1,A3
               BRA          CONVERTDISPLACEMENTADDRESS 

BIT8DISPLACEMENT 
               MOVEA.L      A4,A3
               ADDA.L       #1,A3
               MOVE.B       (A3),D1
               MOVE.B       #24,D5
               LSL.L        D5,D1
               ASR.L        D5,D1
               ADDA.L       #1,A3
               ADDA.L       D1,A3
               BRA          CONVERTDISPLACEMENTADDRESS 

CONVERTDISPLACEMENTADDRESS               
               LEA          HEXTOASCIIFLAG, A6
               MOVE.B       #3,(A6)
               LEA          DISPLACEMENTADDR, A6   
               MOVE.L       A3,(A6)
               MOVEQ        #0,D1
               CLR.L        D2
               BRA          HEX_TO_ASCII
              
************************sourcemode jumps*******************************
SMODE000
                MOVE.B      #$09,(A1)+          
                MOVE.B      #'D',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.W      (A4),D5                 *now were going to look at the destination mode bits, so load this back into d1 to prepare for shifting
                BRA         DONEWITHSOURCE
                        
SMODE001
                MOVE.B      #$09,(A1)+          
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.W      (A4),D5                 *now were going to look at the destination mode bits, so load this back into d1 to prepare for shifting
                BRA         DONEWITHSOURCE
SMODE010
                MOVE.B      #$09,(A1)+          
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.W      (A4),D5                 *now were going to look at the destination mode bits, so load this back into d1 to prepare for shifting
                BRA         DONEWITHSOURCE

SMODE011
                MOVE.B      #$09,(A1)+          
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #'+',(A1)+
                MOVE.W      (A4),D5                 *now were going to look at the destination mode bits, so load this back into d1 to prepare for shifting
                BRA         DONEWITHSOURCE
SMODE100 
                MOVE.B      #$09,(A1)+ 
                MOVE.B      #'-',(A1)+         
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.W      (A4),D5                 *now were going to look at the destination mode bits, so load this back into d1 to prepare for shifting
                BRA         DONEWITHSOURCE

SMODE101
                BRA     BADDATA
SMODE110
                BRA     BADDATA
SMODE111 
                BSR         GETSOURCEREGBITS
                CMPI.B      #%000, D1
                BEQ         SOURCEWORDADDRESS
                CMPI.B      #%001, D1
                BEQ         SOURCELONGADDRESS
                BRA         BADDATA
                
SOURCEWORDADDRESS
                CMPI.B      #$5,EADNEAANFLAG
                BEQ         MOVEMSOURCEWORD
                MOVEA.L     A4,A6
                ADDA.L      #$00000002, A6
                ADDI.B      #$02, D4
                CLR.L       D2
                MOVE.W      (A4),D5
                MOVE.L      #$04, D1
                MOVE.B      #$09,(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII

SOURCELONGADDRESS
                CMPI.B      #$5,EADNEAANFLAG
                BEQ         MOVEMSOURCELONG
                MOVEA.L     A4,A6
                ADDA.L      #$00000002, A6
                ADDI.B      #$04, D4
                CLR.L       D2
                MOVE.W      (A4),D5                 *Put the stuff of A4 into D5 to keep track of the opcode word during Hex to Ascii
                MOVE.L      #$00, D1
                MOVE.B      #$09,(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII              
MOVEMSOURCEWORD
                MOVEA.W     A4,A6
                ADDA.W      #$0004, A6
                ADDI.B      #$02, D4
                CLR.L       D2
                MOVE.W      (A4),D5
                MOVE.L      #$04, D1
                MOVE.B      #$09,(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII
MOVEMSOURCELONG  
                MOVEA.W     A4,A6
                ADDA.W      #$0004, A6
                ADDI.B      #$04, D4
                CLR.L       D2
                MOVE.W      (A4),D5                 *Put the stuff of A4 into D5 to keep track of the opcode word during Hex to Ascii
                MOVE.L      #$00, D1
                MOVE.B      #$09,(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII               
DONEWITHSOURCE
                CMPI.B      #$1,EADNEAANFLAG
                BEQ         HANDLEEADN
                CMPI.B      #$2,EADNEAANFLAG
                BEQ         HANDLEEAAN
                CMPI.B      #$5,EADNEAANFLAG
                BEQ         STARTMOVEMMEMTOREGLOOP
                LEA         HEXTOASCIIFLAG, A6
                MOVE.B      #$02, (A6)
                MOVE.L      D5, D1
                MOVE.B      #',',(A1)+
                BSR         GETDESTMODEBITS
                LEA         CHECKDESTMODETABLE, A0      
                JSR         0(A0, D6)               *were going to just check the opcode against the destination mode for validity with this table (it's a duplicate of the first opcode table, just with it's own logic)

HANDLEEADN
                MOVE.B      #$0,EADNEAANFLAG
                MOVE.B      #',',(A1)+
                MOVE.B      #'D',(A1)+
                BSR         GETDESTREGBITS
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                BRA         DONEWITHDEST
                
HANDLEEAAN
                MOVE.B      #$0,EADNEAANFLAG
                MOVE.B      #',',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETDESTREGBITS
                ADDI.B      #$30,D1
                MOVE.B      D1,(A1)+
                BRA         DONEWITHDEST                
                             
************************sourcemode jumps*******************************

************************destinationmode jumps**************************   
DMODE000                 
                MOVE.B      #'D',(A1)+
                BSR         GETDESTREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST               
DMODE001                              
                MOVE.B      #'A',(A1)+
                BSR         GETDESTREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST            
DMODE010                 
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETDESTREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST               
DMODE011                 
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETDESTREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #'+',(A1)+
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST               
DMODE100                 
                MOVE.B      #'-',(A1)+
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETDESTREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST              
DMODE101
                BRA     BADDATA        
DMODE110                 
                BRA     BADDATA
DMODE111                  
                BSR         GETDESTREGBITS
                CMPI.B      #%000, D1
                BEQ         DESTWORDADDRESS
                CMPI.B      #%001, D1
                BEQ         DESTLONGADDRESS
                BRA         BADDATA
                
DESTWORDADDRESS
                LEA         HEXTOASCIIFLAG,A6
                MOVE.B      #$00,EADNEAANFLAG
                MOVE.B      #$03,(A6)               *set hextoasciiflag to 3, indicating next time hex_to_ascii is called branch to printbuffer
                MOVEA.L     A4,A6
                ADDA.L      D4, A6
                ADDI.B      #$02, D4                *increment byte counter by 4
                CLR.L       D2                      *clean up D2
                MOVE.L      D1, D5
                MOVE.L      #$04, D1                *set up hex_to_ascii to convert a word
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII

DESTLONGADDRESS
                LEA         HEXTOASCIIFLAG,A6
                MOVE.B      #$00,EADNEAANFLAG       
                MOVE.B      #$03,(A6)               *set hextoasciiflag to 3, indicating next time hex_to_ascii is called branch to printbuffer
                MOVEA.L     A4,A6                   *move A6 to start of instruction
                ADDA.L      D4, A6                  *move A6 past first word to long immediate data
                ADDI.B      #$04, D4                *increment byte counter by 4
                CLR.L       D2                      *clean up D2
                MOVE.L      D1, D5
                MOVE.L      #$00, D1                *set up hex_to_ascii to convert a long
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII
                
DONEWITHDEST
                LEA         HEXTOASCIIFLAG,A6
                MOVE.B      #$00, (A6)              *clear A6 back so it can read instruction addresses
                MOVE.B      #$00,EADNEAANFLAG   
                BRA         PRINTGOODBUFFER         *print the good buffer since were done now               
************************destinationmode jumps**************************

************************destination mode vs opcode jumps***************               
DESTVSOP0000
               BRA     BADDATA

DESTVSOP0001
               CMPI.B       #%001, D1               
               BEQ          BADDATA
               CMPI.B       #%101, D1
               BEQ          BADDATA
               CMPI.B       #%110, D1
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEMOVEDESTMODE
               BRA          STARTDESTMODETABLE 
                
DESTVSOP0010
               CMPI.B       #%101, D1
               BEQ          BADDATA
               CMPI.B       #%110, D1
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEMOVEDESTMODE
               BRA          STARTDESTMODETABLE   

DESTVSOP0011
               CMPI.B       #%101, D1
               BEQ          BADDATA
               CMPI.B       #%110, D1
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEMOVEDESTMODE
               BRA          STARTDESTMODETABLE                
DESTVSOP0100
               BRA     BADDATA
               
DESTVSOP0101
               BRA     BADDATA
               
DESTVSOP0110
               BRA     BADDATA
               
DESTVSOP0111
               BRA     BADDATA
               
DESTVSOP1000
               BRA     BADDATA
             
DESTVSOP1001
               BRA     BADDATA
               
DESTVSOP1010
               BRA     BADDATA
               
DESTVSOP1011
               BRA     BADDATA
               
DESTVSOP1100
               BRA     BADDATA
               
DESTVSOP1101
               BRA     BADDATA
               
DESTVSOP1110
               BRA     BADDATA
               
DESTVSOP1111
               BRA     BADDATA
************************destination mode vs opcode jumps*************** 

************************source mode vs opcode jumps***************               
SOURCEVSOP0000
               CMPI.B       #%001, D1               
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEEAMODEVSREGISTER0000
SOURCEVSOP0001
               CMPI.B       #%001, D1               
               BEQ          BADDATA
               CMPI.B       #%101, D1
               BEQ          BADDATA
               CMPI.B       #%110, D1
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEMOVEBSOURCEMODE
               BRA          STARTSOURCEMODETABLE 
                
SOURCEVSOP0010
               CMPI.B       #%101, D1
               BEQ          BADDATA
               CMPI.B       #%110, D1
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEMOVELSOURCEMODE
               BRA          STARTSOURCEMODETABLE 

SOURCEVSOP0011
               CMPI.B       #%101, D1
               BEQ          BADDATA
               CMPI.B       #%110, D1
               BEQ          BADDATA
               CMPI.B       #%111, D1
               BEQ          VALIDATEMOVEWSOURCEMODE
               BRA          STARTSOURCEMODETABLE 
      
SOURCEVSOP0100
               BRA          STARTSOURCEMODETABLE 
               
SOURCEVSOP0101
               BRA     BADDATA
               
SOURCEVSOP0110
               BRA     BADDATA
               
SOURCEVSOP0111
               BRA     BADDATA
               
SOURCEVSOP1000
                CMPI.B      #%111,D1
                BEQ         DETERMINEDIVSIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
             
SOURCEVSOP1001
                CMPI.B      #%111,D1
                BEQ         DETERMINEADDORSUBIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
SOURCEVSOP1010
                BRA     BADDATA
               
SOURCEVSOP1011
                CMPI.B      #%111,D1
                BEQ         DETERMINEADDORSUBIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
               
SOURCEVSOP1100
                BSR         GETDESTMODEBITS
                CMPI.B      #%111,D1
                BNE         SOURCEVSAND 
                BSR         GETSOURCEMODEBITS 
                CMPI.B      #%111,D1
                BEQ         DETERMINEDIVSIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
               
SOURCEVSOP1101
                CMPI.B      #%111,D1
                BEQ         DETERMINEADDORSUBIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
               
SOURCEVSOP1110
                CMPI.B      #%111,D1
                BEQ         DETERMINEDIVSIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
                 
SOURCEVSOP1111
                BRA         BADDATA
               
************************destination mode vs opcode jumps**************
SOURCEVSAND
                BSR         GETSOURCEMODEBITS
                CMPI.B      #%111,D1
                BEQ         DETERMINEADDORSUBIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE  

DETERMINEADDORSUBIMMEDIATEDATA
                BSR         GETSOURCEREGBITS
                CMPI.B      #%100,D1
                BEQ         ADDORSUBIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
                
DETERMINEDIVSIMMEDIATEDATA
                BSR         GETSOURCEREGBITS
                CMPI.B      #%100,D1
                BEQ         DIVSIMMEDIATEDATA
                BRA         STARTSOURCEMODETABLE
                
DIVSIMMEDIATEDATA
                BRA         WORDIMMEDIATEDATA
                
ADDORSUBIMMEDIATEDATA
                BSR         GETDESTMODEBITS
                CMPI.B      #%000,D1
                BEQ         BYTEIMMEDIATEDATA
                CMPI.B      #%001,D1
                BEQ         WORDIMMEDIATEDATA
                CMPI.B      #%010,D1
                BEQ         LONGIMMEDIATEDATA
                CMPI.B      #%011,D1
                BEQ         WORDIMMEDIATEDATA
                CMPI.B      #%111,D1
                BEQ         LONGIMMEDIATEDATA
                BRA         BADDATA
                
************************effective address vs opcode jumps**************
EAVSOP0000
                BSR     GETSOURCEMODEBITS
                CMPI.B  #%111,D1
                BEQ     CHECKBTSTDNIMMEDIATEDATA
                MULU    #6,D1
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)
EAVSOP0001
                BRA     BADDATA
                
EAVSOP0010
                BRA     BADDATA

EAVSOP0011
                BRA     BADDATA
               
EAVSOP0100
                BSR     GETSOURCEMODEBITS               
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)
               
EAVSOP0101
                BSR     GETSOURCEMODEBITS
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)

EAVSOP0110
                BRA     BADDATA
               
EAVSOP0111
                BRA     BADDATA

EAVSOP1000
                BRA     BADDATA

EAVSOP1001
                BSR     GETSOURCEMODEBITS
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)

EAVSOP1010
                BRA     BADDATA
               
EAVSOP1011
                BSR     GETSOURCEMODEBITS
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)
               
EAVSOP1100
                BSR     GETSOURCEMODEBITS
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)

EAVSOP1101
                BSR     GETSOURCEMODEBITS
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)

EAVSOP1110
                BSR     GETSOURCEMODEBITS
                MULU    #6,D1                           *calculate index offset
                LEA     EAMODETABLE,A0                  *load eamodetable to validate effective address mode vs opcode
                JSR     0(A0,D1)
EAVSOP1111
                BRA     BADDATA
************************effective address vs opcode jumps**************
************************effective address mode jumps**************
EAMODE000
                MOVE.B      #'D',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST
EAMODE001                              
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST  
EAMODE010
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST 
EAMODE011
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #'+',(A1)+
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST 
EAMODE100                
                MOVE.B      #'-',(A1)+
                MOVE.B      #'(',(A1)+
                MOVE.B      #'A',(A1)+
                BSR         GETSOURCEREGBITS
                ADD.B       #$30, D1                *convert the binary for the data register to a decimal number to print as ascii
                MOVE.B      D1,(A1)+                *increment the good buffer forward after adding the data register number as decimal (read as ascii)
                MOVE.B      #')',(A1)+
                MOVE.B      #$00, (A1)              *end the string with null
                BRA         DONEWITHDEST  
EAMODE101
                BRA     BADDATA
EAMODE110
                BRA     BADDATA
EAMODE111
                BSR         GETSOURCEREGBITS        *retrieve source register bits and put in D1
                CMPI.B      #%000, D1               *if %000 it's a word address
                BEQ         DESTWORDADDRESS
                CMPI.B      #%001, D1               *if %001 it's a long address
                BEQ         DESTLONGADDRESS 
                BRA         BADDATA                 *else bad data
************************effective address mode jumps**************

*************************get bits and checks subroutines**************************
*get the source mode subroutine
GETSOURCEMODEBITS
                MOVE.W      (A4),D1
                MOVE.B      #10, D5
                LSL.W       D5, D1                  *shift out the first 10 bits (to get to the source, mode and register)
                MOVE.B      #13, D5
                LSR.W       D5, D1                  *shift back to the least significant so just the mode of the source can be looked at
                RTS 
                
*get the source register subroutine               
GETSOURCEREGBITS
                MOVE.W      (A4),D1                 *move contents of A4, first word of instruction to D1
                MOVE.B      #13, D5
                LSL.W       D5, D1                  *bit shift word 13 left
                LSR.W       D5, D1                  *bit shift word 13 right
                RTS
                
*get the destination register subroutine
GETDESTREGBITS
                MOVE.W      (A4),D1                 *move contents of A4, first word of instruction to D1
                LSL.W       #4, D1                  *bit shift word 4 left
                MOVE.B      #13, D5                *Store 13 in D5 to get around immediate data shift restrictions of 0 to 8
                LSR.W       D5, D1                  *bit shift word 13 right
                RTS  
                      
*get the destionation mode subroutine
GETDESTMODEBITS
                MOVE.W      (A4),D1                 *move contents of A4, first word of instruction to D1
                LSL.W       #7, D1                  *bit shift word 7 left
                MOVE.W      #13, D5                 *Store 13 in D5 to get around immediate data shift restrictions of 0 to 8
                LSR.W       D5, D1                  *bit shift 13 right
                RTS
                
*can now start looking at the destination mode subroutine                      
STARTDESTMODETABLE
                LEA         DESTMODETABLE, A0      *now were going to look at the destination modes and ensure they are valid and branching down correctly
                MULU        #6, D1                  *Multiply D1 by 6 for proper jumping, since D1 already has the destination mode bits
                JSR         0(A0, D1)               *Jump to the table
            
*can now start looking at the source mode subroutine
STARTSOURCEMODETABLE
                BSR         GETSOURCEMODEBITS       *Get the source mode bits, which is used for indexing on the table jump
                LEA         SOURCEMODETABLE, A0    *now were going to look at the source modes and ensure they are valid and branching down correctly
                MULU        #6, D1                  *Multiply the source mode bits by 6 for proper jumping
                CLR.L       D2                      *Clear D2 of its contents, to prevent anomolies from using it later
                JSR         0(A0, D1)               *Jump to table    
                
*make sure the destination register is valid for the associated destination mode (111) and opcode
VALIDATEMOVEDESTMODE
                MOVE.W      D1, D7                 *store the destination mode in D7 because it will need to be used later, and this is an "off-chance" check    
                BSR         GETDESTREGBITS         *Get the destination register bits into D1
                MOVE.W      D1, D2                 *register bits will be stored in d2
                MOVE.W      D7, D1                 *Put the destination mode bits back into D1 
                CMPI.B      #%000, D2              *Check if the destination is a hex word address
                BEQ         STARTDESTMODETABLE      *Let our table handle the hex word address conversion
                CMPI.B      #%001, D2               *Check if the destination is a hex long address
                BEQ         STARTDESTMODETABLE      *Let our table handle the hex long address conversion
                BRA         BADDATA                *everything has been UNvalidated at this point, it HAS be a bad data for MOVE SPECIFICALLY 
*make sure the source register is valid for the associated source mode (111) and opcode
VALIDATEMOVEBSOURCEMODE
                MOVE.W      D1, D7                 *store the source mode in D7 because it will need to be used later, and this is an "off-chance" check
                BSR         GETSOURCEREGBITS        *Get the source reg bits into D1
                MOVE.W      D1, D2                 *register bits will be stored in d2
                MOVE.W      D7, D1                  *Move the source mode bits back into D1
                CMPI.B      #%000, D2               *Check if the source is a hex word address
                BEQ         STARTSOURCEMODETABLE    *Let our table logic handle the hex word address conversion
                CMPI.B      #%001, D2               *Check if the source is a hex long address
                BEQ         STARTSOURCEMODETABLE    *Let our table do the conversion on a hex long address
                CMPI.B      #%100, D2               *Check if the source is a byte immediate data
                BEQ         BYTEIMMEDIATEDATA       *Handle byte immediate data conversion
                BRA         BADDATA                *everything has been UNvalidated at this point, it HAS be a bad data for MOVE SPECIFICALLY

VALIDATEMOVEWSOURCEMODE
                MOVE.W      D1, D7                 *store the source mode in D7 because it will need to be used later, and this is an "off-chance" check
                BSR         GETSOURCEREGBITS        *Get the source register bits into D1
                MOVE.W      D1, D2                 *register bits will be stored in d2
                MOVE.W      D7, D1                  *Move the source mode bits back into D1
                CMPI.B      #%000, D2               *Check if the source is a hex word address
                BEQ         STARTSOURCEMODETABLE    *Let our table logic handle the conversion
                CMPI.B      #%001, D2               *Check if the source is a hex long address
                BEQ         STARTSOURCEMODETABLE    *Let our table logic handle the conversion    
                CMPI.B      #%100, D2               *Check if the source is a word immediate data
                BEQ         WORDIMMEDIATEDATA       *Handle the word immediate data conversion
                BRA         BADDATA                *everything has been UNvalidated at this point, it HAS be a bad data for MOVE SPECIFICALLY
                
VALIDATEMOVELSOURCEMODE
                MOVE.W      D1, D7                 *store the source mode in D7 because it will need to be used later, and this is an "off-chance" check
                BSR         GETSOURCEREGBITS       *Get the source register bits into d1
                MOVE.W      D1, D2                 *register bits will be stored in d2
                MOVE.W      D7, D1                 *Store the source mode back into D7, this all prevents losing important data in D1 
                CMPI.B      #%000, D2              *Check if the source is a hex word address 
                BEQ         STARTSOURCEMODETABLE   *Let our table logic do the conversion
                CMPI.B      #%001, D2              *Check if the source is a hex long address
                BEQ         STARTSOURCEMODETABLE   *Let our table logic do the conversion
                CMPI.B      #%100, D2              *Check if the source is immediate data
                BEQ         LONGIMMEDIATEDATA      *Do the conversion on a long immediate data
                BRA         BADDATA                *everything has been UNvalidated at this point, it HAS be a bad data for MOVE SPECIFICALLY
                
BYTEIMMEDIATEDATA
                MOVEA.L     A4,A6                   *set A6 to first word of instruction
                ADDA.L      #$00000003, A6          *move A6 3 bytes, so it's pointing at the byte immediate data
                ADDI.B      #$02, D4                *increment counter of bytes read by 2
                CLR.L       D2                      *clean up D2
                MOVE.L      D1, D5                  
                MOVE.L      #$06, D1                *set hex_to_ascii to convert a byte
                MOVE.B      #$09,(A1)+              *Insert appropriate characters into buffer for printing an immediate hex value
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII            *Branch to HEX_TO_ASCII for conversion
                
WORDIMMEDIATEDATA
                MOVEA.L     A4,A6                   *set A6 to first word of instruction     
                ADDA.L      #$00000002, A6          *move A6 2 bytes, so it's pointing at the word immediate data
                ADDI.B      #$02, D4                *increment counter of bytes read by 2
                CLR.L       D2                      *clean up D2
                MOVE.L      D1, D5
                MOVE.L      #$04, D1                *set up hex_to_ascii to convert a word
                MOVE.B      #$09,(A1)+              *Insert appropriate characters for printing an immediate hex value
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII            *Branch to HEX_TO_ASCII for conversion
                
LONGIMMEDIATEDATA
                MOVEA.L     A4,A6                   *set A6 to first word of instruction
                ADDA.L      #$00000002, A6          *move A6 2 bytes, so it's pointing at the long immediate data
                ADDI.B      #$04, D4                *increment counter of bytes read by 4 (for long)
                CLR.L       D2                      *clean up D2
                MOVE.L      D1, D5
                MOVE.L      #$00, D1                *set up hex_to_ascii to convert a long
                MOVE.B      #$09,(A1)+              *Insert appropriate characters into buffer for print an immediate hex value
                MOVE.B      #'#',(A1)+
                MOVE.B      #'$',(A1)+
                BRA         HEX_TO_ASCII            *Branch to HEX_TO_ASCII for conversion

VALIDATEEAMODEVSREGISTER0000
                MOVE.W      D1, D7                  *store the source mode in D7 because it will need to be used later, and this is an "off-chance" check
                BSR         GETSOURCEREGBITS
                MOVE.W      D1, D2                  *register bits will be stored in d2
                MOVE.W      D7, D1                  *move source mode bits back into D1
                CMPI.B      #%000, D2               *Check if the EA reg is a hex word address
                BEQ         STARTSOURCEMODETABLE    *Use our table to decode the address on its own    
                CMPI.B      #%001, D2               *Check if the EA reg is a hex long address
                BEQ         STARTSOURCEMODETABLE    *Use our table to decode the address on its own
                CMPI.B      #%100, D2               *Otherwise if it is immediate data, branch to the method to verify the immediate data
                BEQ         CHECKBTSTDNIMMEDIATEDATA
                BRA         BADDATA                 *If none of these conditions apply, it is bad data
                          
CHECKBTSTDNIMMEDIATEDATA
                BSR         GETSOURCEREGBITS        *Get the source reg bits given in the BTST instruction, which is Data register to immediate data
                CMPI.B      #%100,D1                *Check to see if it is 100, because then we know the destination is immediate data
                BEQ         BTSTDNIMMEDIATEPRINT    *Handle theimmediate data
                BSR         GETSOURCEMODEBITS       *Otherwise we want to use our EAMODETABLE for the decoding of the destination
                MULU        #6,D1                   *We multiply the source mode bits for indexing to jump to the right method within the table
                LEA         EAMODETABLE,A0
                JSR         0(A0,D1)                *So we load the table and jump 
                
BTSTDNIMMEDIATEPRINT
                ADDI.B      #$02,D4                 *add 2 to count of bits read
                LEA         HEXTOASCIIFLAG, A6
                MOVE.B      #$03, (A6)              *set hextoasciiflag to 3, indicating to print good buffer next time hex_to_ascii is called
                MOVE.L      #$04, D1                *convert a word length. set loop to repeat 8 - D1 times
                MOVEA.W     A4,A6                   *set A6 to start of instruction
                ADDA.W      #$02, A6                *set A6 past first word, so it can read immediate data word
                CLR.L       D2                      *clean up D2
                MOVE.W      (A4),D5                 *move first word of instruction to D5
                MOVE.B      #'#',(A1)+              *put '#' in buffer for immediate data
                MOVE.B      #'$',(A1)+              *put '$' in buffer for hex values
                BRA         HEX_TO_ASCII            *call hex_to_ascii to convert word immediate data

GETBITS6AND7
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                MOVE.B      #14, D5
                LSL.W       #8, D1                  *bit shift word 8 left
                LSR.W       D5, D1                  *bit shift word 14 right
                RTS                                 
                
GETBITS3AND4
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                MOVE.B      #11,D5                  
                LSL.W       D5, D1                  *bit shift word 11 left
                MOVE.B      #14,D5                  
                LSR.W       D5, D1                  *bit shift word 14 right
                RTS
                
GETBIT8
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                LSL.W       #7, D1                  *bit shift word 7 left
                MOVE.B      #15,D5                 
                LSR.W       D5, D1                  *bit shift word 15 right
                RTS
      
GETBITS9AND10
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                MOVE.B      #14, D5 
                LSL.W       #5, D1                  *bit shift word 5 left 
                LSR.W       D5, D1                  *bit shift word 14 right
                RTS      
GETBIT5
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                MOVE.B      #10, D5
                LSL.W       D5, D1                  *bit shift word 10 left
                MOVE.B      #15, D5
                LSR.W       D5, D1                  *bit shift word 15 right
                RTS

GETBITS8THROUGH3
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                LSL.W       #7,D1                   *bit shift word 7 left
                MOVE.B      #10,D5                  *can't immediata data bit shift word with numbers > 8
                LSR.W       D5,D1                   *bit shift word 12 right
                RTS
                
GETBITS11THROUGH8
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                LSL.W       #4,D1                   *bit shift word 4 left
                MOVE.B      #12,D5                  *can't immediata data bit shift word with numbers > 8
                LSR.W       D5,D1                   *bit shift word 12 right
                RTS
                
GETBITS11THROUGH9
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1             
                LSL.W       #4,D1                   *bit shift word 4 left
                MOVE.B      #13,D5                  *can't immediate data bit shift with numbers > 8
                LSR.W       D5,D1                   *bit shift word 13 right
                RTS
                
GETBITS11THROUGH6
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                LSL.W       #4,D1                   *bit shift word 4 left
                MOVE.B      #10,D5                  *can't immediate data bit shift with numbers > 8
                LSR.W       D5,D1                   *bit shift word 10 right
                RTS
                
GETBITS7THROUGH0
                MOVE.W      (A4),D1                 *moves the contents of A4, first word of instruction, to D1
                LSL.W       #8,D1                   *bit shift word 8 left
                LSR.W       #8,D1                   *bit shift word 8 right
                RTS

                                                                     
*************************get bits and checks subroutines**************************                

*****************************************************************************************************************
                
 
* Put variables and constants here

ADDRODDMSG      DC.B    'The address was odd, please enter an address that is divisible by $2',CR, LF, 0
INTROMSG        DC.B    CR,LF,'Welcome to the disassembler!',CR,LF,'Created by Brody Schulke, Chris DuBois, and Rob Stachofsky',CR, LF, 0
REQUSTARTADDR   DC.B    'Please enter your starting address, at least 7000, even, and capitalized',CR, LF, 0
REQUESTENDINGADDR   DC.B    'Please enter your ENDING address, must be LESS than FFFF, even, and capitalized',CR, LF, 0
LOWADDRMSG      DC.B    'Address too low, please enter a higher address',CR, LF, 0
HIADDRMSG       DC.B    'Address too high, please enter a lower address',CR, LF, 0
ASCIIERRMSG     DC.B    'Invalid input, must contain 0-9 and/or A-F',CR, LF, 0
MOREINPUTMSG    DC.B    'Would you like to print out more instructions?',CR,LF,'Enter to contiue, "R" to restart, or "Q" to quit',CR,LF,0  
INVMOREINPMSG   DC.B    CR,LF,'Invalid input, please try again',CR,LF,0
FINISHEDMSG     DC.B    CR,LF,'Thanks for disassembling! Press "R" to restart, or "Q" to quit',CR,LF,0  
ENDINGMSG       DC.B    CR,LF,'Thanks for disassembling! BYYYYYYYYEEEE',CR,LF,0  


    END    $1000        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
