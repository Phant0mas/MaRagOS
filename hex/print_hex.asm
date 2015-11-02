; =============================================================================
; Copyright (C) 2015 Manolis Fragkiskos Ragkousis -- see LICENSE.TXT
; =============================================================================

        [org 0x7c00]            ; Tell the assembler where this code will be
                                ; loaded.
        
print_hex:                      
        pusha           

        add cx, 6               ; get past '0x'
        

print_hex_loop: 
        cmp dx, 0x0000
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

        %include "print_string.asm"     

HEX_TABLE:
        db '0123456789abcdef'
HEX_OUT:
        db '0x0000',0

