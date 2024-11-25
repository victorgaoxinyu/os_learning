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