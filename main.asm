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


main
    jsr mmuSetup
    ; make sure we receive kernel events
    jsr initEvents

    jsr hires.init
    jsr sprite.init
    jsr random.init
    jsr clut.init
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
    jsr sprite.frameOn
    jsr select.doSelect
    jsr select.mouseOff

    jmp exitToBasic
    rts


