org 100h

start:

; -------------------------
    xor ax,ax
    mov ah, 00h
    int 16h
    cmp al, 'D'
    jne wrong

    mov ah, 0Eh
    int 10h
    call change
; -------------------------
    xor ax,ax
    mov ah, 00h
    int 16h

    cmp al, 'A'
    jne wrong

    mov ah, 0Eh
    int 10h    
    call change
; -------------------
    xor ax,ax
    mov ah, 00h
    int 16h

    cmp al, 'R'
    jne wrong

    mov ah, 0Eh
    int 10h  
    call change
; -------------------
    xor ax,ax
    mov ah, 00h
    int 16h

    cmp al, 'K'
    jne wrong

    mov ah, 0Eh
    int 10h
    call change
; -------------
    xor ax,ax
    mov ah, 00h
    int 16h

    cmp al, '6'
    jne wrong

    mov ah, 0Eh
    int 10h
   call change
; -------------------------
    xor ax,ax          
    mov ah, 00h
    int 16h
    cmp al, '6'
    jne wrong
    mov ah, 0Eh
    int 10h
   call change              
; -------------------------
correct:
    
    mov al, ' '
    mov ah, 0Eh
    int 10h
    
    mov al, 'O'
    mov ah, 0Eh
    int 10h
    mov al, 'K'
    mov ah, 0Eh
    int 10h

    jmp 1000h


; -------------------------
wrong:
       hlt            
; -------------------------

    change: 
    mov ax,0600h
    ADD bh,16h
    mov cx,0000h
    mov dx,184Fh
    int 10h     
   ret    
