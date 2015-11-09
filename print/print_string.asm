; =============================================================================
; Copyright (C) 2015 Manolis Fragkiskos Ragkousis -- see LICENSE.TXT
; =============================================================================

;;; Print routine
;;; I push all the register to the stack.
;;; Set the bios routine for printing in the screen
;;; Move to al the data that bx points
;;; Generate the interrupt.
;;; Pop all registers from the stack
;;; Return to where the pc pointed to before getting in here.
;;; bx contains routine argument

%ifndef PRINT_STRING_16BIT
%define PRINT_STRING_16BIT

[bits 16]
print_string:   
        pusha
        mov ah, 0x0e            
        
print_loop:
        mov al, [bx]
        cmp al, 0
        je print_exit

        int 0x10
        inc bx
        jmp print_loop

print_exit:
        popa
        ret
%endif
