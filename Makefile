all : install
.PHONY: all

clean:
	rm -f led led.o led.hex

led.o: led.c
	 avr-gcc -Os -mmcu=atmega328p -c -o led.o led.c

led: led.o
	avr-gcc -mmcu=atmega328p led.o -o led

led.hex: led
	avr-objcopy -O ihex -R .eeprom led led.hex

install: led.hex
	# device can also be bound to /dev/ttyACM0 YMMV.
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyUSB0 -b 115200 -U flash:w:led.hex

