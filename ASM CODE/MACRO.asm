.MODEL SMALL
.STACK 100h

.DATA

Message  db "Hello STAR WARS ",0
Message2 db " Welcom Loard Vader",0


DOOM MACRO
    LOCAL PRINT, DONE1

PRINT:
    lodsb
    or al,al
    jz DONE1
    mov ah,0Eh
    int 10h
    jmp PRINT

DONE1:
    nop

ENDM


.CODE
strat PROC
    mov ax,@data
    mov ds,ax
    mov ah,00h
    mov al,03h
    int 10h                            
    mov ax,0600h
    mov bh,70h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    
    mov si,offset Message
    DOOM

    mov ax,0600h
    mov bh,80h
    mov cx,0000h
    mov dx,184Fh
    int 10h

    mov si,offset Message2
    DOOM

    mov ax,4C00h
    int 21h

strat ENDP

END strat
