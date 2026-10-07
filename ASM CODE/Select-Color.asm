org 100h

jmp START

chose db ?
msg db "WRITE:$"

START:
 mov ah,00h
 mov al,03h
 int 10h

    mov ah,09h
    mov dx,offset msg
    int 21h

    mov ah,01h
    int 21h

    mov [chose],al

    cmp [chose],'1'
    je option1

    cmp [chose],'2'
    je option2

    cmp [chose],'3'
    je option3

    cmp [chose],'4'
    je option4

    cmp [chose],'5'
    je option5

    cmp [chose],'6'
    je option6


    jmp START


option1:
    mov ax,0600h
    mov bh,20h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    call EXIT


option2:
    mov ax,0600h
    mov bh,30h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    call EXIT


option3:
    mov ax,0600h
    mov bh,40h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    call EXIT


option4:
    mov ax,0600h
    mov bh,50h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    call EXIT


option5:
    mov ax,0600h
    mov bh,60h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    call EXIT


option6:
    mov ax,0600h
    mov bh,70h
    mov cx,0000h
    mov dx,184Fh
    int 10h
    call EXIT

EXIT:
mov ax,4C00h
int 21h
