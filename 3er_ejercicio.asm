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
 y equ 0x34
 z equ 0x35
;inicio del programa: 
START
MOVLW 0x07 ;Apagar comparadores
MOVWF CMCON
BCF STATUS, RP1 ;Cambiar al banco 1
BSF STATUS, RP0 
MOVLW b'00000010' ;Establecer puerto B como salida (los 8 bits del puerto), excepto el RB1
MOVWF TRISB 
;MOVLW b'00000000'
;MOVWF TRISA
BCF STATUS, RP0 ;Regresar al banco 0

  
INICIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;EN ESTE CODIGO SE PREGUNTARA CADA SEGUNDO como maximo SI ESTA PRESIONADO O NO EL BOTON EN RB1;
;SI PRESIONAS EL BOTON TE DA 1, SI NO LO PRESIONAS DA 0					      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BTFSS PORTB,1	    ;AQUI SE PREGUNTA SI EL BOTON ESTA PRESIONADO O NO
GOTO mediosegundo 
GOTO unsegundo

unsegundo
BTFSS PORTB,0	    ;AQUI SE PREGUNTA SI EL LED ESTA PRENDIDO O APAGADO
GOTO Prende 
GOTO Apaga 

Prende 
BSF PORTB,0	    ;SE PRENDE EL LED
call tiempo
GOTO INICIO 

Apaga 
BCF PORTB,0	    ;SE APAGA EL LED
call tiempo
NOP 
GOTO INICIO
 
mediosegundo ;;;;;;;;;;;;;;;;;;;;;;;;;;;,, 
BTFSS PORTB,0	    ;AQUI SE PREGUNTA SI EL LED ESTA PRENDIDO O APAGADO
GOTO Prende2
GOTO Apaga2 
 
Prende2
BSF PORTB,0	    ;SE PRENDE EL LED
call tiempo2
call tiempo2
NOP
NOP 
GOTO INICIO
 
Apaga2 
BCF PORTB,0	    ;SE APAGA EL LED
call tiempo2
call tiempo2
NOP
NOP
NOP 
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
	
tiempo2: movlw d'242' ;establecer el valor de la variable i 255,252
	movwf x
xloop: movlw d'54' ;establecer el valor de la variable j 103,104
	movwf y
yloop:  movlw d'5' ;establecer el valor de la variable k  5,5
	movwf z
zloop: decfsz z,f
	goto zloop
	decfsz y,f
	goto yloop
	NOP
	NOP
	NOP
	
	decfsz x,f
	goto xloop
	
NOP
NOP
NOP
;NOP
;NOP
;NOP
	return
	
END 