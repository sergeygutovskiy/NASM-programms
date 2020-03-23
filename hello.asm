org 0x0100

mov ax, 0x002
int 0x10

mov ax, 0xb800
mov ds, ax
mov es, ax
cld	; clear "direction" flag

xor di, di

mov ax, 0x1a48 ; 'h', color (ah) + letter (al)
stosw		   ; AX to ES:DI and DI += 2

mov ax, 0x1b45; 'e'
stosw

mov ax, 0x1c4c; 'l'
stosw

mov ax, 0x1d4c; 'l'
stosw

mov ax, 0x1e4f; '0'
stosw

int 0x20