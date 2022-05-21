.include "m16def.inc"
.def temp=r24
.def led=r20

stack:
	ldi r24, low(RAMEND)		;initialize stack pointer
	out SPL, r24
	ldi r24, high(RAMEND)
	out SPH, r24
	
set_ports:
	ser temp			;initialize PORTA for output - puts 1s
	out DDRA,temp
	clr temp			;initialize PINB for input - puts 0s								
	out DDRB,temp									

main:
	ldi led,01			;initialize the led that will open
	rcall left			;go left
	nop										
	rcall right			;go right
	rjmp main			;go back to main

left:
	in temp,PINB			;temp gets input
	andi temp,01			;isolate PB0
	cpi temp,01			;while PB0=1 loop here
	brcc left
	out PORTA,led			;show current led
	cpi led,80			;when it reaches left end
	brcc return			;return
	lsl led				;if it hasn't reached it yet, move led left 
	rjmp left									

right:
	in temp,PINB			;temp gets input
	andi temp,01			;isolate PB0
	cpi temp,01			;while PB0=1 loop here
	brcc right		
	out PORTA,led			;show current led
	cpi led,01			;when it reaches right end
	breq return			;return
	lsr led				;if it hasn't reached it yet, move led right
	rjmp right

return:
	ret
