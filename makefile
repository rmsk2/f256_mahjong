TILES=tiles.bin
SUDO=
BINARY=shanghai
DIST=dist

RM=rm
PORT=/dev/ttyUSB0
FORCE=-f
PYTHON=python3
CP=cp


ifdef WIN
RM=del
PORT=COM3
FORCE=
PYTHON=python
CP=copy
endif


.PHONY: all
all: pgz

.PHONY: pgz
pgz: $(BINARY).pgz

.PHONY: dist
dist: clean pgz cartridge
	$(RM) $(FORCE) $(DIST)/*
	$(CP) $(BINARY).pgz $(DIST)/
	$(CP) $(BINARY).bin $(DIST)/

$(BINARY): *.asm
	64tass --nostart -o $(BINARY) main.asm -l dummy.txt

clean: 
	$(RM) $(FORCE) $(BINARY)
	$(RM) $(FORCE) dummy.txt
	$(RM) $(FORCE) $(BINARY).pgz
	$(RM) $(FORCE) $(BINARY).bin
	$(RM) $(FORCE) tests/bin/*.bin
	$(RM) $(FORCE) $(TILES)
	$(RM) $(FORCE) $(DIST)/*.bin
	$(RM) $(FORCE) $(DIST)/*.pgz


upload: $(BINARY).pgz
	$(SUDO) $(PYTHON) fnxmgr.zip --port $(PORT) --run-pgz $(BINARY).pgz

$(BINARY).pgz: $(BINARY) $(TILES)
	$(PYTHON) make_pgz.py $(BINARY) $(TILES)

$(TILES): tileset.asm
	64tass --nostart -o $(TILES) tileset_real.asm

.PHONY: test
test:
	6502profiler verifyall -c config.json -trapaddr 0x07FF

.PHONY: cartridge
cartridge: $(BINARY).bin

$(BINARY).bin: $(BINARY).pgz
	pgz2flash -desc "A Shanghai clone" -name shanghai -out $(BINARY).bin -pgz $(BINARY).pgz

