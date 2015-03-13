#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <stdio.h>
#include <termios.h>

#define MAX 100

pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;


void* thread_func(void* arg);

int getch();

int count = 0;
int closed = 0;
int num = 0;

int main(int argc, char argv[]){
	char cmd;
	pthread_t tid[MAX];
	while(1){

		switch(getch(cmd)){
			case 61:	
						count++;
						if(!closed){
							pthread_create(&tid[count-1],
								NULL,
								thread_func,
								(void*)(count-1));
						}
						else
							closed--;
						break;
			case 45:	
						if(count > 0){
							count--;
							closed++;
						}
						break;
			default :   return 0;
		}
	}
	return 0;
}

void* thread_func(void* arg){
	while(count){
		if((int )arg == num){
			pthread_mutex_lock(&mtx);

			if((int )arg >= count-1)
				num = 0;
			else	num++;

			int i = 15;
			printf("          ");
			while(i){
				printf("%d", (int )arg);
				i--;
			}		
			printf("\n");

			pthread_mutex_unlock(&mtx);
			if((int )arg > count - 1){
				if(closed)
					closed--;
				return 0;
			}
		}
	}
	closed--;
	num = 0;
	return 0;
}

int getch( ) {
	struct termios oldt,
	newt;
	int ch;
	tcgetattr( STDIN_FILENO, &oldt );
	newt = oldt;
	newt.c_lflag &= ~( ICANON | ECHO );
	tcsetattr( STDIN_FILENO, TCSANOW, &newt );
	ch = getchar();
	tcsetattr( STDIN_FILENO, TCSANOW, &oldt );
	return ch;
}