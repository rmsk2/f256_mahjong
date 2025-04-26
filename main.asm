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
.include "memory.asm"
.include "sprite.asm"

CTRL_C = 3
KEY_PRESSED .byte 0

main
    jsr mmuSetup
    ; make sure we receive kernel events
    jsr initEvents
    jsr clut.init

    jsr showTitleScreen

_restart
    jsr hires.init
    jsr sprite.init
    jsr random.init
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


PROG_NAME .text "F256 Mahjongg. Developed for the April 2025 game jam. Version 1.0."
SUBTITLE .text "A Shanghai clone for the F256 line of modern retro computers"
GAME_JAM .text "Find the source code at https://github.com/rmsk2/f256_mahjong"
PROGRAMMING .text "Programming by Martin Grap (@mgr42)"
GRPAHICS .text    "Tile set graphics by @econtrerasd"
KEY_STOP .text "- Press RUN/STOP to end program"
KEY_RESRTART .text "- Press any other key to (re)start program"
MOUSE_TEXT .text "You will need a mouse to play this game"

showTitleScreen
    jsr hires.init
    jsr sprite.init
    jsr random.init
    jsr txtio.init
    jsr txtio.cursorOff
 
    #setCol (TXT_BLACK << 4) | (TXT_GREEN)
    jsr txtio.clear
    jsr txtio.home

    #locate 5, 2
    #printString PROG_NAME, len(PROG_NAME)

    #locate 8, 8
    #printString SUBTITLE, len(SUBTITLE)

    #locate 8, 10
    #printString GAME_JAM, len(GAME_JAM)

    #locate 19, 16
    #printString PROGRAMMING, len(PROGRAMMING)

    #locate 20,18
    #printString GRPAHICS, len(GRPAHICS)

    #locate 14, 26
    #printString KEY_STOP, len(KEY_STOP)

    #locate 14, 28
    #printString KEY_RESRTART, len(KEY_RESRTART)

    #locate 17, 50
    #printString MOUSE_TEXT, len(MOUSE_TEXT)


    jsr waitForKey
    cmp #CTRL_C
    bne _return
    jmp sys64738
_return
    rts