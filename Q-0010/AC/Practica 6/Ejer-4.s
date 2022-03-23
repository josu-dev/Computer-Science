;   Escriba un programa que solicite el ingreso por teclado de una clave
;   (sucesión de cuatro caracteres) utilizando la
;   subrutina char de ingreso de un carácter. Luego, debe comparar la
;   secuencia ingresada con una cadena almacenada en la
;   variable clave. Si las dos cadenas son iguales entre si, la subrutina
;   llamada respuesta mostrará el texto “Bienvenido”
;   en la salida estándar del simulador (ventana Terminal). En cambio,
;   si las cadenas no son iguales, la subrutina deberá
;   mostrar “ERROR” y solicitar nuevamente el ingreso de la clave.


                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MSJ_ING:        .asciiz "Ingrese la clave: "
MSJ_NO:         .asciiz "\nERROR"
MSJ_SI:         .asciiz "\nBIENVENIDO"
CLAVE:          .asciiz "i<3u"
CLAVEING:       .ascii ""

                .text
                lwu $s0, DATA($0)
                lwu $s1, CONTROL($0)

main:           jal readKey
                daddi $a0, $0, CLAVEING
                daddi $a1, $0, CLAVE
                jal equals
                dadd $a0, $v0, $0
                jal respond
halt


readKey:        daddi $t0, $0, MSJ_ING
                sd $t0, 0($s0)
                daddi $t0, $0, 4
                sd $t0, 0($s1)
                dadd $t3, $0, $0
                daddi $t4, $0, 4
readKeyLoop:    daddi $t0, $0, 9
                sd $t0, 0($s1)
                lbu $t1, 0($s0)
                sb $t1, CLAVEING($t3)
                daddi $t3, $t3, 1
                bne $t3, $t4, readKeyLoop
                sb $0, CLAVEING($t3)
                jr $ra


equals:         daddi $t0, $0, -1
equalsLoop:     daddi $t0, $t0, 1
                lbu $t1, 0($a0)
                lbu $t2, 0($a1)
                daddi $a0, $a0, 1
                daddi $a1, $a1, 1
                beq $t1, $0, equalsLast
                beq $t2, $0, equalsLast
                beq $t1, $t2, equalsLoop
equalsLast:     beq $t1, $t2, equalsRet
                dadd $v0, $0, $t0
                jr $ra
equalsRet:       daddi $v0, $0, -1
                jr $ra


respond:        slti $t0, $a0, 0
                beq $t0, $0, respondNo
                daddi $t0, $0, MSJ_SI
                sd $t0, 0($s0)
                daddi $t1, $0, 4
                sd $t1, 0($s1)
                jr $ra
respondNo:      daddi $t0, $0, MSJ_NO
                sd $t0, 0($s0)
                daddi $t1, $0, 4
                sd $t1, 0($s1)
                j main
