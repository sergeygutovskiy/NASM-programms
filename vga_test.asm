; cpu 8086
org 0x100

v_a equ 0xfa00 ; 0x200 also works
v_b equ 0xfa02

start:
	mov ax, 0x13 ; 320*200*256 video mode
	int 0x10     ; 

	mov ax, 0xa000 ; video segment
	mov ds, ax	  ;
	mov es, ax	  ;

m4:
	mov ax, 127		; as row
	mov [v_a], ax	;

m0:
	mov ax, 127		; as col
	mov [v_b], ax	;

m1:
	mov ax, [v_a]	; byte pos: y * 320 (screen width) + x
	mov dx, 320		;
	mul dx			;
	add ax, [v_b]	;

	xchg ax, di		; swap ax (byte pos) with di

	mov ax, [v_a]
	and ax, 0x78 ; 0000000001111000 (: 8)
	add ax, ax	 ; pallete index with step by 16

	mov bx, [v_b]
	and bx, 0x78 ; 0000000001111000 (: 8)
	
	mov cl, 3	 ; : 8
	shr bx, cl  ;

	add ax, bx
	stosb

	dec word [v_b]
	jns m1

	dec word [v_a]
	jns m0

	mov ah, 0
	int 0x16

	mov ax, 0x2
	int 0x10

	int 0x20
