;   Escriba un programa que le permita dibujar en la pantalla gráfica
;   de la terminal. Deberá mostrar un cursor (representado
;   por un punto de un color particular) que pueda desplazarse por
;   la pantalla usando las teclas ‘a’, ‘s’, ‘d’ y ‘w’ para ir a la
;   izquierda, abajo, a la derecha y arriba respectivamente. Usando
;   la barra espaciadora se alternará entre modo
;   desplazamiento (el cursor pasa por arriba de lo dibujado sin alterarlo)
;   y modo dibujo (cada punto por el que el cursor pasa
;   quedarwá pintado del color seleccionado). Las teclas del ‘1’ al ‘8’
;   se usarán para elegir uno entre los ocho colores
;   disponibles para pintar.
;   Observaciones: Para poder implementar este programa, se
;   necesitará almacenar en la memoria la imagen completa de la
;   pantalla gráfica.
;   Si cada punto está representado por un byte, se necesitarán
;   50x50x1 = 2500 bytes. El simulador WinMIPS64 viene
;   configurado para usar un bus de datos de 10 bits, por lo que la
;   memoria disponible estará acotada a 210=1024 bytes.
;   Para poder almacenar la imagen, será necesario configurar el
;   simulador para usar un bus de datos de 12 bits, ya que 212=4096
;   bytes, los que si resultarán suficientes. La configuración se
;   logra yendo al menú “Configure  Architecture” y poniendo
;   “Data Address Bus” en 12 bits en lugar de los 10 bits que trae
;   por defecto.


                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
KEYS:           .asciiz "wasd 12345678"
COLORES:        .word32 0x00FFFFFF, 0x006F47EF, 0x006B8CF7, 0x0066D1FF, 0x0083D483, 0x00A0D606, 0x00A9B00C, 0x00B28A11, 0x004C3B07, 0x00000000
MATRIZ:         .byte 0


                .text
                lwu $s6, CONTROL($0)
                lwu $s7, DATA($0)
                daddi $s5, $0, 4
                dadd $s0, $0, $0 ; modo
                daddi $s1, $0, 9 ; color
                dadd $s3, $0, $0 ; x
                dadd $s4, $0, $0 ; y

main:           jal readKey
                dadd $a0, $v0, $0
                jal actStats
                jal drawPoint
                j main

readKey:        daddi $t0, $0, 9
                sd $t0, 0($s6)
                lbu $v0, 0($s7)
                dadd $t0, $0, $0
readKeyLoop:    lbu $t1, KEYS($t0)
                beqz $t1, readKey
                beq $v0, $t1, readKeyRet
                daddi $t0, $t0, 1
                j readKeyLoop
readKeyRet:     jr $ra


actStats:       daddi $t1, $a0, -32
                beqz $t1, actMode
                slti $t1, $a0, 58
                bnez $t1, actColor
                bnez $s0, checkA
                dadd $t7, $ra, $0
                jal resetPoint
                dadd $ra, $t7, $0

checkA:         daddi $t1, $a0, -97
                bnez $t1, checkD
                daddi $s3, $s3, -1
                j actStatsRet
checkD:         daddi $t1, $a0, -100
                bnez $t1, checkS
                daddi $s3, $s3, 1
                j actStatsRet
checkS:         daddi $t1, $a0, -115
                bnez $t1, checkW
                daddi $s4, $s4, -1
                j actStatsRet
checkW:         daddi $s4, $s4, 1
                j actStatsRet

actMode:        beqz $s0, changeMode
                dadd $s0, $0, $0
                daddi $s1, $0, 9
                dadd $t7, $ra, $0
                jal resetPoint
                dadd $ra, $t7, $0
                j actStatsRet
changeMode:     daddi $s0, $0, 1
                j actStatsRet

actColor:       daddi $s1, $a0, -48
                
actStatsRet:    jr $ra

resetPoint:     daddi $t1, $0, 50
                dmul $t1, $t1, $s4
                dadd $t1, $t1, $s3
                lbu $s2, MATRIZ($t1)
                dadd $t2, $0, $0
                lwu $t2, COLORES($s2)
                sw $t2, 0($s7)
                sb $s3, 5($s7)
                sb $s4, 4($s7)
                daddi $t0, $0, 5
                sd $t0, 0($s6)
                jr $ra

drawPoint:      slti $t0, $s3, 0
                beqz $t0, checkRight
                dadd $s3, $s0, $s0
                j checkBottom
checkRight:     slti $t0, $s3, 50
                bnez $t0, checkBottom
                daddi $s3, $s0, 49
checkBottom:    slti $t0, $s4, 0
                beqz $t0, checkTop
                dadd $s4, $s0, $s0
                j markPoint
checkTop:       slti $t0, $s4, 50
                bnez $t0, markPoint
                daddi $s4, $s0, 49

markPoint:      dmul $t1, $s1, $s5
                dadd $t0, $0, $0
                lwu $t0, COLORES($t1)
                sw $t0, 0($s7)
                sb $s3, 5($s7)
                sb $s4, 4($s7)
                daddi $t0, $0, 5
                sd $t0, 0($s6)
                beqz $s0, drawPointRet

                daddi $t1, $0, 50
                dmul $t1, $t1, $s4
                dadd $t1, $t1, $s3

                sb $s1, MATRIZ($t1)

drawPointRet:   jr $ra    