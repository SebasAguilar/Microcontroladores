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
 A equ 0x35	;variable que rotara para sumar
 c equ 0x36	;variable que rotara para restar
;inicio del programa: 
START
MOVLW 0x07 ;Apagar comparadores
MOVWF CMCON
BCF STATUS, RP1 ;Cambiar al banco 1
BSF STATUS, RP0 
MOVLW b'00000000' ;Establecer puerto B como salida (los 8 bits del puerto)
MOVWF TRISB 
MOVLW b'00000000' ;Establecer puerto A como entrada
MOVWF TRISA
BCF STATUS, RP0 ;Regresar al banco 0
 
INICIO
 ;comparamos si el numero i 1000 (8) 8x8=64 es menor que del numero que queremos su raiz 
 ;ejemplo, 121, 1000 - 8x8=64, 64 es menor a 121, ese bit lo dejamos prendido
 ;despues prendemos el siguiente bit 1100 (12) 12x12=144, 144 es mayor que 121, no lo prendemos
 ; pasamos al siguiente, 1010 (10) 10x10=100, 100 es menor que 121, lo dejamos prendido
 ;pasamos al siguiente, 1011 (11) 11x11=121, es el mismo numero, 121=121, prendemos el bit
 MOVLW d'4'
 MOVWF A
 MOVLW d'8'
 MOVWF c

 MOVLW d'100'	;numero del que quieres sacar su raiz
 MOVWF x
 BSF y,3	;y sera el numero que ira prendiendo y apagando (la Raiz)
 
INICIO3
 ;;;;;;;;;;;;;;PROGRAMA DE MULTIPLICACION;;;;;;;;;;;
 MOVLW d'0'
 MOVWF PORTB	;dejo en 0 el PORTB
 MOVF y,0	;mueve el contenido de y a W
 MOVWF i	; i = W
 MOVF y,0	;mueve el contenido de y a W
 MOVWF j	; j = W
 MOVLW d'5'	;iteracion de 4 veces, porque numero binario de 5 digitos no cabe para la multiplicacion
 MOVWF k
otravez
 DECFSZ k,1
 GOTO otravez1
 GOTO INICIO2	    ;aqui se acaba el programa del multiplicador
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
 ;;;;;;;;;;;;;;PROGRAMA DE MULTIPLICACION;;;;;;;;;;;
INICIO2
 ;;;;;;;;;;;;;;PROGRAMA DEL COMPARADOR;;;;;;;;;;;;;;
 MOVLW d'0'
 MOVWF i	    ;pongo en ceros la 'i'
 MOVF PORTB,0	    ;guardo el numero multiplicado en W (64)
 MOVWF i	    ;i = W
 ;nop
 MOVF x,0	    ;guardo el segundo numero, el que quiere saber su raiz en W (121
 BSF STATUS,C ;C=1	------    si la resta da negativo, pondra en cero la C, el bit C = 0
				 ;si la resta da positiva, no le hara nada al bit C
 SUBWF i,1 ;i-W --- Se guarda en i   ---- 64-121
 BTFSS STATUS,Z
 GOTO continua
 GOTO prendeled1
 
prendeled1
 ;BSF PORTB,0	    ;Prende el led que indica que son iguales i y W
 BCF STATUS,Z
 BCF STATUS,C
 BCF STATUS,1
 GOTO INICIO
 
continua
 BTFSC STATUS,C	    ;pregunta si hay un cero en C
 GOTO continua2
 GOTO prendeled2

prendeled2
;prende el led que indica que es menor el primer numero multiplicacion (PORTB) que el de la raiz (y)
 
 MOVLW d'0'
 MOVWF i
		    ;prende el siguiente bit
 MOVF A,0	    ;mueve el contenido de A a W
 ADDWF y,1	    ;sumo y + W, se guarda en y
 BCF STATUS,C
 RRF A,1	    ;roto a la derecha A y lo guardo en si misma
 BCF STATUS,C
 RRF c,1	    ;roto a la derecha C y lo guardo en si misma
 
 GOTO INICIO3
 
continua2
;prende el led que indica que es mayor el primer numero multiplicacion (PORTB) que el de la raiz (y)
 ;;;;;;;SE pone todo en ceros;;;;;
 BCF STATUS,Z
 BCF STATUS,C
 BCF STATUS,1
 MOVLW d'0'
 MOVWF i
 
 MOVF A,0	    ;mueve el contenido de A a W
 ADDWF y,1	    ;sumo y + W, se guarda en y
 MOVF c,0	    ;muevo el contenido de C a W
 SUBWF y,1	    ; F - W, resto y - W, lo guardo en y
 BCF STATUS,C
 BCF STATUS,1
 RRF A,1	    ;roto a la derecha A y lo guardo en si mismo
 BCF STATUS,C
 BCF STATUS,1
 RRF c,1	    ;roto a la derecha C y lo guardo en si mismo
 GOTO INICIO3
 ;;;;;;;;;;;;;;;;;;PROGRAMA DEL COMPARADOR;;;;;;;;;;;;;;
 
END 