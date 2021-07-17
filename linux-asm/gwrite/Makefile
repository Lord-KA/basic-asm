.SUFFIXES: .asm
.PHONY = all clean

all: run

.asm.o:
	nasm -g -felf64 $< -o $@

.c.o:
	gcc -g -c -fno-stack-protector $< -o $@ -no-pie

run: outp.o main_outp.o
	ld $^ -o $@

clean:
	rm run *.o
