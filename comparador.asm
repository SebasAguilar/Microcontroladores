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
;inicio del programa: 
START
MOVLW 0x07 ;Apagar comparadores
MOVWF CMCON
BCF STATUS, RP1 ;Cambiar al banco 1
BSF STATUS, RP0 
MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
MOVWF TRISB 
MOVLW b'11111111' ;Establecer puerto a como entrada
MOVWF TRISA
BCF STATUS, RP0 ;Regresar al banco 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;compara 2 numeros;;;;;;;;;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
INICIO
 MOVLW d'0'
 MOVWF PORTB
 MOVF PORTA,0	    ;guardo el primer numero en W
 MOVWF i	    ;lo guardo en i
 nop
 MOVF PORTA,0	    ;guardo el segundo numero en W
 BSF STATUS,C ;C=1	------    si la resta da negativo, pondra en cero la C, el bit C = 0
				 ;si la resta da positiva, no le hara nada al bit C
 SUBWF i,1 ;i-W --- Se guarda en i
 BTFSS STATUS,Z
 GOTO continua
 GOTO prendeled1
 
prendeled1
 BSF PORTB,0	    ;Prende el led que indica que son iguales i y W
 BCF STATUS,Z
 BCF STATUS,C
 BCF STATUS,1
 GOTO INICIO
 
continua
 BTFSC STATUS,C	    ;pregunta si hay un cero en C
 GOTO continua2
 GOTO prendeled2

prendeled2
 BSF PORTB,1	    ;prende el led que indica que es menor el primer numero (i) que en W
 MOVLW d'0'
 MOVWF i
 GOTO INICIO
 
continua2
 BSF PORTB,2	    ;prende el led que indica que es mayor el primer numero (i) que en W
 ;;;;;;;SE pone todo en ceros;;;;;
 BCF STATUS,Z
 BCF STATUS,C
 BCF STATUS,1
 MOVLW d'0'
 MOVWF i
 GOTO INICIO
 END