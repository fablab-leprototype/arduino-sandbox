clean:
	rm -f led led.o led.hex

led.o: led.c
	 avr-gcc -Os -mmcu=atmega328p -c -o led.o led.c

led: led.o
	avr-gcc -mmcu=atmega328p led.o -o led

led.hex: led
	avr-objcopy -O ihex -R .eeprom led led.hex

install: led.hex
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyACM0 -b 115200 -U flash:w:led.hex

