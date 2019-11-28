ARDUINO_DIR=/usr/share/arduino
ARDUINO_CORE=$(ARDUINO_DIR)/hardware/arduino/cores/arduino
INCLUDE=-I. -I$(ARDUINO_DIR)/hardware/arduino/cores/arduino \
	-I$(ARDUINO_DIR)/hardware/arduino/variants/standard
DHT_INCLUDES=-I./Adafruit_Sensor-1.0.3 -I./DHT_sensor_library-1.3.8

# Depends on what is actually used in the project (sketch.c)
# The following symbols are unresolved at compile time:
#
# * digitalWrite  -> wiring_digital.c
# * delay         -> wiring.c
# * pinMode       -> wiring_digital.c
# * main          -> main.cpp

CORE_C_FILES=wiring_digital wiring_analog wiring
CORE_CPP_FILES=main USBCore CDC Print WString HardwareSerial

# complete lib (just a ls *.c / *.cpp) as follows:
#CORE_C_FILES=WInterrupts wiring wiring_pulse wiring_analog  wiring_digital  wiring_shift
#CORE__CPP_FILES=CDC IPAddress Print USBCore HardwareSerial main Stream WMath HID new Tone WString

CC=avr-gcc
CPP=avr-g++
MCU=atmega328p
DF_CPU=16000000

all : install
.PHONY: all

clean:
	rm -f read *.o read.hex

DHT.o: DHT_sensor_library-1.3.8/DHT.cpp
	 $(CPP) -Os -mmcu=$(MCU) -c -DF_CPU=$(DF_CPU) $^ $(INCLUDE) $(DHT_INCLUDES)

read.o: read.cpp
	 $(CPP) -Os -mmcu=$(MCU) -c -o $@ $^ $(INCLUDE) $(DHT_INCLUDES)

read: read.o arduino_core_c arduino_core_cpp DHT.o
	$(CC) -Os -mmcu=$(MCU) *.o -o read

read.hex: read
	avr-objcopy -O ihex -R .eeprom read read.hex

install: read.hex
	# device can also be bound to /dev/ttyACM0 YMMV.
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyUSB0 -b 115200 -U flash:w:read.hex

arduino_core_c:
		for core_c_file in ${CORE_C_FILES}; do \
		    $(CC) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		          $(CC_FLAGS) $(ARDUINO_CORE)/$$core_c_file.c \
			  -o $$core_c_file.o; \
		done

arduino_core_cpp:
		for core_cpp_file in ${CORE_CPP_FILES}; do \
		    $(CPP) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		           $(CPP_FLAGS) $(ARDUINO_CORE)/$$core_cpp_file.cpp \
			   -o $$core_cpp_file.o; \
		done
