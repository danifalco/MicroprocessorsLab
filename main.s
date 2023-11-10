	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw	0xFF
	movwf	TRISC, A	    ; Port D all inputs
        movlw 	0x0
	movwf	TRISD, A	    ; Port C all outputs
		    
	bra 	test
loop:
	movff 	0x06, PORTD	    ; Move whatever is in 06 to Port C
	incf 	0x06, W, A	    ; increment 0x06 by 1, copy the value in W
test:
	movwf	0x06, A		    ; Copy W to 0x06
	movf 	PORTC, W, A	    ; Copy Port D to W
	cpfsgt 	0x06, A
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	main
