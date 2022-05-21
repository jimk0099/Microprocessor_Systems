#include <avr/io.h>

char x;

int main(void){
	DDRA = 0xFF;    			// αρχικοποίηση PORTA ως output
	DDRC = 0x00;    			// αρχικοποίηση PORTC ως input
	
	x = 0x01;   	    			// αρχικοποίηση μεταβλητής για αρχικά αναμμένο led
	PORTA = x; 			//εξοδος σε PORTA
	
	while(1){
		if((PINC & 0x01) == 1){ 	// ελεγχος πατήματος push-button SW0
			while((PINC & 0x01) == 1){} 	// ελεγχος επαναφοράς push-button
			if(x == 0x80){		//αν το αναμμένο led είναι στο MSB
				x = 0x01;   		//μετακίνησέ το στο LSB
			}
			else{
				x = x<<1;    		// ολίσθηση αριστερά
			}
		}
		if((PINC & 0x02) == 2){	 	// ελεγχος πατήματος push-button SW1
			while((PINC & 0x02) == 2){} 	// ελεγχος επαναφοράς push-button
			if(x == 0x01){  		//αν το αναμμένο led είναι στο LSB
				x = 0x80;   		//μετακίνησέ το στο MSB
			}
			else{
				x = x>>1;  	 	// ολίσθηση δεξια
			}
		}
		if((PINC & 0x04) == 4){  		// ελεγχος πατήματος push-button SW2
			while((PINC & 0x04) == 4){} 	// ελεγχος επαναφοράς push-button
			x = 0x80;  			//μετακίνηση αναμμένου led στην θέση MSB
		}
		if((PINC & 0x08) == 8){  		// ελεγχος πατήματος push-button SW3
			while((PINC & 0x08) == 8){} 	// ελεγχος επαναφοράς push-button
			x = 0x01;  			//μετακίνηση αναμμένου led στην αρχική του θέση LSB
		}

		PORTA = x; 	 		//εξοδος σε PORTA
	}
	return 0;
}
