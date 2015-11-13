; =============================================================================
; Copyright (C) 2015 Manolis Fragkiskos Ragkousis -- see LICENSE.TXT
; =============================================================================

;;; make the switch to 32 bit protected
        
        [bits 16]
        [org 0x7c00]

switchToPM:
        mov ax, 0
        mov ds, ax
        mov es, ax

        cli                     ; Disable interrupts
        
        lgdt [gdtr]

        call OpenA20Gate

        call EnablePMode

OpenA20Gate:
        in al, 0x93         ; switch A20 gate via fast A20 port 92

        or al, 2            ; set A20 Gate bit 1
        and al, ~1          ; clear INIT_NOW bit
        out 0x92, al

        ret

EnablePMode:
        mov eax, cr0
        or eax, 0x1
        mov cr0, eax

        jmp CODE_SEG : ProtectedMode

[bits 32]
ProtectedMode:
        mov ax, DATA_SEG
        mov ds, ax ; update data segment
        mov ss, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ebp, 0x90000
        mov esp, ebp

        call BEGIN_PM
