mov ah, 0x0e

mov bp, 0x8000
mov sp, bp

push 'A'
push 'B'
push 'C'

mov al, [0x7ffe] ; 0x8000 - 2
int 0x10

mov al, [0x8000 - 4]
int 0x10

mov al, [0x8000 - 6]
int 0x10

mov al, [0x8000]
int 0x10

pop bx
mov al, bl
int 0x10

mov al, [0x8000 - 2]
int 0x10

mov al, [0x8000 - 4]
int 0x10

mov al, [0x8000 - 6]
int 0x10

pop bx
mov al, bl
int 0x10 ; prints B

pop bx
mov al, bl
int 0x10 ; prints A

mov al, [0x8000]
int 0x10

jmp $
times 510-($-$$) db 0
dw 0xaa55

