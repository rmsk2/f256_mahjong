* = $0300
.cpu "w65c02"

jmp main

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

CTRL_C = 3
KEY_PRESSED .byte 0

main
    jsr mmuSetup
    ; make sure we receive kernel events
    jsr initEvents
    jsr clut.init

    jsr showTitleScreen
    jsr random.init
    #load16BitImmediate solvablegen.generate, playfield.SHUFFLE_VEC
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

    jsr select.mouseInit
    jsr select.mouseOn
    jsr hires.on
    jsr playfield.init
    jsr playfield.drawAll
    jsr select.doSelect
    jsr select.mouseOff

    lda KEY_PRESSED
    cmp #CTRL_C
    beq _reset
    jmp _restart

_reset
    jmp sys64738
    rts


PROG_NAME .text "F256 Mahjongg. Developed for the April 2025 game jam. Version 1.2.0"
SUBTITLE .text "A Shanghai clone for the F256 line of modern retro computers"
GAME_JAM .text "Find the source code at https://github.com/rmsk2/f256_mahjong"
PROGRAMMING .text "Programming by Martin Grap (@mgr42)"
GRPAHICS .text    "Tile set graphics by Ernesto Contreras (@econtrerasd)"
KEY_STOP .text "- Press RUN/STOP or CTRL+c to end program"
KEY_RESRTART .text "- Press any other key to (re)start program"
MOUSE_TEXT .text "You will need a mouse to play this game"

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

    #locate 14, 32
    #printString KEY_STOP, len(KEY_STOP)

    #locate 14, 34
    #printString KEY_RESRTART, len(KEY_RESRTART)

    #locate 17, 48
    #printString MOUSE_TEXT, len(MOUSE_TEXT)


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