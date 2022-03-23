                .data
CONTROL:        .word32 0x10000
DATA:           .word32 0x10008
MENU:           .asciiz ".TOOL   KEY\n.Mode:  space\n.Move:  wasd\n.Color: 1234567890"
COLORS:         .byte 255, 255, 255, 0      ; 0
                .byte 239,  71, 111, 0      ; 1
                .byte 247, 140, 107, 0      ; 2
                .byte 255, 209, 102, 0      ; 3
                .byte 131, 212, 131, 0      ; 4
                .byte   6, 214, 160, 0      ; 5
                .byte  12, 176, 169, 0      ; 6
                .byte  17, 138, 178, 0      ; 7
                .byte   7,  59, 200, 0      ; 8
                .byte   0,   0,   0, 0      ; 9
                .byte 127, 127, 127, 0      ; pointer Default
MATRIZ:         .byte 0


                .text
                lwu   $s6, CONTROL($0)
                lwu   $s7, DATA($0)
                daddi $s5, $0,  5           ; ctrl print Point
                dadd  $s0, $0,  $0          ; mode
                daddi $s1, $0,  80          ; color
                dadd  $s2, $0,  $0          ; x
                dadd  $s3, $0,  $0          ; y
                dadd  $s4, $0,  $0          ; pos
                daddi $t9, $0,  9           ; ctrl read Ascii

                daddi $t1, $0,  MENU
                daddi $t0, $0,  4           ; ctrl print String
                sd    $t1, 0($s7)
                sd    $t0, 0($s6)
                sd    $0,  0($s7)

                jal drawPoint

readKey:        sd    $t9, 0($s6)
                lbu   $a0, 0($s7)
                daddi $t1, $0,  32
                beq   $a0, $t1, changeMode
                slti  $t1, $a0, 48
                bnez  $t1, readKey
                slti  $t1, $a0, 58
                bnez  $t1, changeColor
                daddi $t1, $0,  65
                daddi $t2, $0,  97
                beq   $a0, $t1, movLeft
                beq   $a0, $t2, movLeft
                daddi $t1, $0,  68
                daddi $t2, $0,  100
                beq   $a0, $t1, movRight
                beq   $a0, $t2, movRight
                daddi $t1, $0,  83
                daddi $t2, $0,  115
                beq   $a0, $t1, movDown
                beq   $a0, $t2, movDown
                daddi $t1, $0,  87
                daddi $t2, $0,  119
                beq   $a0, $t1, movUp
                beq   $a0, $t2, movUp
                j     readKey


changeMode:     beqz  $s0, toDraw
                dadd  $s0, $0,  $0
                daddi $s1, $0,  80
                jal   drawPoint
                j     readKey
toDraw:         daddi $s0, $0,  1
                jal   savePoint
                j     readKey


changeColor:    daddi $t0, $a0, -48
                daddi $t1, $0,  8
                dmul  $t2, $t0, $t1
                dadd  $s1, $0,  $t2
                jal   drawPoint
                beqz  $s0, readKey
                jal   savePoint
                j     readKey


movLeft:        slti  $t0, $s2, 1
                bnez  $t0, readKey
                bnez  $s0, mLNoReset
                jal   resetPoint
mLNoReset:      daddi $s2, $s2, -1
                daddi $s4, $s4, -1
                jal   drawPoint
                beqz  $s0, readKey
                jal   savePoint
                j     readKey

movRight:       slti  $t0, $s2, 49
                beqz  $t0, readKey
                bnez  $s0, mRNoReset
                jal   resetPoint
mRNoReset:      daddi $s2, $s2, 1
                daddi $s4, $s4, 1
                jal   drawPoint
                beqz  $s0, readKey
                jal   savePoint
                j     readKey

movDown:        slti  $t0, $s3, 1
                bnez  $t0, readKey
                bnez  $s0, mDNoReset
                jal   resetPoint
mDNoReset:      daddi $s3, $s3, -1
                daddi $s4, $s4, -50
                jal   drawPoint
                beqz  $s0, readKey
                jal   savePoint
                j     readKey

movUp:          slti  $t0, $s3, 49
                beqz  $t0, readKey
                bnez  $s0, mUNoReset
                jal   resetPoint
mUNoReset:      daddi $s3, $s3, 1
                daddi $s4, $s4, 50
                jal   drawPoint
                beqz  $s0, readKey
                jal   savePoint
                j     readKey




resetPoint:     lbu   $t0, MATRIZ($s4)
                lwu   $t1, COLORS($t0)
                sw    $t1, 0($s7)
                sb    $s2, 5($s7)
                sb    $s3, 4($s7)
                sd    $s5, 0($s6)
                jr    $ra

savePoint:      sb    $s1, MATRIZ($s4)
                jr    $ra

drawPoint:      lwu   $t1, COLORS($s1)
                sw    $t1, 0($s7)
                sb    $s2, 5($s7)
                sb    $s3, 4($s7)
                sd    $s5, 0($s6)
                jr    $ra
