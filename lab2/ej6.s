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
    .global reset           // Define el punto de entrada del código
    .func gestorEventos              // Inidica al depurador el inicio de una funcion

// R0 :almacena el codigo ódigo de la tecla presionada
gestorEventos:
    LDR R1,=base   // R1 apunta a base que contiene la direcciones de memoria de las subrutinas

    LDR R2,[R1,R0,LSL #2]  // Uso R0 como un índice en una tabla de saltos que comienza en el lugarbase. Multiplico por 4 pues la cada elemento de la tabla tiene 4 Bytes
    ORR R2,0x01             // Agrego un bit al final de la direccion para asegurarme que cumplas con las instrucciones THUMB
    BL R3 
    POP {PC}

    .endfunc


    .pool
base: .word 0x1A001D05,0x1A002321,0x01A05FC4,0x01A07C3A