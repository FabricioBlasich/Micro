	
    .cpu cortex-m4              // Indica el procesador de destino 
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM
    .include "configuraciones/lpc4337.s"

/**
 * Vector de interrupciones
 */
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

/**
 * Handler por defecto para manejo de excepciones
 */
    .section .text              // Define la seccion de codigo (FLASH)
    .func handler
handler:
loop:
    B loop
    .pool
    .endfunc

    .global reset               // Define el punto de entrada del codigo
    .func main

reset:
    MOV R0,#(SCU_MODE_INACT | SCU_MODE_INBUFF_EN | SCU_MODE_ZIF_DIS | SCU_MODE_FUNC0)
    LDR R1,=SCU_SFSP2_12
    STR R0,[R1],#4

    MOV R0,#(1 << 12)
    LDR R1,=(GPIO_CLR1)
    STR R0,[R1]
    LDR R1,=(GPIO_DIR1)
    STR R0,[R1]

lazo:
    MOV R0,#(1 << 12)
    LDR R1,=(GPIO_NOT1)
    STR R0,[R1]
    
    LDR R4,=10000
delay:
    SUBS R4,#1
    BNE delay
    B lazo

    .align
    .pool
    .endfunc
