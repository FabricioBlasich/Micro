    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
base:
    .byte 0x07, 0x10, 0x0A, 0x88  //bloque de memoria

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    MOV R0, #4              //Tamaño del arreglo
    MOV R1, #0              //Contador
    LDR R2, =base           //Puntero al bloque de memoria
lazo:
    CMP R0, #0              //Mientras R0 sea mayor a 0 estaremos en un lazo
    BEQ label1
    LDRB R3,[R2],#1
    ADD R1,R3
    SUBS R0, #1
    B lazo
label1:
    STRB R1, [R2]
    LDR R2, =base 
    LDRB R0, [R2,#4]!
stop: B    stop               // Lazo infinito para terminar la ejecución

    .endfunc

