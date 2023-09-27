/*Escriba un programa que permita calcular la cantidad de números impares que se 
encuentranalmacenados en un vector. Los elementos del vector tiene el tamaño de
 un byte.La longitud del vector está almacenada en el registro
R0 y el puntero al primer elemento seencuentra almacenado en la
 direcciónbase. Se pide almacenar el resultado obtenido en ladirecciónbase+4. */

    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM


/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
vector: .byte 0x04,0x07,0x0B,0xBA   //Vector de tamaño 4

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    MOV R0,#4               //Tamaño del vector
    LDR R1,=vector          //R1 apunta al primer elemnto del vector
    MOV R2,#0               //R2 sera mi contador (comienza en 0)
lazo: CMP R0,#0             //Expresion logica de mi bucle while-do
    BEQ label   
    LDRB R3,[R1],#1        //Cargo un elemento del Vector, y desplazo el puntero al vector 1 byte
    TST R3,0x01             //Si el ultimo bit del elemento del vector es 0 es porque el numero es impar
    IT NE
    ADDNE R2,#1             //Si el numero es impar Sumo una unidad al contador
    SUBS R0,#1
    B lazo  
label:
    STRB R2,[R1],#1         //Almaceno la cantidad de numeros impares en la direccion base+4
stop: B    stop               // Lazo infinito para terminar la ejecución
    .endfunc
