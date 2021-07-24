.SUFFIXES: .asm
.PHONY = all clean

all: run

.asm.o:
	nasm -felf64 $< -o $@

.c.o:
	gcc -c -fno-stack-protector $< -o $@ -no-pie

run: gprintf.o main.o
	ld $^ -o $@

clean:
	rm run *.o
