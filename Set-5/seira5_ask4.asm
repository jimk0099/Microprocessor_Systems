INCLUDE macros.asm

DATA SEGMENT
	CHARS DB 20 DUP(?) ;save the char or number table
	DATA ENDS
CODE SEGMENT

	ASSUME CS:CODE, DS:DATA

MAIN PROC FAR
		MOV AX,DATA
		MOV DS,AX
		MOV CL,0     ;counter
	START:
		MOV DI,0     ;pointer table
	NEXTCHAR: 
		READCH
		CMP AL,61   ;check for '='
		JE FINISH
		CMP AL,13   ;check for 'enter'
		JE CAPSLINE
		CMP AL,48   ; if <0;
		JB NEXTCHAR
		CMP AL,122   ;if >z
		JA NEXTCHAR
		CMP AL,57    ; if <=9
		JBE SAVECHAR
		CMP AL,97 
		JB NEXTCHAR
	SAVECHAR:
		PRINTCH AL   ;print all
		MOV CHARS[DI],AL  
		INC DI
		INC CL
		CMP CL,20    ;if they are 20
		JB NEXTCHAR
	CAPSLINE:
		PRINTLN
		MOV Cl,20     ;check for empy table 
		CMP CL,0
		JE  NEXTCHAR
		MOV CX,20
		MOV DI,0 
		PRINT_LETTERS:  		;if its letter then print them first
		MOV AL,CHARS[DI]
		CMP AL,'a'      		;if <a then not letter
		JB  NOT_LETTER
		CMP AL,'z'      		;if >z then not letter
		JA NOT_LETTER
		SUB AL,32       		;low to capital
		PRINTCH AL      		;print letter first
		MOV CHARS[DI],' '		;fill table with empty slots
	NOT_LETTER:
		INC DI
		LOOP PRINT_LETTERS   	 ;if not letter loop until chek all table
		PRINTCH '-'        		;print -
		MOV CX,20
		MOV DI,0
	PRINT_NUMS:         		;cher for numbers
		MOV AL,CHARS[DI]
		CMP AL,30H 				; we check if it is an ASCII coded digit
		JL NOT_A_NUMBER
		CMP AL,39H
		JG NOT_A_NUMBER
		PRINTCH AL 				; print only the digits
		MOV CHARS[DI],' '		;fill table with empty slots
	NOT_A_NUMBER:
		INC DI
		LOOP PRINT_NUMS    		 ;print them second
		PRINTLN
		PRINTLN
		JMP START
	FINISH:
	EXIT
MAIN ENDP

CODE ENDS
END MAIN