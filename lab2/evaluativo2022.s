    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM) 
base:
    .byte 0xD7    // 0xD7  = (215)10
    .space 3   // Reservo 3 bytes para el mapa de bits de 7 segmentos de centena, decena y unidad

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    LDR R0,=base
    BL subrutina
    LDR R2,=base
disp:


    LDRB R0,[R2,#3]         // Guardo el digito a mostrar en R0
    MOV  R1,#4              // Prender el LED3
    BL   mostrar
    BL   demora

    LDRB R0,[R2,#2]         // Guardo el digito a mostrar en R0
    MOV  R1,#2              // Prender el LED2
    BL   mostrar
    BL   demora

    LDRB R0,[R2,#1]         // Guardo el digito a mostrar en R0
    MOV  R1,#1              // Prender el LED1
    BL   mostrar
    BL   demora        

    B    disp
    
stop:   B    stop               // Lazo infinito para terminar la ejecución
    .endfunc



    .func subrutina

subrutina:
    PUSH {R4-R8}  //registros auxiliares para calculos 
    LDRB R4,[R0]   // Cargo en R4 el numero
    LDR R5,=tabla
    MOV R8,#10   // Cargo en R8 el valor 10 para realizar operciones

    // Obtension de la unidad del numero, lo almacenare en R2, y caculare como R2 = R4 - (R4 div 10) * 10 
    UDIV R6,R4,R8           // Cargo en R6 la divicion entera de R4/10
    MUL R6,R8          // Multiplico el valor anterior por 10
    SUB R2,R4,R6    // Realizo la operacion R4 - (R4 div 10)*10 y almaceno el resto en R2
    LDRB R6,[R5,R2]   // Cargo en R6  el mapa de bits de 7 segmentos de las unidades
    STRB R6,[R0,#1]     // Cargo el mapa de bits de 7 segmentos de las unidades en la base

    // Obtension de la decena del numero, lo almacenare en R2, y caculare como R2 = (R4 div 10) % 10
    UDIV R6,R4,R8      // Cargo en R6 la divicion entera R4 div 10
    UDIV R7,R6,R8      // Cargo en R7 la divicion entera R6 div 10, lo cual me permitira calcular el modulo 
    MUL R7,R8          // Multiplico R7 por 10 para luego restar este resultado al valor de R6 y obtener  las decenas
    SUB R2,R6,R7        // Cargo en R2 las decenas
    LDRB R6,[R5,R2]   // Cargo en R6  el mapa de bits de 7 segmentos de las decenas
    STRB R6,[R0,#2]     // Cargo el mapa de bits de 7 segmentos de las decenas en la base


    // Obtension de la Centena del numero, lo almacenare en R2, y caculare como R2 = R4 div 100
    MOV R8,#100
    UDIV R2,R4,R8
    LDRB R6,[R5,R2]   // Cargo en R6  el mapa de bits de 7 segmentos de las centenas
    STRB R6,[R0,#3]     // Cargo el mapa de bits de 7 segmentos de las centenas en la base

    POP {R4-R8}
    BX LR

    .endfunc

    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67       

    .include "Laboratorios/lab2/display.s"
