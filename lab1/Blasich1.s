    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
base: .space 2,0x00             //Reservo 2 bytes para almacenar la suma de todos los elementos
      .byte 0x04                //Reservo el tamaño del bloque
      .byte 0x8A,0xFA,0xEF,0x12 //Reservo el contenido del bloque

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0,=base              //R0 apunta al bloque de datos
    LDRB R1,[R0,#2]!          //Almaceno el tamaña del bloque en R1
    MOV R2,#0                 //R2 sera mi contador para el loop
    MOV R3,#0                 //En R3 almacenare la suma
lazo:
    TEQ R2,R1           //Mientras R1 sea mayor a 0 estaremos en un lazo
    BEQ label
    LDRB R4,[R0,#1]!       //Cargo el numero del bloque de memoria en R4 y me desplazo 1 byte
    ADD R3,R4
    ADD R2,#1
    B lazo
label:
    LDR R0,=base
    STRH R3,[R0]
    LDRB R1,[R0],#1
    LDRB R1,[R0],#1
stop: B    stop               // Lazo infinito para terminar la ejecución

    .endfunc

