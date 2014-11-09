OBJ = main.o 
CFLAGS = -Wall -std=c99

all: main

main: $(OBJ)
	gcc $(CFLAGS) $(OBJ) -o main -lncurses

%.o : %.c
	gcc $(CFLAGS) -c $<

clean:
	rm main $(OBJ)
