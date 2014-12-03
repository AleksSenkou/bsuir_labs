#include <dos.h>
#include <ctype.h>
#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <stdlib.h>

int msCounter = 0;

void interrupt far (*oldInt70h)(void);
void interrupt far newInt70handler(void);

void freeze(void);
void unfreeze(void);
int BCDToInteger(int bcd);
unsigned char IntToBCD(int value);
void getTime(void);
void setTime(void);
void showValue(unsigned char regNum);
void delay_time(void);
void wait(void);

void main()
{
  char c, value;
  clrscr();
  printf("Press:\n'1' - Show time\n'2' - Set time\n'3' - Delay time\n'Esc' - quit\n\n");
  while(c != 27)
  {
    c = getch();
    switch(c)
    {
      case '1': getTime();break;
      case '2': setTime();break;
      case '3': delay_time();break;
      case 27: break;
    }
  }
}

void wait(void)
{
  do    
  {
    outp(0x70, 0x0A);
  } while( inp(0x71) & 0x80 ); 
}

void getTime(void)
{
  unsigned char value;
  wait();
  outp(0x70, 0x04); 
  value = inp(0x71); printf("%d:",BCDToInteger(value)); wait();
  outp(0x70, 0x02);
  value = inp(0x71); printf("%d:",BCDToInteger(value)); wait();
  outp(0x70, 0x00);
  value = inp(0x71); printf("%d   ",BCDToInteger(value)); wait();
  outp(0x70, 0x07);
  value = inp(0x71); printf("%d.",BCDToInteger(value)); wait();
  outp(0x70, 0x08);
  value = inp(0x71); printf("%d.",BCDToInteger(value)); wait();
  outp(0x70, 0x09);
  value = inp(0x71); printf("%d   ",BCDToInteger(value)); wait();
  outp(0x70, 0x06);
  value = inp(0x71);
  switch(BCDToInteger(value))
  {
    case 2: printf("Monday\n"); break;
    case 3: printf("Tuesday\n"); break;
    case 4: printf("Wednesday\n"); break;
    case 5: printf("Thursday\n"); break;
    case 6: printf("Friday\n"); break;
    case 7: printf("Saturday\n"); break;
    case 1: printf("Sunday\n"); break;
    default: printf("Day of week is not set\n"); break;
  }
}

void setTime(void)
{
  int value;
  freeze();
  
  printf("Enter hour: "); scanf("%d", &value);
  outp(0x70, 0x04);
  outp(0x71, IntToBCD(value));
  printf("Enter minute: "); scanf("%d", &value);
  outp(0x70, 0x02);
  outp(0x71, IntToBCD(value));
  printf("Enter second: "); scanf("%d", &value);
  outp(0x70, 0x00);
  outp(0x71, IntToBCD(value));
  printf("Enter week day number: "); scanf("%d", &value);
  outp(0x70, 0x06);
  outp(0x71, IntToBCD(value));
  printf("Enter day of month: "); scanf("%d", &value);
  outp(0x70, 0x07);
  outp(0x71, IntToBCD(value));
  printf("Enter mounth: "); scanf("%d", &value);
  outp(0x70, 0x08);
  outp(0x71, IntToBCD(value));
  printf("Enter year: "); scanf("%d", &value);
  outp(0x70, 0x09);
  outp(0x71, IntToBCD(value));

  unfreeze();
}

void freeze(void)
{
  unsigned char value;
  wait();

  outp(0x70,0x0B);
  value = inp(0x71);
  value|=0x80;
  outp(0x70, 0x0B);
  outp(0x71, value);
}

void unfreeze(void)
{
  unsigned char value;
  wait();
  outp(0x70,0x0B);
  value = inp(0x71);
  value-=0x80;
  outp(0x70, 0x0B);
  outp(0x71, value);
}

void interrupt far newInt70handler(void)
{
  msCounter++;

  outp(0x70,0x0C);
  inp(0x71);
  outp(0x20,0x20);
  outp(0xA0,0x20);
}

void delay_time(void)
{
  unsigned long delayPeriod;
  unsigned char value;
  disable();
  oldInt70h = getvect(0x70);
  setvect(0x70, newInt70handler);
  enable();

  printf("Enter delay time in milliseconds: ");
  scanf("%ld", &delayPeriod);
  printf("Delaying ...");

  value = inp(0xA1);
  outp(0xA1,value & 0xFE);
  
  outp(0x70, 0x0B);
  value = inp(0x0B);

  outp(0x70, 0x0B);
  outp(0x71, value|0x40);

  msCounter = 0;
  while(msCounter != delayPeriod);
  printf("\nEnd delay of %d ms\n", msCounter);
  setvect(0x70, oldInt70h);
    unfreeze();
}

int BCDToInteger (int bcd)
{
  return bcd % 16 + bcd / 16 * 10;
}

unsigned char IntToBCD (int value)
{
  return (unsigned char)((value/10)<<4)|(value%10);
}