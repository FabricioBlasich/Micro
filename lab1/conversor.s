            .cpu cortex-m4
            .syntax unified
            .thumb
            .section .data

origen:     .byte 6,2,8,5,7
            .space 15, 0xFF
destino:    .space 10, 0x00
            .section text
            .global reset
reset:      LDR R0, =origen
            LDR R1, =destino
            LDR R2, =tabla
lazo:       LDRB R2,[R0],#1
            CMP R2,0xFF
            BEQ final
            LDRB R2,[R3,R2]
            STRB R2,[R1],#1
            B   lazo
final:      STRB R2,[R1]
stop:       B   stop    
            .pool
tabla:      .byte 0xFC,0x60,0xDA,0xF2,0x66
            .byte 0xB6,0xBE,0xE0,0xFE,0xF6