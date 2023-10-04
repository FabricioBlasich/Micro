    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM) 

segundos:                    // Vector de 2 bytes para los segundos
    .byte 0x9
    .byte 0x0
minutos:             // Vector de 2 bytes para min
    .byte 0x8
    .byte 0x4
max:
    .word 50000     // Variable que sera usada en la rutina demora

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    MOV R2,#0   // R2 sera mi contador de refrecos de pantalla
    LDR R3,=segundos
    LDR R4,=tabla

lazo:
    CMP R2,#100
    BEQ final_100refrescos

    LDRB R0,[R3]    
    LDRB R0,[R4,R0]         //Guardo en R0 segundos[0]
    MOV R1,#1
    BL mostrar
    Bl demora
    ADD R2,#1

    LDRB R0,[R3,#1]
    LDRB R0,[R4,R0]         //Guardo en R0 segundos[1]
    MOV  R1,#2              // Prender el LED3
    BL   mostrar
    BL   demora
    ADD R2,#1

    LDRB R0,[R3,#2]
    LDRB R0,[R4,R0]         //Guardo en R0 minutos[0]
    MOV  R1,#4              // Prender el LED2
    BL   mostrar
    BL   demora
    ADD R2,#1

    LDRB R0,[R3,#3]
    LDRB R0,[R4,R0]         //Guardo en R0 minutos[1]
    MOV  R1,#8              // Prender el LED1
    BL   mostrar
    BL   demora        
    ADD R2,#1

    B lazo

final_100refrescos:
    LDR R1,=segundos    // R1 apunta a segundos[0]
    MOV R0,#1           // Pongo R0 en 1 para llamar a la funcion de cambio
    Bl cambio60BCD       // Llamo a la funcion de cambio de segundos
    CMP R0,#1               // Comparo si hay que aumentar minutos
    BNE reset               // Si no hay que agregar minutos, vuelvo a ejecutar

    LDR R1,=minutos            // Cargo la dir de hora en R0
    BL cambio60BCD          // Llamo a la funcion para cambiar minutos
    CMP R0,#1               // Comparo si hay que agregar horas
    BNE reset               // Si no hay que agregar horas, vuelvo a ejecutar


    .endfunc  

/****************************************************************************/
/* Funcion demora
    Sin Parametros:                                                         */
/****************************************************************************/
    .func demora
demora: 
    PUSH {R4,R5}
    MOV R4,#0
    LDR R5,=max
    LDR R5,[R5]
lazo_demora:
    ADD R4,#1
    CMP R4,R5   
    BLE lazo_demora

    POP {R4,R5}
    BX LR

    .endfunc


/****************************************************************************/
/* Funcion segmetos
    Parametros:
        - R0 que recibe valor BCD a convertir                               */
/****************************************************************************/
    .func segmentos

segmentos:
    PUSH {R4}
    LDR R4,=tabla    // R4 apunta a la tabla
    LDRB R0,[R4,R0]
    POP {R4}
    BX LR

    .endfunc  


    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67   

    .include "Laboratorios/lab2/display.s"
    .include "Laboratorios/lab2/ej3.s"
