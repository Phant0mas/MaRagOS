; =============================================================================
; Copyright (C) 2015 Manolis Fragkiskos Ragkousis -- see LICENSE.TXT
; =============================================================================

;;; load DH sectors to ES:BX from drive DL
;;; expects number of sectors to be read in dh

disk_load:
        pusha
        
        push dx                 ; Store DX so later we can recall.
        mov ah, 0x02            ; BIOS read sector function.
        mov al, dh              ; Read dh sectors
        mov ch, 0x00            ; Select cylinder 0.
        mov dh, 0x00            ; Select head 0.
        mov cl, 0x02            ; Start reading from second sector.
                                ; (The first being the boot sector.)
        int 0x13                ; Interrupt.

        jc disk_error           ; Jump if error (CF set)

        pop dx                  ; Restore DX.
        cmp dh, al              ; AL (sectors read) != DH (sectors expected)
        jne disk_error          ; guess what

        popa
        ret
        
disk_error:     
        mov bx, DISK_ERROR_MSG
        call print_string
        jmp $

        %ifndef PRINT_STRING
        %include "../print/print_string.asm"
        %endif
        %ifndef PRINT_HEX
        %include "../hex/print_hex.asm"
        %endif

DISK_ERROR_MSG:
        db 'Disk read error!', 0
