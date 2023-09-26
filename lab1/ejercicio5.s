    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
base:   .byte 0x00              //Aqui estara almacenado el mayor elmento del bloque al finalizar el programa
        .byte 0x05              //Indica el Tamaño del bloque
        .byte 0x3A, 0xAA, 0xF2, 0xFA, 0x04  //Elementos del bloque
    
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0, =base
    LDRB R1, [R0,#1]!
    MOV R2, #0
lazo:
    CMP R2, R1
    BGE label1
    LDRB R3, [R0, #1]!
        CMP R2, #0
        BNE label2
        MOV R4, R3
        B label3
    label2:
        CMP R3, R4
        BLT label3
        MOV R4, R3
    label3:
        ADD R2, #1
        B lazo
label1:
    LDR R0, =base
    STRB R4, [R0]
    LDRB R0, [R0]
stop: B    stop               // Lazo infinito para terminar la ejecución