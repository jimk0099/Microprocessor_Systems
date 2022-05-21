INCLUDE macros.asm

DATA SEGMENT
STARTPROMPT DB "START(Y,N):$"      ;starter message
ERRORMSG DB "ERROR$"               ;error message
ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA

MAIN PROC FAR
		MOV AX,DATA
		MOV DS,AX
		PRINTSTR STARTPROMPT
	START:                      ;starter char
		READCH
		CMP AL,'N'              ;= N ?
		JE FINISH               ;finish
		CMP AL,'Y'              ;= Y ?
		JE CONT                 ;begin
		JMP START
	CONT:
		PRINTCH AL              ;print starter char
		PRINTLN
		PRINTLN
	NEWTEMP:
		MOV DX,0
		MOV CX,3                 ;3 hex digit
	READTEMP:                    ;input
		CALL HEX_KEYB            ;put digit
		CMP AL,'N'               ;check for N to end
		JE FINISH                ;all digit in DX
		PUSH CX
		DEC CL                   ;rol
		ROL CL,2 
		MOV AH,0
		ROL AX,CL                ;rol left 8,4,0 digit
		OR DX,AX                    
		POP CX
		LOOP READTEMP
		PRINTTAB
		MOV AX,DX
		CMP AX,2047              ;V<=2 ?
		JBE BRANCH1
		CMP AX,3071              ;V<=3 ?
		JBE BRANCH2
		PRINTSTR ERRORMSG        ;V>3
		PRINTLN
		JMP NEWTEMP
	BRANCH1:                	;1o: V<=2, T=(800*V) div 4095
		MOV BX,800
		MUL BX
		MOV BX,4095
		DIV BX
		JMP SHOWTEMP
	BRANCH2:                	;2o: 2<V<=3, T=((3200*V) div 4095)-1200
		MOV BX,3200
		MUL BX
		MOV BX,4095
		DIV BX
		SUB AX,1200
	SHOWTEMP:
		CALL PRINT_DEC16        ;print integer number  (AX)
								;klasma = (upolipo*10) div 4095
		MOV AX,DX
		MOV BX,10
		MUL BX
		MOV BX,4095
		DIV BX
		PRINTCH ','             ;upodiastoli
		ADD AL,48               ;ASCII
		PRINTCH AL              ;print klasma
		PRINTLN
		JMP NEWTEMP
	FINISH:
		PRINTCH AL
		EXIT
MAIN ENDP

								;hex (in AL)
HEX_KEYB PROC NEAR          	;80x86_programs.pdf selida 20-21
	READ:
		READCH
		CMP Al,'N'
		JE RETURN
		CMP AL,48               ;<0 ?
		JL READ
		CMP AL,57               ;>9 ?
		JG LETTER
		PRINTCH AL
		SUB AL,48               ; ASCII
		JMP RETURN
	LETTER:                     ;A...F
		CMP AL,'A'              ;<A ?
		JL READ
		CMP AL,'F'              ;>F ?
		JG READ
		PRINTCH AL
		SUB AL,55               ;ASCII
	RETURN:
		RET
HEX_KEYB ENDP

								;16 bit dec AX
PRINT_DEC16 PROC NEAR       	;80x86_programs.pdf selida 26-27
		PUSH DX
		MOV BX,10               ;div 10    
		MOV CX,0                ;count
	GETDEC:                     ;output digit
		MOV DX,0                ;number mod 10 (upolipo)
		DIV BX                  ;div 10
		PUSH DX                 ;save
		INC CL
		CMP AX,0                ;number div 10 = 0 ? (piliko)
		JNE GETDEC
	PRINTDEC:                   ;print digit
		POP DX
		ADD DL,48               ; ASCII
		PRINTCH DL
		LOOP PRINTDEC
		POP DX
		RET
PRINT_DEC16 ENDP

CODE ENDS
END MAIN