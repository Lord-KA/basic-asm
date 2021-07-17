section .text
global fib_asm_rec
extern fib_cpp_asm_rec

fib_asm_rec:          ; input via rdi, returs rax                                                                                                                                 
    cmp rdi, 0x0
    mov rax, 0
    jle .loopend    

    cmp rdi, 0x1
    mov rax, 1
    jle .loopend    

    dec rdi
    push rdi
    call fib_cpp_asm_rec
    pop rdi
    dec rdi
    push rax
    call fib_cpp_asm_rec
    pop rsi
    add rax, rsi

    .loopend:
    ret
