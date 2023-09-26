    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
base: .byte 0x06, 0x7A, 0x7B, 0x7C, 0x00

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0, =base
    LDRB R1,[R0]
lazo1: 
    CMP R1, #0
    BEQ label1
    MOV R2, #0
    MOV R3, #7
    MOV R4, #1
    lazo2: 
        CMP R3, #0
        BLE label2
        TST R1, R4
        BEQ aux1
        ADD R2, #1
    aux1:
        SUBS R3, #1
        LSL R4,#1
        B lazo2
    label2:    
        TST R2,0x1
        BEQ aux2
        ORR R1,0x80
    aux2:
        STRB R1,[R0], #1
        LDRB R1,[R0]
        B lazo1
label1: 
stop: B    stop               // Lazo infinito para terminar la ejecución

    .endfunc
