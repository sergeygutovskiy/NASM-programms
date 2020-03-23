org 0x100

in al, (0x40) ; timer counter
and al, 0x07 ; наложить маску, значения станут 0~7
add al, 0x30 ; чтобы вывести вимвол, как ASCII
mov cl, al

game_loop:
	mov al, '?'
	call display_letter
	call read_keyboard

	cmp al, cl
	jne game_loop

	call display_letter

	mov al, ':'
	call display_letter

	mov al, ')'
	call display_letter


int 0x20

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

read_keyboard:
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 0x00
	int 0x16

	pop di
	pop si
	pop dx
	pop cx
	pop bx

	ret
