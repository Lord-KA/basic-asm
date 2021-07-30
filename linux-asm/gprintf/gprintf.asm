section .text

global _start
global gwrite
global gstrlen
global gflush
global gprintf

IO_BUF_SIZE equ 0x100
UINT64_MAX_LEN equ 20
UINT64_MAX_BIN equ 0b1000000000000000000000000000000000000000000000000000000000000000
UINT64_MAX_OCT equ 0b1110000000000000000000000000000000000000000000000000000000000000
UINT64_MAX_HEX equ 0b1111000000000000000000000000000000000000000000000000000000000000

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
    
    push rdi
    push rcx
    push r11
    call gflush
    pop r11
    pop rcx
    pop rdi

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
; void gprintf( char* rdi, ... ) 

gprintf: 
    pop r12        ; WARNING r12 has to stay preserved (stores ret adress) ; TODO save r12 for calling func

    push r9        ; getting all other input parameters into stack  ; TODO rewrite without push 
    push r8
    push rcx
    push rdx
    push rsi

    xor rdx, rdx
    xor rcx, rcx        ; counter on rdi chars
    xor r11, r11        ; counter of used input parameters 
    loop:
        mov dl, [rdi + rcx]         ; WARNING strings with "%" at the end are unsupported (for now)
        cmp dl, 0x0
        je loop_end
        
        cmp dl, '%'
        jne .text_only

        inc rcx 
        inc r11
        mov dl, [rdi + rcx]

        ; xor r8, r             ; TODO figure out if stack correction is needed
        ; test rcx, 1
        ; mov r10, 8
        ; cmovne r8, r10        ; check if cmovE or cmovNE

        ; add rsp, r8

        lea r10, [(rdx - '%') * 8 + jtable]
        mov r10, [r10]
        jmp r10

        ; sub rsp, r8


        .text_only:
            gputchar dl
    
        continue:
        
        inc rcx
        jmp loop
        
       loop_end:

      
    push r11
    call gflush
    pop r11

    mov rcx, 0x5
    sub rcx, r11
    lea rcx, [rcx * 8]
    add rsp, rcx

    push r12
    ret


;=================================================
; jump table to gprint different data types 

print_bin:
    pop rdx
    push rbx
    push rcx
    push r10
    push r9

    xor rbx, rbx
    xor r9, r9
    mov bl, '1'
    .loop:
        test rdx, rdx
        je .loop_end
            
        mov r10, UINT64_MAX_BIN
        and r10, rdx
        xor rcx, rcx
        mov cl, '0'
        test r10, r10
        je .zero_case

        .one_case:
            mov cl, '1'
            mov r9, 0x1 
            jmp .if_end

        .zero_case:
            test r9, r9
            je .continue

            mov cl, '0'

        .if_end:


        push rdx

        gputchar cl
    
        pop rdx

        .continue:

        shl rdx, 0x1
        jmp .loop
        .loop_end:

    pop r9
    pop r10
    pop rcx
    push rbx
    jmp continue

print_char:
    pop rdx
    gputchar dl
    jmp continue

print_dec:
    pop r9
    push rcx
    push r8 
    push r10
    push r11
    
    mov r8, r9
    mov r10, UINT64_MAX_LEN
    .loop_1:
        test r8, r8
        je .loop_1_end
        
        dec r10
        
        xor rdx, rdx
        mov rax, r8
        mov rcx, 0xa
        div rcx

        mov r8, rax
        add dl, '0'
        mov [dec_buf + r10], dl

        jmp .loop_1
        .loop_1_end:


    .loop_2:
        cmp r10, UINT64_MAX_LEN
        je .loop_2_end
        
        mov dl, [dec_buf + r10]

        push r10
        gputchar dl
        pop r10

        inc r10

        jmp .loop_2
        .loop_2_end:


    pop r11
    pop r10
    pop r8
    pop rcx

    jmp continue

print_oct:
    pop rdx
    push rcx
    push r10
    push r9

    xor r9, r9

    mov r10, UINT64_MAX_BIN
    and r10, rdx
    shl rdx, 0x1

    test r10, r10
    je .loop
    gputchar '1'
    mov r9, 1

    .loop:
        test rdx, rdx
        je .loop_end
            
        mov r10, UINT64_MAX_OCT
        and r10, rdx
        shr r10, 0x3d
        xor rcx, rcx
        mov cl, '0'
        test r10, r10
        je .zero_case

        .one_case:
            mov cl, [hex_table + r10]
            mov r9, 0x1 
            jmp .if_end

        .zero_case:
            test r9, r9
            je .continue

            mov cl, '0'

        .if_end:


        push rdx

        gputchar cl
    
        pop rdx

        .continue:

        shl rdx, 0x3
        jmp .loop
        .loop_end:

    pop r9
    pop r10
    pop rcx
    jmp continue

print_string:
    pop r9
    .loop:
        mov dl, [r9]
        test dl, dl    ; if [r9] == 0x0
        je .loop_end
         
        push r9
        gputchar dl
        pop r9

        inc r9
        
        jmp .loop
        .loop_end:
    
    jmp continue

print_hex:
    pop rdx
    push rcx
    push r10
    push r9

    xor r9, r9
    .loop:
        test rdx, rdx
        je .loop_end
            
        mov r10, UINT64_MAX_HEX
        and r10, rdx
        shr r10, 0x3c
        xor rcx, rcx
        mov cl, '0'
        test r10, r10
        je .zero_case

        .one_case:
            mov cl, [hex_table + r10]
            mov r9, 0x1 
            jmp .if_end

        .zero_case:
            test r9, r9
            je .continue

            mov cl, '0'

        .if_end:


        push rdx

        gputchar cl
    
        pop rdx

        .continue:

        shl rdx, 0x4
        jmp .loop
        .loop_end:

    pop r9
    pop r10
    pop rcx
    jmp continue

print_percent:
    gputchar '%'
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

jtable:
    dq print_percent
    times (8 * ('b' - '%' - 1)) db 0xff
        dq print_bin
        dq print_char
        dq print_dec
    times (8 * ('o' - 'd' - 1)) db 0xff
        dq print_oct
    times (8 * ('s' - 'o' - 1)) db 0xff
        dq print_string
    times (8 * ('x' - 's' - 1)) db 0xff
        dq print_hex

buf:
    times IO_BUF_SIZE db 0x0 
buf_end:
balance:
    dq IO_BUF_SIZE

dec_buf:
    times UINT64_MAX_LEN db 0x0

hex_table:
    db "0123456789abcdef"



text:
db "Hell "
text_end:
text_2:
db "is with you, motherfucker!"
text_2_end:


