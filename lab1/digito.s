    .cpu cortex-m4          // Indica el procesador de destino  
    .syntax unified         // Habilita las instrucciones Thumb-2
    .thumb                  // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"

/****************************************************************************/
/* Declaraciones de macros para acceso simbolico a los recursos
/****************************************************************************/

	// Recursos utilizados por el primer segmento
    .equ SA_PORT,	4
    .equ SA_PIN,	0
    .equ SA_BIT,	0
    .equ SA_MASK,	(1 << SA_BIT)

	// Recursos utilizados por el segundo segmento
    .equ SB_PORT,	4
    .equ SB_PIN,	1
    .equ SB_BIT,	1
    .equ SB_MASK,	(1 << SB_BIT)

	// Recursos utilizados por el tercer segmento
    .equ SC_PORT,	4
    .equ SC_PIN,	2
    .equ SC_BIT,	2
    .equ SC_MASK,	(1 << SC_BIT)

	// Recursos utilizados por el cuatro segmento
    .equ SD_PORT,	4
    .equ SD_PIN,	3
    .equ SD_BIT,	3
    .equ SD_MASK,	(1 << SD_BIT)

	// Recursos utilizados por el quint segmento
    .equ SE_PORT,	4
    .equ SE_PIN,	4
    .equ SE_BIT,	4
    .equ SE_MASK,	(1 << SE_BIT)

	// Recursos utilizados por el sexto segmento
    .equ SF_PORT,	4
    .equ SF_PIN,	5
    .equ SF_BIT,	5
    .equ SF_MASK,	(1 << SF_BIT)

	// Recursos utilizados por el septimo segmento
    .equ SG_PORT,	4
    .equ SG_PIN,	6
    .equ SG_BIT,	6
    .equ SG_MASK,	(1 << SG_BIT)

	// Recursos utilizados por los segmentos en general
    .equ SEG_GPIO,	2
    .equ SEG_MASK,	( SA_MASK | SB_MASK | SC_MASK | SD_MASK | SE_MASK | SF_MASK | SG_MASK )

    // Recursos utilizados por el octavo segmento (punto)
    .equ SDP_PORT,	6
    .equ SDP_PIN,	8
    .equ SDP_BIT,	16
    .equ SDP_MASK,	(1 << SDP_BIT)

	// Recursos utilizados por los segmentos en general
    .equ SDP_GPIO,	5
    .equ SDPP_MASK,	( SDP_MASK )

	// Recursos utilizados por el primer digito
    .equ D1_PORT,	0
    .equ D1_PIN,	0
    .equ D1_BIT,	0
    .equ D1_MASK,	(1 << D1_BIT)

	// Recursos utilizados por el segundo digito
    .equ D2_PORT,	0
    .equ D2_PIN,	1
    .equ D2_BIT,	1
    .equ D2_MASK,	(1 << D2_BIT)

	// Recursos utilizados por el tercer digito
    .equ D3_PORT,	1
    .equ D3_PIN,	15
    .equ D3_BIT,	2
    .equ D3_MASK,	(1 << D3_BIT)
    .equ D3_MAT,     1
    .equ D_TMR,     0

	// Recursos utilizados por el cuatro digito
    .equ D4_PORT,	1
    .equ D4_PIN,	17
    .equ D4_BIT,	3
    .equ D4_MASK,	(1 << D4_BIT)
    .equ D4_MAT,     0
    
	// Recursos utilizados por los digitos en general
    .equ DIG_GPIO,	0
    .equ DIG_MASK,	( D1_MASK | D2_MASK | D3_MASK | D4_MASK)

/****************************************************************************/
/* Vector de interrupciones
/****************************************************************************/

    .section .isr_vector
    .word   stack           //  0: Initial stack pointer value
    .word   reset+1         //  1: Initial program counter value: Program entry point
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
    .word   handler+1      // 15: System tick service routine
    .word   handler+1       // 16: Interrupt IRQ service routine

/****************************************************************************/
/* Handler por defecto para manejo de excepciones
/****************************************************************************/
    .section .text              // Define la seccion de codigo (FLASH)
    .func handler
handler:
loop:
    B loop
    .pool
    .endfunc

/****************************************************************************/
/* Programa principal
/****************************************************************************/
    .global reset               // Define el punto de entrada del codigo
    .func main

reset:
    // Configuración de los pines de segmentos como gpio sin pull-up
    LDR R1,=SCU_BASE
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    STR R0,[R1,#(SA_PORT << 7 | SA_PIN << 2)]
    STR R0,[R1,#(SB_PORT << 7 | SB_PIN << 2)]
    STR R0,[R1,#(SC_PORT << 7 | SC_PIN << 2)]
    STR R0,[R1,#(SD_PORT << 7 | SD_PIN << 2)]
    STR R0,[R1,#(SE_PORT << 7 | SE_PIN << 2)]
    STR R0,[R1,#(SF_PORT << 7 | SF_PIN << 2)]
    STR R0,[R1,#(SG_PORT << 7 | SG_PIN << 2)]

    // Configuración de los pines de digitos como gpio sin pull-up
    STR R0,[R1,#(D1_PORT << 7 | D1_PIN << 2)]
    STR R0,[R1,#(D2_PORT << 7 | D2_PIN << 2)]
    STR R0,[R1,#(D3_PORT << 7 | D3_PIN << 2)]
    STR R0,[R1,#(D4_PORT << 7 | D4_PIN << 2)]

    // Apagado de todos los bits gpio de los segmentos
    LDR R1,=GPIO_CLR0
    LDR R0,=SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]
    LDR R0,=SDPP_MASK
    STR R0,[R1,#(SDP_GPIO << 2)]

    // Apagado de todos bits gpio de los digitos
    LDR R0,=DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    // Configuración de los bits gpio de segmentos como salidas
    LDR R1,=GPIO_DIR0
    LDR R0,[R1,#(SEG_GPIO << 2)]
    ORR R0,#SEG_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    LDR R0,[R1,#(SDP_GPIO << 2)]
    ORR R0,#SDPP_MASK
    STR R0,[R1,#(SDP_GPIO << 2)]

    // Configuración de los bits gpio de digitos como salidas
    LDR R0,[R1,#(DIG_GPIO << 2)]
    ORR R0,#DIG_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

    LDR R1,=GPIO_PIN0
    LDR R0,=SA_MASK | SB_MASK | SC_MASK
    STR R0,[R1,#(SEG_GPIO << 2)]

    LDR R0,=D1_MASK | D2_MASK
    STR R0,[R1,#(DIG_GPIO << 2)]

stop:
    B stop

    .align
    .pool
    .endfunc
