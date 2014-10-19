#include <ncurses.h>
#include <unistd.h>
#include <wait.h>
#include <sys/types.h>
#include <string.h>

#define MAX_STR 256
char input_buffer[MAX_STR];
int array[MAX_STR];
int prop_numb = 0;

void child();
int file_reading();
void array_filling(int );
void array_sort();
int power(int ,int );
void array_output();

int main(int argc, char const *argv[])
{       
    pid_t pid;
    pid = fork();
    switch(pid) {
        case -1:
            printf("Error");
            return 88;
        case 0: 
            printf("Child process: \n");
            child();
            break;
        default: 
            printf("\nParent process: \n");
            break;
    }
    return 0;
}

void child() {

    int array_length = file_reading();
    array_filling(array_length);
    printf("    array from file:\n    ");
    array_output();
    array_sort();
    printf("    array after sorting:\n    ");
    array_output();

    getchar();
}

int file_reading() {
    FILE *file;
    file = fopen("text", "r");
    fgets(input_buffer, sizeof(input_buffer), file);
    input_buffer[strlen(input_buffer) - 1]='\0';
    fclose(file);
    return strlen(input_buffer);
}

void array_filling(int array_length){
    int i, j, a;
    for(i = 0; i < array_length; i++) {
        if(input_buffer[i] != ' ' && input_buffer[i] != '\0') {
            if(input_buffer[i + 1] != ' ') {
                array[prop_numb] = 0;
                for(j = i; input_buffer[j + 1] != ' ' && input_buffer[j + 1] != '\0'; j++) {a = j + 1;}
                for(j = i; a >= j; j++) {
                    array[prop_numb] += (input_buffer[j] - '0')*power(10,(a - j));
                }
                prop_numb++;
                i = a + 1;
            }
            else {
                array[prop_numb++] = input_buffer[i] - '0';
            }
        }
    }
}

void array_sort() {
    int i, j;
    for(i = 0; i < prop_numb; i++) { 
        for(j = 0; j < prop_numb - i - 1; j++) {  
            if(array[j] > array[j+1]) {           
                int tmp = array[j];
                array[j] = array[j+1];
                array[j+1] = tmp; 
           }
       }
   }
}

int power(int t, int k)
{
    int res = 1;
    while (k) {
        if (k & 1) 
            res *= t;
        t *= t;
        k >>= 1;
    }
    return res;
}
 
void array_output() {
    int i;
    for(i = 0; i < prop_numb; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
}