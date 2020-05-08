#include "p16F628a.inc"    ;incluir librerias relacionadas con el dispositivo
 __CONFIG _FOSC_INTOSCCLK & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF    
;configuración del dispositivotodo en OFF y la frecuencia de oscilador
;es la del "reloj del oscilador interno" (INTOSCCLK)     
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program
; TODO ADD INTERRUPTS HERE IF USED
MAIN_PROG CODE                      ; let linker place main program
;variables para el contador:
 i equ 0x30	;variable donde estara guardado el resultado
 j equ 0x31
 k equ 0x32
 x equ 0x33
;inicio del programa: 
START
MOVLW 0x07 ;Apagar comparadores
MOVWF CMCON
BCF STATUS, RP1 ;Cambiar al banco 1
BSF STATUS, RP0 
MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
MOVWF TRISB 
MOVLW b'11111111' ;Establecer puerto A como entrada
MOVWF TRISA
BCF STATUS, RP0 ;Regresar al banco 0
 
INICIO
 nop
 MOVF PORTA,0	    ;mueve el conenido de PORTA a W
 MOVWF x	    
 RRF x,0	    ;lo rota a la derecha
 
 XORWF x,0	    ;XOR con el numero dado y el numero dado pero rotado a la derecha una vez
 BCF STATUS,C	    ;pone en 0 el bit de carry
 MOVWF PORTB	    ;en PORTB se guarda el numero convertido
 ;call tiempo	    ;por si se quiere poner por tiempo
 ;call tiempo
 ;call tiempo
 ;call tiempo	
 ;call tiempo
 MOVLW d'0'
 MOVWF x
 MOVLW d'0'
 MOVWF PORTB
 GOTO INICIO

tiempo: movlw d'201' ;establecer el valor de la variable i 255,252
	movwf i
iloop: movlw d'108' ;establecer el valor de la variable j 103,104
	movwf j
jloop:  movlw d'14' ;establecer el valor de la variable k  5,5
	movwf k
kloop: decfsz k,f
	goto kloop
	decfsz j,f
	goto jloop
	NOP
	NOP
	NOP
	decfsz i,f
	goto iloop
	
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP ;(999.989ms)
	return
 
END 