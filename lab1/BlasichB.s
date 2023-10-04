    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data              // Define la sección de variables (RAM) 
origen:     
    .byte 175            // Variable inicializada de 5 bytes
destino:    
    .space 20,0x00              // Variable de 20 bytes en blanco

/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/

    .section .text          // Define la sección de código (FLASH)
    .global reset           // Define el punto de entrada del código
    .func main              // Inidica al depurador el inicio de una funcion

reset:
    LDR  R1,=origen         // Apunta R1 al bloque de origen
    LDR  R2,=destino        // Apunta R2 al bloque de destino
    LDR  R3,=tabla           // Apunta R3 al bloque con la tabla
    LDRB R0,[R1],#1         // Carga en R0 el elemento a convertir
    AND R4,R0,0x0F          //Cargo en R4 parte baja del BCD compactado
    LDRB R4,[R3,R4]         // Cargar en R0 el elemento convertido
    STRB R0,[R2],#1         // Guardar el elemento convertido                        
stop: B    stop               // Lazo infinito para terminar la ejecución

    .pool                   // Almacenar las constantes de código
tabla:                      // Define la tabla de conversión 
    .byte 0x3A,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67   
    .byte 0x77,0x7C,0x35,0x75,0x71   
    .endfunc
