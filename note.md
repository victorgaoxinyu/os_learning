### Endianness
For multi-byte data 0xa01183d1
- Big Endian
  - put MSB first
  - mem block: [a0][11][83][d1]
  
- Little Endian
  - Put LSB first
  - mem block: [d1][83][11][a0]

Note:
- Endianess is about BYTE ordering not BIT ordering
- Endianess only applies to Multi-byte values

### Bootsector print
```asm
mov ah, 0x0E ; this interrupt and function allow direct writing of chars to the screen in tty mode.
```
TTY mode:
- teletypewrite mode, text-based input and output on terminals.

register
- AX: the full 16-bit accumulator register
  - AH: high 8 bits
  - AL: low 8 bits


### Bootsector memory
check `src/boot_sect_memory.asm`, 4 diff ways to try to print `the_secret`

```asm
the_secret:
  db "X"  ; hex for "X" in ascii is 58

mov al, the_secret   ; this prints the memory address/pointer

mov al, [the_secret] ; this tries to print the content stored at the memory address, but wont work as BIOS place bootsector binary at 0x7c00

mov bx, the_secret
add bx, 0x7c00
mov al, [bx]         ; use bx register to help cal the actual memory address after offset

mov al, [0x7c2d]     ; manual calcualte the actual memory address of the_secret and get content.
```

Note:
- in the original src code, `0x7c2d` is used for memory address of `the_secret`, this is because it declare ****`the_secret`**** after all 4 tries. use xxd to view the binary.

```
8:00:27 victor@victor-MacBookPro 03-bootsector-memory ±|master|→ xxd boot_sect_memory.bin
00000000: b40e b031 cd10 b02d cd10 b032 cd10 a02d  ...1...-...2...-
00000010: 00cd 10b0 33cd 10bb 2d00 81c3 007c 8a07  ....3...-....|..
00000020: cd10 b034 cd10 a02d 7ccd 10eb fe58 0000  ...4...-|....X..  // X is at location 0x2d, 45.
00000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................  // all 0 paddings we add with the times 510-($-$$) db 0
00000040: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000050: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000060: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000070: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000080: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000090: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000a0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000000f0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000100: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000110: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000120: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000130: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000140: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000150: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000160: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000170: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000180: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000190: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001a0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.  // magic bios number
```
but in my own implementation, `the_secret` is declared at the top. hence `[0x7c00]` should be used.
```
08:00:37 victor@victor-MacBookPro 03-bootsector-memory ±|master|→ xxd ~/Documents/dev/os_learning/src/bin/boot_sect_memory.bin 
00000000: 58b4 0eb0 31cd 10b0 00cd 10b0 32cd 10a0  X...1.......2...  // X is at the beginning.
00000010: 0000 cd10 b033 cd10 bb00 0081 c300 7c8a  .....3........|.
00000020: 07cd 10b0 34cd 10a0 007c cd10 ebfe 0000  ....4....|......
```

#### Global offset
```asm
[org 0x7c00]
```
org stands for origin, this tells the assembler the all addresses in the code should be calculated asif code starts at `0x7c00`


### Bootsector stack
```asm
mov bp, 0x8000
mov sp, bp

push 'A'
push 'B'
push 'C'
```
```
...
0x7ffa  | C |
0x7ffc  | B |
0x7ffe  | A |
0x8000  |   | <- sp, bp

```

### Bootsector Strings and Functions
#### Strings
```asm
mystring:
  db 'Hello, World', 0
```
- terminate with null-byte
- surrounded with quotes -> convert to ASCII

#### Control
cmp
- Compare
- `cmp operand1, operand2`
- Updates the flags
  - ZF: Zero Flag, if result is zero
  - SF: Sign Flag, if result is negative
  - CF: Carry Flag, if there's an unsigned underflow

je
- Jump if Equal
- `je label`

```asm
cmp ax, bx
je match
; Code here runs if not equal
```

jmp
- Unconditional Jump
- `jmp label`
- Program flow jumps to label immediately

Exmaple
```asm
cmp ax, 4      ; if ax = 4
je ax_is_four  ; do something (by jumping to that label)
jmp else       ; else, do another thing
jmp endif      ; finally, resume the normal flow

ax_is_four:
    .....
    jmp endif

else:
    .....
    jmp endif  ; not actually necessary but printed here for completeness

endif:
```
#### Functions
Paramter handling
- developer knows a specific register or memory address to lookup
- make func calls generic

Example:
```asm
mov al, 'X'
jmp print
endprint:

...

print:
    mov ah, 0x0e  ; tty code
    int 0x10      ; I assume that 'al' already has the character
    jmp endprint  ; this label is also pre-agreed
```
Improvements
- store the return address
  - CPU can help us, use `call` and `ret` instead of `jmp`s
- save the current registers to allow sub funcs to modify
  - `pusha` and `popa`, Push All and Pop All **general-purpose registers** onto the stack.

#### Include ext files
```asm
%include "file.asm"
```
#### Print Hex
```
; assume input is 0x1234 stored at dx

; 1. convert the last char of 'dx' to ascii
mov ax, dx
and ax, 0x000f   ; 0b0000000000001111 & 0b0001001000110100 -> 0b0000000000000100
                 ; 0x000f & 0x1234 -> 0x0004
                 ; mask first three
add al, 0x30     ; Numeric ASCII values for '0' is 0x30
                 ; add 0x30 to N (here 4) to convert it to ASCII "N"
com al, 0x39     ; if > 9, add extra 7 to represent 'A' to 'F'
jle step2        ; if < 9, goto step 2
add al, 7        ; 'A' in ASCII is 65 instead of 58, so add 7, 
                 ; Dec Hx Chr
                 ; 57  39   9
                 ; 58  3A   :
                 ; 65  41   A

; 2. get correct position for string to place ASCII char
; bx <- base address + string_length - index of current char
step 2:
  mov bx, HEX_OUT + 5  ; base + length
  sub bx, cx           ; base + length - index of current char, cx 0->1->2->3
                       ; --------------
                       ; 0x8000  | '0' | <- base address
                       ; 0x8001  | 'x' | 
                       ; 0x8002  | '1' | <- base address + 5 - 3
                       ; 0x8003  | '2' | <- base address + 5 - 2
                       ; 0x8004  | '3' | <- base address + 5 - 1
                       ; 0x8005  | '4' | <- base address + 5 - 0
                       ; 0x8006  |NULL |

  mov [bx], al         ; copy the ASCII char on 'al' to position pointed by 'bx'
  ror dx, 4            ; 0x1234 -> 0x4123 -> 0x3412 -> 0x2341 -> 0x1234

  ; increment index and loop
  add cx, 1
  jmp hex_loop

end:
  mov bx, HEX_OUT
  call print

  popa
  ret


HEX_OUT:
  db '0x0000', 0 ; reserve memory for new string
                       ; --------------
                       ; 0x8000  | '0' | <- base address
                       ; 0x8001  | 'x' | 
                       ; 0x8002  | '0' | <- base address + 5 - 3
                       ; 0x8003  | '0' | <- base address + 5 - 2
                       ; 0x8004  | '0' | <- base address + 5 - 1
                       ; 0x8005  | '0' | <- base address + 5 - 0
                       ; 0x8006  |NULL |


```

### Bootsector Segmentation
- Segmentation means specify an offset to all data
```
cs: Code Segmentation
ds: Data
ss: Stack
es: Extra
fs: General Purpose
gs: General Purpose
```
- Overlap segment and address to compute real address
`segment << 4 + address`
- cannot use `mov` directly, need to use a general purpose register


### Bootsector Disk
- OS wont fit inside the bootsector 512 bytes
- Need to reaad data from disk to run the kernel

carry bit
- extra bit present on each register which stores when an operation has overflowed its current capacity

```asm
mov ax, 0xFFFF
add ax, 1  ; ax = 0x0000 and carry = 1
```

#### int 0x13 functions
- `INT 0x13` interrupt is a BIOS interrupt for low-level disk services.
- set the `AH` register to a function number **before** invoking the interrupt.

```
0x00	Reset the disk system.
0x01	Retrieve the disk status after an operation.
0x02	Read sectors from the disk.
0x03	Write sectors to the disk.
0x04	Verify sectors (check for read errors).
0x05	Format a track on a floppy disk.
0x08	Retrieve disk parameters (e.g., number of sectors, heads, and cylinders).
0x0C	Seek to a specific track.
0x41	Check for the presence of enhanced disk services (EDDS).
0x42	Extended read sectors (supports 32-bit addressing for large disks).
0x43	Extended write sectors (supports 32-bit addressing for large disks).
0x44	Verify sectors using extended disk services.
0x48	Get drive parameters (geometry and capabilities) using extended disk services.
```

### 32-bit protected mode
New string print routine!
- no BIOS interrupts
- play with VGA video memory which starts at 0xb8000
- access specific char on 80x25 grid
  - `0xb8000 + 2 * (row * 80 + col)

### Enter 32-bit protected mode
- Disable interrupts
- Load GDT
- Set a bit on the CPU control register cr0
- Flush CPU pipeline by issuing a carefully crafted far jump
- Update all segment registers
- Update the stack
- Call to a well-known label which contains the first useful code in 32 bits
