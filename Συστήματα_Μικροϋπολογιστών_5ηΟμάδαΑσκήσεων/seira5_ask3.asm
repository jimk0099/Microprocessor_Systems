INCLUDE macros.asm

CODE SEGMENT
	ASSUME CS:CODE

    MAIN PROC FAR
        START:
            CALL HEX_KEYB       ;insert first digit
            CMP AL,'T'          ;check if input = T 
            JE FINISH           ;and if so terminate
            MOV BH,AL           ;store first element in 4 LSBs of BH            ;
            CALL HEX_KEYB
            CMP AL,'T'
            JE FINISH
            MOV BL,AL           ;store second elemets 
            ROL BL,4            ;and move it in the 4 MSBs of BL
            CALL HEX_KEYB       
            CMP AL,'T'
            JE FINISH
            ADD BL,AL           ;store third element in 4 LSBs of BL
            
             
            PRINTCH '='
			CALL PRINT_DEC		;print bin
			PRINTCH '='
			CALL PRINT_OCT		;print oct 
			PRINTCH '='
			CALL PRINT_BIN		;print hex
			
			PRINTLN
			JMP START
			
		FINISH:
			EXIT
	MAIN ENDP
    
    
    HEX_KEYB PROC NEAR
        
            PUSH DX             ;store DX in stack
        IGNORE:                 
            READCH              ;read character from keyboard
            CMP AL,'T'          ;check if character is 'T'
            JE ADDR2
            CMP AL,30H          ;check if character is digit
            JL IGNORE           ;if not ignore it and read next
            CMP AL,39H 
            JG ADDR1
            PUSH AX
            PRINTCH AL          ;print digit
            POP AX
            SUB AL,30H          ;get actual number from ascii code
            JMP ADDR2
        ADDR1:
            CMP AL,'A'
            JL IGNORE
            CMP AL,'F'
            JG IGNORE
            PUSH AX
            PRINTCH AL
            POP AX
            SUB AL,37H          ;conver into actual number from ascii code
        ADDR2:
            POP DX
            RET
    HEX_KEYB ENDP 
    
    
    PRINT_DEC PROC NEAR
            PUSH AX             ;
            PUSH BX             ;store AX and BX in stack
            MOV AL,0
        LOOP1:
            CMP BX,1000         ;if BX < 1000
            JL LABEL1           ;go to LABEL1
            SUB BX,1000         ;else decrease BX by 1000
            INC AL              ;and increase AL (thousands) by 1
            JMP LOOP1           ;repeat until BX <1000
        LABEL1:
            ADD AL,30H          ;AL has thousands so by adding 30H we get 
            PRINTCH AL          ;the ascii code for thousands
            MOV AL,0
        LOOP2:
            CMP BX,100          ;repeat the same for hundreds
            JL LABEL2
            SUB BX,100
            INC AL
            JMP LOOP2
        LABEL2:
            ADD AL,30H
            PRINTCH AL
            MOV AL,0
        LOOP3:
            CMP BX,10           ;repeat the same for tens
            JL LABEL3
            SUB BX,10
            INC AL
            jMP LOOP3
        LABEL3:
            ADD AL,30H          ;get tens in AL and convert to ascii
            PRINTCH AL          ;
            ADD BL,30H          ;get ones in BL and convert to ascii
            PRINTCH BL
            POP BX              ;
            POP AX              ;restore AX and BX
            RET           
    PRINT_DEC ENDP                    
          
               
    PRINT_OCT PROC NEAR
            PUSH AX
            PUSH BX             ;store AX and BX in stack
            MOV AL,0
        LOOPA1:
            CMP BX,512          ;if BX < 512 
            JL LABELA1          ;go to LABELA1
            SUB BX,512          ;decrease BX by 512
            INC AL              ;and increase by 1 register BX which counts the times of (8^3) 
            JMP LOOPA1          ;repeat until BX < 512
        LABELA1:
            ADD AL,30H          ;get ascii number of number of (8^3)s   
            PRINTCH AL
            MOV AL,0
        LOOPA2:
            CMP BX,64           ;repeat and count number of (8^2)s
            JL LABELA2
            SUB BX,64
            INC AL
            JMP LOOPA2
        LABELA2:
            ADD AL,30H
            PRINTCH AL
            MOV AL,0
        LOOPA3:
            CMP BX,8            ;repeat the same for (8^1)s
            JL LABELA3
            SUB BX,8
            INC AL
            jMP LOOPA3
        LABELA3:
            ADD AL,30H          ;get times (8^1) in AL and convert to ascii
            PRINTCH AL
            ADD BL,30H          ;get times of ones in BL and convert to ascii
            PRINTCH BL
            POP BX              ;restore BX and AX
            POP AX
            RET
    PRINT_OCT ENDP
    
    
    PRINT_BIN PROC NEAR         
            PUSH AX             ;store AX and BX
            PUSH BX
            MOV AL,0
            ROL BX,4            ;first bit of our number is in first place of BX
                                
            MOV CX,12           ;counter so we repeat for 12 times
        LOOPB1:
            SHL BX,1            ;get first digit of our number in carry
            MOV AL,0
            ADC AL,30H          ;add 30 to get the asccii code 
            PRINTCH AL
            LOOP LOOPB1         ;repeat until CX = 0
            POP BX              ;restore AX and BX
            POP AX  
            RET
    PRINT_BIN ENDP
     
               
CODE ENDS
END MAIN