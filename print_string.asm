org 0x100

start:
	mov bx, string

repeat:
	mov al, [bx]
	test al, al ; проверка на ноль
	je end
	
	push bx
	mov ah, 0x0e
	mov bx, 0x00f ; bh - номер страницы, bl - цвет
	int 0x10
	pop bx

	inc bx
	jmp repeat

end:
	int 0x20

string: 
	db "Hello, world", 0