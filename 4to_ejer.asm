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
;inicio del programa: 
START
MOVLW 0x07 ;Apagar comparadores
MOVWF CMCON
BCF STATUS, RP1 ;Cambiar al banco 1
BSF STATUS, RP0 
MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
MOVWF TRISB 
;MOVLW b'00000000'
;MOVWF TRISA
BCF STATUS, RP0 ;Regresar al banco 0
 
INICIO
;EL REGISTRO QUE SE TOMO EN DONDE SE SUMARAN TODOS LOS NUMEROS 1,2,4,8,16,32,64,128 SERA 'i'	i=255
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
MOVLW d'0'	;ASIGNAR EL NUMERO DECIMAL 0 AL REGISTRO W
MOVWF i		;ASIGNAR EL CONTENIDO DE W AL REGISTRO i
BSF PORTB,0	;poner 1 en PORTB

INICIO2 
MOVF PORTB,0	;MOVER LA CANTIDAD DEL REGISTRO PORTB AL REGISTRO W
ADDWF i,1	;SUMAR EL REGISTRO W CON EL REGISTRO i, GUARDARLO EN i
BTFSS PORTB,7	;PREGUNTAR SI HAY UN 1 EN LA POSICION 7 DEL TRGISTRO PORTB, si= SALTA 'GOTO KEEP', no=EJECUTA 'GOTO KEEP'
GOTO KEEP	;IR A KEEP
BCF PORTB,7	;PONER UN 0 EN LA POSICION 7 DEL REGISTRO PORTB
GOTO INICIO	;IR A INICIO
 
KEEP 
RLF PORTB,1	;ROTAR A LA IZQUIERDA EL 1 QUE ESTA EN PORTB, GUARDAR EL RESULTADO EN PORTB
GOTO INICIO2	;IR A INICIO2
 
END