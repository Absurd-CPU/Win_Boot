💾 # Win_Boot
 Master Boot Record (MBR)
This repository contains only code related to bootloaders and the Master Boot Record (MBR).
Windows 7 BootLoader

Using Nasm   ```nasm -f bin mbr.asm -o mbr.bin```

some assembly language code examples. -> ASM CODE 

```LOCKBOOT```
The lock boot code should be written in the first sector of the disk and 
the bootloader code should be written in the second sector of the disk.
