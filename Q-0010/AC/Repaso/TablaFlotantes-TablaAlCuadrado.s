;   Escribir un programa Winmips que genere un arreglo (tabla1) de N números en punto flotante 
;   ingresados por el usuario desde el teclado, y otro arreglo (tabla2) con los elementos de tabla1 
;   elevados al cuadrado. Ambos arreglos deben almacenarse en memoria uno a continuación de otro. 
;   El ingreso de datos por el teclado se debe implementar en una subrutina. Una vez ingresados los
;   N valores y almacenados en memoria se debe generar el segundo arreglo. Esto debe implementarse a
;   través de otra  subrutina, que reciba como parámetros las direcciones de comienzo de tabla1 y tabla2.
;   Considerar N=12.

                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MSJ:            .asciiz "Ingrese un numero real: "
N:              .word 4
TABLA1:         .double 0.0

                .text
                lwu $s6, CONTROL($0)
                lwu $s7, DATA($0)

                ld $a0, N($0)
                daddi $a1, $0, TABLA1
                jal leerTabla

                ld $a0, N($0)
                daddi $a1, $0, TABLA1
                daddi $t0, $0, 8
                dmul $t0, $t0, $a0
                daddi $a2, $t0, TABLA1
                jal generarTabla2

                ld $a0, N($0)
                daddi $t0, $0, 8
                dmul $t0, $t0, $a0
                daddi $a1, $t0, TABLA1
                jal imprimirFloats
halt

leerTabla:      daddi $t1, $0, 4
                daddi $t2, $0, 8
ltLoop:         beqz $a0, ltFin
                daddi $a0, $a0, -1
                daddi $t0, $0, MSJ
                sd $t0, 0($s7)
                sd $t1, 0($s6)
                sd $t2, 0($s6)
                l.d f1, 0($s7)
                s.d f1, 0($a1)
                daddi $a1, $a1, 8
                j ltLoop
ltFin:          jr $ra


generarTabla2:  beqz $a0, gtFin
                daddi $a0, $a0, -1
                l.d f1, 0($a1)
                mul.d f2, f1, f1
                s.d f2, 0($a2)
                daddi $a1, $a1, 8
                daddi $a2, $a2, 8
                j generarTabla2
gtFin:          jr $ra

imprimirFloats: daddi $t0, $0, 3
iFLoop:         beqz $a0, iFFin
                daddi $a0, $a0, -1
                l.d f1, 0($a1)
                s.d f1, 0($s7)
                sd $t0, 0($s6)
                daddi $a1, $a1, 8
                j iFLoop
iFFin:          jr $ra
