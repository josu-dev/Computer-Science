;   Escriba un programa que realice la suma de dos números enteros
;   (de un dígito cada uno) utilizando dos subrutinas: La
;   denominada ingreso del ejercicio anterior (ingreso por teclado
;   de un dígito numérico) y otra denominada resultado,
;   que muestre en la salida estándar del simulador (ventana Terminal)
;   el resultado numérico de la suma de los dos números
;   ingresados (ejercicio similar al ejercicio 7 de Práctica 2).


                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MSJ_ING:        .asciiz "Ingrese un numero: "
ENTER:          .word 0
DIG_1:          .word 0
DIG_2:          .word 0

                .text
                j main

ingreso:        lwu $s1, CONTROL($0)

                lwu $s0, DATA($0)
                daddi $t0, $0, MSJ_ING
                sd $t0, 0($s0)

                daddi $t0, $zero, 4
                sd $t0, 0($s1)

                daddi $t0, $zero, 9
                sd $t0, 0($s1)

                lbu $t1, 0($s0)

                daddi $t0, $t1, 2560
                sd $t0, ENTER($0)
                daddi $t0, $0, ENTER
                sd $t0, 0($s0)

                daddi $t0, $zero, 4
                sd $t0, 0($s1)

                dadd $t0, $t1, $0
                slti $t1, $t0, 48
                bne $t1, $0, ingreso
                slti $t1, $t0, 58
                beq $t1, $0, ingreso

                daddi $v0, $t0, -48
                jr $ra

resultado:      lwu $s0, DATA($0)
                sd $a0, 0($s0)

                lwu $s1, CONTROL($0)
                daddi $t0, $0, 1
                sd $t0, 0($s1)

                jr $ra

main:           jal ingreso
                sd $v0, DIG_1($0)
                jal ingreso
                sd $v0, DIG_2($0)

                ld $t0, DIG_1($0)
                ld $t1, DIG_2($0)
                dadd $a0, $t0, $t1
                jal resultado
                j main
halt