#include <xc.inc>

global	out_char, key_reader
    
extrn	delay
    
psect	udata_acs
	
low_byte:   ds 1    
delay_count:ds 1    ; Reserve 1 byte ofr counter in the delay routine
key_val:    ds 1    ; Reserve 1 byte for the key result (binary)
out_char:   ds 1    ; Reserve 1 byte for the ASCII charater output from keyboard
    
psect	keyboard_code, class=CODE

key_reader:
    ; SETUP KEYBOARD
    movlb   15
    bsf	    REPU
    movlb   0
    clrf    LATE

    ; ACTIVATE PORT F FOR DEBUGGING PURPOSES
    movwf   TRISF, A	; Port F All outputs
    movwf   PORTF
    
    ; END OF SETUP
    
    ; Begin row read
    movlw   0xF0
    movwf   TRISE
    call    delay
    movff   PORTE, high_byte
    
    ; Begin column read
    movlw   0x0F
    movwf   TRISE
    call    delay
    movf    PORTE, W
    iorwf   high_byte, A
    movwf   key_val, A	; Store button value (binary) in key_val

; Decode
is_1:
    movlw   11101110b
    cpfseq  key_val
    bra	    is_2
    movlw   '1'
    movwf   out_char, A
    bra	    output

is_2:
    movlw   11101100b
    cpfseq  key_val
    bra	    is_3
    movlw   '2'
    movwf   out_char, A
    bra	    output
    
is_3:
    movlw   11101010b
    cpfseq  key_val
    bra	    is_F
    movlw   '3'
    movwf   out_char, A
    bra	    output
    
is_F:
    movlw   11100110b
    cpfseq  key_val
    bra	    is_4
    movlw   'F'
    movwf   out_char, A
    bra	    output
    
is_4:
    movlw   11011110b
    cpfseq  key_val
    bra	    is_5
    movlw   '4'
    movwf   out_char, A
    bra	    output
    
is_5:
    movlw   11011100b
    cpfseq  key_val
    bra	    is_6
    movlw   '5'
    movwf   out_char, A
    bra	    output
    
is_6:
    movlw   11011010b
    cpfseq  key_val
    bra	    is_E
    movlw   '6'
    movwf   out_char, A
    bra	    output
    
is_E:
    movlw   11010110b
    cpfseq  key_val
    bra	    is_7
    movlw   'E'
    movwf   out_char, A
    bra	    output
    
is_7:
    movlw   10111110b
    cpfseq  key_val
    bra	    is_8
    movlw   '7'
    movwf   out_char, A
    bra	    output
    
is_8:
    movlw   10111100b
    cpfseq  key_val
    bra	    is_9
    movlw   '8'
    movwf   out_char, A
    bra	    output
    
is_9:
    movlw   10111010b
    cpfseq  key_val
    bra	    is_D
    movlw   '9'
    movwf   out_char, A
    bra	    output
    
is_D:
    movlw   10110110b
    cpfseq  key_val
    bra	    is_A
    movlw   'D'
    movwf   out_char, A
    bra	    output
    
is_A:
    movlw   1111110b
    cpfseq  key_val
    bra	    is_0
    movlw   'A'
    movwf   out_char, A
    bra	    output
    
is_0:
    movlw   1111100b
    cpfseq  key_val
    bra	    is_B
    movlw   '0'
    movwf   out_char, A
    bra	    output
    
is_B:
    movlw   1111010b
    cpfseq  key_val
    bra	    is_C
    movlw   'B'
    movwf   out_char, A
    bra	    output
    
is_C:
    movlw   1110110b
    cpfseq  key_val
    bra	    invalid
    movlw   'C'
    movwf   out_char, A
    bra	    output
    
invalid:
    goto    key_reader

output:
    return
