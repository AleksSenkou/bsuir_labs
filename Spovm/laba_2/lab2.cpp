#include <ncurses.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#include <iostream>
using namespace std;

void allowPrint(int sign);
void setKillFlag(int sign);
int createProcess(pid_t pidArray[]);
bool killProcess(pid_t pidArray[]);
int controlProcesses(pid_t pidArray[]);
void killAllProcesses(pid_t pidArray[]);

bool printAllowed = false;
bool killFlag = true;
bool flag = false;
int processesCount = 0;
int currentProcessNumber = 0;

struct sigaction printSignal, killSignal;


int main(){
	// initscr();
	// clear();
	// noecho();
	// refresh();
	
	printSignal.sa_handler = allowPrint; // указатель на функцию-обработчик
	sigaction(SIGUSR1,&printSignal,NULL);
	
	killSignal.sa_handler = setKillFlag;
	sigaction(SIGUSR2,&killSignal,NULL);
	
	pid_t pidArray[100];
	
	while(int i = controlProcesses(pidArray)) {
	
		if(i == -1) return 0;
	
		if(killFlag && processesCount > 0){ // if current process stop printing
			killFlag = false;
			if(currentProcessNumber >= processesCount - 1) currentProcessNumber = 0; // if the number of current process is last, start from beginning
			else if(!flag) currentProcessNumber++; // else if last stopped process wasn't the last by number go to next process
			flag = false;
			kill(pidArray[currentProcessNumber], SIGUSR1); // signal to child process start the printing
		}
	// refresh();
	}
	// stop all child processes
	killAllProcesses(pidArray);
	
	// clear();
	// endwin();
	
	return 0;
}

void allowPrint(int sign){
	printAllowed = true;
}

void setKillFlag(int sign){
	killFlag = true;
}

int createProcess(pid_t pidArray[]){

	if(processesCount > 100) return 1;
	
	pidArray[processesCount] = fork();
	processesCount++;
	
	switch(pidArray[processesCount - 1]){
		case 0:{
			killFlag = false;
			char buff[255];
			// sprintf(buff,"Process %d || ", processesCount);
			// refresh();
			while(!killFlag) {
				// usleep(1000);
				if(printAllowed){
					for(int i = 0; i < 10; i++){
						if(killFlag) { return -1;};
						cout << processesCount;
						// usleep(1000);
					}
					cout << endl;
					// refresh();
					printAllowed = false;
					// signal to parent that process stop print
					kill(getppid(), SIGUSR2);
				}
			}
			return -1;
		}
		case -1: cout << "error"; return 1;		
		default: return 1;
	}
}

bool killProcess(pid_t pidArray[]){
	if (processesCount <= 0) return 1;

	processesCount--; // stop last child process
	kill(pidArray[processesCount], SIGUSR2);
	waitpid(pidArray[processesCount], NULL, 0); // if the process that printing now stopped

	if (currentProcessNumber >= processesCount){
		currentProcessNumber = 0; // start from beginning
		flag = true; // flag last process by number
		killFlag = true; // flag of end printing current process
	}
return 1;
}

int controlProcesses(pid_t pidArray[]){
	halfdelay(1);
	noecho();
	switch((char)getchar()){
		case '+': return createProcess(pidArray);
		case '-': return killProcess(pidArray);
		case 'q': return 0;
		default: return 1;
	}
}

void killAllProcesses(pid_t pidArray[]){
	if(pidArray[--processesCount] != 0)
	for( ;processesCount >= 0; processesCount--){
		kill(pidArray[processesCount],SIGUSR2);
		waitpid(pidArray[processesCount],NULL,0);
	}
}	
	
