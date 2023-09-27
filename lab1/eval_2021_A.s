/*Se tiene un bloque de datos de 8 bits, guardados en codificación magnitud y signo.
El primerelemento está guardado en la dirección vector y el final del bloque está 
marcado con el valor0x80.a)  Escriba un programa que modifique los elementos del 
bloque para quedar almacenados encodificación complemento a 2. Los elementos deben
quedar almacenados en las mismasdirecciones de memoria en que se encontraban originalmente.
A continuación se muestra un ejemplo de funcionamiento del programa.
Tenga en cuentaque el programa debe funcionar para diferentes valores y 
diferentes longitudes de bloques,además del caso particular del ejemplo.

          Dato              Resultado
   (vector) = 0x06      (vector) = 0x06
   (vector + 1) = 0x85  (vector + 1) = 0xFB
   (vector + 2) = 0x78  (vector + 2) = 0x78
   (vector + 3) = 0xF8  (vector + 3) = 0x88
   (vector + 4) = 0xE0  (vector + 4) = 0xA0
   (vector + 5) = 0x80  (vector + 5) = 0x80
*/


/*
Cosas a tener en cuenta Antes de comenzar:
-Los datos estan almacenados en codificacion magnitud y signo (MyS) (bitSigno(1 Negativo y 0 Positivo)+MagnitudNumero) y se los
 debe modificar para que pasen a estar en complemento a 2 (Ca2):
 *Los numeros que son POSITIVOS representados en MyS ya estan representados en Ca2, entonces en este caso no hace falta realizar ningun cambio
 *Los numeros que son NEGATIVOS representados en Mys NO estan representados en Ca2, 
  luego para realizar esta conversion al numero representado en MyS le realizamos un Ca1 
  (Cambiamos todos los 1s por 0s, y todos los 0s por 1s (El bit de signo no cambia!))
  y luego le sumamos 1 para obtener el numero representado en Ca2
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
    LDR R0,=vector          //R0 apunta al vector
    MOV R1,0x80             //Guardo el valor con el cual si se encuentra, dejare de recorrer el vector
lazo: LDRB R3,[R0]          //Cargo el primer elemento del vector en R3
    CMP R3,R1               //Si R3 = 0x80 dejo de recorrer el vector
    BEQ label
    TST R3,0x80             //Me fijo si el MSB es 1 (si el numero es negativo)
    ITT NE
    EORNE R3,R3,0x7F        //Si el numero es negativo, realizo un Ca1 del numero (mediante una XOR) menos al MSB
    ADDNE R3,#1               //Le sumo 1 al resultado anterior para obtener una representacion en Ca2
    STRB R3,[R0],#1         //Almaceno el nuevo el valor de R3 en el vector, "piso" el valor anterior
    B lazo
label:
//############# Verificacion del que el programa funciona bien #########
    LDR R0,=vector          //R0 apunta al vector
    MOV R1,0x80             //Guardo el valor con el cual si se encuentra, dejare de recorrer el vector
lazo1: LDRB R3,[R0],#1          
    CMP R3,R1 
    BEQ stop                //Cargo en R3 los valores del vector y verifico que cumple con el ejemplo que propone el ejercicio
    B lazo1
stop: B    stop               // Lazo infinito para terminar la ejecución
    .endfunc


