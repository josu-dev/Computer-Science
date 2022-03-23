;   El siguiente programa implementa una animación de una pelotita
;   rebotando por la pantalla. Modifíquelo para que en lugar
;   de una pelotita, se muestren simultáneamente varias pelotitas
;   (cinco, por ejemplo), cada una con su posición, dirección y
;   color particular.

                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
color_fondo:    .word32 0x00FFFFFF
COLORES:        .word32 0x004335CB, 0x007D3C98, 0x002E86C1, 0x0028B463, 0x00D68910
POS:            .byte 0,0, 0,0, 0,0, 0,0, 0,0
DIR:            .byte 1,2, 1,4, 2,1, 4,1, 2,4

                .text
                lwu $s6, CONTROL($0)
                lwu $s7, DATA($0)
                lwu $v1, color_fondo($0)

                dadd $a0, $0, $0
                dadd $a1, $0, $0
                daddi $t7, $0, 5
                
                daddi $s4, $0, 5 ; Comando para dibujar un punto
reset:          daddi $t0, $0, 7
                sd $t0, 0($s6)
loop:           jal loadBall
                dadd $s0, $s0, $s2 ; Mueve la pelota en la dirección actual
                dadd $s1, $s1, $s3
                daddi $t1, $0, 48 ; Comprueba que la pelota no esté en la columna de más
                slt $t0, $t1, $s0 ; a la derecha. Si es así, cambia la dirección en X.
                dsll $t0, $t0, 1
                dsub $s2, $s2, $t0
                slt $t0, $t1, $s1 ; Comprueba que la pelota no esté en la fila de más arriba.
                dsll $t0, $t0, 1 ; Si es así, cambia la dirección en Y.
                dsub $s3, $s3, $t0
                slti $t0, $s0, 1 ; Comprueba que la pelota no esté en la columna de más
                dsll $t0, $t0, 1 ; a la izquierda. Si es así, cambia la dirección en X.
                dadd $s2, $s2, $t0
                slti $t0, $s1, 1 ; Comprueba que la pelota no esté en la fila de más abajo.
                dsll $t0, $t0, 1 ; Si es así, cambia la dirección en Y.
                dadd $s3, $s3, $t0


                sw $v0, 0($s7) ; Dibuja la pelota.
                sb $s0, 4($s7)
                sb $s1, 5($s7)
                sd $s4, 0($s6)

                jal saveBall

                daddi $a0, $a0, 1
                daddi $a1, $a1, 4
                daddi $t7, $t7, -1
                bnez $t7, loop
                daddi $t7, $0, 5
                daddi $a0, $0, 0
                daddi $a1, $0, 0

                daddi $t0, $0, 2043 ; Hace una demora para que el rebote no sea tan rápido.
demora:         daddi $t0, $t0, -1 ; Esto genera una infinidad de RAW y BTS pero...
                bnez $t0, demora ; ¡hay que hacer tiempo igualmente!
                j reset

loadBall:       lwu $v0, COLORES($a1)
                lb $s0, POS($a0) ; Coordenada X de la pelota
                lb $s2, DIR($a0) ; Dirección X de la pelota
                daddi $a0, $a0, 1
                lb $s1, POS($a0) ; Coordenada Y de la pelota
                lb $s3, DIR($a0) ; Dirección Y de la pelota
                jr $ra
saveBall:       daddi $a0, $a0, -1
                sb $s0, POS($a0) ; Coordenada X de la pelota
                sb $s2, DIR($a0) ; Dirección X de la pelota
                daddi $a0, $a0, 1
                sb $s1, POS($a0) ; Coordenada Y de la pelota
                sb $s3, DIR($a0) ; Dirección Y de la pelota
                jr $ra


