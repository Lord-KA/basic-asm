section .text

global _start
global gwrite
global gstrlen
global gflush
global gprintf

IO_BUF_SIZE equ 0xa


;=================================================
; "put single char" macro with counter

%assign gputchar_no 0x0

%macro gputchar 1
    mov cl, %1
    mov r10, IO_BUF_SIZE
    sub r10, [balance]
    mov [buf + r10], cl

    mov r10, [balance]
    dec r10
    mov [balance], r10
    
    xor r10, r10
    cmp [balance], r10
    jne .macro_end %+ gputchar_no
    
    call gflush

    .macro_end %+ gputchar_no:

    %assign gputchar_no gputchar_no+1

%endmacro


;=================================================
_start:

    push rbp

    ; call main
    mov r10, 0x1
    lw r10,jtable
    jalr r10

    call gflush
 
   
    pop rbp

    mov rdi, rax
    mov rax, 60
    syscall


;=================================================
; void gprintf( char* rdi, ... ) TODO 
gprintf: 
    mov [jtable + 'c' ], print_c    ; preping jump table
    mov [jtable + 'd' ], print_d
    mov [jtable + 's' ], print_s


    pop r11        ; WARNING r11 has to stay preserved (stores ret adress)
    push rbp

    push r9        ; getting all other input parameters into stack  ; TODO rewrite without push 
    push r8
    push rcx
    push rdx
    push rsi

    xor rcx, rcx
    .loop:
        mov cl, [rdi + rcx]         ; WARNING strings with "%" at the end are unsupported (for now)
        cmp cl, 0x0
        je .loop_end
        
        cmp cl, '%'
        jne .text_only

        inc rcx 
        mov cl, [rdi + rcx]

        xor r8, r8
        test rcx, 1
        cmove r8, 8        ; check if cmovE or cmovNE

        add rsp, r8

        jmp [cl + jtable]

        dec rsp, r8


        .text_only:
            gputchar cl
    
        continue:
        
        inc rcx
        
       .loop_end:

    


    pop rbp
    push r11
    ret


;=================================================
; jump table to gprint different data types 

jtable:
    times 0x100 db 0x0

print_c:
    pop cl
    gputchar cl
    jmp continue


print_d:
    pop r9
    .loop:
        test r9, r9
        je .loop_end

        xor rdx, rdx    ; getting % 10 of r9
        mov rax, r9
        div 0xa
        mov r9, rax
        mov cl, rdx
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


