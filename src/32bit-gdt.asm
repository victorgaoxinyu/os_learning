gdt_start:  ; labels are needed to compute sizes and jumps
            ; GDT starts
  dd 0x0    ; 4 byte
  dd 0x0    ; 4 byte

; GDT for code segment.
; base = 0x00000000
; length = 0xfffff
; flags: code segment, present, kernel mode, 4KB granularity, 32-bit segment

gdt_code:
  dw 0xffff    ; segment length, bits 0-15
  dw 0x0       ; segment base  , bits 0-15
  db 0x0       ; segment base  , bits 16-23
  db 10011010b ; flags (8 bits)
  db 11001111b ; flags (4 bits) + segment length, bits 16-19
  db 0x0       ; segment base, bits 24-31

; GDT for data segment. 
; base = 0x00000000
; length = 0xfffff
; flags: data segment, present, read/write, 4KB, 32-bit

gdt_data:
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; size (16-bit), always one less of its true size
  dd gdt_start               ; address (32 bit)

; constants
CODE_SEG equ gdt_code - gdt_start
DATA_SET equ gdt_data - gdt_start
