    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 

operando1:                      //Numero de 64 bits
    .word 0x81000304
    .word 0x00200605
operando2:                      //Numero de 32 bits
    .word 0xA0560102

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR  R0,=operando1         //R0 apunta al primer operando1 de 64 bits
    LDR R1,=operando2          //R1 apunta al operando2 de 32 bits
    LDR  R1,[R1]             //Cargo en R1 un numero de 32 bits
    BL suma                     //Llamada a la funcion suma

stop: B    stop               // Lazo infinito para terminar la ejecución

suma:
    LDR R2,[R0]                 //Cargo en R2 los 32 bits menos significativos del operando de 64 bits
    LDR R3,[R0,#4]              //Cargo en R2 los 32 bits mas significativos del operando de 64 bits
    ADDS R2,R1                  //Sumo los numeros mas significativos
    STR R2,[R0]                 //Almaceno la suma anterior
    ADC R3,#0                   //Sumo la parte mas significativa con 0, se sumara 1 en caso de que la suma anterior tuviera acarreo
    STR R3,[R0,#4]              //Almaceno esta suma
    BX LR                       //Vuelo a mi programa principal