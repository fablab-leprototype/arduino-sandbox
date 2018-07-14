ARDUINO_DIR=/usr/share/arduino
ARDUINO_CORE=$(ARDUINO_DIR)/hardware/arduino/cores/arduino
ARDUINO_LIB=$(ARDUINO_DIR)/libraries
INCLUDE=-I. -I./liquidcrystal -I$(ARDUINO_DIR)/hardware/arduino/cores/arduino \
	-I$(ARDUINO_DIR)/hardware/arduino/variants/standard \
	-I$(ARDUINO_LIB)/Wire \
        -I$(ARDUINO_LIB)/Wire/utility

CC=avr-gcc
CPP=avr-g++
MCU=atmega328p
DF_CPU=16000000
CPP_FLAGS=-DARDUINO=100 -ffunction-sections -fdata-sections
LD_FLAGS=-Wl,--gc-sections

CORE_CPP_FILES=main Print WString
CORE_C_FILES=wiring_digital wiring

LIB_C_FILES=Wire/utility/twi
LIB_CPP_FILES=Wire/Wire

USB_DEVICE=/dev/ttyUSB0

all : install
.PHONY: all

clean:
	rm -f lcd *.o lcd.hex

lcd.o: lcd.c
	 $(CPP) $(CPP_FLAGS) $(LD_FLAGS) -std=c++11 -Os -mmcu=$(MCU) -c -o lcd.o lcd.c $(INCLUDE)

liquidcrystal.o:
	 $(CPP) $(CPP_FLAGS) $(LD_FLAGS) -std=c++11 -Os -mmcu=$(MCU) -c -o liquidcrystal.o liquidcrystal/LiquidCrystal_I2C.cpp $(INCLUDE)


lcd: lcd.o liquidcrystal.o arduino_core_cpp arduino_core_c arduino_lib_c arduino_lib_cpp
	$(CPP) $(CPP_FLAGS) $(LD_FLAGS) -std=c++11 -mmcu=$(MCU) *.o -o lcd


lcd.hex: lcd
	avr-objcopy -O ihex -R .eeprom lcd lcd.hex

install: lcd.hex
	avrdude -F -V -c arduino -p ATMEGA328P -P $(USB_DEVICE) -b 115200 -U flash:w:lcd.hex

arduino_core_cpp:
		for core_cpp_file in ${CORE_CPP_FILES}; do \
		    $(CPP) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		           $(CPP_FLAGS) $(LD_FLAGS) $(ARDUINO_CORE)/$$core_cpp_file.cpp \
			   -o $$core_cpp_file.o; \
		done
arduino_core_c:
		for core_c_file in ${CORE_C_FILES}; do \
		    $(CC) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		          $(CC_FLAGS) $(LD_FLAGS) $(ARDUINO_CORE)/$$core_c_file.c \
			  -o $$core_c_file.o; \
		done
arduino_lib_c:
		for lib_c_file in ${LIB_C_FILES}; do \
		    $(CC) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		          $(CC_FLAGS) $(LD_fLAGS) $(ARDUINO_LIB)/$$lib_c_file.c \
			  -o `basename $$lib_c_file`.o; \
		done


arduino_lib_cpp:
		for lib_cpp_file in ${LIB_CPP_FILES}; do \
		    $(CPP) -c -mmcu=$(MCU) -DF_CPU=$(DF_CPU) $(INCLUDE) \
		           $(CPP_FLAGS) $(LD_FLAGS) $(ARDUINO_LIB)/$$lib_cpp_file.cpp \
			   -o `basename $$lib_cpp_file`.o; \
		done

