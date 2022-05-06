INCLUDE macros.asm


DATA SEGMENT
    TABLE DB 128 DUP(?)         ;sunolo dedomenon
    TWO DB DUP(2)               ;elegxos isotimias
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
    MAIN PROC FAR
            MOV AX,DATA
            MOV DS,AX           ;save numbers in memory
            MOV DI,0            ;pointer of number table
            MOV CX,128          ;all the numbers
        STORE:
            MOV TABLE[DI],CL
            INC DI            
            LOOP STORE			;sum and count
            MOV DH,0            ;sum AX+DL
            MOV AX,0            ;sum odd
            MOV BX,0            ;oloi oi odd
            MOV DI,0
            MOV CX,128
        FINDADDODD:
            PUSH AX
            MOV AH,0            ;AX/2
            MOV AL,TABLE[DI]    ;elegxos isotimias           
            DIV TWO             
            CMP AH,0             
            POP AX            
            JE SKIPEVEN         ;AX div 2 = 0 ?            
            MOV DL,TABLE[DI]    ;save             
            ADD AX,DX           ;sum            
            INC BX              ;odd            
        SKIPEVEN:               ;even            
            INC DI            
            LOOP FINDADDODD     ;count  m.o 
            MOV DX,0            ;AX/BX           
            DIV BX              ;sum/total           
                                ;prin m.o
            MOV BL,10
            MOV CL,AL
            DIV BL
            ADD AL,30H
            PRINTCH AL
            SUB AL,30H
            MUL BL
            SUB CL,AL
            ADD CL,30H
            PRINTCH CL
            
            PRINTLN
                                ;check max,min          
            MOV AL,TABLE[0]     ;first max
            MOV BL,TABLE[127]   ;first min
            MOV DI,0            
            MOV CX,128            
        MAXMIN:            
            CMP AL,TABLE[DI]    ;check max            
            JC NEWMAX            
            JMP TOMIN            
        NEWMAX:                 ;new max           
            MOV AL,TABLE[DI]           
            JMP NEXTNUM          
        TOMIN:                  ;check min          
            CMP TABLE[DI],BL           
            JC NEWMIN            
            JMP NEXTNUM            
        NEWMIN:                 ;new min            
            MOV BL,TABLE[DI]           
        NEXTNUM:           
            INC DI            
            LOOP MAXMIN         ;print max,min           
            CALL PRINT_NUM8_HEX     ;print max            
            PRINTCH ' '            
            MOV AL,BL            
            CALL PRINT_NUM8_HEX     ;pirnt min            
            EXIT            
    MAIN ENDP            
                                    ;print hex  AL
            
    PRINT_NUM8_HEX PROC NEAR        ;80x86_programs.pdf selida 17            
            MOV DL,AL            
            AND DL,0F0H             ;1o digit hex            
            MOV CL,4            
            ROR DL,CL           
            CMP DL,0                       
            JE SKIPZERO           
            CALL PRINT_HEX            
        SKIPZERO:            
            MOV DL,AL            
            AND DL,0FH              ;2o digit hex            
            CALL PRINT_HEX            
            RET            
    PRINT_NUM8_HEX ENDP
            
                                    ;print hex DL
           
    PRINT_HEX PROC NEAR             ;80x86_programs.pdf selida 18            
            CMP DL,9                ;0...9            
            JG LETTER            
            ADD DL,48           
            JMP SHOW           
        LETTER:           
            ADD DL,55               ;A...F           
        SHOW:            
            PRINTCH DL            
            RET      
    PRINT_HEX ENDP 
                
            
CODE ENDS
END MAIN