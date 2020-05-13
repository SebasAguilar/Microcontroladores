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
;inicio del programa: 
START
MOVLW 0x07 ;Apagar comparadores
MOVWF CMCON
BCF STATUS, RP1 ;Cambiar al banco 1
BSF STATUS, RP0 
MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
MOVWF TRISB 
;MOVLW b'11111111' ;Establecer puerto A como entrada
;MOVWF TRISA
BCF STATUS, RP0 ;Regresar al banco 0
 
INICIO
 MOVLW d'13'
 MOVWF i
 MOVLW d'13'
 MOVWF j
 MOVLW d'5'	;iteracion de 4 veces, porque numero binario de 5 digitos no cabe para la multiplicacion
 MOVWF k
otravez
 DECFSZ k,1
 GOTO otravez1
 GOTO INICIO
otravez1
 BTFSS j,0
 GOTO paso1
 GOTO paso2
 
paso1
 RRF j,1	;roto a la derecha la j
 RLF i,1	;roto a la izquierda la i
 GOTO otravez
paso2
 MOVF i,0	;mueve el contenido de i a W
 ADDWF PORTB,1	;suma W + PORTB, lo guarda en PORTB
 RRF j,1	;rota a la derecha la j
 BCF STATUS,C
 RLF i,1	;rota a la izquierda la i
 GOTO otravez 
END 