;   El siguiente programa produce una salida estableciendo el color de
;   un punto de la pantalla gráfica (en la ventana Terminal
;   del simulador WinMIPS64). Modifique el programa de modo que las
;   coordenadas y color del punto sean ingresados por teclado.
;               .data
;   coorX:      .byte 24 ; coordenada X de un punto
;   coorY:      .byte 24 ; coordenada Y de un punto
;   color:      .byte 255, 0, 255, 0 ; color: máximo rojo + máximo azul => magenta
;   CONTROL:    .word32 0x10000
;   DATA:       .word32 0x10008
;
;           .text
;           lwu $s6, CONTROL($zero) ; $s6 = dirección de CONTROL
;           lwu $s7, DATA($zero) ; $s7 = dirección de DATA
;           daddi $t0, $zero, 7 ; $t0 = 7 -> función 7: limpiar pantalla gráfica
;           sd $t0, 0($s6) ; CONTROL recibe 7 y limpia la pantalla gráfica
;           lbu $s0, coorX($zero) ; $s0 = valor de coordenada X
;           sb $s0, 5($s7) ; DATA+5 recibe el valor de coordenada X
;           lbu $s1, coorY($zero) ; $s1 = valor de coordenada Y
;           sb $s1, 4($s7) ; DATA+4 recibe el valor de coordenada Y
;           lwu $s2, color($zero) ; $s2 = valor de color a pintar
;           sw $s2, 0($s7) ; DATA recibe el valor del color a pintar
;           daddi $t0, $zero, 5 ; $t0 = 5 -> función 5: salida gráfica
;           sd $t0, 0($s6) ; CONTROL recibe 5 y produce el dibujo del punto
;           halt


                .data
coorX:          .byte 0
coorY:          .byte 0
color:          .byte 255, 0, 255, 0
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MSJCOORX:       .asciiz "Coordenada X: "
MSJCOORY:       .asciiz "Coordenada Y: "
MSJR:           .asciiz "Valor Red: "
MSJG:           .asciiz "Valor Green: "
MSJB:           .asciiz "Valor Blue: "

                .text
                lwu $s6, CONTROL($zero) ; $s6 = dirección de CONTROL
                lwu $s7, DATA($zero) ; $s7 = dirección de DATA
                jal readPoint
                jal readRGB
                daddi $t0, $zero, 7 ; $t0 = 7 -> función 7: limpiar pantalla gráfica
                sd $t0, 0($s6) ; CONTROL recibe 7 y limpia la pantalla gráfica
                lbu $s0, coorX($zero) ; $s0 = valor de coordenada X
                sb $s0, 5($s7) ; DATA+5 recibe el valor de coordenada X
                lbu $s1, coorY($zero) ; $s1 = valor de coordenada Y
                sb $s1, 4($s7) ; DATA+4 recibe el valor de coordenada Y
                lwu $s2, color($zero) ; $s2 = valor de color a pintar
                sw $s2, 0($s7) ; DATA recibe el valor del color a pintar
                daddi $t0, $zero, 5 ; $t0 = 5 -> función 5: salida gráfica
                sd $t0, 0($s6) ; CONTROL recibe 5 y produce el dibujo del punto
halt

readByte:       sd $t0, 0($s6)
                daddi $t0, $0, 8
                sd $t0, 0($s6)
                lb $v0, 0($s7)
                jr $ra

readPoint:      dadd $s0, $ra, $0
                daddi $t0, $0, MSJCOORX
                sd $t0, 0($s7)
                daddi $t0, $0, 4
                jal readByte
                sb $v0, coorX($0)
                daddi $t0, $0, MSJCOORY
                sd $t0, 0($s7)
                daddi $t0, $0, 4
                jal readByte
                sb $v0, coorY($0)
                dadd $ra, $s0, $0
                jr $ra

readRGB:        dadd $s0, $ra, $0
                dadd $s1, $0, $0
                daddi $t0, $0, MSJR
                sd $t0, 0($s7)
                daddi $t0, $0, 4
                jal readByte
                sb $v0, color($s1)
                daddi $s1, $s1, 1
                daddi $t0, $0, MSJG
                sd $t0, 0($s7)
                daddi $t0, $0, 4
                jal readByte
                sb $v0, color($s1)
                daddi $s1, $s1, 1
                daddi $t0, $0, MSJB
                sd $t0, 0($s7)
                daddi $t0, $0, 4
                jal readByte
                sb $v0, color($s1)
                dadd $ra, $s0, $0
                jr $ra
            