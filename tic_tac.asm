org 0x0100

board: equ 0x0300

start:
	mov bx, board
	mov cx, 9
	mov al, '1'

b09:
	mov [bx], al
	inc al
	inc bx
	loop b09


b10:					; game loop
	call get_movement
	mov byte[bx], 'X'

	call show_board
	call find_line

	call get_movement
	mov byte[bx], 'O'

	call show_board
	call find_line

	jmp b10

get_movement:
	call read_keyboard
	cmp al, 0x1b
	je do_exit

	sub al, 0x31	; ASCII 1-9 from 0x31 to 0x39
	jc get_movement

	cmp al, 0x09
	jnc get_movement

	cbw

	; AL = 9Bh = -101
    ; cbw -> AX = FF9Bh = -101

	mov bx, board
	add bx, ax
	mov al, [bx]

	cmp al, 'O' ; no 'X' or 'O'
	jnc get_movement

	call show_clif	
	ret

do_exit:
	int 0x20

show_board:
	mov bx, board + 0
	call show_row
	call show_div

	mov bx, board + 3
	call show_row
	call show_div

	mov bx, board + 6
	jmp show_row


show_row:
	call show_square
	mov al, '|'
	call display_letter

	call show_square
	mov al, '|'
	call display_letter

	call show_square

show_clif:
	mov al, 0x0d  		; курсор на начало страницы
	call display_letter 
	mov al, 0x0a		; перенос на следущую строку
	jmp display_letter

show_div:
	mov al, '-'
	call display_letter
	mov al, '+'
	call display_letter

	mov al, '-'
	call display_letter
	mov al, '+'
	call display_letter

	mov al, '-'
	call display_letter

	jmp show_clif

show_square:
	mov al, [bx]
	inc bx
	jmp display_letter


find_line:
	; first hor line
	mov al, [board + 0]
	cmp al, [board + 1]
	jne b01

	cmp al, [board + 2]
	je win

b01:
	; leftmost ver line
	cmp al, [board + 3]
	jne b04

	cmp al, [board + 6]
	je win

b04:
	; first diagonal
	cmp al, [board + 4]
	jne b05

	cmp al, [board + 8]
	je win

b05:
	; second hor line
	mov al, [board + 3]
	cmp al, [board + 4]
	jne b02

	cmp al, [board + 5]
	je win

b02:
	; third hor line
	mov al, [board + 6]
	cmp al, [board + 7]
	jne b03

	cmp al, [board + 8]
	je win

b03:
	; mid ver line
	mov al, [board + 1]
	cmp al, [board + 4]
	jne b06

	cmp al, [board + 7]
	je win

b06:
	; rightmost ver line
	mov al, [board + 2]
	cmp al, [board + 5]
	jne b07

	cmp al, [board + 8]
	je win

b07: 
	; second diagonal
	cmp al, [board + 4]
	jne b08

	cmp al, [board + 6]
	je win

b08:
	ret

win:
	call display_letter

	mov al, ' '
	call display_letter

	mov al, 'w'
	call display_letter

	mov al, 'o'
	call display_letter


	mov al, 'n'
	call display_letter

	mov al, '!'
	call display_letter

	int 0x20


; liblary

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