ARDUINO_DIR=/usr/share/arduino
ARDUINO_CORE=$(ARDUINO_DIR)/hardware/arduino/cores/arduino
INCLUDE=-I. -I$(ARDUINO_DIR)/hardware/arduino/cores/arduino \
	-I$(ARDUINO_DIR)/hardware/arduino/variants/standard \
	-I$(ARDUINO_DIR)/libraries/Stepper \


# Depends on what is actually used in the project
# The following symbols are unresolved at compile time:
#
# * digitalWrite  -> wiring_digital.c
# * delay         -> wiring.c
# * pinMode       -> wiring_digital.c
# * main          -> main.cpp

CORE_C_FILES=wiring_digital wiring_analog wiring
CORE_CPP_FILES=main HardwareSerial Print WString

CC=avr-gcc
CPP=avr-g++
MCU=atmega328p
DF_CPU=16000000

all : install
.PHONY: all

clean:
	rm -f stepper *.o stepper.hex

stepper.o: stepper.cpp
	 $(CPP) -Os -mmcu=$(MCU) -c -o $@ $^ $(INCLUDE) $(DHT_INCLUDES)

stepper: stepper.o arduino_core_c arduino_core_cpp stepper-lib
	$(CC) -Os -mmcu=$(MCU) *.o -o $@

stepper.hex: stepper
	avr-objcopy -O ihex -R .eeprom stepper stepper.hex

install: stepper.hex
	# device can also be bound to /dev/ttyACM0 YMMV.
	avrdude -F -V -c arduino -p ATMEGA328P -P /dev/ttyUSB0 -b 115200 -U flash:w:stepper.hex

stepper-lib:
		    $(CPP) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		           $(CPP_FLAGS) $(ARDUINO_DIR)/libraries/Stepper/Stepper.cpp \
			   -o stepper-lib.o

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
