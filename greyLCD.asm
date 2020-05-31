#include "p16F887.inc"   ; TODO INSERT CONFIG CODE HERE USING CONFIG BITS GENERATOR
 	__CONFIG	_CONFIG1,	_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_ON & _FCMEN_ON & _LVP_OFF 
 	__CONFIG	_CONFIG2,	_BOR40V & _WRT_OFF

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

    BCF PORTC,0		;reset
    MOVLW 0x01
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
  
    GOTO    START

MAIN_PROG CODE                      ; let linker place main program

START

i equ 0x30
j equ 0x31
resul equ 0x32 

START

    BANKSEL PORTA ;
    CLRF PORTA ;Init PORTA
    BANKSEL ANSEL ;
    CLRF ANSEL ;digital I/O
    CLRF ANSELH
    BANKSEL TRISA ;
    MOVLW d'255'
    MOVWF TRISA 
    CLRF TRISB
    CLRF TRISC
    CLRF TRISD
    CLRF TRISE
    BCF STATUS,RP1
    BCF STATUS,RP0
    BCF PORTC,1
    BCF PORTC,0
    ;0x80	es en donde incia el primer rengon del LCD
    ;0xC0	es en donde incia el segundo renglon del LCD
INITLCD
    BCF PORTC,0		;reset 	;poner en ceros la pantalla	;modo comando
    MOVLW 0x01
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time		;enable=1
    BCF PORTC,1
    CALL time
    
    MOVLW 0x0C		;first line
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
         
    MOVLW 0x3C		;cursor mode
    MOVWF PORTD
    
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    

INICIO	  
    ;;;;;;;;;;;conversion a gray;;;;;;;;;;
    MOVF PORTA,W
    MOVWF resul
    RRF resul,0
    XORWF resul,1
    BCF STATUS,C
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BCF PORTC,0		;command mode	;modo de instrucciones
    CALL time
    
    MOVLW 0x88		;LCD position	;80 es en donde incia la primera linea del LCD ;0x80
    MOVWF PORTD
    CALL exec		;lo graba en el LCD
    
    BSF PORTC,0		;data mode
    CALL time
    
    MOVLW ':'
    MOVWF PORTD
    CALL exec
    
    MOVLW ' '
    MOVWF PORTD
    CALL exec
    
    MOVLW 'A'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'n'
    MOVWF PORTD
    CALL exec
    
    MOVLW 't'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'e'
    MOVWF PORTD
    CALL exec
    
    MOVLW 's'
    MOVWF PORTD
    CALL exec
 
    BCF PORTC,0		;command mode	;modo de instruccion
    CALL time
    
    MOVLW 0x80		;LCD position	;te vas a la posicion que tu quieras del LCD
    MOVWF PORTD
    CALL exec	    ;enable=1
    
    BSF PORTC,0		;data mode
    CALL time
    ;;;;;;;;;;;;;;;;;;;;imprime el numero binario;;;;;;;;;;;;;;;;;
    BTFSS PORTA,7
    CALL print0
    BTFSC PORTA,7
    CALL print1
    
    BTFSS PORTA,6
    CALL print0
    BTFSC PORTA,6
    CALL print1
    
    BTFSS PORTA,5
    CALL print0
    BTFSC PORTA,5
    CALL print1
    
    BTFSS PORTA,4
    CALL print0
    BTFSC PORTA,4
    CALL print1
    
    BTFSS PORTA,3
    CALL print0
    BTFSC PORTA,3
    CALL print1
    
    BTFSS PORTA,2
    CALL print0
    BTFSC PORTA,2
    CALL print1
    
    BTFSS PORTA,1
    CALL print0
    BTFSC PORTA,1
    CALL print1
    
    BTFSS PORTA,0
    CALL print0
    BTFSC PORTA,0
    CALL print1 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BCF PORTC,0		;command mode ;modo de instruccion
    CALL time
    
    MOVLW 0xC8		;LCD position	    
    MOVWF PORTD
    CALL exec

    BSF PORTC,0		;data mode
    CALL time
    
    MOVLW ':'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'D'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'e'
    MOVWF PORTD
    CALL exec
    
    MOVLW 's'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'p'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'u'
    MOVWF PORTD
    CALL exec
    
    MOVLW 'e'
    MOVWF PORTD
    CALL exec
    
    MOVLW 's'
    MOVWF PORTD
    CALL exec
      
    BCF PORTC,0		;command mode	;modo de instruccion
    CALL time
    
    MOVLW 0xC0		;LCD position	;C0, es en donde inicia el LCD, segunda linea
    MOVWF PORTD
    CALL exec
    
    BSF PORTC,0		;data mode
    CALL time
    ;;;;;;;;;;;;;;;;;;imprime el numero convertido a gray;;;;;;;;;;;;;;;;;;;;;
    BTFSS resul,7
    CALL print0
    BTFSC resul,7
    CALL print1
    
    BTFSS resul,6
    CALL print0
    BTFSC resul,6
    CALL print1
    
    BTFSS resul,5
    CALL print0
    BTFSC resul,5
    CALL print1
    
    BTFSS resul,4
    CALL print0
    BTFSC resul,4
    CALL print1    
    
    BTFSS resul,3
    CALL print0
    BTFSC resul,3
    CALL print1
    
    BTFSS resul,2
    CALL print0
    BTFSC resul,2
    CALL print1
    
    BTFSS resul,1
    CALL print0
    BTFSC resul,1
    CALL print1
    
    BTFSS resul,0
    CALL print0
    BTFSC resul,0
    CALL print1    
    
    GOTO INICIO
    
print0
    MOVLW 0x30 ;'0'
    MOVWF PORTD
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    nop
    RETURN
    
print1
    MOVLW 0x31
    MOVWF PORTD
    BSF PORTC,1		;exec
    CALL time
    BCF PORTC,1
    CALL time
    nop
    RETURN
    
exec
    BSF PORTC,1		;exec	;enable=1
    CALL time
    BCF PORTC,1		;enable=0
    CALL time
    RETURN
    
time
    CLRF i
    MOVLW d'10'
    MOVWF j
ciclo    
    MOVLW d'80'
    MOVWF i
    DECFSZ i
    GOTO $-1
    DECFSZ j
    GOTO ciclo
    RETURN
			
    END