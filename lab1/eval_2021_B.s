/*
b)  Guarde en el registro R1 el mapa de bits correspondiente para mostrar 
la cantidad de ele-mentos negativos del vector del ejercicio anterior.
Para ello, considere la siguiente conexióndel display 7 segmentos. 
*/


    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM


/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
vector: .byte 0x06,0x85,0x78,0xF8,0xE0,0x80

  
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0,=vector      //R0 apunta al vector
    MOV R2,#0           //R2 es el contador de numeros negativos, inicializado en 0
    MOV R3,0x80             //Guardo el valor con el cual si se encuentra, dejare de recorrer el vector
    LDR R4,=tabla           //R4 apunta a tabla
    LDRB R1,[R4]            //inicialmente hay 0 numeros negativos, cargo el valor correspondiente a 0 para mostrar por el display
lazo:
    LDRB R5,[R0],#1         //Cargo los elementos del vector en R5, y aumento en 1 byte el puntero
    CMP R5,R3
    BEQ label
    TST R5,0x80             //Mediante una operacion AND con la mascara 0x80 = 1000.0000 me fijo si el elemento es negativo
    ITT NE              
    ADDNE R2,#1             //Si es negativo aumento en 1 mi contador de numeros negativos
    LDRBNE R1,[R4,R2]       //Cargo en R2 el valor del contador correspondiente para mostrar por display
    B lazo
label:
stop: B    stop               // Lazo infinito para terminar la ejecución
    
    
    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3A,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67    

.endfunc