    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM) 
dia_mes:
    .space 1, 98                // Reservo un espacio de 1 byte para el dia 
    .space 1,  43             // Reservo un espacio de 1 byte para el mes
destino:
    .space 4                // Aqui almacenare las decenas y unidades del numero

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0,=dia_mes     // R0 apunta al bloque de memoria donde estan almacenados el dia y mes
    LDR R1,=destino     // R1 apunta al bloque de memoria donde se almacenara el mapa de bits de 7 segmentos del dia y mes
    BL fecha
    LDR R2,=destino
disp:
    LDRB R0,[R2,#3]
    MOV R1,#1
    BL mostrar
    Bl demora

    LDRB R0,[R2,#2]         // Guardo el digito a mostrar en R0
    MOV  R1,#2              // Prender el LED3
    BL   mostrar
    BL   demora

    LDRB R0,[R2,#1]         // Guardo el digito a mostrar en R0
    MOV  R1,#4              // Prender el LED2
    BL   mostrar
    BL   demora

    LDRB R0,[R2]         // Guardo el digito a mostrar en R0
    MOV  R1,#8              // Prender el LED1
    BL   mostrar
    BL   demora        

    B    disp

stop:   B    stop               // Lazo infinito para terminar la ejecución
    .endfunc


    .func segmentos

segmentos:
    // R0 recibe valor BCD a convertir
    PUSH {R4}
    LDR R4,=tabla    // R4 apunta a la tabla
    LDRB R0,[R4,R0]
    POP {R4}
    BX LR

    .endfunc  


    .func coonversion

conversion:
    // El enunciado nos asegura que el numero es menor a 99, entonces nos asegura que es como maximo de dos digitos
    // R0 recibe la dirección de memoria donde está almacenado un número binario
    PUSH {R4-R6}
    LDRB R4,[R0]    // Cargo en R4 el numero
    // Calculare el mod como MOD = NUM - (NUM div 10)*10
    MOV R5,#10    // Cargo en R5 10 para peder realizar las divicion y multiplicacion

    // Haciendo la siguiente operacion obtengo la decenas del numero
    UDIV R6,R4,R5
    STRB R6,[R1]   // Guardo el valor de las decenas en la dirección de memoria almacenada enR1

    // Haciendo la siguientes operaciones obtendre la unidad del numero
    MUL R6,R5       // (NUM div 10)*10
    SUB R4,R6       // NUM - (NUM div 10)*10
    STRB R4,[R1,#1]

    POP {R4-R6}
    BX LR

    .endfunc 

    .func fecha
fecha:
    // Recibo como parametro R0 = puntero al bloque dia_mes
    // Recibo como parametro R1 = puntero al bloque destino
    PUSH {LR}  // Push LR pues llamare a otras subrutinas
    PUSH {R0}
    MOV R4,R0  // R4 apunta al bloque dia_mes

    // Llamo la funcion convetir, la cual almacenara en (destino) la decena y en (destino+1) las unidades del dia
    BL conversion
    LDRB R0,[R1]   // Cargo en R0 la decena del dia
    BL segmentos   // Cargo en R0 el mapa de bits de 7 segmentos correspondientes a la decena del dia
    STRB R0,[R1],#1   // Almaceno este valor en (destino)

    LDRB R0,[R1]   // Cargo en R0 la unidad del dia
    BL segmentos   // Cargo en R0 el mapa de bits de 7 segmentos correspondientes a la unidad del dia
    STRB R0,[R1],#1   // Almaceno este valor en (destino)

    POP {R0}    
    ADD R0,#1      // R0 apunta al bloque dia_mes, en especifico al mes 
    
    // Llamo la funcion convetir, la cual almacenara en (destino) la decena y en (destino+1) las unidades del mes
    BL conversion
    LDRB R0,[R1]   // Cargo en R0 la decena del dia
    BL segmentos   // Cargo en R0 el mapa de bits de 7 segmentos correspondientes a la decena del mes
    STRB R0,[R1],#1   // Almaceno este valor en (destino)

    LDRB R0,[R1]   // Cargo en R0 la unidad del dia
    BL segmentos   // Cargo en R0 el mapa de bits de 7 segmentos correspondientes a la unidad del dia
    STRB R0,[R1],#1   // Almaceno este valor en (destino)

    POP {PC}
    
    .endfunc


    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67   

    .include "Laboratorios/lab2/display.s"
    