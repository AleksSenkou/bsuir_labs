#include <dos.h>
#include <conio.h>
#include <stdio.h>

void interrupt new_handler(void);       // address printing options on the screen for new handler
void interrupt (*old_handler)(void);    // for old hendler
void indicator(unsigned char guise);     
void blinking (void);                   

int anyError = 1;   // error flag, retransmission
int quit = 0;       // close programm
int blinkingON = 0; // blinking flag

void main()
{
  old_handler = getvect(9); // copy old interrupt handler
  setvect(9, new_handler);  // write new handler into vectors table 
  while(!quit)
  {
    if (blinkingON) blinking(); 
  }
  setvect(9, old_handler);  // write old handler
  return;
}

void interrupt new_handler(voi)
{
  unsigned char value = 0;
  old_handler();
  value = inp(0x60);          // return the bytes read from port PS/2
  if(value == 0x01) quit = 1; // Esc button --> quit

  if (value == 0x26 && blinkingON == 0) blinkingON = 1;      // 'l' for turn on blinking 
  else if (value == 0x26 && blinkingON == 1) blinkingON = 0; // turn off

  if (value != 0xFA && blinkingON == 1) anyError = 1; // if 0xFA(error code) -> retransmission
  else anyError = 0;

  printf("Code: \t%x\n", value);
  outp(0x20, 0x20); // get the scan code and ASCII-code key 122-key keyboard 
}

void indicator(unsigned char guise)
{
  anyError = 1; 
  while (anyError) 
  {
    while((inp(0x64) & 0x02) != 0x00); // waiting for the release of keyboard input buffer
    outp(0x60, 0xED); // 0xED - indicators management
    delay(50);
  }

  anyError = 1;
  while (anyError)  
  {
    while((inp(0x64) & 0x02) != 0x00);  
    outp(0x60, guise); // bit quise 
    delay(50);
  }
}

void blinking ()
{
  indicator(0x02); //  Num Lock
  delay(150);
  indicator(0x04); //  Caps Lock
  delay(150);
  indicator(0x6);  //  Num Lock  Caps Lock
  delay(200);
  indicator(0x00); //  turn off
  delay(50);
  indicator(0x06); //  Num Lock  Caps Lock
  delay(100);
  indicator(0x00); //  turn off
}
