#include <avr/io.h>

unsigned char a, b, c, notc, d, f0, f1;

int main(void)
{
	DDRB=0xFF;			//αρχικοποιηση ως portB output
	DDRA=0x00;			//αρχικοποιηση ως portA input
	
	
	while (1)
	{
		a = PINA & 0x01;	//διαβαζει απο το portA το 1ο LSB
		b = PINA & 0x02;	//διαβαζει απο το portA το 2ο LSB
		b = b >> 1;		//ολισθηση δεξια κατα 1 θεση (το βαζει στο 1ο LSB)
		c = PINA & 0x04;	//διαβαζει απο το portA το 3ο LSB
		c = c >> 2;		//ολισθηση δεξια κατα 2 θεση (το βαζει στο 1ο LSB)
		d= PINA & 0x08;	//διαβαζει απο το portA το 4ο LSB
		d= d >> 3;		//ολισθηση δεξια κατα 3 θεση (το βαζει στο 1ο LSB)
		
		f1 = (a|b) & (c|d);	//φτιαχνω την f1
		f1 = f1 << 1;		//ολισθηση αριστερα μια θεση για να παει στο 2ο LSB
		
		notc =c^0x01;		//σημπληρωμα c με XOR
		
		f0 = ((a & b & notc) | (c & d));
		f0 = f0^0x01;		//φτιαχνω την f1
		
		f0 = f0|f1;		//φτιαχνω την portB
		PORTB = f0;		//γραφω στην portB
		
	}
	return 0;
}
