/* Copyright 2016, Laboratorio de Microprocesadores 
 * Facultad de Ciencias Exactas y Tecnología 
 * Universidad Nacional de Tucuman
 * http://www.microprocesadores.unt.edu.ar/
 * Copyright 2016, Esteban Volentini <evolentini@gmail.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

    .cpu cortex-m4              // Indica el procesador de destino  
    .syntax unified             // Habilita las instrucciones Thumb-2
    .thumb                      // Usar instrucciones Thumb y no ARM

    .include "configuraciones/lpc4337.s"

    .section .data

max:
    .word 0x186A0
/**
* Programa principal, siempre debe ir al principio del archivo
*/
    .section .text              // Define la seccion de codigo (FLASH)
    .global reset               // Define el punto de entrada del codigo

    .func main

reset:
    BL configurar
    MOV R2,#0
    LDR R3,=max
    LDR R3,[R3]

reloj:
    ADD R2,#1
    CMP R2,R3
    BNE reloj
    
    // Carga en R0 el valor a mostrar
    LDR R1,=GPIO_PIN2
    LDR R0,=0xF7
    STR R0,[R1]

    // Prende el digito 1
    LDR R1,=GPIO_PIN0
    LDR R0,=0x01
    STR R0,[R1]
    
    MOV R2,#0

segundo:
    ADD R2,#1
    CMP R2,R3
    BNE segundo

    // Carga en R0 el valor a mostrar
    LDR R1,=GPIO_PIN2
    LDR R0,=0x38
    STR R0,[R1]

    // Prende el digito 2
    LDR R1,=GPIO_PIN0
    LDR R0,=0x02
    STR R0,[R1]

    MOV R2,#0

tercero:
    ADD R2,#1
    CMP R2,R3
    BNE tercero

    // Carga en R0 el valor a mostrar
    LDR R1,=GPIO_PIN2
    LDR R0,=0xBF
    STR R0,[R1]

    // Prende el digito 3
    LDR R1,=GPIO_PIN0
    LDR R0,=0x04
    STR R0,[R1]

    MOV R2,#0

cuarto:
    ADD R2,#1
    CMP R2,R3
    BNE cuarto

    // Carga en R0 el valor a mostrar
    LDR R1,=GPIO_PIN2
    LDR R0,=0xF6
    STR R0,[R1]

    // Prende el digito 4
    LDR R1,=GPIO_PIN0
    LDR R0,=0x08
    STR R0,[R1]

    MOV R2,#0
    B reloj
stop:
    B stop              // Lazo infinito para terminar la ejecucion

    .align
    .pool
    .endfunc

/**
* Inclusion de las funciones para configurar los teminales GPIO del procesador
*/
    .include "ejemplos/digitos.s"
