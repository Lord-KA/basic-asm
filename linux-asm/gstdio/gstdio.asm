section .text

global _start
global gwrite
global gread
global gstrlen
global gflush

extern main
IO_BUF_SIZE equ 10

_start:
    push rbp

    call main
    
    pop rbp

    mov rdi, rax
    mov rax, 60
    syscall



; void gwrite( cosnt char*, size_t )
gwrite:
    push rbp
    cmp rsi, 0x0
    jle gwrite_end

    cmp [outp_balance], rsi
    jle .write_buf
    
    mov rcx, rsi
    mov r11, outp_buf + IO_BUF_SIZE
    sub r11, [outp_balance]
    .loop:
        mov dl, [rdi + rcx - 1]
        mov [r11 + rcx - 1], dl
        loop .loop
    sub [outp_balance], rsi
    jmp gwrite_end

    .write_buf:
        push rsi
        push rdi

        mov rsi, outp_buf
        mov rdx, IO_BUF_SIZE
        sub rdx, [outp_balance]
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
        mov [outp_balance], r11

 


    gwrite_end:
        pop rbp
        ret
        


; void gread( cosnt char* rdi, size_t rsi )
gread:
    push rbp
    cmp rsi, 0x0
    jle gread_end

    cmp [inp_balance], rsi
    jl .read_buf
    
    
    mov rcx, [inp_balance]      
    mov r10, inp_buf
    add r10, IO_BUF_SIZE
    sub r10, rcx
    .loop_1:                ; copying buf to outp
        mov dl, [r10 + rcx - 1]
        mov [rdi + rcx - 1], dl
        loop .loop_1

    jmp gread_end

    .read_buf:
        push rsi
        push rdi
        
        xor r10, r10
        cmp [inp_balance], r10
        je .loop_2_end

        mov rcx, [inp_balance]
        mov r10, inp_buf
        add r10, IO_BUF_SIZE
        sub r10, rcx
        add rdi, [inp_balance]
        .loop_2:                ; copying buf to outp
            mov dl, [r10 + rcx - 1]
            mov [rdi + rcx - 1], dl
            loop .loop_2
        .loop_2_end:

        mov rdx, rsi            ; getting the rest of read request
        sub rdx, [inp_balance]
        mov rsi, rdi
        mov rdi, 1
        xor rax, rax
        syscall

        mov rdx, IO_BUF_SIZE    ; filling buf
        mov rsi, inp_buf
        mov rdi, 1
        xor rax, rax 
        syscall
        
        mov r10, IO_BUF_SIZE
        mov [inp_balance], r10      ; buf is full

        pop rdi
        pop rsi


    gread_end:
        pop rbp
        ret
 


; size_t rax gstrlen( char* rdi )
gstrlen:
    mov rax, rdi
    .loop:
        mov cl, [rax]
        test cl, cl
        jz .gstrlen_end
        inc rax
        jmp .loop


    .gstrlen_end:
        sub rax, rdi
        ret

; void gflush( void ) 
gflush:
    push rbp

    mov rsi, outp_buf
    mov rdx, IO_BUF_SIZE
    sub rdx, [outp_balance]
    mov rdi, 1
    mov rax, 1
    syscall

    pop rbp
    ret
   


section .data

outp_buf:
    times IO_BUF_SIZE db 0x0 
outp_buf_end:
outp_balance:
    dq IO_BUF_SIZE
  
inp_buf:
    times IO_BUF_SIZE db 0x0 
inp_buf_end:
inp_balance:
    dq 0x0



text:
db "Hell "
text_end:
text_2:
db "is with you, motherfucker!"
text_2_end:


