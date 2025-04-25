RM=rm
PORT=/dev/ttyUSB0
SUDO=

BINARY=mahjong
FORCE=-f
PYTHON=python
CP=cp
DIST=dist
TILES=tiles.bin


ifdef WIN
RM=del
PORT=COM3
SUDO=
FORCE=
endif


.PHONY: all
all: pgz

.PHONY: pgz
pgz: $(BINARY).pgz

.PHONY: dist
dist: clean pgz
	$(RM) $(FORCE) $(DIST)/*
	$(CP) $(BINARY).pgz $(DIST)/


$(BINARY): *.asm
	64tass --nostart -o $(BINARY) main.asm -l dummy.txt

clean: 
	$(RM) $(FORCE) $(BINARY)
	$(RM) $(FORCE) dummy.txt
	$(RM) $(FORCE) $(BINARY).pgz
	$(RM) $(FORCE) tests/bin/*.bin
	$(RM) $(FORCE) *.inc
	$(RM) $(FORCE) $(TILES)
	$(RM) $(FORCE) $(DIST)/*


upload: $(BINARY).pgz
	$(SUDO) $(PYTHON) fnxmgr.zip --port $(PORT) --run-pgz $(BINARY).pgz

$(BINARY).pgz: $(BINARY) $(TILES)
	$(PYTHON) make_pgz.py $(BINARY) $(TILES)

$(TILES): tileset.asm
	64tass --nostart -o $(TILES) tileset_real.asm

test:
	6502profiler verifyall -c config.json -trapaddr 0x07FF
