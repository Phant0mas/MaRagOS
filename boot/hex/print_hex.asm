; =============================================================================
; Copyright (C) 2015 Manolis Fragkiskos Ragkousis -- see LICENSE.TXT
; =============================================================================
;;; expects arg in dx
%ifndef PRINT_HEX_16BIT
%define PRINT_HEX_16BIT

print_hex:                      
        pusha           
        
        mov cx, 5               ; start modifying from the last char
                                ; representing a number and go backwards.
        

print_hex_loop: 
        cmp cx, 1
        je print_hex_exit
        
        mov ax, dx
        mov bx, HEX_TABLE
        and ax, 0x000f
        add bx, ax
        mov al, byte [bx]

        mov bx, HEX_OUT         ; pointer to the first char of the string
        add bx, cx
        mov [bx], al

        sub cx, 1
        shr dx, 4
        jmp print_hex_loop

print_hex_exit:
        mov bx, HEX_OUT
        call print_string
        popa
        ret

        %include "print/print_string.asm"

HEX_TABLE:
        db '0123456789abcdef'
HEX_OUT:
        db '0x0000',0

%endif
