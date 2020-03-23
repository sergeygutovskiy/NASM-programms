org 0x100

mov ax, 123

display_number:
	mov dx, 0
	mov cx, 10 
	div cx ; AX = DX:AX / CX
	push dx
	cmp al, 0
	je display_number_1
	call display_number

display_number_1:
	pop ax
	add al, '0' ; convert to ASCII
	call display_letter
	ret

ret 0x20

display_letter: ; в al должен быть символ для вывода
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 0x0e
	mov bx, 0x00f
	int 0x10

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	ret 