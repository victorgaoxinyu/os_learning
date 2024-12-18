[bits 32]  ; 32-bit protected mode

VIDEO_MEMORY equ 0xb8000
WHILE_ON_BLACK equ 0x0f

print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY

print_string_pm_loop:
  mov al, [ebx]  ; [ebx] is the address of our char
  mov ah, WHILE_ON_BLACK

  cmp al, 0 ; check if End of String
  je print_string_pm_done

  mov [edx], ax
  add ebx, 1
  add edx, 2

  jmp print_string_pm_loop


print_string_pm_done:
  popa
  ret