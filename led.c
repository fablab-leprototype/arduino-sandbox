#define F_CPU 16000000UL

#include <avr/io.h>
#include <util/delay.h>
#include <unistd.h> 
#define BLINK_DELAY_MS 100
 
int main (void)
{
 /* set pin 5 of PORTB for output*/
 DDRB |= _BV(DDB5);
 
 while(1) {
  /* set pin 5 high to turn led on */
  PORTB |= _BV(PORTB5);
  _delay_ms(BLINK_DELAY_MS);
  /* set pin 5 low to turn led off */
  PORTB &= ~_BV(PORTB5);
  _delay_ms(BLINK_DELAY_MS);
 }
}