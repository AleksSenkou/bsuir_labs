#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <stdlib.h>

#define PORT43 0x43
#define PORT42 0x42
#define PORT41 0x41
#define PORT40 0x40
#define PORT61 0x61


void from_char_to_bin(unsigned char temp, char *str)
{
    int i;
    i=7;
    while(temp)
    {
	str[i]='0'+temp%2;
	temp=temp/2;
	i--;
    }
    for(;i>-1;i--)
    {
	str[i]=' ';
    }
}

int main()
{
    unsigned char temp;
    char *str;
    short cnt;
    double f = 11193180.0;
    int freq = 800;
    char port61word;
    str=(char*)calloc(9, sizeof(char));
    cnt = f/ freq; /* zadergka */

    puts("------------------------------");
    puts("System sound");
    sound(freq);
    delay(2000);
    nosound();

    puts("Work with loudspeaker:");
    outp(PORT43, 0xB6); /* regim canala 2-go taimera */

    outp(PORT42, (char)cnt); /* zagrugaem mladhii bit */
    outp(PORT42, (char)(cnt >> 8)); /* starshii bit */

    /* turn on loudspeaker */
    port61word = inp(PORT61);
    port61word = port61word | 3;
    outp(PORT61, port61word);
    /* ---------------------------- */

    outp(PORT43, 0xe2); /* 11100010B */
    temp=inp(PORT40); /* return bytes read from the port */
    from_char_to_bin(temp, str);
    printf("Status word of channel number 0: %s\n", str);

    outp(PORT43, 0xe4); /* 11100100B */
    temp=inp(PORT41);
    from_char_to_bin(temp, str);
    printf("Status word of channel number 1: %s\n", str);

    outp(PORT43, 0xe8); /* 11101000B */
    temp=inp(PORT42);
    from_char_to_bin(temp, str);
    printf("System word of channel number 2: %s\n", str);

    delay(4000);
    port61word = port61word & 0xFFFC;
    outp(PORT61, port61word); /* turn off loudspeaker */

    puts("------------------------------");
    system("pause");
    return 0;
}