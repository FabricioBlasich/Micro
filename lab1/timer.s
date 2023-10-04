    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la sección de variables (RAM) 
divisor:     
    .space 2,0              // Espacio de 2 bytes para el divisor (max 1000)
segundos:
    .space 2,0              // Vector de 2 bytes para los segundos
hora:
    .space 4,0              // Vector de 4 bytes para hora-min

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR R0,=divisor         // Cargo la dir de divisor en R0
    LDRH R3,[R0]            // Cargo el valor de R0 en R3
    ADD R3,#1               // Agrego 1 al contador divisor
    LDR R1,=segundos        // Cargo la dir de segundos en R1
    LDRB R2,[R1]            // Cargo segundos[0] como byte en R2

    CMP R3,1000             // Comparo si el divisor llego a 1000
    ITT EQ                  // Si llego a 1000, divisor va a 0 y se aumenta uno segundos[0]
    MOVEQ R3,#0
    ADDEQ R2,#1
    STRH R3,[R0]            // Guardo divisor en memoria

    LDRB R3,[R1,#1]         // Cargo segundos[1] como byte en R3
    CMP R2,9                // Comparo si segundos[0] > 9
    ITT GT                  // Si es asi, segundos[0] toma 0 y segundos[1] aumenta en uno
    MOVGT R2,#0
    ADDGT R3,#1
    STRB R2,[R1]            // Guardo segundos[0] en memoria

    LDR R0,=hora            // Cargo la dir de hora en R0
    LDRB R2,[R0]            // Cargo hora[0] como byte en R2
    CMP R3,5                // Comparo si segundos[1] > 5
    ITT GT                  // Si es asi, segundos[1] toma 0 y hora[0] aumenta en uno
    MOVGT R3,#0
    ADDGT R2,#1
    STRB R3,[R1,#1]         // Guardo segundos[1] en memoria

    LDRB R1,[R0,#1]         // Cargo hora[1] como byte en R1
    CMP R2,9                // Comparo si hora[0] > 9
    ITT GT                  // Si es asi, hora[0] toma 0 y hora[1] aumenta en uno
    MOVGT R2,#0
    ADDGT R1,#1
    STRB R2,[R0]            // Guardo hora[0] en memoria

    LDRB R2,[R0,#2]         // Cargo hora[2] como byte en R2
    CMP R1,5                // Comparo si hora[1] > 5
    ITT GT                  // Si es asi, hora[1] toma 0 y hora[2] aumenta en uno
    MOVGT R1,#0
    ADDGT R2,#1
    STRB R1,[R0,#1]         // Guardo hora[1] en memoria

    LDRB R1,[R0,#3]         // Cargo hora[3] como byte en R1
    CMP R1,2                // Comparo hora[3] con 2
    BNE no24                // Si hora[3] no es 2, salto a no24
    CMP R2,3                // Comparo hora[2] con 3
    BLE no24                // Si hora[2] no es mayor que 3 salto a no24
    MOV R2,#0               // Si hora[3] es 2 y hora[2] es mayor que 3, hora[2] <- 0 y
    MOV R1,#0               // hora[3] <- 0
    B final                 // Va al final de la ejecucion

no24:
    CMP R2,9                // Comparo hora[2] con 9
    BLE final               // Si hora[2] no es mayor a 9, va al final de la ejecucion
    MOV R2,#0               // Si hora[2] es mayor a 9, hora[2] <- 0 y
    ADD R1,#1               // hora[3] <- hora[3] + 1

final:
    STRB R2,[R0,#2]         // Guardo en memoria hora[2]
    STRB R1,[R0,#3]         // Guardo en memoria hora[3]

startest:  
    LDR R0,=divisor         // Cargo la dir de divisor en R0
    LDRH R3,[R0]            // Cargo el valor de R0 en R3
    LDR R4,=#999
    CMP R3,R4
    BEQ  test
    B    reset

test:
    LDR R1,=segundos        // Cargo la dir de segundos en R1
    LDRB R2,[R1]            // Cargo segundos[0] como byte en R2    
    LDRB R3,[R1,#1]         // Cargo segundos[1] como byte en R3
    CMP R2,9                // Comparo si segundos[0] > 9
    BEQ test2
    B    reset

test2:
    LDR R0,=hora            // Cargo la dir de hora en R0
    LDRB R2,[R0]            // Cargo hora[0] como byte en R2
    CMP R3,5                // Comparo si segundos[1] > 5
    BEQ test3
    B    reset

test3:
    CMP R2,9                // Comparo si hora[0] > 9
    LDRB R1,[R0,#1]         // Cargo hora[1] como byte en R1
    BEQ test4
    B    reset    

test4:
    LDRB R2,[R0,#2]         // Cargo hora[2] como byte en R2
    CMP R1,5                // Comparo si hora[1] > 5
    BEQ test5
    B    reset

test5:
    B    reset    
stop:
    B    stop               // Lazo infinito para terminar la ejecución

    .align
    .pool





