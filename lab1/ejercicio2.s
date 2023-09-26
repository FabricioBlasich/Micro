    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM


/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
base: .hword 0x4              //tamaño del vector 

vector:  .space 2, 0x00      // Vector
  
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0,=base         // R0 contendra el tamaño del vector
    LDR R0, [R0]
    LDR R1, =vector    //Apunto R1 al vector
    MOV R2, R0      // R1 sera mi contador que arranca en el valor que tiene la variable global base (tamaño del arreglo)
    MOV R3, 0x55          // Almaceno en R2 el valor que debo almacenar en el vector
lazo1:                  //Lazo whilw-do, mientras R2 > 0 
    CMP R2, #0
    BLE label1
    STRB R3, [R1], #2   //Almaceno en vector el valor de R2 y aumento en 16 bits la direccion de memoria
    SUBS R2, #1         //Disminuyo el contador en 1
    B lazo1
label1:

//###################### Prueba para verificar que el programa ande correctamente ################
    LDR R1, =vector
    MOV R2, R0
    MOV R3, 0x0
lazo2:
    CMP R2, #0
    BLE stop
    LDRH R3,[R1],#2
    SUBS R2, #1
    B lazo2
stop:
    B    stop               // Lazo infinito para terminar la ejecución
    
    .endfunc


