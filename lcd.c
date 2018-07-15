#define F_CPU 16000000UL
#define ARDUINO 100

#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>


extern "C" void __cxa_pure_virtual() { while (1); }

/* Wiring:
 * SDA -> A4
 * SCL -> A5
 */
char array1[]=" Elefab                   "; //the string to print on the LCD
char array2[]="hello, world!             "; //the string to print on the LCD
int tim = 1500; //the value of delay time
// initialize the library with the numbers of the interface pins
// addr might be 0x3f or 0x27
LiquidCrystal_I2C lcd(0x3f,16,2);


/*********************************************************/
void setup()
{
  lcd.init(); //initialize the lcd
  lcd.backlight(); //open the backlight
}
/*********************************************************/
void loop()
{
  lcd.setCursor(15,0); // set the cursor to column 15, line 0
  lcd.backlight();
  for (int positionCounter1 = 0; positionCounter1 < 26; positionCounter1++)
  {
    lcd.scrollDisplayLeft(); //Scrolls the contents of the display one space to the left.
    lcd.print(array1[positionCounter1]); // Print a message to the LCD.
    delay(tim); //wait for 250 microseconds
  }
  lcd.clear(); //Clears the LCD screen and positions the cursor in the upper-left  corner.
  lcd.setCursor(15,1); // set the cursor to column 15, line 1
  for (int positionCounter = 0; positionCounter < 26; positionCounter++)
  {
    lcd.scrollDisplayLeft(); //Scrolls the contents of the display one space to the left.
    lcd.print(array2[positionCounter]); // Print a message to the LCD.
    delay(tim); //wait for 250 microseconds
  }
  lcd.clear(); //Clears the LCD screen and positions the cursor in the upper-left corner.
}

