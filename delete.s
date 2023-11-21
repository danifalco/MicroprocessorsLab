#include <xc.inc>

extrn	UART_Setup, UART_Transmit_Message, LCD_Clear  ; external subroutines
extrn	LCD_Setup, LCD_Write_Message
global	low_byte
	
psect	udata_acs   ; reserve data space in access ram
counter:    ds 1    ; reserve one byte for a counter variable
delay_count:ds 1    ; reserve one byte for counter in the delay routine
low_byte:   ds 1
high_byte:  ds 1
    
psect	udata_bank4 ; reserve data anywhere in RAM (here at 0x400)
myArray:    ds 0x80 ; reserve 128 bytes for message data

psect	data    
	; ******* myTable, data in programme memory, and its length *****
myTable:
	db	'H','e','l','l','o',' ','W','o','r','l','d','!',0x0a
					; message, plus carriage return
	myTable_l   EQU	13	; length of data
	align	2
    
psect	code, abs	
rst: 	org 0x0
 	goto	setup

	; ******* Programme FLASH read Setup Code ***********************
setup:	bcf	CFGS	; point to Flash program memory  
	bsf	EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup UART
	
	movlb	15
	bsf	REPU
	movlb	0
	clrf	LATE
	
	movlw	0x0
	movwf	TRISD, A	; PortD all Outputs

	movwf	TRISF, A	; Port F All outputs
	movwf	PORTF
	
	goto	thing
	
thing:
	movlw	0x0F
	movwf	TRISE
	call	delay
	movff	PORTE, low_byte
	; movff	PORTE, PORTF
	
	movlw	0xF0
	movwf	TRISE
	call	delay
	movf	PORTE, W
	iorwf	low_byte, A
	
	movff	low_byte, PORTF
	; call	LCD_Write_Message
	
	movlw	0xFF
	movwf	delay_count
	call	delay
	
	call	LCD_Clear
	goto	thing
	

	; a delay subroutine if you need one, times around loop in delay_count
delay:	decfsz	delay_count, A	; decrement until zero
	bra	delay
	return

	end	rst
