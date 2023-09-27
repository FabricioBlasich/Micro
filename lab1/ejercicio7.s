    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
origen: .byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xFF
destino: .space 8, 0x00

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0,=origen
    LDR R1,=destino
    LDR R3,=tabla
lazo: 
    LDRB R2,[R0],#1
    CMP R2, 0xFF
    BEQ label
    LDRB R2, [R3,R2]
    STRB R2,[R1],#1
    B lazo
label:
    STRB R2,[R1]
stop:   B    stop               // Lazo infinito para terminar la ejecución

    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3A,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67      
    .endfunc
    