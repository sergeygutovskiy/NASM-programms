; preudo-algorithm
;
; x = 0, y = 0
; while (iteration 	< 100 and x^2 + y^2 < 4)
;   t = x^2 - y^2 + ix
;   y = 2xy + iy
;   x = t
;	iteration += 1

; asm notes
;
; x, y are 32-bit integers with 8-bit fraction
; 1.0 is 0x00000100 (256 decimal)	
;
; 0x0100 * 0x0100 = 0x010000 (so need to devide by 256 (1.0))


cpu 8086
org 0x100

v_a  equ 0xfa00 ; y-coordinate
v_b  equ 0xfa02 ; x-coordinate
v_x  equ 0xfa04 ; x 32-bit for fraction
v_y  equ 0xfa08 ; y 32-bit for fraction
v_s1 equ 0xfa0c ; temp s1
v_s2 equ 0xfa10 ; temp s2 (48-bit)

start:
	mov ax, 0x13 ; vga 320*200*256 mode
	int 0x10 	 ;

	mov ax, 0xa000 ; setup video segment 
	mov ds, ax	   ;
	mov es, ax 	   ;


; 199 and 319 gets by formuls 
m4:
	mov ax, 199		
	mov [v_a], ax

m0: 
	mov ax, 319
	mov [v_b], ax


m1:
	xor ax, ax
	mov [v_x + 0], ax ; 
	mov [v_x + 2], ax ; x = 0.0

	mov [v_y + 0], ax ;
	mov [v_y + 2], ax ; y = 0.0

	mov cx, 0 		  ; iteration = 0


m2:
	push cx	; save iterator
	mov ax, [v_x + 0] ; get x and square it
	mov dx, [v_x + 2] ; 
	call square32     ;
	
	push dx ; save squared x
	push ax ; 

	mov ax, [v_y + 0] ; get y and square it
	mov dx, [v_y + 2] ;
	call square32     ;

	pop bx	   ; x^2 + y^2
	add ax, bx ;
	pop bx     ;
	add dx, bx ;

	pop cx ; restore iterator
	cmp dx, 0       ; result is >= 4.0 ?
	jne m3          ;
	cmp ax, 4 * 256 ;
	jnc m3          ;

	;
	; t = x^2 - y^2 + ix
	;

	push cx	; save iterator
	mov ax, [v_x + 0] ; get x and square it
	mov dx, [v_x + 2] ; 
	call square32     ;
	
	push dx ; save squared x
	push ax ; 

	mov ax, [v_y + 0] ; get y and square it
	mov dx, [v_y + 2] ;
	call square32     ;

	pop bx	   ; x^2 - y^2
	sub ax, bx ;
	pop bx     ;
	sub dx, bx ;

	add ax, [v_b]
	adc dx, 0
	add ax, [v_b]
	adc dx, 0
	
	sub ax, 480
	sbb dx, 0

	push ax
	push dx

	;
	; y = 2xy + iy
	;

	mov ax, [v_x + 0] ; get x
	mov dx, [v_x + 2] ;

	mov bx, [v_y + 0] ; get y
	mov cx, [v_y + 2] ;

	call square32

	shr ax, 1
	rcl dx, 1

	add ax, [v_a]
	adc dx, 0
	add ax, [v_a]
	adc dx, 0
	
	sub ax, 250
	sbb dx, 0	

	mov [v_y + 0], ax
	mov [v_y + 2], dx

	pop dx
	pop ax

	mov [v_x + 0], ax
	mov [v_x + 2], dx

	pop cx
	inc cx

	cmp cx, 100
	je m3
	jmp m2

m3:
	mov ax, [v_a]
	mov dx, 320
	mul dx
	add ax, [v_b]
	xchg ax, di

	add cl, 0x20
	mov [di], cl

	dec word[v_b]
	jns m1

	dec word[v_a]
	jns m0

	mov ah, 0
	int 0x16

	mov ax, 2
	int 0x10

	int 0x20


;
; square 32-bit number
; ax:dx = (ax:dx * ax:dx) / 256
;

square32:
	mov bx, ax
	mov cx, dx

mul32:
	xor dx, cx
	pushf
	xor dx, cx
	jns mul32_2

	not ax
	not dx
	add ax, 1
	adc dx, 0

mul32_2:
	test cx, cx
	jns mul32_3
	
	not bx
	not cx
	add bx, 1
	adc cx, 0

mul32_3:
	mov [v_s1 + 0], ax
	mov [v_s1 + 2], dx

	mul bx
	mov [v_s2 + 0], ax
	mov [v_s2 + 2], dx

	mov ax, [v_s1 + 2]
	mul cx
	mov [v_s2 + 4], ax

	mov ax, [v_s1 + 2]
	mul bx
	add [v_s2 + 2], ax 
	add [v_s2 + 4], bx

	mov ax, [v_s1]
	mul cx
	add [v_s2 + 2], ax 
	add [v_s2 + 4], bx

	mov ax, [v_s2 + 1]
	mov dx, [v_s2 + 3]

	popf
	jns mul32_1

	not ax
	not dx
	add ax, 1
	adc dx, 0

mul32_1:
	ret



