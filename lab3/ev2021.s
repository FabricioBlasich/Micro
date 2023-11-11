    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por los segmentos del desplay
    .equ SEG_A_PORT,    4
    .equ SEG_A_PIN,     0
    .equ SEG_A_BIT,     0
    .equ SEG_A_MASK,    (1 << SEG_A_BIT)

//--------------------------------------------------
    .equ SEG_B_PORT,    4
    .equ SEG_B_PIN,     1
    .equ SEG_B_BIT,     1
    .equ SEG_B_MASK,    (1 << SEG_B_BIT)

//--------------------------------------------------
    .equ SEG_C_PORT,    4
    .equ SEG_C_PIN,     2
    .equ SEG_C_BIT,     2
    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

//--------------------------------------------------
    .equ SEG_D_PORT,    4
    .equ SEG_D_PIN,     3
    .equ SEG_D_BIT,     3
    .equ SEG_D_MASK,    (1 << SEG_D_BIT)

//--------------------------------------------------
    .equ SEG_E_PORT,    4
    .equ SEG_E_PIN,     4
    .equ SEG_E_BIT,     4
    .equ SEG_E_MASK,    (1 << SEG_E_BIT)

//--------------------------------------------------
    .equ SEG_F_PORT,    4
    .equ SEG_F_PIN,     5
    .equ SEG_F_BIT,     5
    .equ SEG_F_MASK,    (1 << SEG_F_BIT)

//--------------------------------------------------
    .equ SEG_G_PORT,    4
    .equ SEG_G_PIN,     6
    .equ SEG_G_BIT,     6
    .equ SEG_G_MASK,    (1 << SEG_G_BIT)



// Recursos utilizados por los segmentos
    // Numero de puerto GPIO utilizado por los segmentos del display
    .equ SEG_GPIO,      2
    // Desplazamiento para acceder a los registros GPIO de los segmentos del display
    .equ SEG_OFFSET,    ( 4 * SEG_GPIO )
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada segmento
    .equ SEG_MASK,      (SEG_A_MASK | SEG_B_MASK | SEG_C_MASK | SEG_D_MASK | SEG_E_MASK | SEG_F_MASK | SEG_G_MASK)


// ---------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------
// Recursos utilizados por el Digito1
    .equ D1_PORT,    0
    .equ D1_PIN,     0
    .equ D1_BIT,     0
    .equ D1_MASK,    (1 << D1_BIT)

// Recursos utilizados por el Digito2
    .equ D2_PORT,    0
    .equ D2_PIN,     1
    .equ D2_BIT,     1
    .equ D2_MASK,    (1 << D2_BIT)

// Recursos utilizados por el Digito3
    .equ D3_PORT,    1
    .equ D3_PIN,     15
    .equ D3_BIT,     2
    .equ D3_MASK,    (1 << D3_BIT)

// Recursos utilizados por el Digito4
    .equ D4_PORT,    1
    .equ D4_PIN,     17
    .equ D4_BIT,     3
    .equ D4_MASK,    (1 << D4_BIT)

// Recursos utilizados por los digitos 1,2,3,4
    .equ DIG_GPIO,    0
    .equ DIG_OFFSET,  ( DIG_GPIO << 2)
    .equ DIG_MASK,    ( D1_MASK | D2_MASK | D3_MASK | D4_MASK )



//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
// Recursos utilizados por el led 2
    .equ LED_2_PORT,    2
    .equ LED_2_PIN,     11
    .equ LED_2_BIT,     11
    .equ LED_2_MASK,    (1 << LED_2_BIT)

// Recursos utilizados por el led 3
    .equ LED_3_PORT,    2
    .equ LED_3_PIN,     12
    .equ LED_3_BIT,     12
    .equ LED_3_MASK,    (1 << LED_3_BIT)

// Recursos utilizados por los leds 2 y 3
    .equ LED_N_GPIO,    1
    .equ LED_N_OFFSET,  ( LED_N_GPIO << 2)
    .equ LED_N_MASK,    ( LED_2_MASK | LED_3_MASK )


// ---------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------
// Recursos utilizados por el boton aceptar
    .equ ACEPTAR_PORT,    3
    .equ ACEPTAR_PIN,     1
    .equ ACEPTAR_BIT,     8
    .equ ACEPTAR_MASK,    (1 << ACEPTAR_BIT)

// Recursos utilizados por el boton cancelar
    .equ CANCELAR_PORT,    3
    .equ CANCELAR_PIN,     2
    .equ CANCELAR_BIT,     9
    .equ CANCELAR_MASK,    (1 << CANCELAR_BIT)

// Recursos utilizados por los botones
    .equ BOT_GPIO,    5
    .equ BOT_OFFSET,  ( BOT_GPIO << 2)
    .equ BOT_MASK,    ( ACEPTAR_MASK | CANCELAR_MASK )


// ------------------------------------------------------------------------- 
// -------------------------------------------------------------------------    
// Recursos utilizados por la primera tecla
    .equ TEC_1_PORT,    4
    .equ TEC_1_PIN,     8
    .equ TEC_1_BIT,     12
    .equ TEC_1_MASK,    (1 << TEC_1_BIT)

// Recursos utilizados por la segunda tecla
    .equ TEC_2_PORT,    4
    .equ TEC_2_PIN,     9
    .equ TEC_2_BIT,     13
    .equ TEC_2_MASK,    (1 << TEC_2_BIT)

// Recursos utilizados por la tercera tecla
    .equ TEC_3_PORT,    4
    .equ TEC_3_PIN,     10
    .equ TEC_3_BIT,     14
    .equ TEC_3_MASK,    (1 << TEC_3_BIT)

// Recursos utilizados por la tercera tecla
    .equ TEC_4_PORT,    6
    .equ TEC_4_PIN,     7
    .equ TEC_4_BIT,     15
    .equ TEC_4_MASK,    (1 << TEC_4_BIT)

// Recursos utilizados por el teclado
    .equ TEC_GPIO,      5
    .equ TEC_OFFSET,    ( TEC_GPIO << 2)
    .equ TEC_MASK,      ( TEC_1_MASK | TEC_2_MASK | TEC_3_MASK | TEC_4_MASK)



/****************************************************************************/
/* Vector de interrupciones                                                 */
/****************************************************************************/

    .section .isr           // Define una seccion especial para el vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value
    .word   handler+1       //  2: Non mascarable interrupt service routine
    .word   handler+1       //  3: Hard fault system trap service routine
    .word   handler+1       //  4: Memory manager system trap service routine
    .word   handler+1       //  5: Bus fault system trap service routine
    .word   handler+1       //  6: Usage fault system tram service routine
    .word   0               //  7: Reserved entry
    .word   0               //  8: Reserved entry
    .word   0               //  9: Reserved entry
    .word   0               // 10: Reserved entry
    .word   handler+1       // 11: System service call trap service routine
    .word   0               // 12: Reserved entry
    .word   0               // 13: Reserved entry
    .word   handler+1       // 14: Pending service system trap service routine
    .word   systick_isr+1   // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine



/****************************************************************************/
/* Definicion de variables globales                                         */
/****************************************************************************/

    .section .data          // Define la seccion de variables (RAM)
espera:
    .word 1                 // Variable compartida con el tiempo de espera
segundos_player1:                    
    .byte 0x9
    .byte 0x9
segundos_player2:  
    .byte 0x9
    .byte 0x9
control_Player1:
    .word 0x0
control_Player2:
    .word 0x0
velocidad_Sistick:
    .word 0x100
/****************************************************************************/
/* Programa principal                                                       */
/****************************************************************************/
    .global reset           // Define el punto de entrada del codigo
    .section .text          // Define la seccion de codigo (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:
    // Mueve el vector de interrupciones al principio de la segunda RAM
    LDR R1,=VTOR
    LDR R0,=#0x10080000
    STR R0,[R1]

    // Llama a una subrutina para configurar el systick
    BL systick_init

//------------- Se configuran los terminales
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT  | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(LED_2_PORT << 7 | LED_2_PIN << 2)]
    STR R0,[R1,#(LED_3_PORT << 7 | LED_3_PIN << 2)]

    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * SEG_A_PORT + SEG_A_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_B_PORT + SEG_B_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_C_PORT + SEG_C_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_D_PORT + SEG_D_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_E_PORT + SEG_E_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_F_PORT + SEG_F_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_G_PORT + SEG_G_PIN))]

    // Configuración de los pines de digitos como gpio sin pull-up
    STR R0,[R1,#(D1_PORT << 7 | D1_PIN << 2)]
    STR R0,[R1,#(D2_PORT << 7 | D2_PIN << 2)]
    STR R0,[R1,#(D3_PORT << 7 | D3_PIN << 2)]
    STR R0,[R1,#(D4_PORT << 7 | D4_PIN << 2)]

    MOV R0,#(SCU_MODE_PULLDOWN | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#(ACEPTAR_PORT << 7 | ACEPTAR_PIN << 2)]
    STR R0,[R1,#(CANCELAR_PORT << 7 | CANCELAR_PIN << 2)]

    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#((TEC_1_PORT << 5 | TEC_1_PIN) << 2)]
    STR R0,[R1,#((TEC_2_PORT << 5 | TEC_2_PIN) << 2)]
    STR R0,[R1,#((TEC_3_PORT << 5 | TEC_3_PIN) << 2)]
    STR R0,[R1,#((TEC_4_PORT << 5 | TEC_4_PIN) << 2)]
    
//----------- Apagado de todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    // Apagado de todos bits gpio de los leds
    LDR R0,=LED_N_MASK
    STR R0,[R1,#LED_N_OFFSET]

    // Apagado de todos bits gpio de los segmentos
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Apagado de todos bits gpio de los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

//----------------------------------------------

    LDR R1,=GPIO_DIR0

    // Se configuran los bits gpio de los leds 2 a 3 como salidas
    LDR R0,=LED_N_MASK
    STR R0,[R1,#LED_N_OFFSET]

    // Configuración de los bits gpio de segmentos como salidas
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]

    // Configuración de los bits gpio de digitos como salidas
    LDR R0,[R1,#DIG_OFFSET]
    ORR R0,#DIG_MASK
    STR R0,[R1,#DIG_OFFSET]

    // Configuración de los bits gpio de botones como entradas
    LDR R0,[R1,#BOT_OFFSET]
    BIC R0,#BOT_MASK
    STR R0,[R1,BOT_OFFSET]

    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK
    STR R0,[R1,#TEC_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_SET0
    LDR R6,=GPIO_CLR0
    LDR R8,=GPIO_PIN0

refrescar:

    
    LDR R0,[R8,TEC_OFFSET]
    LDR R10,[R8,BOT_OFFSET]

    // Frenar cuenta del player1
    TST R0,TEC_1_MASK
    BEQ no_frenar_player1
    LDR R2,=control_Player1
    LDR R3,[R2]
    ADD R3,#1
    CMP R3,#2
    IT EQ
    MOVEQ R3,#0
    STR R3,[R2]
no_frenar_player1:


    // Frenar cuenta del player2
    TST R0,TEC_4_MASK
    BEQ no_frenar_player2
    LDR R2,=control_Player2
    LDR R3,[R2]
    ADD R3,#1
    CMP R3,#2
    IT EQ
    MOVEQ R3,#0
    STR R3,[R2]
no_frenar_player2:

    // acelerar cuenta 
    TST R0,TEC_2_MASK
    BNE acelerar
    TST R10,CANCELAR_MASK
    BEQ no_acelerar_cuenta
acelerar:
    LDR R1,=velocidad_Sistick
    LDR R2,[R1]
    CMP R2,#10
    IT GT
    SUBGT R2,#10
    STR R2,[R1]
no_acelerar_cuenta:

    // desacelerar cuenta 
    TST R0,TEC_3_MASK
    BNE desacelerar
    TST R10,ACEPTAR_MASK
    BEQ no_desacelerar_cuenta
desacelerar:
    BEQ no_desacelerar_cuenta
    LDR R1,=velocidad_Sistick
    LDR R2,[R1]
    ADD R2,#10
    STR R2,[R1]
no_desacelerar_cuenta:



    //Pintar displays del player1
    MOV R0,#0
    LDR R1,=segundos_player1
    LDR R2,=tabla_segmentos
    LDR R3,=tabla_digitos

lazo_mostrar_player1:
    LDR R7,=DIG_MASK
    STR R7,[R6,#DIG_OFFSET]
    LDR R7,=SEG_MASK
    STR R7,[R6,#SEG_OFFSET]
    CMP R0,#2
    BEQ final_mostrar_player1
    LDRB R5,[R1],#1  //Cargo segundos_player1[]
    LDRB R5,[R2,R5]  //Cargo en R5 el digito en 7seg
    STR R5,[R4,SEG_OFFSET]
    LDRB R5,[R3,R0]  //Cargo en R5 la mascara del display a mostrar
    STR R5,[R4,DIG_OFFSET]

    BL demora
    
    ADD R0,#1
    B lazo_mostrar_player1
final_mostrar_player1:

    //Pintar displays del player1
    LDR R1,=segundos_player2

lazo_mostrar_player2:
    LDR R7,=DIG_MASK
    STR R7,[R6,#DIG_OFFSET]
    LDR R7,=SEG_MASK
    STR R7,[R6,#SEG_OFFSET]
    CMP R0,#4
    BEQ final_mostrar_player2
    LDRB R5,[R1],#1  //Cargo segundos_player2[]
    LDRB R5,[R2,R5]  //Cargo en R5 el digito en 7seg
    STR R5,[R4,SEG_OFFSET]
    LDRB R5,[R3,R0]  //Cargo en R5 la mascara del display a mostrar
    STR R5,[R4,DIG_OFFSET]

    BL demora
    
    ADD R0,#1
    B lazo_mostrar_player2
final_mostrar_player2:

    B refrescar
.endfunc

/************************************************************************************/
/* Rutina de Configuraciondel SysTick                                               */
/************************************************************************************/
.func systick_init
systick_init:
    CPSID I                     // Se deshabilitan globalmente las interrupciones

    // Se sonfigura prioridad de la interrupcion
    LDR R1,=SHPR3               // Se apunta al registro de prioridades
    LDR R0,[R1]                 // Se cargan las prioridades actuales
    MOV R2,#2                   // Se fija la prioridad en 2
    BFI R0,R2,#29,#3            // Se inserta el valor en el campo
    STR R0,[R1]                 // Se actualizan las prioridades

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x00
    STR R0,[R1]                 // Se quita el bit ENABLE

    // Se configura el desborde para un periodo de 100 ms
    LDR R1,=SYST_RVR
    LDR R0,=#840000
    STR R0,[R1]                 // Se especifica el valor de RELOAD

    // Se inicializa el valor actual del contador
    LDR R1,=SYST_CVR
    MOV R0,#0
    // Escribir cualquier valor limpia el contador
    STR R0,[R1]                 // Se limpia COUNTER y flag COUNT

    // Se habilita el SysTick con el reloj del nucleo
    LDR R1,=SYST_CSR
    MOV R0,#0x07
    STR R0,[R1]                 // Se fijan ENABLE, TICKINT y CLOCK_SRC

    CPSIE I                     // Se habilitan globalmente las interrupciones
    BX  LR                      // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
.endfunc


/************************************************************************************/
/* Rutina de servicio para la interrupcion del SysTick                              */
/************************************************************************************/
    .func systick_isr
systick_isr: 
    PUSH {LR}

    LDR  R0,=espera             // Se apunta R0 a la variable espera
    LDR R1,[R0]                // Se carga el valor de la variable espera
    SUBS R1,#1                  // Se decrementa el valor de espera
    BHI  systick_exit           // Si Espera > 0 entonces NO pasaron 10 veces
    PUSH {R0-R2}

    LDR R0,=control_Player1
    LDR R0,[R0]
    CMP R0,#1
    IT NE
    BLNE tiempo_player1

    LDR R0,=control_Player2
    LDR R0,[R0]
    CMP R0,#1
    IT NE
    BLNE tiempo_player2

    POP {R0-R2}
    LDR R1,=velocidad_Sistick
    LDR R1,[R1]
systick_exit:
    LDR  R0,=espera
    STR R1,[R0]                // Se actualiza la variable espera

    POP {PC}                       // Se retorna al programa principal
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

/************************************************************************************/
/* Rutina que drcrementa el tiempo del player1                                      */
/************************************************************************************/
    .func tiempo_player1
tiempo_player1:
    PUSH {LR}

    LDR R1,=segundos_player1
    BL decrementar

    POP {PC}
    .endfunc

/************************************************************************************/
/* Rutina que drcrementa el tiempo del player2                                      */
/************************************************************************************/
    .func tiempo_player1
tiempo_player2:
    PUSH {LR}

    LDR R1,=segundos_player2
    BL decrementar

    POP {PC}
    .endfunc


/****************************************************************************/
/*Rutina de decremento de segundos*/
/*Recibe en R1 la direccion de los datos*/
/****************************************************************************/
    .func decrementar
decrementar:
    PUSH {R4-R5}
    MOV R0,#1
    LDRB R4,[R1]    // Busca el valor menos significativo
    SUBS R4,R0   // Se decrementa en 1 

    CMP R4,#0
    BGE final_decrementar    // Salta si es mayor que 0

    LDRB R5,[R1, #1]    // Busca el valor mas significativo
    SUBS R5,R0   // Se decrementa en 1
    MOV R4,#9   // Resetea el menos significativo

    CMP R5,#0
    BGE salto_decrementar   // Salta si es mayor a 0

    MOV R5,#9   // Resetea el mas significativo
salto_decrementar:
    STRB R5,[R1,#1]    // Almacena el nuevo valor mas significativo
final_decrementar:
    STRB R4,[R1]    // Almacena el nuevo valor menos significativo
    POP {R4-R5}
    BX LR    
    .endfunc


/************************************************************************************/
/*Demora para mostrar mejor los display */
/************************************************************************************/


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
max:
    .word 50000
    .endfunc

/************************************************************************************/
/* Rutina de servicio generica para excepciones                                     */
/* Esta rutina atiende todas las excepciones no utilizadas en el programa.          */
/* Se declara como una medida de seguridad para evitar que el procesador            */
/* se pierda cuando hay una excepcion no prevista por el programador                */
/************************************************************************************/
    .func handler
handler:
    LDR R1,=GPIO_SET0           // Se apunta a la base de registros SET
    MOV R0,#LED_2_MASK          // Se carga la mascara para el LED 1
    STR R0,[R1,#LED_N_OFFSET]   // Se activa el bit GPIO del LED 1
    B handler                   // Lazo infinito para detener la ejecucion
    .pool                       // Se almacenan las constantes de codigo
    .endfunc

    .pool                   // Almacenar las constantes de código
tabla_segmentos:            // Define la tabla de conversión 
    .byte 0x3F,0x06,0x5B,0x4F,0x66
    .byte 0x6D,0x7D,0x07,0x7F,0x67 
tabla_digitos:
    .byte D1_MASK
    .byte D2_MASK
    .byte D3_MASK
    .byte D4_MASK


