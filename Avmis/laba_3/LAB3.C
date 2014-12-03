#include <dos.h>
#include <ctype.h>
#include <stdio.h>
#include <conio.h>
#include <string.h>
#include <stdlib.h>

int msCounter = 0;

void interrupt far (*oldInt70h)(void);    // Указатель на старый обработчик прерывания
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
	do    // Ожидание, пока часы заняты
	{
		outp(0x70, 0x0A);
	} while( inp(0x71) & 0x80 ); // 0x80 = 10000000, пока 7-й бит - 1, часы заняты
}

void getTime(void)
{
	unsigned char value;
	wait();
	outp(0x70, 0x04); // Текущий час
	value = inp(0x71); printf("%d:",BCDToInteger(value)); wait();
	outp(0x70, 0x02); // Текущая минута
	value = inp(0x71); printf("%d:",BCDToInteger(value)); wait();
	outp(0x70, 0x00); // Текущая секунда
	value = inp(0x71); printf("%d   ",BCDToInteger(value)); wait();
	outp(0x70, 0x07); // Текущий день месяца
	value = inp(0x71); printf("%d.",BCDToInteger(value)); wait();
	outp(0x70, 0x08); // Текущий месяц
	value = inp(0x71); printf("%d.",BCDToInteger(value)); wait();
	outp(0x70, 0x09); // Текущий год
	value = inp(0x71); printf("%d   ",BCDToInteger(value)); wait();
	outp(0x70, 0x06); // Текущий день недели
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
	freeze();     // Запретить обновление часов
	
	printf("Enter hour: "); scanf("%d", &value);
	outp(0x70, 0x04);
	outp(0x71, IntToBCD(value)); // Значение в порт 71h в BCD-формате
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

	unfreeze(); // Разрешить обновление часов
}

// Запретить обновление часов
void freeze(void)
{
	unsigned char value;
	wait();  // Ожидание, пока часы заняты

	outp(0x70,0x0B);
	value = inp(0x71); // читаем регистр состояния B
	value|=0x80;       // Заменяем 7-й бит на 1 для запрещения обновления часов
	outp(0x70, 0x0B);
	outp(0x71, value); // Записываем новое значение в регистр B, обновление часов запрещено
}

void unfreeze(void)
{
	unsigned char value;
	wait();  // Ожидание, пока часы заняты
	outp(0x70,0x0B);
	value = inp(0x71);  // читаем регистр состояния B
	value-=0x80;        // Заменяем 7-й бит на 0 для разрешения обновления часов
	outp(0x70, 0x0B);
	outp(0x71, value); // Записываем новое значение в регистр B, обновление часов разрешено
}

void interrupt far newInt70handler(void)
{
	msCounter++;     // Счётчик милисекунд

	outp(0x70,0x0C); // Если регистр C не будет прочитан после IRQ 8,
	inp(0x71);       // тогда прерывание не случится снова
	outp(0x20,0x20); // Посылаем контроллеру прерываний (master) сигнал EOI (end of interrupt)
	outp(0xA0,0x20); // Посылаем второму контроллеру прерываний (slave) сигнал EOI (end of interrupt)
}

void delay_time(void)
{
	unsigned long delayPeriod;
	unsigned char value;
	disable();    // Запретить прерывания
	oldInt70h = getvect(0x70);
	setvect(0x70, newInt70handler);
	enable();     // Разрешить прерывания

	printf("Enter delay time in milliseconds: ");
	scanf("%ld", &delayPeriod);
	printf("Delaying ...");

	// Размаскирование линии сигнала запроса от ЧРВ
	value = inp(0xA1);
	outp(0xA1,value & 0xFE);// 0xFE = 11111110, бит 0 в 0, чтобы разрешить прерывания от ЧРВ

	// Включение периодического прерывания
	outp(0x70, 0x0B);  // Выбираем регистр B
	value = inp(0x0B); // Читаем содержимое регистра B

	outp(0x70, 0x0B);  // Выбираем регистр B
	outp(0x71, value|0x40); // 0x40 = 01000000, 6-й бит регистра B устанавливаем в 1

	msCounter = 0;
	while(msCounter != delayPeriod); // Задержка на заданное кол-во миллисекунд
	printf("\nEnd delay of %d ms\n", msCounter);
	setvect(0x70, oldInt70h); // Восстанавливаем старый обработчик
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