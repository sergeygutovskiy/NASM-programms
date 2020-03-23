org 0x100

start:
	mov ah, 0x00
	int 0x16 ; get key

	cmp al, 0x1b ; ESC key
	je exit

	mov ah, 0x0e
	mov bx, 0x00f
	int 0x10 ; print key

	jmp start

exit:
	int 0x20