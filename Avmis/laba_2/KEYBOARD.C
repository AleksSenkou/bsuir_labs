#include <dos.h>
#include <conio.h>
#include <stdio.h>

void interrupt newInt9(void);     // Функция обработки прерывания
void interrupt (*oldInt9)(void);  // Указатель на прерывание

void indicator(unsigned char mask); // Функция управления индикаторами
void blinking (void);    // Функция мигания индикаторами

int isResend = 1;  // Флаг ошибки / необходимости повторной передачи данных
int quitFlag = 0;
int blinkingON = 0;

void main()
{
	oldInt9 = getvect(9);	// Сохраняем старое прерывание
	setvect(9, newInt9);	// Меняем его на новое	
	while(!quitFlag)	 // Пока не установлен флаг выхода
	{
		if (blinkingON) 		// Если установлен флаг мигания индикаторов 
			blinking(); // мигаем индикаторами
	}		
	setvect(9, oldInt9);    // Восстанавливаем старое прерывание
	return;
}

// Функция обработки прерывания
void interrupt newInt9()
{
	unsigned char value = 0;
	oldInt9();
	value = inp(0x60);    // Получаем значение из порта 60h
	if(value == 0x01) quitFlag = 1; // Устанавливаем флаг выхода, если нажата Esc	
	
	if (value == 0x26 && blinkingON == 0) blinkingON = 1;  // Поставить или снять флаг мигания
	else if (value == 0x26 && blinkingON == 1) blinkingON = 0;
	
	if (value != 0xFA && blinkingON == 1)    // Если нет подтверждения успешного выполнения команды
		isResend = 1; 	// Устанавливаем флаг повторной передачи байта
	else isResend = 0;
	
	printf("\t%x", value);
	outp(0x20, 0x20);       // Сброс контроллера прерываний
}

// Функция управления индикаторами
void indicator(unsigned char mask)
{
	isResend = 1;
	while (isResend)     // Пока нет подтверждения успешного выполнения команды
	{
		while((inp(0x64) & 0x02) != 0x00); // Ожидаем освобождения входного буфера клавиатуры
		outp(0x60, 0xED);	// Записываем в порт команду управления индикаторами
		delay(50);
	}
	
	isResend = 1;
	while (isResend)    // Пока нет подтверждения успешного выполнения команды
	{
		while((inp(0x64) & 0x02) != 0x00);  // Ожидаем освобождения входного буфера клавиатуры
		outp(0x60, mask);     // Записываем в порт битовую маску для настройки индикаторов
		delay(50);
	}
}

// Функция мигания индикаторами
void blinking ()
{
	indicator(0x02); // вкл. индикатор Num Lock
	delay(150);
	indicator(0x04); // вкл. индикатор Caps Lock
	delay(150);
	indicator(0x6); // вкл. Num Lock и Caps Lock
	delay(200);
	indicator(0x00); // выкл. все индикаторы
    delay(50);
	indicator(0x06); // вкл. Num Lock и Caps Lock
    delay(100);
    indicator(0x00); // выкл. все индикаторы
}
