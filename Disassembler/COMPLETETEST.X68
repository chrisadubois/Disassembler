*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    
        ORG    $7000

START  
    BCHG    D3,D4    
    BCLR    D4,D1   
    BSET    D7,(A1)   
    ABCD    -(A3),-(A2)    
    EXG     D3,D1
    EXG     A4,A2
    EXG     D3,A2  
    MULU    (A3)+,D2
    MULU    -(A2),D1
    MULU    D5,D4 
		MOVEA.L		-(A1),A1
		MOVEA.L		-(A2),A2
		MOVEA.L		-(A3),A3
		MOVEA.L		-(A4),A4
		MOVEA.L		-(A5),A5
		MOVEA.L		-(A6),A6
		MOVEA.L		(A1)+,A0
		MOVEA.L		(A2)+,A1
		MOVEA.L		(A3)+,A2
		MOVEA.L		(A4)+,A3
		MOVEA.L		(A5)+,A4
		MOVEA.L		(A6)+,A5
		MOVEA.L		$1234,A0
		MOVEA.L		$2345,A1
		MOVEA.L		$3456,A2
		MOVEA.L		$4567,A3
    BCHG    D3,D4   
    BCLR    D4,D1   
    BSET    D7,(A1)    
    ABCD    -(A3),-(A2)    
    EXG     D3,D1
    EXG     A4,A2
    EXG     D3,A2    
    MULU    (A3)+,D2
    MULU    -(A2),D1
    MULU    D5,D4
		MOVEA.L		$5678,A4
		MOVEA.L		$7890,A5
		MOVEA.L		$12345678,A0
		MOVEA.L		$12345678,A1
		MOVEA.L		$12345678,A2
		MOVEA.L		$12345678,A3
		MOVEA.L		$12345678,A4
		MOVEA.L		$12345678,A5	
		SUBI.B		#$12,D0
		SUBI.B		#$24,(A0)
		SUBI.B		#$36,-(A0)
		SUBI.B		#$48,(A0)+
		SUBI.B		#$5A,$7010
		SUBI.B		#$6C,$00007014
		SUBI.W		#$1234,D0
		SUBI.W		#$2456,(A0)
		SUBI.W		#$3678,-(A0)
		SUBI.W		#$4890,(A0)+
		SUBI.W		#$5ABC,$7010
		SUBI.W		#$6CDE,$00007014
		SUBI.L		#$12345678,D0
		SUBI.L		#$12345678,(A0)
		SUBI.L		#$12345678,-(A0)
		SUBI.L		#$12345678,(A0)+
		SUBI.L		#$12345678,$7010
		SUBI.L		#$12345678,$00007014
		EORI.B		#$12,D0
		EORI.B		#$24,(A0)
		EORI.B		#$36,-(A0)
		EORI.B		#$48,(A0)+
		EORI.B		#$5A,$7010
		EORI.B		#$6C,$00007014
		EORI.W		#$1234,D0
		EORI.W		#$2456,(A0)
		EORI.W		#$3678,-(A0)
		EORI.W		#$4890,(A0)+
		EORI.W		#$5ABC,$7010
		EORI.W		#$6CDE,$00007014
		EORI.L		#$12345678,D0
		EORI.L		#$12345678,(A0)
		EORI.L		#$12345678,-(A0)
		EORI.L		#$12345678,(A0)+
		EORI.L		#$12345678,$7010
		EORI.L		#$12345678,$00007014
		ORI.B		#$12,D0
		ORI.B		#$24,(A0)
		ORI.B		#$36,-(A0)
		ORI.B		#$48,(A0)+
		ORI.B		#$5A,$7010
		ORI.B		#$6C,$00007014
		ORI.W		#$1234,D0
		ORI.W		#$2456,(A0)
		ORI.W		#$3678,-(A0)
		ORI.W		#$4890,(A0)+
		ORI.W		#$5ABC,$7010
		ORI.W		#$6CDE,$00007014
		ORI.L		#$12345678,D0
		ORI.L		#$12345678,(A0)
		ORI.L		#$12345678,-(A0)
		ORI.L		#$12345678,(A0)+
		ORI.L		#$12345678,$7010
		ORI.L		#$12345678,$00007014
		CMPI.B		#$12,D0
		CMPI.B		#$24,(A0)
		CMPI.B		#$36,-(A0)
		CMPI.B		#$48,(A0)+
		CMPI.B		#$5A,$7010
		CMPI.B		#$6C,$00007014
		 DIVS.W      $5678, D3
    DIVS.W      (A4), D2
    DIVS.W      (A1)+, D4
    DIVS.W      -(A6), D6
    DIVS.W      $56789012, D7
    DIVS.W      $1348, D0
    DIVS.W      #$1234, D1
    DIVS.W      #$34, D5
		CMPI.W		#$1234,D0
		CMPI.W		#$2456,(A0)
		CMPI.W		#$3678,-(A0)
		CMPI.W		#$4890,(A0)+
		CMPI.W		#$5ABC,$7010
		CMPI.W		#$6CDE,$00007014
		CMPI.L		#$12345678,D0
		CMPI.L		#$12345678,(A0)
		CMPI.L		#$12345678,-(A0)
		CMPI.L		#$12345678,(A0)+
		CMPI.L		#$12345678,$7010
		CMPI.L		#$12345678,$00007014	
			LSL.B	D1, D6
	LSR.B	D4, D2
	LSL.B	#7, D3
	LSR.B	#3, D1
	LSL.W	D1, D6
	LSR.W	D4, D2
	LSL.W	$5000
	LSR.W	$8769
	LSL.W	#7, D1
	LSR.W	#3, D5
	LSL.L	D3, D5
	LSR.L	D7, D0
	    CMPM.B  (A2)+,(A3)+
    CMPM.W  (A2)+,(A3)+
    CMPM.L  (A2)+,(A3)+    
    SUBX.B  D4,D7
    SUBX.W  -(A3),-(A5)
    SUBX.L  D4,D7
    SUBX.L  -(A3),-(A5)  
    ADDX.B  D4,D7
    ADDX.W  -(A3),-(A5)
    ADDX.L  D4,D7
    ADDX.L  -(A3),-(A5)  
    DIVU    (A3)+,D2
    DIVU    -(A2),D1
    DIVU    D5,D4
    SBCD    D3,D2
	LSL.L   #4, D4
	LSR.L   #7, D2
	LSL.W	(A4)
	LSR.W	(A3)
	LSL.W	(A1)+
	LSR.W	-(A5)
	LSL.W	$12345678
	LSR.W	$12345678
	ASL.B	D1, D6
	ASR.B	D4, D2
	ASL.B	#7, D3
	ASR.B	#3, D1
	ASL.W	D1, D6
	ASR.W	D4, D2
	ASL.W	$5000
	ASR.W	$8769
	ASL.W	#7, D1
	ASR.W	#3, D5
	ASL.L	D3, D5
	ASR.L	D7, D0
	ASL.L   #4, D4
	ASR.L   #7, D2
	ASL.W	(A4)
	ASR.W	(A3)
	ASL.W	(A1)+
	ASR.W	-(A5)
	ASL.W	$12345678
	ASR.W	$12345678
	ROL.B	D1, D6
	ROR.B	D4, D2
	ROL.B	#7, D3
	ROR.B	#3, D1
	ROL.W	D1, D6
	ROR.W	D4, D2
	ROL.W	$5000
	ROR.W	$8769
	ROL.W	#7, D1
	ROR.W	#3, D5
	ROL.L	D3, D5
	ROR.L	D7, D0
	ROL.L   #4, D4
	ROR.L   #7, D2
	ROL.W	(A4)
	ROR.W	(A3)
	ROL.W	(A1)+
	ROR.W	-(A5)
	ROL.W	$12345678
	ROR.W	$12345678
		SUBI.B		#$12,D0
		SUBI.B		#$24,(A0)
		SUBI.B		#$36,-(A0)
		SUBI.B		#$48,(A0)+
		SUBI.B		#$5A,$7010
		SUBI.B		#$6C,$00007014
		SUBI.W		#$1234,D0
		SUBI.W		#$2456,(A0)
		SUBI.W		#$3678,-(A0)
		SUBI.W		#$4890,(A0)+
		SUBI.W		#$5ABC,$7010
		SUBI.W		#$6CDE,$00007014
		SUBI.L		#$12345678,D0
		SUBI.L		#$12345678,(A0)
		SUBI.L		#$12345678,-(A0)
		SUBI.L		#$12345678,(A0)+
		SUBI.L		#$12345678,$7010
		SUBI.L		#$12345678,$00007014
		EORI.B		#$12,D0
		EORI.B		#$24,(A0)
		EORI.B		#$36,-(A0)
		EORI.B		#$48,(A0)+
		EORI.B		#$5A,$7010
		EORI.B		#$6C,$00007014
		EORI.W		#$1234,D0
		EORI.W		#$2456,(A0)
		EORI.W		#$3678,-(A0)
		EORI.W		#$4890,(A0)+
		EORI.W		#$5ABC,$7010
		EORI.W		#$6CDE,$00007014
		EORI.L		#$12345678,D0
		EORI.L		#$12345678,(A0)
		EORI.L		#$12345678,-(A0)
		EORI.L		#$12345678,(A0)+
		EORI.L		#$12345678,$7010
		EORI.L		#$12345678,$00007014
		ORI.B		#$12,D0
		ORI.B		#$24,(A0)
		ORI.B		#$36,-(A0)
		ORI.B		#$48,(A0)+
		ORI.B		#$5A,$7010
		ORI.B		#$6C,$00007014
		ORI.W		#$1234,D0
		ORI.W		#$2456,(A0)
		ORI.W		#$3678,-(A0)
		ORI.W		#$4890,(A0)+
		ORI.W		#$5ABC,$7010
		ORI.W		#$6CDE,$00007014
		    SBCD    -(A3),-(A7)
    OR.B    (A2),D3
    OR.B     D3,(A2)
    OR.W    (A2),D3
    OR.W     D3,(A2)
    OR.L    (A2),D3
    OR.L     D3,(A2) 
    SUBQ.B    #3,D2
    SUBQ.W    #5,A2
    SUBQ.L    #8,A6   
    SCC      (A4)+
    ROXL.L  D3,D5
    ROXL.W  (A7)
    ROXL.W  D3,D5
    ROXL.W  (A7)
    ROXL.B  D3,D6
    ROXL.W  (A4)  
    ROXR.L  D3,D5
    ROXR.W  (A7)
    ROXR.W  D3,D5
		ORI.L		#$12345678,D0
		ORI.L		#$12345678,(A0)
		ORI.L		#$12345678,-(A0)
		ORI.L		#$12345678,(A0)+
		ORI.L		#$12345678,$7010
		ORI.L		#$12345678,$00007014
		CMPI.B		#$12,D0
		CMPI.B		#$24,(A0)
		CMPI.B		#$36,-(A0)
		CMPI.B		#$48,(A0)+
		CMPI.B		#$5A,$7010
		CMPI.B		#$6C,$00007014
		CMPI.W		#$1234,D0
		CMPI.W		#$2456,(A0)
		CMPI.W		#$3678,-(A0)
		CMPI.W		#$4890,(A0)+
		CMPI.W		#$5ABC,$7010
		CMPI.W		#$6CDE,$00007014
		CMPI.L		#$12345678,D0
		CMPI.L		#$12345678,(A0)
		CMPI.L		#$12345678,-(A0)
		CMPI.L		#$12345678,(A0)+
		CMPI.L		#$12345678,$7010
		CMPI.L		#$12345678,$00007014
     BRA TEST_LOOP     
TEST_LOOP 
    MOVE.L D0,(A0)
    CMP.L (A0),D0
    BEQ ADDR_OK
NOT_OK
    MOVE.W A0,(A4)
    ADDQ.B #1,(A3)
    CMPI.B #5,(A3)
    BEQ DONE
ADDR_OK
    ADDQ.L #1,A0
    CMPA A0,A1
    BGE TEST_LOOP
    BRA TEST_LOOP
DONE
        LEA     $A978BFED,A1
        LEA     (A3),A2
        LEA     $6002,A2
        LEA     $C656,A6
        LEA     $39BCB443,A4
        JSR     NEGNOTTEST
        JSR     NOTTEST1
NEGTEST1
        NEG.B       D1
        NEG.W       (A4)+
        RTS      
NOTTEST1
        NOT.W       $8000
        NOT.L       $0192ABCF       
NEGNOTTEST
        NEG.L       $AFB3231
        NEG.W       $211B
        NOT.B       -(A4)
        JSR         NEGTEST1
        RTS
    BRA     LOOP2   
LOOP1
    MOVE.B  #$1, D1
    CMPI.B  #$1, D1
    BHI     LOOP2
    BRA     LOOP2
LOOP8

LOOP7
    MOVE.B  #$0, D1
    CMPI.B  #$1, D1
    BNE     LOOP8
    BRA     LOOP1  
LOOP2
    MOVE.B  #$2, D1
    CMPI.B  #$1, D1
    BLT     LOOP3
    BRA     LOOP1
LOOP6
    MOVE.B  #$2, D1
    CMPI.B  #$1, D1
    BLT     LOOP7
    BRA     LOOP1     
LOOP3
    MOVE.B  #$0, D1
    CMPI.B  #$1, D1
    BGT     LOOP4
    BRA     LOOP1
LOOP5
    MOVE.B  #$1, D1
    CMPI.B  #$1, D1
    BEQ     LOOP6 
    BRA     LOOP1     
LOOP4
    BRA     LOOP5
    BRA     LOOP1
*TANNA TEST    
    MOVE.L $1234,$5678
    MOVE.W $1234,$12345678
    MOVE.W $12345678, $246810
    MOVE.W #$123,D6
    MOVE.L #$2468135,$54789
    MOVE.L #$1234,D3
    MOVE.L  D1,D2
    MOVE.W  A4, (A5)
    MOVE.L  (A5)+,-(A5)
    MOVE.B  $BA, D0         
    MOVE.W  $1234, D1
    MOVE.L  #$FFAA1234, D2
    MOVE.B  $BA, (A0)        
    MOVE.W  $1234, (A1)
    MOVE.L  #$FFAA1234, (A2)
    MOVE.B  #$BA, (A3)+       
    MOVE.W  $1234, (A4)+
    MOVE.L  $FFAA1234, (A5)+
    MOVE.B  $BA, -(A0)      
    MOVE.W  $1234, -(A2)
    MOVE.L  #$FFAA1234, -(A4)
    MOVE.B  $BA, $1234        
    MOVE.W  $1234, $FFAA1234       
    MOVE.L  $00000000, $00F00200    
    ADD.W       $FFAA1234,D1    
    ADD.B       $1234,D0    
    ADD.B       D0,D1   
    ADD.W       D1,D2
    ADD.L       D2,D3
    ADD.W       A1,D1    
    ADD.L       A2,D2
    ADD.L       A3,D5
    ADD.B       (A0),D2  
    ADD.W       (A1),D3
    ADD.L       (A2),D4
    ADD.B       (A3)+,D0 
    ADD.W       (A4)+,D1
    ADD.L       (A5)+,D2
    ADD.B       -(A0),D3  
    ADD.W       -(A1),D4    
    ADD.L       -(A2),D5
    ADDA.W       D0,A0   
    ADDA.L       D1,A1   
    ADDA.L       A2,A3     
    ADDA.W       A3,A4
    ADDA.W       (A0),A0         
    ADDA.L       (A2),A2
    ADDA.L       (A1)+,A1        
    ADDA.W       (A2)+,A2
    ADDA.W       -(A3),A2        
    ADDA.L       -(A2),A3
    ADDA.L       $1234,A0       
    ADDA.W       $1234,A2    
    ADDA.W       $FFAA1234,A3        
    ADDA.L       $FFAA1234,A4  
    ADDA.W       #$23,A7
    ADDA.L       #$FFAA1234,A1
    ADDA.L       #$FCFCFCFC,A5      
    SUBQ        #3,D2 
    MOVEQ       #$23,D6
    MOVEQ       #$12,D1
    MOVEQ       #$23,D3
    MOVEQ       #$12,D4
    SUB.B       D0,D1       
    SUB.W       D2,D3 
    SUB.L       A1,D0      
    SUB.W       A4,D3
    SUB.B       (A3),D3     
    SUB.L       (A2),D0
    SUB.B       (A0)+,D1    
    SUB.W       (A3)+,D2
    SUB.L       -(A1),D2    
    SUB.B       -(A2),D1    
    SUB.W       $1234,D0    
    SUB.L       $FCFCFCFC,D2    
    SUB.W       $1,D5
    SUB.L       $54FFF,D7
    SUB.W       D0,A1      
    SUB.L       D3,A4
    SUB.B       D3,(A3)     
    SUB.W       D0,(A2)
    SUB.L       D1,(A0)+    
    SUB.B       D2,(A3)+
    SUB.W       D2,-(A1)    
    SUB.L       D1,-(A2)
    SUB.B       D0,$1234    
    SUB.W       D2,$FCFCFCFC  
    SUB.L       D3,$FFAA1234
*TANNA TEST
		ADDQ.B		#$1,D0
		ADDQ.B		#$2,(A0)
		ADDQ.B		#$3,-(A0)
		ADDQ.B		#$4,(A0)+
		ADDQ.B		#$5,$7010
		ADDQ.B		#$6,$00007014
		ADDQ.W		#$4,D0
		ADDQ.W		#$6,(A0)
		ADDQ.W		#$8,-(A0)
		ADDQ.W		#$7,(A0)+
		ADDQ.W		#$5,$7010
		ADDQ.W		#$6,$00007014
		ADDQ.L		#$1,D0
		ADDQ.L		#$2,(A0)
		ADDQ.L		#$8,-(A0)
		ADDQ.L		#$6,(A0)+
		ADDQ.L		#$7,$7010
		ADDQ.L		#$4,$00007014
            ADD.B D2,D3
            ADD.B (A2)+,D2
            ADD.B  $23,D6
            ADD.B   $00FCA453,D3   
        MULS.W  #$1111,D2
		AND.B		#$12,D0
		AND.B		D0,D1
		AND.B		D0,(A0)
		AND.B		D0,-(A0)
		AND.B		D0,(A0)+
		AND.B		D0,$7010
		AND.B		D0,$00007014
		AND.B		(A0),D0
		AND.B		-(A1),D0
		AND.B		(A1)+,D0
		AND.B		$1234,D0
		ROXR.W  (A7)
    ROXR.B  D3,D6
    ROXR.W  (A4)
    MOVE.W  D4,CCR
    MOVE.W  -(A4),CCR   
    MOVE.W  SR,D2
    MOVE.W  D3,SR    
    NEGX.B  D3
    NEGX.W  (A5)
    NEGX.L  -(A4)    
    CLR.B   D2
    CLR.W   D5
    CLR.L   (A2)    
    EXT.W   D3
    EXT.L   D7
		AND.B		$12345678,D0
		AND.W		#$1234,D0
		AND.W		D0,D1
		AND.W		D0,(A0)
		AND.W		D0,-(A0)
		AND.W		D0,(A0)+
		AND.W		D0,$7010
		AND.W		D0,$00007014
		AND.W		(A0),D0
		AND.W		-(A1),D0
		AND.W		(A1)+,D0
		AND.W		$1234,D0
		AND.W		$12345678,D0
    	AND.L		#$12345678,D0
		AND.L		D0,D1
		AND.L		D0,(A0)
		AND.L		D0,-(A0)
		AND.L		D0,(A0)+
		AND.L		D0,$7010
		AND.L		D0,$00007014
		AND.L		(A0),D0
		AND.L		-(A1),D0
		AND.L		(A1)+,D0	
		AND.L		$1234,D0
		AND.L		$12345678,D0
		EXG     D1, D4
		EXG     A1, A4
		EXG     D6, A5
		ABCD    D4, D5
		ABCD    -(A4),-(A7)
		MULU.W  D2,D1
		MULS.W      D1, D4
		MULS.W      (A5), D6
		MULS.W      (A2)+, D2
		MULS.W      -(A6), D7
		MULS.W      $5555, D3
		MULS.W      $12345555, D4
		MULS.W      #$1234, D4
    CMP.B	D1, D2
	CMP.B	(A4), D5
	CMP.B	(A3), D6
	CMP.B	(A6)+, D1
	CMP.B	-(A0), D7
	CMP.B	$4567, D4
	CMP.B 	$1234567, D2
	CMP.B	#$09, D5
	CMP.B	#$34, D6
	CMP.B	#$78, D3
	CMP.W	D1, D2
	CMP.W	A4, D5
	CMP.W	(A3), D6
	CMP.W	(A6)+, D1
	CMP.W	-(A0), D7
	CMP.W	$4567, D4
	CMP.W 	$1234567, D2
	CMP.W	#$09, D5
	CMP.W	#$1234, D6
	CMP.W	#$A9B3, D3
	CMP.L	D1, D2
	CMP.L	A4, D5
	CMP.L	(A3),D6
	CMP.L	(A6)+, D1
	CMP.L	-(A0),D7
	CMP.L	$4567, D4
	CMP.L 	$1234567, D2
	CMP.L	#$09, D5
	CMP.L	#$1234, D6
	CMP.L	#$12345678, D3
	CMPA.W	D1, A2
	CMPA.W	A4, A5
	CMPA.W	(A3),A6
	CMPA.W	(A6)+, A1
	CMPA.W	-(A0),A7
	CMPA.W	$4567, A4
	CMPA.W 	$1234567, A2
	CMPA.W	#$09, A5
	CMPA.W	#$1234, A6
	CMPA.W	#$1678, A3
	CMPA.L	D1, A2
	CMPA.L	A4, A5
	CMPA.L	(A3), A6
	CMPA.L	(A6)+, A1
	CMPA.L	-(A0), A7
	CMPA.L	$4567, A4
	CMPA.L 	$1234567, A2
	CMPA.L	#$09, A5
	CMPA.L	#$1234, A6
	CMPA.L	#$12345678, A3
	EOR.B	D1, D7
	EOR.B	D6, (A4)
	EOR.B	D2, (A3)+
	EOR.B	D4, -(A6)
	EOR.B	D3, $1234
	EOR.B	D5, $12345678
	EOR.W	D1, D7
	EOR.W	D6, (A4)
	EOR.W	D2, (A3)+
	EOR.W	D4, -(A6)
	EOR.W	D3, $1234
	EOR.W	D5, $12345678
	EOR.L	D1, D7
	EOR.L	D6, (A4)
	EOR.L	D2, (A3)+
	EOR.L	D4, -(A6)
	EOR.L	D3, $1234
	EOR.L	D5, $12345678
    BTST            #608,D1
    BTST            #5,(A5)
    BTST            #1200, $7986
    BTST            #1400, (A1)
    BTST            #9,$00FDCDFE
    BTST            #$78, D2
    BTST            #$12345678, $7600
    BTST            D4,$9283
    BTST            D2,-(A5)
    BTST            D0, #$29
    BTST            D3, #$3929
    BTST            #9,$00FDCDFE
    BTST            #$78, D2
    BTST            #$12345678, $7600  
    DIVS.W      $5678, D3
    DIVS.W      (A4), D2
    DIVS.W      (A1)+, D4
    DIVS.W      -(A6), D6
    DIVS.W      $56789012, D7
    DIVS.W      $1348, D0
    DIVS.W      #$1234, D1
    DIVS.W      #$34, D5   
    MOVE.W          $4000,$5000
    CMPI.B          #$90,D4
    EORI.L          #$9ABE0231,(A4)+
    CMPI.W          #$3273,(A2)
    ORI.W          #$2AFF,(A2)
    CMPI.L          #$00F39DA2,(A4)+
    EORI.B          #$90,D4
    EORI.W          #$3C44,(A2)
    ORI.B           #$02,D4
    ORI.L           #$92830231,(A4)+         
    BTST            #608,D1
    BTST            #5,(A5)
    BTST            #1200, $7986
    BTST            #1400, (A1)
    BTST            #9,$00FDCDFE
    BTST            #$78, D2
    		MOVE.W		#$4890,(A0)+
		MOVE.W		#$5ABC,$7010
		MOVE.W		#$6CDE,$00007014
    BTST            #$12345678, $7600
    BTST            D4,$9283
    BTST            D2,-(A5)
    BTST            D0, #$29
    BTST            D3, #$3929
    BTST            #9,$00FDCDFE
    		MOVEA.L		(A1),A1
		MOVEA.L		(A2),A2
		MOVEA.L		(A3),A3
    BTST            #$78, D2
    BTST            #$12345678, $7600
        MOVEM.W     $4000, A0/A1/D3-D6
        MOVEM.L     $ABCDF123, A1-A5/D3-D6
        MOVEM.L     D0/D1/D3/D5/A1/A4/A7, -(A2)
        MOVEM.L     (A0),A4/A3/A2/D6/D3/D1/D0
        MOVEM.L     (A4)+, D0-D5/A3-A6
        MOVEM.W     D0/D4/D5/A3/A2/A1, $4050
        MOVEM.L     D0/D1/D3/D5/A1/A4/A7,(A3)
        MOVEM.W     A3/A4/A7/D1-D5, $3451234
            MOVEM.L     A0-A3/D0-D3/D6/D7,-(A7)
            MOVEM.L     A0/A1/A2/D3/D0/D1/D2/A3/D4/D5/D6/D7, -(A7)
    MOVE.B  D1, D2
    MOVE.B  D7, D3
    MOVE.B  D4, D6
    MOVE.B  D0, D5    
    MOVE.B  D1, D2
    MOVE.B  D7, D3
    MOVE.B  D4, D6
    MOVE.B  $6BCF,$7654
    MOVE.B  $ABCF09,$456712
    MOVE.B  D0, D5
    MOVE.B  (A0),D5
    MOVE.B  (A4),(A7)
    MOVE.B  D5,(A3)
    MOVE.B  (A3)+,-(A4)
    MOVE.B  -(A6),(A1)+
    MOVE.B  $7F6E, D0
    MOVE.B  $C608, D2
    MOVE.B  D1, D2
    MOVE.B  D7, D3
    MOVE.W  D7, D1
    MOVE.L  D1,(A4)
    MOVE.B  D4, D6
    MOVE.B  D0, D5
    MOVE.B  (A0),D5
    MOVE.B  (A4),(A7)
    MOVE.B  D5,(A3)
    MOVE.B  (A3)+,-(A4)
    MOVE.B  -(A6),(A1)+
    MOVE.B  $7F6E, D0
    MOVE.B  $C608, D2
    MOVE.W  (A5)+,D6
    MOVE.B  #$00000000000000000000000000000000000000008, D2
    MOVE.B  $456712,$ABCF09
    MOVE.B  $6BCF,$ABCF09
    SUB.B   D4, D5
    MOVE.W  D2,D5
    MOVE.W  (A7),D0
    MOVE.B  #$A7, D2
    MOVE.W  -(A5),D6
    MOVE.B  D7, $ABCF
    MOVE.B  (A7)+,$7654
    MOVE.B  $ABCF09,$7654
    MOVE.W  A7,D0
    MOVE.W  D0,(A7)
    MOVEA.W $ABCF, A4
    MOVEA.W D0,A7
		MOVE.B		#$12,D2
		MOVE.B		#$24,(A0)
		MOVE.B		#$36,-(A0)
		MOVE.B		#$48,(A0)+
		MOVE.B		#$5A,$7010
		MOVE.B		#$6C,$00007014
		MOVE.B		D0,D1
		MOVE.B		D0,(A0)
		MOVE.B		D0,-(A0)
		MOVE.B		D0,(A0)+
		MOVE.B		D0,$7010
		MOVE.B		D0,$00007014
		MOVE.B		(A0),D0
		MOVE.B		(A1),(A2)
		MOVE.B		(A2),-(A3)
		MOVE.B		(A3),(A4)+
		MOVE.B		(A4),$7010
		MOVE.B		(A5),$00007014
		MOVE.B		-(A1),D0
		MOVE.B		-(A2),(A1)
		MOVE.B		-(A3),-(A2)
		MOVE.B		-(A4),(A3)
		MOVE.B		-(A5),$7010
		MOVE.B		-(A6),$00007014
		MOVE.B		(A1)+,D0
		MOVE.B		(A2)+,(A1)
		MOVE.B		(A3)+,-(A2)
		MOVE.B		(A4)+,(A3)+
		MOVE.B		(A5)+,$7010
		MOVE.B		(A6)+,$00007014
		MOVE.B		$1234,D0
		MOVE.B		$2345,(A1)
		MOVE.B		$3456,-(A2)
		MOVE.B		$4567,(A3)+
		MOVE.B		$5678,$7010
		MOVE.B		$7890,$00007014
		MOVE.B		$12345678,D0
		MOVE.B		$12345678,(A4)
		MOVE.B		$12345678,-(A4)
		MOVE.B		$12345678,(A4)+
		MOVE.B		$12345678,$7010
		MOVE.B		$12345678,$00007014
		MOVE.W		#$1234,D0
		MOVE.W		#$2456,(A0)
		MOVE.W		#$3678,-(A0)
		MOVE.W		#$4890,(A0)+
		MOVE.W		#$5ABC,$7010
		MOVE.W		#$6CDE,$00007014
		MOVE.W		D0,D1
		MOVE.W		D0,(A0)
		MOVE.W		D0,-(A0)
		MOVE.W		D0,(A0)+
		MOVE.W		D0,$7010
		MOVE.W		D0,$00007014
		MOVE.W		(A0),D0
		MOVE.W		(A1),(A2)
		MOVE.W		(A2),-(A3)
		MOVE.W		(A3),(A4)+
		MOVE.W		(A4),$7010
		MOVE.W		(A5),$00007014
		MOVE.W		-(A1),D0
		MOVE.W		-(A2),(A1)
		MOVE.W		-(A3),-(A2)
		MOVE.W		-(A4),(A3)
		MOVE.W		-(A5),$7010
		MOVE.W		-(A6),$00007014
		MOVE.W		(A1)+,D0
		MOVE.W		(A2)+,(A1)
		MOVE.W		(A3)+,-(A2)
		MOVE.W		(A4)+,(A3)+
		MOVE.W		(A5)+,$7010
		MOVE.W		(A6)+,$00007014
		MOVE.W		$1234,D0
		MOVE.W		$2345,(A1)
		MOVE.W		$3456,-(A2)
		MOVE.W		$4567,(A3)+
		MOVE.W		$5678,$7010
		MOVE.W		$7890,$00007014
		MOVE.W		$12345678,D0
		MOVE.W		$12345678,(A4)
		MOVE.W		$12345678,-(A4)
		MOVE.W		$12345678,(A4)+
		MOVE.W		$12345678,$7010
		MOVE.W		$12345678,$00007014
		MOVE.L		#$12345678,D0
		MOVE.L		#$12345678,(A0)
		MOVE.L		#$12345678,-(A0)
		MOVE.L		#$12345678,(A0)+
		MOVE.L		#$12345678,$7010
		MOVE.L		#$12345678,$00007014
		MOVE.L		D0,D1
		MOVE.L		D0,(A0)
		MOVE.L		D0,-(A0)
		MOVE.L		D0,(A0)+
		MOVE.L		D0,$7010
		MOVE.L		D0,$00007014
		MOVE.L		(A0),D0
		MOVE.L		(A1),(A2)
		MOVE.L		(A2),-(A3)
		MOVE.L		(A3),(A4)+
		MOVE.L		(A4),$7010
		MOVE.L		(A5),$00007014
		MOVE.L		-(A1),D0
		MOVE.L		-(A2),(A1)
		MOVE.L		-(A3),-(A2)
		MOVE.L		-(A4),(A3)
		MOVE.L		-(A5),$7010
		MOVE.L		-(A6),$00007014
		MOVE.L		(A1)+,D0
		MOVE.L		(A2)+,(A1)
		MOVE.L		(A3)+,-(A2)
		MOVE.L		(A4)+,(A3)+
		MOVE.L		(A5)+,$7010
		MOVE.L		(A6)+,$00007014
		MOVE.L		$1234,D0
		MOVE.L		$2345,(A1)
		MOVE.L		$3456,-(A2)
		MOVE.L		$4567,(A3)+
		MOVE.L		$5678,$7010
		MOVE.L		$7890,$00007014
		MOVE.L		$12345678,D0
		MOVE.L		$12345678,(A4)
		MOVE.L		$12345678,-(A4)
		MOVE.L		$12345678,(A4)+
		MOVE.L		$12345678,$7010
		MOVE.L		$12345678,$00007014
		MOVEA.W		#$1234,A0
		MOVEA.W		#$2456,A1
		MOVEA.W		#$3678,A2
		MOVEA.W		#$4890,A3
		MOVEA.W		#$5ABC,A4
		MOVEA.W		#$6CDE,A5
		MOVEA.W		D0,A0
		MOVEA.W		D0,A1
		MOVEA.W		D0,A2
		MOVEA.W		D0,A3
		MOVEA.W		D0,A4
		MOVEA.W		D0,A5
		MOVEA.W		(A0),A0
		MOVEA.W		(A1),A1
		MOVEA.W		(A2),A2
		MOVEA.W		(A3),A3
		MOVEA.W		(A4),A4
		MOVEA.W		(A5),A5
		MOVEA.W		-(A1),A0
		MOVEA.W		-(A2),A1
		MOVEA.W		-(A3),A2
		MOVEA.W		-(A4),A3
		MOVEA.W		-(A5),A4
		MOVEA.W		-(A6),A5
		MOVEA.W		(A1)+,A0
		MOVEA.W		(A2)+,A1
		MOVEA.W		(A3)+,A2
		MOVEA.W		(A4)+,A3
		MOVEA.W		(A5)+,A4
		MOVEA.W		(A6)+,A5
		MOVEA.W		$1234,A0
		MOVEA.W		$2345,A1
		MOVEA.W		$3456,A2
		MOVEA.W		$4567,A3
		MOVEA.W		$5678,A4
		MOVEA.W		$7890,A5
		MOVEA.W		$12345678,A0
		MOVEA.W		$12345678,A1
		MOVEA.W		$12345678,A2
		MOVEA.W		$12345678,A3
		MOVEA.W		$12345678,A4
		MOVEA.W		$12345678,A5
		MOVEA.L		#$12345678,A0
		MOVEA.L		#$12345678,A1
		MOVEA.L		#$12345678,A2
		MOVEA.L		#$12345678,A3
		MOVEA.L		#$12345678,A4
		MOVEA.L		#$12345678,A5
		MOVEA.L		D0,A0
		MOVEA.L		D0,A1
		MOVEA.L		D0,A2
		MOVEA.L		D0,A3
		MOVEA.L		D0,A4
		MOVEA.L		D0,A5
		MOVEA.L		(A0),A0
		MOVEA.L		(A1),A1
		MOVEA.L		(A2),A2
		MOVEA.L		(A3),A3
		MOVEA.L		(A4),A4
		MOVEA.L		(A5),A5
		MOVEA.L		-(A1),A1
		MOVEA.L		-(A2),A2
		MOVEA.L		-(A3),A3
		MOVEA.L		-(A4),A4
		MOVEA.L		-(A5),A5
		MOVEA.L		-(A6),A6
		MOVEA.L		(A1)+,A0
		MOVEA.L		(A2)+,A1
		MOVEA.L		(A3)+,A2
		MOVEA.L		(A4)+,A3
		MOVEA.L		(A5)+,A4
		MOVEA.L		(A6)+,A5
		MOVEA.L		$1234,A0
		MOVEA.L		$2345,A1
		MOVEA.L		$3456,A2
		MOVEA.L		$4567,A3
		MOVEA.L		$5678,A4
		MOVEA.L		$7890,A5
		MOVEA.L		$12345678,A0
		MOVEA.L		$12345678,A1
		MOVEA.L		$12345678,A2
		MOVEA.L		$12345678,A3
		MOVEA.L		$12345678,A4
		MOVEA.L		$12345678,A5
		ADDQ.B		#$1,D0
		ADDQ.B		#$2,(A0)
		ADDQ.B		#$3,-(A0)
		ADDQ.B		#$4,(A0)+
		ADDQ.B		#$5,$7010
		ADDQ.B		#$6,$00007014
		ADDQ.W		#$4,D0
		ADDQ.W		#$6,(A0)
		ADDQ.W		#$8,-(A0)
		ADDQ.W		#$7,(A0)+
		ADDQ.W		#$5,$7010
		ADDQ.W		#$6,$00007014
		ADDQ.L		#$1,D0
		ADDQ.L		#$2,(A0)
		ADDQ.L		#$8,-(A0)
		ADDQ.L		#$6,(A0)+
		ADDQ.L		#$7,$7010
		ADDQ.L		#$4,$00007014	
		    ADD.B D2,D3
            ADD.B (A2)+,D2
            ADD.B  $23,D6
            ADD.B   $00FCA453,D3
    CMP.B	D1, D2
	CMP.B	(A4), D5
	CMP.B	(A3), D6
	CMP.B	(A6)+, D1
	CMP.B	-(A0), D7
	CMP.B	$4567, D4
	CMP.B 	$1234567, D2
	CMP.B	#$09, D5
	CMP.B	#$34, D6
	CMP.B	#$78, D3
	CMP.W	D1, D2
	CMP.W	A4, D5
	CMP.W	(A3), D6
	CMP.W	(A6)+, D1
	CMP.W	-(A0), D7
	CMP.W	$4567, D4
	CMP.W 	$1234567, D2
	CMP.W	#$09, D5
	CMP.W	#$1234, D6
	CMP.W	#$A9B3, D3
	CMP.L	D1, D2
	CMP.L	A4, D5
	CMP.L	(A3),D6
	CMP.L	(A6)+, D1
	CMP.L	-(A0),D7
	CMP.L	$4567, D4
	CMP.L 	$1234567, D2
	CMP.L	#$09, D5
	CMP.L	#$1234, D6
	CMP.L	#$12345678, D3
	CMPA.W	D1, A2
	CMPA.W	A4, A5
	CMPA.W	(A3),A6  
    ILLEGAL
    TAS     D3   
    TST.B   D3
    TST.W   (A4)
    TST.L   -(A2)    
    TRAP    #15    
    UNLK    A4   
    MOVE    USP,A6
    MOVE    A3,USP   
    RESET   
    NOP    
    RTE   
    CHK     (A3),D4   
    JMP     (A3)
	CMPA.W	(A6)+, A1
	CMPA.W	-(A0),A7
	CMPA.W	$4567, A4
	CMPA.W 	$1234567, A2
	CMPA.W	#$09, A5
	CMPA.W	#$1234, A6
	CMPA.W	#$1678, A3
	CMPA.L	D1, A2
	CMPA.L	A4, A5
	CMPA.L	(A3), A6
	CMPA.L	(A6)+, A1
	CMPA.L	-(A0), A7
	CMPA.L	$4567, A4
	CMPA.L 	$1234567, A2
	CMPA.L	#$09, A5
	CMPA.L	#$1234, A6
	CMPA.L	#$12345678, A3
	EOR.B	D1, D7
	EOR.B	D6, (A4)
	EOR.B	D2, (A3)+
	EOR.B	D4, -(A6)
	EOR.B	D3, $1234
	EOR.B	D5, $12345678
	EOR.W	D1, D7
	EOR.W	D6, (A4)
	EOR.W	D2, (A3)+
	EOR.W	D4, -(A6)
	EOR.W	D3, $1234
	EOR.W	D5, $12345678
	EOR.L	D1, D7
	EOR.L	D6, (A4)
	EOR.L	D2, (A3)+
	EOR.L	D4, -(A6)
	EOR.L	D3, $1234
	EOR.L	D5, $12345678
	BTST            #608,D1
    BTST            #5,(A5)
    BTST            #1200, $7986
    BTST            #1400, (A1)
    BTST            #9,$00FDCDFE
    BTST            #$78, D2
    BTST            #$12345678, $7600
    BTST            D4,$9283
    BTST            D2,-(A5)
    BTST            D0, #$29
    BTST            D3, #$3929
    BTST            #9,$00FDCDFE
    BTST            #$78, D2
    BTST            #$12345678, $7600
    CMPI.B          #$90,D4
    EORI.L          #$9ABE0231,(A4)+
    CMPI.W          #$3273,(A2)
    ORI.W          #$2AFF,(A2)
    CMPI.L          #$00F39DA2,(A4)+
    EORI.B          #$90,D4
    EORI.W          #$3C44,(A2)
    ORI.B           #$02,D4
    ORI.L           #$92830231,(A4)+         
    BTST            #608,D1
    BTST            #5,(A5)
    BTST            #1200, $7986
    BTST            #1400, (A1)
    BTST            #9,$00FDCDFE
    BTST            #$78, D2
    MOVE.W		    #$4890,(A0)+
		MOVE.W		#$5ABC,$7010
		MOVE.W		#$6CDE,$00007014
    BTST            #$12345678, $7600
    BTST            D4,$9283
    BTST            D2,-(A5)
    BTST            D0, #$29
    BTST            D3, #$3929
    BTST            #9,$00FDCDFE
    		MOVEA.L		(A1),A1
		MOVEA.L		(A2),A2
		MOVEA.L		(A3),A3
    BTST            #$78, D2
    BTST            #$12345678, $7600  
    MOVE.B  D1, D2
    MOVE.B  D7, D3
    MOVE.B  D4, D6
    MOVE.B  D0, D5  
    LSL.B	D1, D6
	LSR.B	D4, D2
	LSL.B	#7, D3
	LSR.B	#3, D1
	LSL.W	D1, D6
	LSR.W	D4, D2
	LSL.W	$5000
	LSR.W	$8769
	LSL.W	#7, D1
	LSR.W	#3, D5
	LSL.L	D3, D5
	LSR.L	D7, D0
	LSL.L   #4, D4
	LSR.L   #7, D2
	LSL.W	(A4)
	LSR.W	(A3)
	LSL.W	(A1)+
	LSR.W	-(A5)
	LSL.W	$12345678
	LSR.W	$12345678
	ASL.B	D1, D6
	ASR.B	D4, D2
	ASL.B	#7, D3
	ASR.B	#3, D1
	ASL.W	D1, D6
	ASR.W	D4, D2
	ASL.W	$5000
	ASR.W	$8769
	ASL.W	#7, D1
	ASR.W	#3, D5
	ASL.L	D3, D5
	ASR.L	D7, D0
	ASL.L   #4, D4
	ASR.L   #7, D2
	ASL.W	(A4)
	ASR.W	(A3)
	ASL.W	(A1)+
	ASR.W	-(A5)
	ASL.W	$12345678
	ASR.W	$12345678
	ROL.B	D1, D6
	ROR.B	D4, D2
	ROL.B	#7, D3
	ROR.B	#3, D1
	ROL.W	D1, D6
	ROR.W	D4, D2
	ROL.W	$5000
BCC1	
    BMI     BCC1
    BPL     BCC1
    BVS     BCC1
    BVC     BCC1
    BCS     BCC1
    BGE     BCC1
    BGT     BCC1
    BLE     BCC1
    BLS     BCC1
	ROR.W	$8769
	ROL.W	#7, D1
	ROR.W	#3, D5
	ROL.L	D3, D5
	ROR.L	D7, D0
	ROL.L   #4, D4
	ROR.L   #7, D2
	ROL.W	(A4)
	ROR.W	(A3)
	ROL.W	(A1)+
	ROR.W	-(A5)
	ROL.W	$12345678
	ROR.W	$12345678
	MOVE.B              D1, D2
    MOVE.B              $9000, D3
    NOP
    MOVE.B  D1, D2
    MOVE.B  D7, D3
    MOVE.B  D4, D6
    MOVE.B  $6BCF,$7654
    MOVE.B  $ABCF09,$456712
    MOVE.B  D0, D5
    MOVE.B  (A0),D5
    MOVE.B  (A4),(A7)
    MOVE.B  D5,(A3)
    MOVE.B  (A3)+,-(A4)
    MOVE.B  -(A6),(A1)+
    MOVE.B  $7F6E, D0
    MOVE.B  $C608, D2
    MOVE.B  D1, D2
    MOVE.B  D7, D3
    MOVE.W  D7, D1
    MOVE.L  D1,(A4)
    MOVE.B  D4, D6
    MOVE.B  D0, D5
    MOVE.B  (A0),D5
    MOVE.B  (A4),(A7)
    MOVE.B  D5,(A3)
    MOVE.B  (A3)+,-(A4)
    MOVE.B  -(A6),(A1)+
    MOVE.B  $7F6E, D0
    MOVE.B  $C608, D2
    MOVE.W  (A5)+,D6
    MOVE.B  #$00000000000000000000000000000000000000008, D2
    MOVE.B  $456712,$ABCF09
    MOVE.B  $6BCF,$ABCF09
    SUB.B   D4, D5
    MOVE.W  D2,D5
    MOVE.W  (A7),D0
    MOVE.B  #$A7, D2
    MOVE.W  -(A5),D6
    MOVE.B  D7, $ABCF
    MOVE.B  (A7)+,$7654
    MOVE.B  $ABCF09,$7654
    MOVE.W  A7,D0
    MOVE.W  D0,(A7)
    MOVEA.W $ABCF, A4
    MOVEA.W D0,A7
		MOVE.B		#$12,D2
		MOVE.B		#$24,(A0)
		MOVE.B		#$36,-(A0)
		MOVE.B		#$48,(A0)+
		MOVE.B		#$5A,$7010
		MOVE.B		#$6C,$00007014
		MOVE.B		D0,D1
		MOVE.B		D0,(A0)
		MOVE.B		D0,-(A0)
		MOVE.B		D0,(A0)+
		MOVE.B		D0,$7010
		MOVE.B		D0,$00007014
		MOVE.B		(A0),D0
		MOVE.B		(A1),(A2)
		MOVE.B		(A2),-(A3)
		MOVE.B		(A3),(A4)+
		MOVE.B		(A4),$7010
		MOVE.B		(A5),$00007014
		MOVE.B		-(A1),D0
		MOVE.B		-(A2),(A1)
		MOVE.B		-(A3),-(A2)
		MOVE.B		-(A4),(A3)
		MOVE.B		-(A5),$7010
		MOVE.B		-(A6),$00007014
		MOVE.B		(A1)+,D0
		MOVE.B		(A2)+,(A1)
		MOVE.B		(A3)+,-(A2)
		MOVE.B		(A4)+,(A3)+
		MOVE.B		(A5)+,$7010
		MOVE.B		(A6)+,$00007014
		MOVE.B		$1234,D0
		MOVE.B		$2345,(A1)
		MOVE.B		$3456,-(A2)
		MOVE.B		$4567,(A3)+
		MOVE.B		$5678,$7010
		MOVE.B		$7890,$00007014
		MOVE.B		$12345678,D0
		MOVE.B		$12345678,(A4)
		MOVE.B		$12345678,-(A4)
		MOVE.B		$12345678,(A4)+
		MOVE.B		$12345678,$7010
		MOVE.B		$12345678,$00007014
		MOVE.W		#$1234,D0
		MOVE.W		#$2456,(A0)
		MOVE.W		#$3678,-(A0)
		MOVE.W		#$4890,(A0)+
		MOVE.W		#$5ABC,$7010
		MOVE.W		#$6CDE,$00007014
		MOVE.W		D0,D1
		MOVE.W		D0,(A0)
		MOVE.W		D0,-(A0)
		MOVE.W		D0,(A0)+
		MOVE.W		D0,$7010
		MOVE.W		D0,$00007014
		MOVE.W		(A0),D0
		MOVE.W		(A1),(A2)
		MOVE.W		(A2),-(A3)
		MOVE.W		(A3),(A4)+
		MOVE.W		(A4),$7010
		MOVE.W		(A5),$00007014
		MOVE.W		-(A1),D0
		MOVE.W		-(A2),(A1)
		MOVE.W		-(A3),-(A2)
		MOVE.W		-(A4),(A3)
		MOVE.W		-(A5),$7010
		MOVE.W		-(A6),$00007014
		MOVE.W		(A1)+,D0
		MOVE.W		(A2)+,(A1)
		MOVE.W		(A3)+,-(A2)
		MOVE.W		(A4)+,(A3)+
		MOVE.W		(A5)+,$7010
		MOVE.W		(A6)+,$00007014
		MOVE.W		$1234,D0
		MOVE.W		$2345,(A1)
		MOVE.W		$3456,-(A2)
		MOVE.W		$4567,(A3)+
		MOVE.W		$5678,$7010
		MOVE.W		$7890,$00007014
		MOVE.W		$12345678,D0
		MOVE.W		$12345678,(A4)
		MOVE.W		$12345678,-(A4)
		MOVE.W		$12345678,(A4)+
		MOVE.W		$12345678,$7010
		MOVE.W		$12345678,$00007014
		MOVE.L		#$12345678,D0
		MOVE.L		#$12345678,(A0)
		MOVE.L		#$12345678,-(A0)
		MOVE.L		#$12345678,(A0)+
		MOVE.L		#$12345678,$7010
		MOVE.L		#$12345678,$00007014
		MOVE.L		D0,D1
		MOVE.L		D0,(A0)
		MOVE.L		D0,-(A0)
		MOVE.L		D0,(A0)+
		MOVE.L		D0,$7010
		MOVE.L		D0,$00007014
		MOVE.L		(A0),D0
		MOVE.L		(A1),(A2)
		MOVE.L		(A2),-(A3)
		MOVE.L		(A3),(A4)+
		MOVE.L		(A4),$7010
		MOVE.L		(A5),$00007014
		MOVE.L		-(A1),D0
		MOVE.L		-(A2),(A1)
		MOVE.L		-(A3),-(A2)
		MOVE.L		-(A4),(A3)
		MOVE.L		-(A5),$7010
		MOVE.L		-(A6),$00007014
		MOVE.L		(A1)+,D0
		MOVE.L		(A2)+,(A1)
		MOVE.L		(A3)+,-(A2)
		MOVE.L		(A4)+,(A3)+
		MOVE.L		(A5)+,$7010
		MOVE.L		(A6)+,$00007014
		MOVE.L		$1234,D0
		MOVE.L		$2345,(A1)
		MOVE.L		$3456,-(A2)
		MOVE.L		$4567,(A3)+
		MOVE.L		$5678,$7010
		MOVE.L		$7890,$00007014
		MOVE.L		$12345678,D0
		MOVE.L		$12345678,(A4)
		MOVE.L		$12345678,-(A4)
		MOVE.L		$12345678,(A4)+
		MOVE.L		$12345678,$7010
		MOVE.L		$12345678,$00007014
		MOVEA.W		#$1234,A0
		MOVEA.W		#$2456,A1
		MOVEA.W		#$3678,A2
		MOVEA.W		#$4890,A3
		MOVEA.W		#$5ABC,A4
		MOVEA.W		#$6CDE,A5
		MOVEA.W		D0,A0
		MOVEA.W		D0,A1
		MOVEA.W		D0,A2
		MOVEA.W		D0,A3
		MOVEA.W		D0,A4
		MOVEA.W		D0,A5
		MOVEA.W		(A0),A0
		MOVEA.W		(A1),A1
		MOVEA.W		(A2),A2
		MOVEA.W		(A3),A3
		MOVEA.W		(A4),A4
		MOVEA.W		(A5),A5
		MOVEA.W		-(A1),A0
		MOVEA.W		-(A2),A1
		MOVEA.W		-(A3),A2
		MOVEA.W		-(A4),A3
		MOVEA.W		-(A5),A4
		MOVEA.W		-(A6),A5
		MOVEA.W		(A1)+,A0
		MOVEA.W		(A2)+,A1
		MOVEA.W		(A3)+,A2
		MOVEA.W		(A4)+,A3
		MOVEA.W		(A5)+,A4
		MOVEA.W		(A6)+,A5
		MOVEA.W		$1234,A0
		MOVEA.W		$2345,A1
		MOVEA.W		$3456,A2
		MOVEA.W		$4567,A3
		MOVEA.W		$5678,A4
		MOVEA.W		$7890,A5
		MOVEA.W		$12345678,A0
		MOVEA.W		$12345678,A1
		MOVEA.W		$12345678,A2
		MOVEA.W		$12345678,A3
		MOVEA.W		$12345678,A4
		MOVEA.W		$12345678,A5
		MOVEA.L		#$12345678,A0
		MOVEA.L		#$12345678,A1
		MOVEA.L		#$12345678,A2
		MOVEA.L		#$12345678,A3
		MOVEA.L		#$12345678,A4
		MOVEA.L		#$12345678,A5
		MOVEA.L		D0,A0
		MOVEA.L		D0,A1
		MOVEA.L		D0,A2
		MOVEA.L		D0,A3
		MOVEA.L		D0,A4
		MOVEA.L		D0,A5
		MOVEA.L		(A0),A0
		MOVEA.L		(A1),A1
		MOVEA.L		(A2),A2
		MOVEA.L		(A3),A3
		MOVEA.L		(A4),A4
		MOVEA.L		(A5),A5
END

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
