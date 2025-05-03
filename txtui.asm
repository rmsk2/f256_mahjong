txtui .namespace

locateAddr .macro x_pos, y_pos
    lda \x_pos
    sta CURSOR_STATE.xPos
    lda \y_pos
    sta CURSOR_STATE.yPos
    jsr txtio.cursorSet
.endmacro

printStringAddr .macro address, length
    lda (TXTUI_PTR)
    sta TXT_PTR3
    ldy #1
    lda (TXTUI_PTR), y
    sta TXT_PTR3 + 1
    lda LINE_LEN
    jsr txtio.printStr
.endmacro


UL = 169
UR = 170
LL = 171
LR = 172
ML = 164
MR = 168
H = 173
V = 174

LINE1 .byte UL, H, H, H, H, H, H, H, UR
LINE2 .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINE3 .byte V, ' ', 'U', 'N', 'D', 'O', ' ', ' ', V
LINE4 .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINE5 .byte ML, H, H, H, H, H, H, H, MR
LINE6 .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINE7 .byte V, 'R', 'E', 'S', 'T', 'O', 'R', 'E', V
LINE8 .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINE9 .byte ML, H, H, H, H, H, H, H, MR
LINEb .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEc .byte V, 'S', 'O', 'L', 'V', 'B', 'L', 'E', V
LINEd .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEe .byte ML, H, H, H, H, H, H, H, MR
LINEf .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEg .byte V, 'R', 'A', 'N', 'D', 'O', 'M', ' ', V
LINEh .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEi .byte ML, H, H, H, H, H, H, H, MR
LINEj .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEk .byte V, ' ', ' ', 'N', 'E', 'W', ' ', ' ', V
LINEl .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEm .byte ML, H, H, H, H, H, H, H, MR
LINEn .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEo .byte V, ' ', ' ', 'E', 'N', 'D', ' ', ' ', V
LINEp .byte V, ' ', ' ', ' ', ' ', ' ', ' ', ' ', V
LINEq .byte LL, H, H, H, H, H, H, H, LR

START_X .byte 71
START_Y .byte 20
LINE_LEN .byte 9

LINE_DATA
    .word LINE1
    .word LINE2
    .word LINE3
    .word LINE4
    .word LINE5
    .word LINE6
    .word LINE7
    .word LINE8
    .word LINE9
    .word LINEb
    .word LINEc
    .word LINEd
    .word LINEe
    .word LINEf
    .word LINEg
    .word LINEh
    .word LINEi
    .word LINEj
    .word LINEk
    .word LINEl
    .word LINEm
    .word LINEn
    .word LINEo
    .word LINEp
    .word LINEq
    .word 0


COUNT_Y .byte 0
COUNT_LINE .word 0
COL_TEMP .word 0
drawButtons
    lda CURSOR_STATE.col
    sta COL_TEMP
    lda START_Y
    sta COUNT_Y
    #load16BitImmediate LINE_DATA, TXTUI_PTR
_loop
    #locateAddr START_X, COUNT_Y
    #printStringAddr
    inc COUNT_Y
    #add16BitImmediate 2, TXTUI_PTR
    lda (TXTUI_PTR)
    bne _loop
    ldy #1
    lda (TXTUI_PTR), y
    bne _loop

    lda COL_TEMP
    sta CURSOR_STATE.col
    jsr sprite.buttonBackgroundOn
    rts


NO_BUTTON = $FF

BG_X = 286
BG_Y = 82

X_MIN .word BG_X
Y_UPPER .byte BG_Y
Y_LOWER .byte BG_y+6*16

BUTTON_0 = 0
BUTTON_1 = 1
BUTTON_2 = 2
BUTTON_3 = 3
BUTTON_4 = 4
BUTTON_5 = 5

checkForButton
    #cmp16Bit X_MIN, select.CLICK_POS.x
    beq _testFurther
    bcc _testFurther
_noButton
    lda #NO_BUTTON
    rts
_testFurther
    lda select.CLICK_POS.y
    cmp Y_UPPER
    bcc _noButton
    cmp Y_LOWER
    beq _evalButtons
    bcs _noButton
_evalButtons
    sec
    lda select.CLICK_POS.y
    sbc Y_UPPER
    lsr
    lsr
    lsr
    lsr
    rts



.endnamespace