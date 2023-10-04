    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM) 
cadena:
    .asciz "Hola Mundo"

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion
    comienzo .req R0
    final .req R1
reset:
    LDR comienzo,=cadena
    ADD final,comienzo,#9
    PUSH {comienzo,final}
    BL invertir
    POP {comienzo,final}
stop:
    B    stop               // Lazo infinito para terminar la ejecución

    .endfunc

    .func invertir

invertir:
    PUSH {LR}
    LDR R0,[SP,#4]
    LDR R1,[SP,#8]
    CMP R0,R1
    BGT finInv
    BL cambiar
    ADD comienzo,#1
    SUB final,#1
    PUSH {R0,R1}
    BL invertir
    POP {R0,R1}
finInv:
    POP {PC}

    .endfunc


    .func cambiar

cambiar:
    PUSH {R4,R5}
    LDRB R4,[comienzo]
    LDRB R5,[final]
    STRB R5,[comienzo]
    STRB R4,[final]
    POP {R4,R5}
    BX LR

    .endfunc

