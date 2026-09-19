[org 0x1000]
bits 16

start:
    xor ax,ax
    mov ds, ax
    mov es, ax

    mov si, msg_kernel
    call print

    mov si, msg_HellO
    call print

    jmp $

print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10   ; interrupt
    jmp print
.done:
    ret

msg_kernel db "Success: Kernel Loaded at 0x1000!", 13, 10, 0
msg_HellO  db "Hello .........!", 13, 10, 0
times 2048-($-$$) db 0
