org 0x100
start:
  mov bx, string1
  call print
  mov bx, string2
  call print
finish:
  mov ax, 0x4c00
  int 0x21
string1:
  db "Hello World!", 0x0a, 0x0
string2:
  db "Go to hell!", 0x0a, 0x0
print:
  mov dx, bx
  .loop:
    mov cl, [bx]
    cmp cl, 0x0
    jz .loopend
    inc bx
    jmp .loop
    .loopend:
  
  mov cl, '$'
  mov [bx], cl
  
  mov ah, 0x09
  int 0x21
  
  mov cl, 0x0
  mov [bx], cl
  
  ret
