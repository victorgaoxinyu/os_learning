; Infinite loop (e9 fd ff)
loop:
    jmp loop

times 510-($-$$) db 0
dw 0xaa55

; E9: opcode for a near jump (jmp)
