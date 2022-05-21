PRINTCH MACRO CHAR
	PUSH AX
	PUSH DX
	MOV DL,CHAR
	MOV AH,2
	INT 21H
	POP DX
	POP AX
ENDM


PRINTSTR MACRO STRING
	PUSH AX
	PUSH DX
	MOV DX,OFFSET STRING
	MOV AH,9
	INT 21H
	POP DX
	POP AX
ENDM


PRINTLN MACRO
	PUSH AX
	PUSH DX
	MOV DL,13
	MOV AH,2
	INT 21H
	MOV DL,10
	MOV AH,2
	INT 21H
	POP DX
	POP AX
ENDM


PRINTTAB MACRO
	PUSH AX
	PUSH DX
	MOV DL,9
	MOV AH,2
	INT 21H
	POP DX
	POP AX
ENDM


READCH MACRO
	MOV AH,8
	INT 21H
ENDM


READNPRINTCH MACRO
	MOV AH,1
	INT 21H
ENDM


EXIT MACRO
	MOV AX,4C00H
	INT 21H
ENDM