section .text

global _start
global gwrite
global gstrlen
global gflush
global gprintf

IO_BUF_SIZE equ 0x10

extern main


;=================================================
; "put single char" macro with counter

%assign gputchar_no 0x0

%macro gputchar 1
    mov dl, %1
    mov r10, IO_BUF_SIZE
    sub r10, [balance]
    mov [buf + r10], dl

    mov r10, [balance]
    dec r10
    mov [balance], r10
    
    xor r10, r10
    cmp [balance], r10
    jne .macro_end %+ gputchar_no
    
    push rcx
    call gflush
    pop rcx

    .macro_end %+ gputchar_no:

    %assign gputchar_no gputchar_no+1

%endmacro


;=================================================
_start:

    push rbp

    call main
    ; mov r10, 0x1
    ; lw r10,jtable
    ; jalr r10

    ; gputchar 'a'
    ; gputchar 'b'
    ; gputchar 'c'
    ; gputchar 'd'
    call gflush
 
    pop rbp

    xor rax, rax
    mov rdi, rax
    mov rax, 60
    syscall


;=================================================
; void gprintf( char* rdi, ... ) TODO 
gprintf: 
    mov r10, print_c
    mov [jtable + 'c'], r10    ; preping jump table

    mov r10, print_d
    mov [jtable + 'd'], r10

    mov r10, print_s
    mov [jtable + 's'], r10

    pop r11        ; WARNING r11 has to stay preserved (stores ret adress)

    push r9        ; getting all other input parameters into stack  ; TODO rewrite without push 
    push r8
    push rcx
    push rdx
    push rsi

    xor rcx, rcx        ; counter
    loop:
        mov dl, [rdi + rcx]         ; WARNING strings with "%" at the end are unsupported (for now)
        cmp dl, 0x0
        je loop_end
        
        cmp dl, '%'
        jne .text_only

        inc rcx 
        mov dl, [rdi + rcx]

        xor r8, r8
        test rcx, 1
        mov r9, 8
        cmove r8, r9        ; check if cmovE or cmovNE

        add rsp, r8

        mov r8, rdx
        add r8, jtable
        jmp r8

        sub rsp, r8


        .text_only:
            gputchar dl
    
        continue:
        
        inc rcx
        jmp loop
        
       loop_end:

    

    call gflush
    pop rbp
    push r11
    ret


;=================================================
; jump table to gprint different data types 

jtable:
    times 0x100 db 0x0

print_c:
    pop rcx
    gputchar cl
    jmp continue


print_d:
    pop r9
    .loop:
        test r9, r9
        je .loop_end

        xor rdx, rdx    ; getting % 10 of r9
        mov rax, r9
        mov rcx, 0xa
        div rcx
        mov r9, rax
        mov rcx, rdx
        add cl, '0'
        gputchar cl

        .loop_end:

    jmp continue


print_s:
    pop r9
    .loop:
        mov cl, [r9]
        test cl, cl    ; if [r9] == 0x0
        je .loop_end
         
        gputchar cl
        add r9, 8

        .loop_end:
    
    jmp continue



;=================================================
; void gwrite( cosnt char*, size_t )
gwrite:
    push rbp
    cmp rsi, 0x0
    jle gwrite_end

    cmp [balance], rsi
    jle .write_buf
    
    mov rcx, rsi
    mov r8, buf + IO_BUF_SIZE
    sub r8, [balance]
    .loop:
        mov dl, [rdi + rcx - 1]
        mov [r8 + rcx - 1], dl
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

        mov r8, IO_BUF_SIZE
        mov [balance], r8

 


    gwrite_end:
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

    mov rsi, buf
    mov rdx, IO_BUF_SIZE
    sub rdx, [balance]
    mov rdi, 1
    mov rax, 1
    syscall

    mov r10, IO_BUF_SIZE
    mov [balance], r10

    pop rbp
    ret
   


section .data

buf:
    times IO_BUF_SIZE db 0x0 
buf_end:
balance:
    dq IO_BUF_SIZE





text:
db "Hell "
text_end:
text_2:
db "is with you, motherfucker!"
text_2_end:


