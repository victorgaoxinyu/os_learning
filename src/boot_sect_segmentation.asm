mov ah, 0x0e ; tty

mov al, [the_secret]
int 0x10;

mov bx, 0x7c0
mov ds, bx
; WARNING: from now on all memory references will be offset by 'ds' implicitly
mov al, [the_secret]
int 0x10

mov al, [es:the_secret]
int 0x10

mov ax, es
call print_hex ; es is 0x0080

call print_nl

mov bx, 0x7c0
mov es, bx
mov al, [es:the_secret]
int 0x10

call print_nl

mov ax, es
call print_hex

call print_nl

jmp $

%include "boot_sect_print.asm"
%include "boot_sect_print_hex.asm"

the_secret:
  db "X"

times 510 - ($-$$) db 0
dw 0xaa55
