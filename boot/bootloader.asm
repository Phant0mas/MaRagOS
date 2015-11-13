; =============================================================================
; Copyright (C) 2015 Manolis Fragkiskos Ragkousis -- see LICENSE.TXT
; =============================================================================
;;; The kernel bootloader.
[org 0x7c00]
[bits 16]

        jmp 0x0000:start
        
KERNEL_OFFSET equ 0x1000

start:
        xor ax, ax
	mov ds, ax
	mov es, ax

        cli
        mov bp, 0x9000
        mov sp, bp
        mov ss, ax
        sti
        
        mov [BOOT_DRIVE], dl
        
        mov bx, MSG_REAL_MODE
        call print_string

        call load_kernel

        call switchToPM

        jmp $

%include "pm/gdt.asm"
%include "pm/switch_to_pm.asm"

%include "disk/disk_load.asm"

%include "print/print_string.asm"
%include "print/print_string_32bit.asm"

;; %include "hex/print_hex.asm"   ; For debugging purposes.

[bits 16]
load_kernel:
        mov bx, MSG_LOAD_KERNEL
        call print_string

        mov bx, KERNEL_OFFSET
        mov dh, 1
        mov dl, [BOOT_DRIVE]
        call disk_load

        ret

[bits 32]
BEGIN_PM:
        mov ebx, MSG_PROT_MODE
        call print_string_pm

        call KERNEL_OFFSET

.halt:
        hlt
        jmp .halt


BOOT_DRIVE:
        db 0
MSG_REAL_MODE:
        db "Started in 16-bit Real Mode",0
MSG_PROT_MODE:
        db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL:
        db "Loading kernel", 0

;;; Padding and magic BIOS number
        
        times 510-($-$$) db 0
        dw 0xaa55
