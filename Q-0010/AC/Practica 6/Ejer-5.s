;   Escriba un programa que calcule el resultado de elevar un valor
;   en punto flotante a la potencia indicada por un exponente
;   que es un número entero positivo. Para ello, en el programa principal
;   se solicitará el ingreso de la base (un número en
;   punto flotante) y del exponente (un número entero sin signo) y se
;   deberá utilizar la subrutina a_la_potencia para
;   calcular el resultado pedido (que será un valor en punto flotante).
;   Tenga en cuenta que cualquier base elevada a la 0 da
;   como resultado 1. Muestre el resultado numérico de la operación en la
;   salida estándar del simulador (ventana Terminal).


                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MSJFLO:         .asciiz "Ingrese la base: "
MSJINT:         .asciiz "Ingrese el exponente: "
MSJRES:         .asciiz "Resultado: "
BASE:           .double 0.0
EXP:            .word 0
RES:            .double 0.0

                .text
                lwu $s0, DATA($0)
                lwu $s1, CONTROL($0)

main:           jal readFloat
                jal readInt
                dadd $a1, $v0, $0
                jal potencia
                s.d f2, RES($0)
                jal showResult
halt


readFloat:      daddi $t0, $0, MSJFLO
                sd $t0, 0($s0)
                daddi $t0, $0, 4
                sd $t0, 0($s1)
                daddi $t0, $0, 8
                sd $t0, 0($s1)
                l.d f1, 0($s0)
                jr $ra

readInt:        daddi $t0, $0, MSJINT
                sd $t0, 0($s0)
                daddi $t0, $0, 4
                sd $t0, 0($s1)
                daddi $t0, $0, 8
                sd $t0, 0($s1)
                ld $v0, 0($s0)
                jr $ra

potencia:       daddi $t0, $0, 1
                mtc1 $t0, f2
                cvt.d.l f2, f2
potenciaLoop:   beq $a1, $0, potenciaRet
                mul.d f2, f2, f1
                daddi $a1, $a1, -1
                j potenciaLoop
potenciaRet:    jr $ra


showResult:     daddi $t0, $0, MSJRES
                sd $t0, 0($s0)
                daddi $t0, $0, 4
                sd $t0, 0($s1)
                l.d f1, RES($0)
                s.d f1, 0($s0)
                daddi $t0, $0, 3
                sd $t0, 0($s1)
                jr $ra