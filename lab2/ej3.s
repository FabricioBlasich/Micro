    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

//    .section .data          // Define la sección de variables (RAM) 


/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .func cambio60BCD               // Inidica al depurador el inicio de una funcion

/*
recibe el valor numérico 1 en el registro R0 y 
la dirección de memoria donde está almacenado el dígito menos significativo en el registro R1
*/

cambio60BCD:
    PUSH {R4,R5}        // Push de R4 y R5
    LDRB R4,[R1]        // Cargo segundos[0] en R4
    ADD R4,#1           // Incremento en 1 segundos[0]
    LDRB R5,[R1,#1]     // Cargo segundos[1] en R5

    CMP R4,#9           
    ITT GT              // Si segundos[0] > 9, entonces segundos[0] = 0  y aumento una unidad segundos[1]
    MOVGT R4,#0
    ADDGT R5,#1
    STRB R4,[R1]       // Guardo segundos[0] en memoria

    CMP R5,#5          
    ITE GT              // Si segundos[1] > 5, entonces segundos[1] = 0  y indico un desbordamiento en los segundos
    MOVGT R5,#0
    MOVLE R0,#0
    STRB R5,[R1,#1]     // Guardo segundos[2] en memoria

    POP {R4,R5}
    BX LR

    .endfunc
    