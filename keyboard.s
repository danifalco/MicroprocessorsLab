#include <xc.inc>

global	key_reader, out_char, key_setup, key_val
    
extrn	delay
    
psect	udata_acs
	
high_byte:  ds 1    
delay_count:ds 1    ; Reserve 1 byte ofr counter in the delay routine
key_val:    ds 1    ; Reserve 1 byte for the key result (binary)
out_char:   ds 1    ; Reserve 1 byte for the ASCII charater output from keyboard
    
psect	keyboard_code, class=CODE

key_setup:
    ; SETUP KEYBOARD
    movlb   15
    bsf	    REPU
    movlb   0
    clrf    LATE
    return

key_reader:
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
    movff   high_byte, key_val
    ;movwf   key_val, A	; Store button value (binary) in key_val
    
    movff   key_val, PORTF

; Decode
is_1:
    movlw   0xEF
    cpfseq  key_val
    bra	    is_2
    movlw   '1'
    movwf   out_char, A
    bra	    output

is_2:
    movlw   0xED
    cpfseq  key_val
    bra	    is_3
    movlw   '2'
    movwf   out_char, A
    bra	    output
    
is_3:
    movlw   0xEB
    cpfseq  key_val
    bra	    is_F
    movlw   '3'
    movwf   out_char, A
    bra	    output
    
is_F:
    movlw   0xE7
    cpfseq  key_val
    bra	    is_4
    movlw   'F'
    movwf   out_char, A
    bra	    output
    
is_4:
    movlw   0xDF
    cpfseq  key_val
    bra	    is_5
    movlw   '4'
    movwf   out_char, A
    bra	    output
    
is_5:
    movlw   0xDD
    cpfseq  key_val
    bra	    is_6
    movlw   '5'
    movwf   out_char, A
    bra	    output
    
is_6:
    movlw   0xDB
    cpfseq  key_val
    bra	    is_E
    movlw   '6'
    movwf   out_char, A
    bra	    output
    
is_E:
    movlw   0xD7
    cpfseq  key_val
    bra	    is_7
    movlw   'E'
    movwf   out_char, A
    bra	    output
    
is_7:
    movlw   0xBF
    cpfseq  key_val
    bra	    is_8
    movlw   '7'
    movwf   out_char, A
    bra	    output
    
is_8:
    movlw   0xBD
    cpfseq  key_val
    bra	    is_9
    movlw   '8'
    movwf   out_char, A
    bra	    output
    
is_9:
    movlw   0xBB
    cpfseq  key_val
    bra	    is_D
    movlw   '9'
    movwf   out_char, A
    bra	    output
    
is_D:
    movlw   0xB7
    cpfseq  key_val
    bra	    is_A
    movlw   'D'
    movwf   out_char, A
    bra	    output
    
is_A:
    movlw   0x7F
    cpfseq  key_val
    bra	    is_0
    movlw   'A'
    movwf   out_char, A
    bra	    output
    
is_0:
    movlw   0x7D
    cpfseq  key_val
    bra	    is_B
    movlw   '0'
    movwf   out_char, A
    bra	    output
    
is_B:
    movlw   0x7B
    cpfseq  key_val
    bra	    is_C
    movlw   'B'
    movwf   out_char, A
    bra	    output
    
is_C:
    movlw   0x77
    cpfseq  key_val
    bra	    invalid
    movlw   'C'
    movwf   out_char, A
    bra	    output
    
invalid:
    goto    key_reader

output:
    return
