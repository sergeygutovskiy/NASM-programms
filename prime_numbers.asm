org 0x100

table: 		equ 0x8000
table_size: equ 1000

start:
	mov bx, table
	mov cx, table_size
	mov al, 0 

p1:
	mov [bx], al
	inc bx
	loop p1

mov ax, 2

p2:
	mov bx, table
	add bx, ax
	cmp byte [bx], 0
	jne p3

	push ax
	call display_number
	mov al, ','
	call display_letter 
	; mov al, 0x0d
	; call display_letter 
	; mov al, 0x0a
	; call display_letter 
	pop ax

	mov bx, table
	add bx, ax

p4:
	add bx, ax
	cmp bx, table + table_size
	jnc p3
	mov byte [bx], 1
	jmp p4

p3:
	inc ax
	cmp ax, table_size
	jne p2


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