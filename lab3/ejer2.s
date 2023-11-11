    .cpu cortex-m4          // Indica el procesador de destino
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"
    .include "configuraciones/rutinas.s"

/****************************************************************************/
/* Definiciones de macros                                                   */
/****************************************************************************/

// Recursos utilizados por el canal SEG_B
  
    .equ SEG_B_PORT,    4
    
    .equ SEG_B_PIN,     1

    .equ SEG_B_BIT,     1

    .equ SEG_B_MASK,    (1 << SEG_B_BIT)

// Recursos utilizados por el canal SEG_C
  
    .equ SEG_C_PORT,    4
    
    .equ SEG_C_PIN,     2

    .equ SEG_C_BIT,     2

    .equ SEG_C_MASK,    (1 << SEG_C_BIT)

// Recursos utilizados por el canal SEG_E
  
    .equ SEG_E_PORT,    4
    
    .equ SEG_E_PIN,     4

    .equ SEG_E_BIT,     4

    .equ SEG_E_MASK,    (1 <<SEG_E_BIT)

// Recursos utilizados por el canal SEG_F
  
    .equ SEG_F_PORT,    4
    
    .equ SEG_F_PIN,     5

    .equ SEG_F_BIT,     5

    .equ SEG_F_MASK,    (1 << SEG_F_BIT)



    // Numero de puerto GPIO utilizado por los todos leds
    .equ SEG_GPIO,      2
    // Desplazamiento para acceder a los registros GPIO de los leds
    .equ SEG_OFFSET,    ( 4 * SEG_GPIO )
    // Mascara de 32 bits con un 1 en los bits correspondiente a cada led
    .equ SEG_MASK,      (SEG_B_MASK | SEG_C_MASK | SEG_E_MASK  | SEG_F_MASK)

// -------------------------------------------------------------------------
  
    .equ DIG1_PORT,    0
    .equ DIG1_PIN,     0
    .equ DIG1_BIT,     0
    .equ DIG1_MASK,    (1 << DIG4_BIT)

// -------------------------------------------------------------------------
  
    .equ DIG2_PORT,    0
    .equ DIG2_PIN,     1
    .equ DIG2_BIT,     1
    .equ DIG2_MASK,    (1 << DIG4_BIT)

// -------------------------------------------------------------------------
  
    .equ DIG3_PORT,    1
    .equ DIG3_PIN,     15
    .equ DIG3_BIT,     2
    .equ DIG3_MASK,    (1 << DIG4_BIT)

// -------------------------------------------------------------------------
  
    .equ DIG4_PORT,    1
    .equ DIG4_PIN,     17
    .equ DIG4_BIT,     3
    .equ DIG4_MASK,    (1 << DIG4_BIT)

// Recursos utilizados por el teclado
    .equ DIG_GPIO,      0
    .equ DIG_OFFSET,    ( DIG_GPIO << 2)
    .equ DIG_MASK,      (DIG1_MASK | DIG2_MASK | DIG3_MASK | DIG4_MASK)


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
/* Programa principal                                                       */
/****************************************************************************/

    .global reset           // Define el punto de entrada del codigo
    .section .text          // Define la seccion de codigo (FLASH)
    .func main              // Inidica al depurador el inicio de una funcion
reset:

    // Configura los pines de los seg como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * SEG_B_PORT + SEG_B_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_C_PORT + SEG_C_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_E_PORT + SEG_E_PIN))]
    STR R0,[R1,#(4 * (32 * SEG_F_PORT + SEG_F_PIN))]

    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * DIG4_PORT + DIG4_PIN))]
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(4 * (32 * DIG1_PORT + DIG1_PIN))]
    STR R0,[R1,#(4 * (32 * DIG2_PORT + DIG2_PIN))]
    STR R0,[R1,#(4 * (32 * DIG3_PORT + DIG3_PIN))]



    // Configura los pines de las teclas como gpio con pull-up
    MOV R0,#(SCU_MODE_PULLUP | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC4)
    STR R0,[R1,#((TEC_1_PORT << 5 | TEC_1_PIN) << 2)]
    STR R0,[R1,#((TEC_2_PORT << 5 | TEC_2_PIN) << 2)]
    STR R0,[R1,#((TEC_3_PORT << 5 | TEC_3_PIN) << 2)]
    STR R0,[R1,#((TEC_4_PORT << 5 | TEC_4_PIN) << 2)]

    // Apaga todos los bits gpio de los seg rgb
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#SEG_OFFSET]


    // Configura los bits gpio de los leds rgb como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#SEG_OFFSET]
    ORR R0,#SEG_MASK
    STR R0,[R1,#SEG_OFFSET]


    // Configura los bits gpio de los botones como entradas
    LDR R0,[R1,#TEC_OFFSET]
    BIC R0,#TEC_MASK
    STR R0,[R1,#TEC_OFFSET]

    // Define los punteros para usar en el programa
    LDR R4,=GPIO_PIN0
    LDR R5,=GPIO_NOT0

refrescar:
    // Define el estado actual de los leds como todos apagados
    MOV   R3,#0x00
    // Carga el estado arctual de las teclas
    LDR   R0,[R4,#TEC_OFFSET]

    MOV R1,#0
    STR R1,[R4,DIG_OFFSET]

    // Verifica el estado del bit correspondiente a la tecla uno
    TST R0,#TEC_1_MASK
    // Si la tecla esta apretada
    IT NE
    // Enciende el bit del canal rojo del led rgb
    ORRNE R3,#SEG_B_MASK

    // Prende el canal verde si la tecla dos esta apretada
    TST R0,#TEC_2_MASK
    IT    NE
    ORRNE R3,#SEG_C_MASK

    // Prende el canal azul si la tecla tres esta apretada
    TST R0,#TEC_3_MASK
    IT    NE
    ORRNE R3,#SEG_E_MASK


    TST R0,#TEC_4_MASK
    IT    NE
    ORRNE R3,#SEG_F_MASK

    // Actualiza las salidas con el estado definido para los leds
    STR   R3,[R4,#SEG_OFFSET]

    // Repite el lazo de refresco indefinidamente
    B     refrescar
stop:
    B stop
    .pool                   // Almacenar las constantes de codigo
    .endfunc
