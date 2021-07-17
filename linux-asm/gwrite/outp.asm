section .text

global _start
global gwrite
extern main
IO_BUF_SIZE equ 10

_start:
    push rbp
    ; mov rdi, text            ; pointer to data
    ; mov rsi, text_end - text ; len of data
    ; call gwrite

    ; mov rdi, text_2              ; pointer to data
    ; mov rsi, text_2_end - text_2; len of data
    ; call gwrite

    call main
    
    pop rbp
    mov rdi, rax
    mov rax, 60
    syscall

; void gwrite( cosnt char*, size_t )
gwrite:
    push rbp
    cmp [balance], rsi
    jle .write_buf
    
    mov rcx, rsi
    mov r11, buf + IO_BUF_SIZE
    sub r11, [balance]
    .loop:
        mov dl, [rdi + rcx - 1]
        mov [r11 + rcx - 1], dl
        loop .loop
    sub [balance], rsi
    jmp gwrite_end

    .write_buf:
        push rsi
        push rdi

        mov rsi, buf
        mov rdx, IO_BUF_SIZE
        sub rdx, [balance]
        mov rdi, 1
        mov rax, 1
        syscall

        pop rdi
        pop rsi

        mov rdx, rsi
        mov rsi, rdi
        mov rdi, 1
        mov rax, 1
        syscall

        mov r11, IO_BUF_SIZE
        mov [balance], r11

 


    gwrite_end:
        pop rbp
        ret
        
  




section .data
text:
    db "Hell "
text_end:
text_2:
    db "is with you, motherfucker!"
text_2_end:
buf:
    times IO_BUF_SIZE db 0x0 
buf_end:
balance:
    db IO_BUF_SIZE
