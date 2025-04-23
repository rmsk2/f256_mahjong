BITMAP_0_MEM = $40000
BITMAP_1_MEM = $20000

hires .namespace

MMU_IO_CTRL = $0001
VKY_MSTR_CTRL_0 = $D000
VKY_MSTR_CTRL_1 = $D001

LAYER_REG1 = $D002
LAYER_REG2 = $D003
BITMAP_0_ENABLE = $D100
BITMAP_0_ADDR_LOW = $D101
BITMAP_0_ADDR_MDL = $D102
BITMAP_0_ADDR_HI = $D103

BITMAP_1_ENABLE = $D108
BITMAP_1_ADDR_LOW = $D109
BITMAP_1_ADDR_MDL = $D10A
BITMAP_1_ADDR_HI = $D10B

BITMAP_2_ENABLE = $D110

BITMAP_WINDOW = $A000

WINDOW_8K_BLOCK = BITMAP_WINDOW / 8192
WINDOW_MMU_ADDR = WINDOW_8K_BLOCK + 8


BIT_TEXT = 1
BIT_OVERLY = 2
BIT_GRAPH = 4
BIT_BITMAP = 8
BIT_TILE = 16
BIT_SPRITE = 32
BIT_GAMMA = 64
BIT_X = 128

BIT_CLK_70 = 1
BIT_DBL_X = 2
BIT_DBL_Y = 4
BIT_MON_SLP = 8 
BIT_FON_OVLY = 16
BIT_FON_SET = 32

LAYER_0_BITMAP_0 = %00000000
LAYER_1_BITMAP_1 = %00010000

LINE_NO = 261*2  ; 240+21

init
    #saveIo
    #setIo 0

    ; setup layers, we want bitmap 0 in layer 0 and bitmap 1 in layer 1
    lda #LAYER_0_BITMAP_0 | LAYER_1_BITMAP_1
    sta LAYER_REG1  

    ; Explicitly disable all bitmaps for the moment
    stz BITMAP_0_ENABLE
    stz BITMAP_1_ENABLE
    stz BITMAP_2_ENABLE

    ; set address of bitmap 0 memory, i.e $40000
    lda #<BITMAP_0_MEM
    sta BITMAP_0_ADDR_LOW
    lda #>BITMAP_0_MEM
    sta BITMAP_0_ADDR_MDL
    lda #`BITMAP_0_MEM
    sta BITMAP_0_ADDR_HI

    ; set address of bitmap 1 memory, i.e $20000
    lda #<BITMAP_1_MEM
    sta BITMAP_1_ADDR_LOW
    lda #>BITMAP_1_MEM
    sta BITMAP_1_ADDR_MDL
    lda #`BITMAP_1_MEM
    sta BITMAP_1_ADDR_HI

    #restoreIo

    stz ACTIVE_LAYER
    rts

ACTIVE_LAYER .byte 0

On
    #saveIo
    #setIo 0
    
    stz ACTIVE_LAYER
    jsr setLayer0
    jsr layer0On

    ; turn on graphics mode on and allow for displaying bitmap layers
    lda # BIT_BITMAP | BIT_GRAPH | BIT_OVERLY | BIT_TEXT
    sta VKY_MSTR_CTRL_0
    stz VKY_MSTR_CTRL_1    
    #restoreIo
    rts


switchLayer
    lda ACTIVE_LAYER
    beq _active0
    jsr setLayer0
    bra _done
_active0
    jsr setLayer1
_done
    lda ACTIVE_LAYER
    eor #1
    sta ACTIVE_LAYER
    rts


showLayer
    lda ACTIVE_LAYER
    beq _active0
    jsr layer1On
    rts
_active0
    jsr layer0On
    rts


layer0On
    #saveIo
    #setIo 0

    jsr checkVBlank
    lda #0
    sta BITMAP_1_ENABLE
    lda #1
    sta BITMAP_0_ENABLE

    #restoreIo
    rts


layer1On
    #saveIo
    #setIo 0

    jsr checkVBlank

    lda #0
    sta BITMAP_0_ENABLE
    lda #1
    sta BITMAP_1_ENABLE

    #restoreIo
    rts


setLayer0
    lda #BITMAP_0_MEM/8192
    sta memory.BLIT_PARMS.targetRAMblock
    rts


setLayer1
    lda #BITMAP_1_MEM/8192
    sta memory.BLIT_PARMS.targetRAMblock
    rts

; --------------------------------------------------
; This routine turns the bitmap mode off again.
;--------------------------------------------------
Off
    lda #1
    sta VKY_MSTR_CTRL_0
    stz VKY_MSTR_CTRL_1
    rts


checkVBlank
    lda #<LINE_NO
    ldx #>LINE_NO
_wait1
    cpx $D01B
    beq _wait1
_wait2
    cmp $D01A
    beq _wait2
_wait3
    cpx $D01B
    bne _wait3
_wait4
    cmp $D01A
    bne _wait4
    rts


COUNT_WINDOWS .byte 0
MAX_256_BYTE_BLOCK .byte 0

clearBitmap
    ; save MMU state
    lda WINDOW_MMU_ADDR
    pha

    stz COUNT_WINDOWS
    lda COUNT_WINDOWS
_nextWindow
    ; clear 9 full blocks
    ; calculate block number of next block to clear
    clc
    adc memory.BLIT_PARMS.targetRAMblock
    ; bring this block into view
    sta WINDOW_MMU_ADDR
    ; setup page counter => clear 32 pages
    lda #32
    sta MAX_256_BYTE_BLOCK
    ; clear block
    jsr clearBitmapWindow
    ; increment block counter
    inc COUNT_WINDOWS
    lda COUNT_WINDOWS
    cmp #9
    bne _nextWindow

    ; clear 10th block only partially
    ; go to next RAM block
    inc WINDOW_MMU_ADDR

    ; clear 12 pages in last block
    lda #12
    sta MAX_256_BYTE_BLOCK
    ; clear block
    jsr clearBitmapWindow

    ; restore MMU state
    pla
    sta WINDOW_MMU_ADDR

    rts


BACKGROUND_COLOUR .byte 0

clearBitmapWindow
    #load16BitImmediate BITMAP_WINDOW, ZP_GRAPHIC_PTR
    ldx #0
_nextBlock
    ldy #0
    lda BACKGROUND_COLOUR
_loopBlock
    sta (ZP_GRAPHIC_PTR), Y
    iny
    bne _loopBlock
    inc ZP_GRAPHIC_PTR+1
    inx
    cpx MAX_256_BYTE_BLOCK
    bne _nextBlock
    rts

.endnamespace