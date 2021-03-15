;******************************************************************************
;     _____          ___                                     ___              *
;    /  /::\        /  /\                        ___        /  /\             *
;   /  /:/\:\      /  /:/_                      /  /\      /  /::\            *
;  /  /:/  \:\    /  /:/ /\    ___     ___     /  /:/     /  /:/\:\           *
; /__/:/ \__\:|  /  /:/ /:/_  /__/\   /  /\   /  /:/     /  /:/~/::\          *
; \  \:\ /  /:/ /__/:/ /:/ /\ \  \:\ /  /:/  /  /::\    /__/:/ /:/\:\         *
;  \  \:\  /:/  \  \:\/:/ /:/  \  \:\  /:/  /__/:/\:\   \  \:\/:/__\/         *
;   \  \:\/:/    \  \::/ /:/    \  \:\/:/   \__\/  \:\   \  \::/              *
;    \  \::/      \  \:\/:/      \  \::/         \  \:\   \  \:\              *
;     \__\/        \  \::/        \__\/           \__\/    \  \:\             *
;                   \__\/                                   \__\/             *  
;                                                                             *
;******************************************************************************
;                                                                             *
;                                                                             *
;                                Description                                  *
;                                                                             *
;									      *
;******************************************************************************
;                                                                             *
;  Filename: Line Follower Robot in Assembly Language                         *
;  Date:  14.03.21                                                            *
;  File Version: XC, PIC-as 2.31                                              *
;                                                                             *
;  Authors: Andrès Juan Duràn Valencia and Juan Sebastian Mosquera Cifuentes  *                                                            *
;  University: Universidad de Ibaguè                                          *
;                                                                             *
;******************************************************************************
;                                                                             *
;    FDEVICE: P16F877A                                                        *
;                                                                             *
;******************************************************************************
    
PROCESSOR 16F877A

#include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS

PSECT code

INISYS: 
    ;Cambio a Banco N1
    BCF STATUS, 6
    BSF STATUS, 5 ; Banco1
    ; Modificar TRIS
    BSF TRISB, 0    ; S0 = PortB0 <- entrada
    BSF TRISB, 1    ; S1 = PortB1 <- entrada
    BSF TRISB, 2    ; S2 = PortB2 <- entrada
    BSF TRISB, 3    ; S3 = PortB3 <- entrada
    BSF TRISB, 4    ; S4 = PortB4 <- entrada
    BCF TRISC, 0    ; MI = PortC0 <- salida
    BCF TRISC, 1    ; MIR = PortC1 <- salida
    BCF TRISC, 2    ; MD = PortC2 <- salida
    BCF TRISC, 3    ; MDR = PortC3 <- salida
    BCF TRISC, 4    ; LR = PortC4 <- salida
    BCF TRISC, 5    ; LAI = PortC5 <- salida
    BCF TRISC, 6    ; LAD = PortC6 <- salida
    ; Regresar a banco 0

    BCF STATUS, 5 ; Banco0   

MAIN:
    MOVF PORTB,0
    MOVWF 0x20
    ; S4 = B4 -> 21
    MOVF 0x20,0
    ANDLW 0b00010000
    MOVWF 0x21
    RRF 0x21,1
    RRF 0x21,1
    RRF 0x21,1
    RRF 0x21,1
    MOVF 0x21,0
    ANDLW 0b00000001
    MOVWF 0x21
    ; S3 = B3 -> 22
    MOVF 0x20,0
    ANDLW 0b00001000
    MOVWF 0x22
    RRF 0x22,1
    RRF 0x22,1
    RRF 0x22,1
    MOVF 0x22,0
    ANDLW 0b00000001
    MOVWF 0x22 
    ; S2 = B2 -> 23
    MOVF 0x20,0
    ANDLW 0b00000100
    MOVWF 0x23
    RRF 0x23,1
    RRF 0x23,1
    MOVF 0x23,0
    ANDLW 0b00000001
    MOVWF 0x23
    ; S1 = B1 -> 24
    MOVF 0x20,0
    ANDLW 0b00000010
    MOVWF 0x24
    RRF 0x24,1
    MOVF 0x24,0
    ANDLW 0b00000001
    MOVWF 0x24
    ; S0 = B0 -> 25
    MOVF 0x20,0
    ANDLW 0b00000001
    MOVWF 0x25
    MOVF 0x25,0
    ANDLW 0b00000001
    MOVWF 0x25
    ; S4' = B4' -> 26
    MOVF 0x20,0
    ANDLW 0b00010000
    MOVWF 0x26
    RRF   0x26,1
    RRF   0x26,1
    RRF   0x26,1
    RRF   0x26,1
    COMF  0x26,1
    MOVF  0x26,0
    ANDLW 0b00000001
    MOVWF 0x26
    ; S3' = B3' -> 27
    MOVF 0x20,0
    ANDLW 0b00001000
    MOVWF 0x27
    RRF   0x27,1
    RRF   0x27,1
    RRF   0x27,1
    COMF  0x27,1
    MOVF  0x27,0
    ANDLW 0b00000001
    MOVWF 0x27
    ; S2' = B2' -> 28
    MOVF 0x20,0
    ANDLW 0b00000100
    MOVWF 0x28
    RRF 0x28,1
    RRF 0x28,1
    COMF 0x28,1
    MOVF 0x28,0
    ANDLW 0b00000001
    MOVWF 0x28
    ; S1' = B1' -> 29
    MOVF 0x20,0
    ANDLW 0b00000010
    MOVWF 0x29
    RRF 0x29,1
    COMF 0x29,1
    MOVF 0x29,0
    ANDLW 0b00000001
    MOVWF 0x29
    ; S0' = B0' -> 2A
    MOVF 0x20,0
    ANDLW 0b00000001
    MOVWF 0x2A
    COMF 0x2A,1
    MOVF 0x2A,0
    ANDLW 0b00000001
    MOVWF 0x2A
    
    ;OPERACIONES
    ;MI (S2+S1+S0')(S3')
    MI:
    MOVF 0x23,0 ;W=S2
    IORWF 0x24,0 ;W=S1+S2
    IORWF 0x25,0 ;W=S1+S2+S0
    ANDWF 0x27,0 ;W=(S1+S2+S0)(S3')
    MOVWF 0x2B
    BTFSC 0x2B,0
    GOTO ONMI
    GOTO OFFMI
ONMI:
    BSF PORTC,0
    GOTO MIR
OFFMI:
    BCF PORTC,0
    GOTO MIR
    
    ;MIR (S4+S3')(S1')(S2')(S0')
    MIR:
    MOVF 0x21,0 ;W=S4
    IORWF 0x27,0 ;W=S4+S3'
    ANDWF 0x29,0 ;W=(S4+S3')(S1')
    ANDWF 0x28,0 ;W=(S4+S3')(S1')(S2')
    ANDWF 0x2A,0 ;W=(S4+S3')(S1')(S2')(S0')
    MOVWF 0x2C
    BTFSC 0x2C,0
    GOTO ONMIR
    GOTO OFFMIR
    ONMIR:
    BSF PORTC,1
    GOTO MD
    OFFMIR:
    BCF PORTC,1
    GOTO MD
    
    ;MD (S4+S3+S2)(S1')
    MD:
    MOVF 0x21,0 ;W=S4
    IORWF 0x22,0 ;W=S4+S3
    IORWF 0x23,0 ;W=S4+S3+S2
    ANDWF 0x29,0 ;W=(S4+S3+S2)(S1')
    MOVWF 0x2D
    BTFSC 0x2D,0
    GOTO ONMD
    GOTO OFFMD
    ONMD:
    BSF PORTC,2
    GOTO MDR
    OFFMD:
    BCF PORTC,2
    GOTO MDR
    
    ;MDR (S1'+S0)(S3')(S4')(S2')
    MDR:
    MOVF 0x29,0 ;W=S1'
    IORWF 0x25,0 ;W=S1'+S0
    ANDWF 0x27,0 ;W=(S1'+S0)(S3')
    ANDWF 0x26,0 ;W=(S1'+S0)(S3')(S4')
    ANDWF 0x28,0 ;W=(S1'+S0)(S3')(S4')(S2')
    MOVWF 0x2E
    BTFSC 0x2E,0
    GOTO ONMDR
    GOTO OFFMDR
    ONMDR: 
    BSF PORTC,3
    GOTO LR
    OFFMDR:
     BCF PORTC,3
     GOTO LR
     
    ;LR (S3S1)+(S4'S3'S2'S1'S0')
    LR:
    MOVF 0x22,0 ;W=S3
    ANDWF 0x24,0 ;W=S3S1
    MOVWF 0x2F
    MOVF 0x26,0 ;W=S4'
    ANDWF 0x27,0 ;W=S4'S3'
    ANDWF 0x28,0 ;W=S4'S3'S2'
    ANDWF 0x29,0 ;W=S4'S3'S2'S1'
    ANDWF 0x2A,0 ;W=S4'S3'S2'S1'S0'
    IORWF 0x2F,1
    BTFSC 0x2F,0
    GOTO ONLR
    GOTO OFFLR
    ONLR:
    BSF PORTC,4
    GOTO LAI
    OFFLR:
    BCF PORTC,4
    GOTO LAI
    
    ;LAI (S1')(S4+S3)
    LAI:
    MOVF 0x21,0 ;W=S4
    IORWF 0x22,0 ;W=S4+S3
    ANDWF 0x29,0 ;W=(S4+S3)(S1')
    MOVWF 0x30
    BTFSC 0x30,0
    GOTO ONLAI
    GOTO OFFLAI
    ONLAI:
    BSF PORTC,5
    GOTO LAD
    OFFLAI:
    BCF PORTC,5
    GOTO LAD
    
    ;LAD (S1+S0)(S3')
    LAD:
    MOVF 0x24,0 ;W=S1
    IORWF 0x25,0 ;W=S1+S0
    ANDWF 0x27,0 ;W=(S1+S0)(S3')
    MOVWF 0x31
    BTFSC 0x31,0
    GOTO ONLAD
    GOTO OFFLAD
    ONLAD:
    BSF PORTC,6
    GOTO MAIN
    OFFLAD:
    BCF PORTC,6
    GOTO MAIN
    
    END resetVec
