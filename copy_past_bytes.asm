org 0x100


mov si, source_address
mov di, target_address
mov cx, bytes_count

rep movsb 

int 0x21

source_address equ 0x000
target_address equ 0x200
bytes_count    equ 20