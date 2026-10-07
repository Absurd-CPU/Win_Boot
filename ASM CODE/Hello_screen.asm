org 100h

jmp START

MSG  db "Hello","$"
TEXT db "FROM world", 0


START:

;-------------------------
; Text mode 80x25
;-------------------------

mov ah, 00h
mov al, 03h
int 10h


;-------------------------
; Clear screen
; Red background
;-------------------------

mov ax, 0600h
mov bh, 40h
mov cx, 0000h
mov dx, 184Fh
int 10h


;-------------------------
; Print MSG
;-------------------------

mov ah, 09h
lea dx, MSG
int 21h


;-------------------------
; Print TEXT
;-------------------------

lea si, TEXT
call Print

ret


;================================
; Print TEXT
; White text
; Red background
;================================

Print:

lodsb

cmp al, 0
jz .done

mov ah, 0Eh
mov bh, 00h
mov bl, 4Fh
int 10h

jmp Print

.done:
ret
