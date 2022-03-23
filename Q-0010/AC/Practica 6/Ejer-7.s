;   Se desea realizar la demostración de la transformación de un
;   carácter codificado en ASCII a su visualización en una
;   matriz de puntos con 7 columnas y 9 filas. Escriba un programa
;   que realice tal demostración, solicitando el ingreso por
;   teclado de un carácter para luego mostrarlo en la pantalla
;   gráfica de la terminal.


                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
TABLALADOS:     .byte 2,8, 3,8, 4,8, 0,0, 0,0, 0,0, 0,0, 0,0
                .byte 5,7, 5,6, 5,5, 0,0, 0,0, 0,0, 0,0, 0,0
                .byte 5,4, 5,3, 5,2, 0,0, 0,0, 0,0, 0,0, 0,0
                .byte 2,1, 3,1, 4,1, 0,0, 0,0, 0,0, 0,0, 0,0
                .byte 1,4, 1,3, 1,2, 0,0, 0,0, 0,0, 0,0, 0,0
                .byte 1,7, 1,6, 1,5, 0,0, 0,0, 0,0, 0,0, 0,0
                .byte 2,5, 3,5, 4,5, 0,0, 0,0, 0,0, 0,0, 0,0
TABLA_NUM:      .asciiz "abcdef"
                .asciiz "bc"
                .asciiz "abdeg"
                .asciiz "abcdg"
                .asciiz "bcfg"
                .asciiz "acdfg"
                .asciiz "acdefg"
                .asciiz "abc"
                .asciiz "abcdefg"
                .asciiz "abcfg"
COLOR:          .byte 0,0,0,0
MSJ_ING:        .asciiz "Numero a dibujar: "
ENTER:          .asciiz " \n"


                .text
                daddi $sp, $zero, 0x400
                lwu $s6, CONTROL($0)
                lwu $s7, DATA($0)
                daddi $t0, $0, 7
                sd $t0, 0($s6)
                jal ingreso
                dadd $a0, $v0, $0
                jal draw
halt



actListPoints:  lwu $t0, COLOR($0)
                sw $t0, 0($s7)
actLoop:        lbu $t0, 0($a0)
                sb $t0, 5($s7)
                daddi $a0, $a0, 1
                lbu $t0, 0($a0)
                sb $t0, 4($s7)
                daddi $a0, $a0, 1
                daddi $t0, $0, 5
                sd $t0, 0($s6)
                lbu $t0, 0($a0)
                bnez $t0, actLoop
                jr $ra

draw:           daddi $sp, $sp, -8
                sd $ra, 0($sp)

                daddi $t3, $0, 16
                daddi $s0, $0, 8
                daddi $t1, $0, TABLA_NUM
                dmul $s0, $s0, $a0
                dadd $s0, $s0, $t1
drawLoop:       lbu $t2, 0($s0)
                beqz $t2, drawRet
                daddi $t2, $t2, -97
                dmul $t2, $t2, $t3
                daddi $a0, $t2, TABLALADOS
                jal actListPoints
                daddi $s0, $s0, 1
                j drawLoop

drawRet:        ld $ra, 0($sp)
                daddi $sp, $sp, 8
                jr $ra




ingreso:        daddi $t0, $0, MSJ_ING
                sd $t0, 0($s7)

                daddi $t0, $0, 4
                sd $t0, 0($s6)

                daddi $t0, $0, 9
                sd $t0, 0($s6)

                lbu $t1, 0($s7)
                sb $t1, ENTER($0)
                daddi $t0, $0, ENTER
                sd $t0, 0($s7)

                daddi $t0, $0, 4
                sd $t0, 0($s6)

                dadd $t0, $t1, $0
                slti $t1, $t0, 48
                bne $t1, $0, ingreso
                slti $t1, $t0, 58
                beq $t1, $0, ingreso

                daddi $v0, $t0, -48
                jr $ra

