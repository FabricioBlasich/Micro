    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 

fechaAct:
    .byte 29,9                  // Fecha inicializada

destino:    
    .space 4                    // Espacio de 4 bytes para resultado de fecha
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR  R0,=fechaAct       // Apunto R0 a la fecha actual
    LDR  R1,=destino        // Apunto R1 al bloque de destino
    BL   fecha
disp:
    LDR  R2,=destino
    LDRB R0,[R2],#1         // Guardo el digito a mostrar en R0
    MOV  R1,#8              // Prender el LED4
    BL   mostrar
    BL   demora

    LDRB R0,[R2],#1         // Guardo el digito a mostrar en R0
    MOV  R1,#4              // Prender el LED3
    BL   mostrar
    BL   demora

    LDRB R0,[R2],#1         // Guardo el digito a mostrar en R0
    MOV  R1,#2              // Prender el LED2
    BL   mostrar
    BL   demora

    LDRB R0,[R2],#1         // Guardo el digito a mostrar en R0
    MOV  R1,#1              // Prender el LED1
    BL   mostrar
    BL   demora        

    B    disp
stop:
    B    stop               // Lazo infinito para terminar la ejecución

    .endfunc

    .func segmentos
    // Recibe en R0 el num a convertir, devuelve en R0 el num convertido
segmentos:
    PUSH {R4}               // Guardo el valor de R4
    LDR  R4,=tabla          // Apunta R4 al bloque con la tabla
    LDRB R0,[R4,R0]         // Cargar en R0 el elemento convertido
    POP  {R4}               // Devuelvo R4 a su valor original
    BX   LR                 // Vuelta a la llamada

    .pool                   // Almacenar las constantes de código

tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67      
    .endfunc

    .func conversion
    // Recibe en R0 &numero 0-99, guarda en la dir almacenada en R1 las decenas, unidades en R1+1
conversion:
    PUSH {R4-R6}            // Guardo los valores de R4-R6
    LDRB R4,[R0]            // Cargo el valor del numero en R4
    MOV  R6,#10             // Cargo 10 en R6
    UDIV R5,R4,R6           // Guardo en R5 <- R4/10
    MUL  R5,R5,R6           // R5 <- R5 x 10
    SUB  R5,R4,R5           // R5 <- R4 - R5, unidades en R5
    UDIV R4,R4,R6           // Guardo en R4 las decenas
    STRB R4,[R1]            // Guardo en la direccion de R1 las decenas
    STRB R5,[R1,#1]         // Guardo en la dir de R1+1 las unidades
    POP  {R4-R6}            // Devuelvo R4-R6 a sus valores originales
    BX   LR                 // Vuelta a la llamada

    .endfunc

    .func fecha
    // Recibe en R0 &fecha, dia en fecha, mes en fecha+1, guarda la rep en 7seg en dir de R1 como
    // dest = dec_dia, dest+1 = un_dia, dest+2 = dec_mes, dest+3 = un_mes
fecha:
    //Conversion de fecha en 2 bytes a fecha en 4 bytes en destino
    PUSH {LR}               // Guardo la direccion de la llamada
    BL  conversion          // Llamada a conversion de dia
    ADD R0,#1               // Sumo uno a R0 para convertir mes
    ADD R1,#2               // Sumo dos a R1 para guardar conversion de mes
    BL  conversion          // Llamada a conversion de mes
    SUB R1,#2               // Vuelvo a la direccion base

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#1         // Guardo en R1 el numero convertido, sumo 1 a R1

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#1         // Guardo en R1 el numero convertido, sumo 1 a R1

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#1         // Guardo en R1 el numero convertido, sumo 1 a R1

    LDRB R0,[R1]            // Cargo en R0 el numero a convertir
    BL  segmentos           // Llamo a segmentos para convertir
    STRB R0,[R1],#-3        // Guardo en R1 el numero convertido, resto 3 a R1

    POP {PC}                // Vuelvo a la llamada            

    .endfunc

    .include "lab2/lab2_seg.s"
