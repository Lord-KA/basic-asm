section .text

; global main
global fib
extern printf

main:
    mov rdi, 0x10     ; the desired fibbonacci num
    
    call fib
    mov rdi, text2
    mov rsi, rax
    sub rsp, 8
    call printf
    
    xor rax, rax
    add rsp, 8
    ret

fib:          ; input via rdi
    mov rcx, rdi
    mov rsi, 0 ; the smaller of two last nums
    mov rdi, 0 ; the biger of two last nums
    mov rax, 1
    .loop:
        cmp rcx, 0x1
        jle .loopend
        mov rsi, rdi
        mov rdi, rax
        add rax, rsi
        dec rcx
        jmp .loop
        .loopend:

    ret


section .data
text:
    db "The fibbonacci number = ", 0x0
text2:
    db "%d", 0x0

