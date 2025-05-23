* = $0300
.cpu "w65c02"

jmp main

DO_DUMMY = 0

.include "setup.asm"
.include "api.asm"
.include "clut.asm"
.include "zeropage.asm"
.include "arith16.asm"
.include "khelp.asm"
.include "hires_base.asm"
.include "random.asm"
.include "txtio.asm"
.include "select.asm"
.include "playfield.asm"
.include "create_solvable.asm"
.include "memory.asm"
.include "rtc.asm"
.include "undo.asm"
.include "sprite.asm"
.include "txtui.asm"
.if DO_DUMMY == 1
.include "dummy.asm"
.endif

CTRL_C = 3
KEY_PRESSED .byte 0

main
    jsr mmuSetup
    ; make sure we receive kernel events
    jsr initEvents
    jsr clut.init

    jsr showTitleScreen
    jsr random.init
.if DO_DUMMY == 1
    #load16BitImmediate dummy.getDummy, playfield.SHUFFLE_VEC
.else
    #load16BitImmediate solvablegen.generate, playfield.SHUFFLE_VEC
.endif
    #load16BitImmediate playfield.DIFFICULTY_SOLVEABLE, playfield.DIFFICULTY_VEC
    jsr setTimerClockTick

_restart
    jsr undo.init
    jsr hires.init
    jsr sprite.init
    jsr txtio.init
    jsr txtio.cursorOff
 
    #setCol (TXT_BLACK << 4) | (TXT_WHITE)
    jsr txtio.clear
    jsr txtio.home

    lda #255-12
    sta hires.BACKGROUND_COLOUR

    lda #BITMAP_0_MEM/8192
    sta memory.BLIT_PARMS.targetRAMblock
    jsr hires.clearBitmap

    jsr select.mouseOn
    jsr select.mouseInit
    jsr hires.on
    jsr playfield.init
    jsr undo.saveState
    jsr playfield.drawAll
    jsr txtui.drawButtons
    jsr select.doSelect

    lda KEY_PRESSED
    cmp #CTRL_C
    beq _reset
    jmp _restart

_reset
    jmp sys64738
    rts


PROG_NAME .text "F256 Mahjongg. Developed for the April 2025 game jam. Version 1.3.0"
SUBTITLE .text "A Shanghai clone for the F256 line of modern retro computers"
GAME_JAM .text "Find the source code at https://github.com/rmsk2/f256_mahjong"
PROGRAMMING .text "Programming by Martin Grap (@mgr42)"
GRPAHICS .text    "Tile set graphics by Ernesto Contreras (@econtrerasd)"
TXT_MOUSE .text "In the game use the mouse to click on the menu to the right or ..."
KEY_STOP     .text "- Press RUN/STOP or CTRL+c to end program"
KEY_UNDO     .text "- Press F1 to undo last move"
KEY_RANDOM   .text "- Press F5 to create random decks (difficult)"
KEY_SOLVE    .text "- Press F3 to create solveable decks (less difficult)"
KEY_RESTORE  .text "- Press F7 to restart current deck"
KEY_RESTART  .text "- Press any other key to create a new deck"
KEY_ANY  .text "Press any key (but RUN/STOP) to begin"
MOUSE_TEXT .text "You will need a mouse to play this game"
ENUM_POS = 13

TILE_COUNT .byte 0
WOSCHT .byte 0

showTitleScreen
    jsr hires.init
    jsr sprite.init
    jsr random.init
    jsr txtio.init
    jsr txtio.cursorOff
    jsr playfield.dataInit
 
    lda #255-12
    sta hires.BACKGROUND_COLOUR

    lda #BITMAP_0_MEM/8192
    sta memory.BLIT_PARMS.targetRAMblock
    jsr hires.clearBitmap

    #setCol (TXT_BLACK << 4) | (TXT_GREEN)
    jsr txtio.clear
    jsr txtio.home

    jsr hires.checkVBlank
    jsr hires.on

    #locate 5, 12
    #printString PROG_NAME, len(PROG_NAME)

    #locate 8, 14
    #printString SUBTITLE, len(SUBTITLE)

    #locate 8, 16
    #printString GAME_JAM, len(GAME_JAM)

    #locate 19, 22
    #printString PROGRAMMING, len(PROGRAMMING)

    #locate 10, 24
    #printString GRPAHICS, len(GRPAHICS)

    #locate ENUM_POS - 6, 29
    #printString TXT_MOUSE, len(TXT_MOUSE)

    #locate ENUM_POS, 32
    #printString KEY_STOP, len(KEY_STOP)

    #locate ENUM_POS, 34
    #printString KEY_UNDO, len(KEY_UNDO)

    #locate ENUM_POS, 36
    #printString KEY_RANDOM, len(KEY_RANDOM)

    #locate ENUM_POS, 38
    #printString KEY_SOLVE, len(KEY_SOLVE)

    #locate ENUM_POS, 40
    #printString KEY_RESTORE, len(KEY_RESTORE)

    #locate ENUM_POS, 42
    #printString KEY_RESTART, len(KEY_RESTART)

    #locate 17, 46
    #printString MOUSE_TEXT, len(MOUSE_TEXT)

    #locate 18, 48
    #printString KEY_ANY, len(KEY_ANY)

    #load16BitImmediate 0, memory.X_POS
    stz memory.Y_POS
    stz TILE_COUNT
_loopTop
    lda TILE_COUNT
    jsr playfield.blitTile2D
    #add16BitImmediate TILE_X, memory.X_POS
    inc TILE_COUNT
    lda TILE_COUNT
    cmp #16
    bne _loopTop   

    #load16BitImmediate 0, memory.X_POS
    lda #240-TILE_Y
    sta memory.Y_POS
    stz TILE_COUNT
_loopBottom
    clc
    lda TILE_COUNT
    adc #17
    jsr playfield.blitTile2D
    #add16BitImmediate TILE_X, memory.X_POS
    inc TILE_COUNT
    lda TILE_COUNT
    cmp #16
    bne _loopBottom

    #load16BitImmediate 0, memory.X_POS
    lda #3 * 24
    sta memory.Y_POS
    stz TILE_COUNT
_loopLeft
    lda TILE_COUNT
    clc
    adc #35
    jsr playfield.blitTile2D
    lda #TILE_Y
    clc
    adc memory.Y_POS
    sta memory.Y_POS
    inc TILE_COUNT
    lda TILE_COUNT
    cmp #4
    bne _loopLeft

    #load16BitImmediate 320-TILE_X, memory.X_POS
    lda #3 * TILE_Y
    sta memory.Y_POS
    stz TILE_COUNT
_loopRight
    lda TILE_COUNT
    clc
    adc #39
    jsr playfield.blitTile2D
    lda #TILE_Y
    clc
    adc memory.Y_POS
    sta memory.Y_POS
    inc TILE_COUNT
    lda TILE_COUNT
    cmp #4
    bne _loopRight

    #load16BitImmediate 320-3*TILE_X, memory.X_POS
    lda #240-TILE_Y
    sta memory.Y_POS
    lda #33
    jsr playfield.blitTile2D

    jsr waitForKey
    cmp #CTRL_C
    bne _return
    jmp sys64738
_return
    jsr hires.off
    rts