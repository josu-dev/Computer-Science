;   Escriba un programa que utilice sucesivamente dos subrutinas:
;   La primera, denominada ingreso, debe solicitar el
;   ingreso por teclado de un número entero (de un dígito),
;   verificando que el valor ingresado realmente sea un dígito. La
;   segunda, denominada muestra, deberá mostrar en la salida estándar
;   del simulador (ventana Terminal) el valor del
;   número ingresado expresado en letras (es decir, si se ingresa
;   un ‘4’, deberá mostrar ‘CUATRO’). Establezca el pasaje de
;   parámetros entre subrutinas respetando las convenciones para el
;   uso de los registros y minimice las detenciones del cauce
;   (ejercicio similar al ejercicio 6 de Práctica 2).

                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MSJ_ING:        .asciiz "Ingrese un numero: "
ENTER:          .word 0
TABLA_NUM:      .asciiz "CERO\n"
                .asciiz "UNO\n"
                .asciiz "DOS\n"
                .asciiz "TRES\n"
                .asciiz "CUATRO\n"
                .asciiz "CINCO\n"
                .asciiz "SEIS\n"
                .asciiz "SIETE\n"
                .asciiz "OCHO\n"
                .asciiz "NUEVE\n"
DIG_ING:        .word 0

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

muestra:        daddi $t0, $0, 8
                dmul $t0, $t0, $a1
                dadd $t0, $t0, $a0

                lwu $s0, DATA($0)
                sd $t0, 0($s0)

                lwu $s1, CONTROL($0)
                daddi $t0, $0, 4
                sd $t0, 0($s1)

                jr $ra

main:           jal ingreso
                sd $v0, DIG_ING($0)
                daddi $a0, $0, TABLA_NUM
                ld $a1, DIG_ING($0)
                jal muestra
                j main
halt