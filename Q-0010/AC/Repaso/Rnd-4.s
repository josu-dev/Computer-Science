.data
    CONTROL: .word 0x10000
    DATA:    .word 0x10008
    A: .word 0
    B: .word 0
    C: .word 0
    RESUL: .word 0
    MENSAJE:      .asciiz " INGRESE UN NUMERO: "
    MINFORME:   .asciiz " EL RESULTADO ES: "

.code
    LD $s0, CONTROL ($0)    
    LD $s1, DATA ($0)
    DADDI $s2, $s2, 2           ; MOSTRAR ENTERO
    DADDI $s3, $s3, 4           ; IMPRIMIR
    DADDI $s4, $s4, MENSAJE
    DADDI $s5, $s5, 8           ; LEER

    daddi $a0, $0, A
    jal LECTURA


    DADDI $t0, $0, 0
    ld $t1, A($0) 
    ld $t2, B($0) 
    DADD $t4, $t1, $t2      ; A + B
    
    ld $t3, C($0)
    DADDI $t0, $t0 ,1
    LOOP: BEQZ $t3, TERMINO
        dmul $t0, $t0, $t4  
        DADDI $t3, $t3, -1        
    J LOOP
    TERMINO: SD $t0, RESUL ($0)
    
    daddi $a0, $0, RESUL
    jal INFORMAR

HALT

            
LECTURA:    daddi $t2, $a0, 24
LLOOP:      SD $s4, 0($s1)              
            SD $s3, 0($s0)

            SD $s5, 0 ($s0)             
            LD $t1, 0 ($s1)             
            SD $t1, 0($a0)
            daddi $a0, $a0, 8
            bne $a0, $t2, LLOOP
            jr $ra

INFORMAR:   daddi $t0, $0, MINFORME
            SD $t0, 0($s1)         
            SD $s3, 0($s0)

            ld $t0, 0($a0)
            SD $t0, 0($s1)
            daddi $t0, $0, 2     
            SD $t0, 0($s0)
            jr $ra
