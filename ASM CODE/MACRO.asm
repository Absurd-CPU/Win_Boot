org 100h

      
jmp strat 

Message db "Hello STAR WARS ",0
Message2 db " Welcom Loard Vader",0  
 
   
DOOM MACRO

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



DOOM2 MACRO
    
PRINT2:
    lodsb
    or al,al
    jz DONE2
    mov ah,0Eh
    int 10h
    jmp PRINT2

DONE2:
     nop

ENDM


strat: 
    mov ah, 00h
    mov al, 03h
    int 10h 
   
    mov ax,0600h
    mov bh,70h
    mov cx,0000h
    mov dx,184Fh
    int 10h     

    mov si, offset Message
    DOOM   
    
    
    mov ax,0600h
    mov bh,80h
    mov cx,0000h
    mov dx,184Fh
    int 10h 
    
    xor ax,ax
    mov si, offset Message2
   
    DOOM2  
     
    ret
