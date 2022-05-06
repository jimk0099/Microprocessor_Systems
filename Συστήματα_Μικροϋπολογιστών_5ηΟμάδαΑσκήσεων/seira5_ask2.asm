INCLUDE macros.asm

DATA SEGMENT

	MSGZ DB "Z=$"
	MSGW DB "W=$"
	MSGSUM DB "Z+W=$"
	MSGSUB DB "Z-W=$"
	MSGMINUS DB "Z-W=-$"
	Z DB 0
	W DB 0
	TEN DB DUP(10)   			;gia tis dekades
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA

MAIN PROC FAR

		MOV AX,DATA
		MOV DS,AX	
	START:
		PRINTSTR MSGZ       	;kataskebei,emfanisi,apothikeusi tou z
		CALL READ_DEC_DIGIT 	;1o digit dekades
		MUL TEN
		LEA DI,Z            	;save 1o digit
		MOV [DI],AL
		CALL READ_DEC_DIGIT    	;2o digit monades
		ADD [DI],AL            	;save 2o digit
		PRINTCH ' '
		PRINTSTR MSGW        	;kataskebei,emfanisi,apothikeusi tou w
		CALL READ_DEC_DIGIT   	;1o digit dekades
		MUL TEN
		LEA DI,W            	;save 1o digit   
		MOV [DI],AL
		CALL READ_DEC_DIGIT   	;2o digit monades
		ADD [DI],AL           	;save 2o digit
		PRINTLN               	;sum
		MOV AL,[DI]           	;w
		LEA DI,Z              	;z
		ADD AL,[DI]           	;sum
		PRINTSTR MSGSUM
		CALL PRINT_NUM8_HEX     ;print sum
		PRINTCH ' '
		MOV AL,[DI]             ;difference
		LEA DI,W                ;z
		MOV BL,[DI]             ;w
		CMP AL,BL               ;z>w or w>z
		JB MINUS				;difference for z>w
		SUB AL,BL 
		PRINTSTR MSGSUB
		JMP SHOWSUB
	MINUS:
		SUB BL,AL              ;difference for z<w
		MOV AL,BL
		PRINTSTR MSGMINUS
	SHOWSUB:
		CALL PRINT_NUM8_HEX    ;print difference 
		PRINTLN
		PRINTLN
		JMP START
MAIN ENDP


READ_DEC_DIGIT PROC NEAR
	READ:
		READCH
		CMP AL,48               ;if<0
		JB READ
		CMP AL,57               ;if>9
		JA READ
		PRINTCH AL
		SUB AL,48               ;ascii
		RET
READ_DEC_DIGIT ENDP     		;print 8-bit to hex  AL


PRINT_NUM8_HEX PROC NEAR   		;selida 17 pdf 80x86_programming 
		MOV DL,AL
		AND DL,0F0H             ;1o hex digit 
		MOV CL,4
		ROR DL,CL
		CMP DL,0                ;exept zero
		JE SKIPZERO
		CALL PRINT_HEX
	SKIPZERO:
		MOV DL,AL
		AND DL,0FH              ;2o hex digit
		CALL PRINT_HEX
		RET
PRINT_NUM8_HEX ENDP				;print 8-bit to hex DL

PRINT_HEX PROC NEAR        		;selida 18 pdf 80x86_programming
		CMP DL,9 
		JG LETTER
		ADD DL,48
		JMP SHOW
	LETTER:						;A..F
		ADD DL,55
		SHOW:
		PRINTCH DL
		RET
PRINT_HEX ENDP

CODE ENDS
END MAIN