    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM) 

segundos:                    // Vector de 2 bytes para los segundos
    .byte 0x0
    .byte 0x0
min_hora:             // Vector de 2 bytes para min
    .byte 0x5,0x4
    .byte 0x3,0x2
max:
    .word 50000     // Variable que sera usada en la rutina demora

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    MOV R2,#0   // R2 sera mi contador de refrecos de pantalla
    LDR R3,=min_hora
    LDR R4,=tabla

lazo:
    CMP R2,#100
    BEQ final_100refrescos

    LDRB R0,[R3]    
    LDRB R0,[R4,R0]         //Guardo en R0 segundos[0]
    MOV R1,#1
    BL mostrar
    Bl demora
    ADD R2,#1

    LDRB R0,[R3,#1]
    LDRB R0,[R4,R0]         //Guardo en R0 segundos[1]
    MOV  R1,#2              // Prender el LED3
    BL   mostrar
    BL   demora
    ADD R2,#1

    LDRB R0,[R3,#2]
    LDRB R0,[R4,R0]         //Guardo en R0 minutos[0]
    MOV  R1,#4              // Prender el LED2
    BL   mostrar
    BL   demora
    ADD R2,#1

    LDRB R0,[R3,#3]
    LDRB R0,[R4,R0]         //Guardo en R0 minutos[1]
    MOV  R1,#8              // Prender el LED1
    BL   mostrar
    BL   demora        
    ADD R2,#1

    B lazo

final_100refrescos:
    MOV R0,#1   // Cargo 1 a R1 para llamar a la funcion incremento
    LDR R1,=segundos
    BL incrementar
    CMP R0,#1
    BNE reset   // Si R0 != 1, los segundos no desboraron y no hace falta incrementar los minutos

    LDR R1,=min_hora
    BL incrementar
    CMP R0,#1
    BNE reset   // Si R0 != 1, los segundos no desboraron y no hace falta incrementar las horas

    
    LDRB R0,[R1,#2]         // Cargo hora[0] como byte en R0
    ADD R0,#1


    LDRB R2,[R1,#3]         // Cargo hora[1] como byte en R1
    CMP R2,2                // Comparo hora[1] con 2
    BNE no24                // Si hora[1] no es 2, salto a no24
    CMP R0,3                // Comparo hora[0] con 3
    BLE no24                // Si hora[0] no es mayor que 3 salto a no24
    MOV R0,#0               // Si hora[1] es 2 y hora[0] es mayor que 3, hora[0] <- 0 y
    MOV R2,#0               // hora[1] <- 0
    B final                 // Va al final de la ejecucion

no24:
    CMP R0,9                // Comparo hora[0] con 9
    BLE final               // Si hora[0] no es mayor a 9, va al final de la ejecucion
    MOV R0,#0               // Si hora[0] es mayor a 9, hora[0] <- 0 y
    ADD R2,#1               // hora[1] <- hora[1] + 1

final:
    STRB R0,[R1,#2]         // Guardo en memoria hora[0]
    STRB R2,[R1,#3]         // Guardo en memoria hora[1]

    B reset


stop:   B    stop               // Lazo infinito para terminar la ejecución
    .endfunc


/****************************************************************************/
/* Funcion demora
    Sin Parametros:                                                         */
/****************************************************************************/
    .func demora
demora: 
    PUSH {R4,R5}
    MOV R4,#0
    LDR R5,=max
    LDR R5,[R5]
lazo_demora:
    ADD R4,#1
    CMP R4,R5   
    BLE lazo_demora

    POP {R4,R5}
    BX LR
    .endfunc



/****************************************************************************/
/* Funcion segmetos
    Parametros:
        - R0 que recibe valor BCD a convertir                               */
/****************************************************************************/
    .func segmentos

segmentos:
    PUSH {R4}
    LDR R4,=tabla    // R4 apunta a la tabla
    LDRB R0,[R4,R0]
    POP {R4}
    BX LR
    .endfunc 

/****************************************************************************/
/*Rutina de incremtento de segundos*/
/*Recibe en R0 el valor a incrementar*/
/*Recibe en R1 la direccion de los datos*/
/****************************************************************************/
    .func incrementar
incrementar:
    PUSH {R4-R5}
    LDRB R4,[R1]    // Busca el valor menos significativo
    ADD R4,R0   // Se incrementa en R0 cantidad
    MOV R0,#0   // Setea el valor de retorno por defecto

    CMP R4,#9
    BLS final_incrementar    // Salta si es menor o igual que 9

    SUB R4,#9   // Calcula la cantidad que se desbordo
    LDRB R5,[R1, #1]    // Busca el valor mas significativo
    ADD R5,R4   // Se incrementa en la cantidad de desborde
    MOV R4,#0   // Resetea el menos significatico

    CMP R5,#5
    BLS salto_incrementar   // Salta si es menor o igual que 5

    MOV R5,#0   // Resetea el mas significatico
    MOV R0,#1   // Setea el valor de retorno por desborde
salto_incrementar:
    STRB R5,[R1,#1]    // Almacena el nuevo valor menos significativo
final_incrementar:
    STRB R4,[R1]    // Almacena el nuevo valor menos significativo
    POP {R4-R5}
    BX LR    // Retorna al programa principa
    .endfunc


    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67   

    .include "Laboratorios/lab2/display.s"
    .include "Laboratorios/lab2/ej3.s"
