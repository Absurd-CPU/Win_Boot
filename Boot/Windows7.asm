; ============================================================
; 512-BYTE MBR RECONSTRUCTION  Sektor 0 
; NASM:
; nasm -f bin mbr.asm -o mbr.bin
; Layout:
; 7C00 - 7D62 : executable code
; 7D63 - 7DB4 : error strings + padding
; 7DB5 - 7DB7 : message selector bytes
; 7DB8 - 7DBD : disk signature / reserved
; 7DBE - 7DFD : partition table
; 7DFE - 7DFF : 55 AA
; ============================================================

BITS 16
ORG 0x7C00  ; Address LOadin At 0x7C00
; ------------------------------------------------------------
; 0x7C00 - 0x7D62
; ------------------------------------------------------------

xor ax,ax
mov ss,ax
mov sp,7C00
mov es,ax
mov ds,ax
mov si,7C00
mov di,0600
mov cx,0200
cld
rep movsb
push ax
push 061C
retf

sti
mov cx,4
mov bp,07BE

find_active:
cmp byte [bp],00
jl 7C34
jne 7D3B
add bp,10
loop 7C23
int 0x18


boot_partition:
mov [bp],dl
push bp
mov byte [bp+11],05
mov byte [bp+10],00
mov ah,41
mov bx,55AA
int 0x13
pop bp
jb 7C59
cmp bx,AA55
jne 7C59
test cx,0001
je 7C59
inc byte [bp+10]


read_sector:
pushad
cmp byte [bp+10],00
je 7C87

push dword 00000000
push dword [bp+08]
push word 0000
push word 7C00
push word 0001
push word 0010
mov ah,42
mov dl,[bp]
mov si,sp
int 0x13
lahf
add sp,10
sahf
jmp 7C9B


chs_read:

mov ax,0201
mov bx,7C00
mov dl,[bp]
mov dh,[bp+01]
mov cl,[bp+02]
mov ch,[bp+03]
int 0x13


read_done:
popad
jae 7CBB
dec byte [bp+11]
jne 7CB0
cmp byte [bp],80
je 7D36
mov dl,80
jmp 7C34


retry_read:
push bp
xor ah,ah
mov dl,[bp]
int 0x13
pop bp
jmp 7C59


read_ok:
cmp word [7DFE],AA55
jne 7D31
push word [bp]
call 7D56
jne 7CE2

cli
mov al,D1
out 0x64,al
call 7D56
mov al,DF
out 0x60,al
call 7D56
mov al,FF
out 0x64,al
call 7D56
sti

mov ax,BB00
int 1A
and eax,eax
jne 7D27
cmp ebx,41504354
jne 7D27
cmp cx,0102
jb 7D27

push dword 0000BB07
push dword 00000200
push dword 00000008
push ebx
push ebx
push ebp
push dword 00000000
push dword 00007C00
popad
push word 0000
pop es
int 1A


continue_boot:
pop dx
xor dh,dh
jmp 0000:7C00
int 0x18


invalid_table:
mov al,[07B7]
jmp 7D3E


no_os:
mov al,[07B6]
jmp 7D3E


error_no_os:
mov al,[07B5]


print_error:
xor ah,ah
add ax,0700
mov si,ax


print_loop:
lodsb
cmp al,00
je 7D53
mov bx,0007
mov ah,0E
int 0x10
jmp 7D45


halt:

hlt
jmp 7D53


wait_kbd:

sub cx,cx
in al,0x64
jmp 7D5C
and al,02
loopne 7D58
and al,02
ret

; ------------------------------------------------------------
; 0x7D63 - 0x7DB4
; ------------------------------------------------------------

db "Invalid partition table", 0
db "Error loading operating system", 0
db "Missing operating system", 0
db 0x00, 0x00

; ------------------------------------------------------------
; 0x7DB5 - 0x7DB7
; Message selector bytes
; ------------------------------------------------------------

db 0x63
db 0x7B
db 0x9A

; ------------------------------------------------------------
; 0x7DB8 - 0x7DBD
; Disk signature + reserved
; ------------------------------------------------------------

db 0xD6, 0x89, 0xD5, 0x18
db 0x00, 0x00

; ------------------------------------------------------------
; 0x7DBE - 0x7DFD
; Partition Table
; ------------------------------------------------------------

db 0x80, 0x20, 0x21, 0x00
db 0x07, 0xDD, 0x1E, 0x3F
db 0x00, 0x08, 0x00, 0x00
db 0x00, 0xA0, 0x0F, 0x00
db 0x00, 0xDD, 0x1F, 0x3F
db 0x07, 0xFE, 0xFF, 0xFF
db 0x00, 0xA8, 0x0F, 0x00
db 0x00, 0x50, 0x70, 0x07
times 16 db 0x00
times 16 db 0x00

-----------------------------------------------------------
db 0x55, 0xAA
; ------------------------------------------------------------
; Verify final size
; ------------------------------------------------------------

%if ($ - $$) != 512
%error "ERROR: output is not 512 bytes"
%endif
