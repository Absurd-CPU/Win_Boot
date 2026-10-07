💾 # Win_Boot
 Master Boot Record (MBR)
This repository contains only code related to bootloaders and the Master Boot Record (MBR).
Windows 7 BootLoader

Using Nasm   ```nasm -f bin mbr.asm -o mbr.bin```

some assembly language code examples. -> ASM CODE 

```LOCKBOOT```
The lock boot code should be written in the first sector of the disk and 
the bootloader code should be written in the second sector of the disk.

     <img width="706" height="257" alt="image" src="https://github.com/user-attachments/assets/7d3410e1-8694-4662-9c09-7cb550dda065" />


The boot process on MBR-based systems is handled by the BIOS. In the first stage of this process, known as POST, diagnostic checks and error
detection are performed. The BIOS produces beep sounds for errors to identify and report any faults in the initial boot process or hardware
components

    <img width="1181" height="749" alt="image" src="https://github.com/user-attachments/assets/92fb18c5-3e3e-4a9f-bf4c-2fad92dd8bf4" />


The BIOS stores certain hard-coded addresses, the most important of which is 0x7C00. When the CPU is ready, its first request to retrieve an
instruction is directed to the BIOS. The BIOS provides this address to the CPU. Keep in mind that the CPU generally performs four operations: it fetches
an instruction, decodes it, executes it, and then stores the result.

    <img width="846" height="427" alt="image" src="https://github.com/user-attachments/assets/1a7fc218-a77b-4ea1-be48-0a1e2bc94c28" />

The first address is therefore 0x7C00. This is a physical address within RAM. It is a 16-bit address in Real Mode. In this mode, direct communication
with the BIOS is possible through interrupts (INTs), and the code executed at this stage is 16-bit code.


     <img width="604" height="436" alt="image" src="https://github.com/user-attachments/assets/01cacb6d-35bb-4f65-a766-3da261384821" />

The address space is limited to 1 MB of RAM. Early operating systems, such as MS-DOS, ran in 16-bit mode, or Real Mode.

       <img width="1201" height="645" alt="image" src="https://github.com/user-attachments/assets/45ca1265-bad8-44a7-8c41-d0e0e8f1d3c3" />

To execute code, data must be loaded into RAM. Since RAM is volatile, the data is stored on disk and then loaded into RAM. However, this data is
located in an important area of the disk. Here, “data” refers to the bootloader code, which is one of the earliest and most important components of the
boot process. It is located at Sector 0, Cylinder 0, and Disk 0—in other words, the first sector. Note that each sector contains 512 bytes.

The initial executable boot code is 512 bytes long. This does not mean that booting is a single-stage process; a bootloader can have multiple stages.
The initial code is placed at address 0x7C00 so that, once loaded into RAM, it can be read and executed by the CPU. The IP register is set to 0x7C00.
This code then identifies the number of active partitions, after which the bootloader executes the filesystem’s VBR.
The MBR identifies active partitions. The operating system’s bootloader then runs, and the process continues with loading the kernel and starting the
operating system. When using MBR, the maximum addressable disk space is 2 TB. The MBR executes the boot code and supports up to four partitions


           <img width="1005" height="322" alt="image" src="https://github.com/user-attachments/assets/a73e7996-946e-49c5-b58f-03fa94fd8b7c" />


At the end of the boot code in the first sector, there is a two-byte signature, 0x55AA. Of the sector’s contents, 440 bytes contain the initial boot code, 4
bytes contain the disk signature, 64 bytes contain the partition table, and 2 bytes contain the MBR signature. The total is 512 bytes. Any remaining
space must be filled with zeros. In assembly language, the TIMES directive is used to fill this space with zeros.
MBR-based systems do not have a defensive mechanism against bootkits. For example, on Windows, CreateFileA can be used to overwrite the initial
512 bytes in the first sector of the disk. This requires only local administrator privileges to access the disk.
Four bytes constitute the bootable flag, with a value of 0x80. Offset 0x04 represents the partition filesystem. LBA stands for Logical Block Addressing,
and offsets 0x0C through 0x0F represent the number of addressable sectors in the partition.



Bootloader  Code Review


        <img width="220" height="109" alt="image" src="https://github.com/user-attachments/assets/fd360d3f-908e-43f3-9697-fde838435a67" />


This directive tells the NASM assembler that the code is in 16-bit mode. The org directive specifies that the code will execute at address 0x7C00. This
address is placed in the IP register.
      
      <img width="454" height="248" alt="image" src="https://github.com/user-attachments/assets/96a6bcfe-4770-4def-a941-c04d2111d308" />


We then execute the instructions under a label, which can have any name. First, we need to disable all CPU interrupts. Here, we define a label named
start, then use the cli instruction to stop all interrupts or other CPU activities so that our instructions can execute. The CLI instruction clears the IF flag
in the FLAGS register, disabling hardware interrupts.
Next, we set all the main registers to zero. We use xor to reduce the number of clock cycles. Since SS = 0, the stack begins at physical address 0x7C00
and grows toward lower addresses as it is used. The CLD instruction clears the direction flag (DF). As a result, string instructions such as LODSB and
MOVSB increment the address during normal operation.To re-enable interrupts, sti sets the IF flag to 1, allowing hardware interrupts again.

    <img width="435" height="481" alt="image" src="https://github.com/user-attachments/assets/8c1a473c-c8cd-4a58-bb00-98b4587a225e" />

This section of code continues the first-stage bootloader. It first saves the boot drive number, displays a message, reads four sectors from the disk,
and, if successful, transfers execution to the second stage.
                                                      mov [BOOT_DRIVE], dl

This instruction stores the value of the DL register in the memory variable BOOT_DRIVE. During BIOS boot, DL typically holds the boot drive number—
for example, 0x80 for the first BIOS hard disk.
db 0 defines and initializes the variable, while mov [BOOT_DRIVE], dl stores the actual boot drive number in it. Since the system may have booted from
another drive, we save the value provided by the BIOS rather than guessing the drive number.
The code then uses the print function to display the message:


    <img width="999" height="414" alt="image" src="https://github.com/user-attachments/assets/779e2a3d-55cb-479c-a32b-16dd7b29a3fc" />


Booting MiniOS...

Setting the load address

           <img width="489" height="353" alt="image" src="https://github.com/user-attachments/assets/c581dc95-d631-47ec-833f-5cb6ed175499" />



These instructions set AX to zero, set ES to zero, and set the destination offset to 0x1000.The BIOS uses the ES:BX combination to write the data read
from the disk:
Physical address=ES×16+BX\text{Physical address} = ES \times 16 + BX Physical address=ES×16+BX


Therefore, the destination address is 0x100. Here, AH specifies which BIOS service to execute. In the traditional INT 13h service, the value 0x02
means reading disk sectors.AL specifies the number of sectors to read:
4×512=2048 bytes4 \times 512 = 2048 \text{ bytes}4×512=2048 bytes
Thus, assuming 512-byte sectors, a total of 2 KB of data is requested.Setting the disk location

 <img width="398" height="114" alt="image" src="https://github.com/user-attachments/assets/99c0e8d3-7402-4901-821c-446b26b2d66a" />


We set the cylinder to zero using CH, the sector to 2 using CL, and the head to zero using DH. For example, if the saved drive number is 0x80, the read
operation is performed on that drive.Executing the read request int 0x13
At this point, the BIOS executes the request:
• Read four sectors from cylinder zero, head zero, starting at sector 2.
• Write the data into memory starting at address 0x1000. If the operation succeeds, execution proceeds to the next line.

     <img width="572" height="205" alt="image" src="https://github.com/user-attachments/assets/40311cb6-ed58-4d52-80d1-d6b7e70896ff" />


Finally, the remaining space up to byte 510 is filled with zeros, and the last two bytes are set to AA55.

