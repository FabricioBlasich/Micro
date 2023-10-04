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
    LDR R0,=base            //R0 apunta al vecor
    MOV R1,0x0              //R1 almacenara el valor el cual si lo encuentro en el vector dejare de iterar
lazo: LDRB R4,[R0]          //Almaceno en R2 el elemento del vector
    CMP R4,0x00
    BEQ label
    MOV R2,R4
    AND R3,R2,0x0F
    LSR R2,#4
    EOR R2,R2,R3
    AND R3,R2,0x03
    LSR R2,#2
    EOR R2,R2,R3
    AND R3,R2,0x01
    LSR R2,#1
    EOR R2,R2,R3
    CMP R2,#0
    IT GT
    ORRGT R4,0x80
    STRB R4,[R0],#1
    B lazo
label: stop: B    stop               // Lazo infinito para terminar la ejecución

    .endfunc



