	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
	
SPI_MasterInit: ; Set Clock edge to negative
    bcf CKE2 ; CKE bit in SSP2STAT, 
    ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
    movlw (SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
    movwf SSP2CON1, A
    ; SDO2 output; SCK2 output
    bcf TRISD, PORTD_SDO2_POSN, A ; SDO2 output
    bcf TRISD, PORTD_SCK2_POSN, A ; SCK2 output
return
    
SPI_MasterTransmit: ; Start transmission of data (held in W)
    movwf SSP2BUF, A ; write data to output buffer
Wait_Transmit: ; Wait for transmission to complete 
    btfss PIR2, 5 ; check interrupt flag to see if data has been sent
    bra Wait_Transmit
    bcf PIR2, 5 ; clear interrupt flag
return
    
start:
	movlw	0xFF
	movwf	TRISC, A	    ; Port C all inputs
        movlw 	0x0
	movwf	TRISD, A	    ; Port D all outputs
	
				    ; Set Clock edge to negative
	call	SPI_MasterInit
		    
	bra 	test
	

loop:
	movf	0x06, W		    ; Move the number in 06 to W
	movwf	SSP2BUF, A	    ; write W data to output buffer

;Wait_Transmit:			    ; Wait for transmission to complete 
	btfss	SSP2IF		    ; check interrupt flag to see if data has been sent
	;bra	Wait_Transmit
	bcf	SSP2IF		    ; clear interrupt flag
	
	incf 	0x06, W, A	    ; increment 0x06 by 1, copy the value in W
test:
	movwf	0x06, A		    ; Copy W to 0x06
	call	SPI_MasterTransmit
	movf 	PORTC, W, A	    ; Copy Port C to W
	cpfsgt 	0x06, A
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	main
