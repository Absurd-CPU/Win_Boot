org 100h 


JMP START

START:
mov ah, 00h
mov al, 03h
int 10h  
                
xor ax,ax                         
mov ah,06h
mov bh,40h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,20h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,30h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,40h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,50h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,60h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,70h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,80h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,90h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,0A0h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,0B0h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,0C0h
mov cx,000h
mov dx,184Fh
int 10h

mov bh,0D0h
mov cx,000h
mov dx,184Fh  
int 10h      

call START
ret
