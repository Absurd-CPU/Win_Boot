[org 0x7C00]
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov [BOOT_DRIVE], dl

    mov si, msg_boot
    call print

    mov ax, 0x0000    
    mov es, ax
    mov bx, 0x1000   
    mov ah, 0x02    
    mov al, 4        
    mov ch, 0       
    mov cl, 2        
    mov dh, 0       
    mov dl, [BOOT_DRIVE]
    int 0x13
    jc disk_error     

    jmp 0x0000:0x1000

disk_error:
    mov si, msg_disk
    call print
    jmp $

print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print
.done:
    ret

BOOT_DRIVE db 0
msg_boot db "Booting MiniOS...", 13, 10, 0
msg_disk db "Disk Error!", 13, 10, 0

times 510-($-$$) db 0
dw 0xAA55
