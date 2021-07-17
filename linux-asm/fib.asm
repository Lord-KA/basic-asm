section .text

global fib_asm


fib_asm:          ; input via rdi, returs rax                                                                                                                                 
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
