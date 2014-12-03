#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/sem.h>
#include <sys/ipc.h>
#include <sys/wait.h>

const int STRING_SIZE = 80;
const int DEC = 0, INC = 1, WAIT = 2;
int file_descriptors[2];

int setSemaphore(char* path)
{
    int id;
    id = ftok(path, 10); // создаем ключ    
    id = semget(id, 1, IPC_CREAT | 0600); // создаем набор семафоров с одним семафором
    semctl(id, 0, SETVAL, 0); // ставиv значение счетчика семафора в 0;
    return id;
}

struct sembuf *createSembufs()
{
    struct sembuf *result = calloc(3, sizeof(struct sembuf));
    result[DEC].sem_num = result[INC].sem_num = result[WAIT].sem_num = 0;
    result[DEC].sem_op = -1;
    result[INC].sem_op = 1;
    result[WAIT].sem_op = 0;
    return result;
}

void child_program(int semId)
{
    close(file_descriptors[1]);
    char recieved_string[STRING_SIZE];
    struct sembuf *sembufs = createSembufs();
    while (strcmp(recieved_string,"q")) {
        semop(semId, &sembufs[INC], 1);
        semop(semId, &sembufs[WAIT], 1);
        printf("#CHILD PROC# ");
        read(file_descriptors[0], recieved_string, sizeof(recieved_string));
        printf("Received string is: %s\n", recieved_string);
        semop(semId, &sembufs[DEC], 1);
    }
    free(sembufs);
    exit(0);
}

int init(int semId)
{
    pid_t childPid = 0;        
    childPid = fork();
    if(!childPid)
    {
        child_program(semId);
    }
    return childPid;
}

void input(char *target)
{
    printf("Enter string: "); 
    fgets(target, STRING_SIZE, stdin);
    *strchr(target, (int)'\n') = '\0';
}

int main(int argc, char **argv)
{
    char myString[STRING_SIZE];
    int semId = setSemaphore(argv[0]);

    pipe(file_descriptors);
    struct sembuf *sembufs = createSembufs();
    init(semId);
    close(file_descriptors[0]);
    while((strcmp(myString, "q"))){
        printf("#PARENT PROC# ");
        input(myString);
        write(file_descriptors[1], myString, (strlen(myString)+1));
        semop(semId, &sembufs[DEC], 1);
        semop(semId, &sembufs[INC], 1);
        semop(semId, &sembufs[WAIT], 1);
    }
    free(sembufs); 
   return 0;    
}