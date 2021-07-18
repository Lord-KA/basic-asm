.SUFFIXES: .asm
.PHONY = all clean

all: run

.asm.o:
	nasm -g -felf64 $< -o $@

.c.o:
	gcc -g -c -fno-stack-protector $< -o $@ -no-pie

run: gstdio.o main.o
	ld $^ -o $@

clean:
	rm run *.o
