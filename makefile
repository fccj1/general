## Para gerar executáveis para windows a partir do linux, instale o pacote "mingw-w64" (debian/arch) ou equivalente.
## (Apenas para Linux) Para gerar "compile_commands.json" (necessário para que o clangd interprete corretamente a organização do projeto), instale "bear" (Build EAR).

## Definindo variáveis específicas para cada sistema
ifdef OS # Windows
	FixPath = $(subst /,\,$1)
	RM=del /s /F /q
	ZIP=powershell Compress-Archive -DestinationPath
else
   ifeq ($(shell uname), Linux) # Linux
      FixPath = $1
      RM=rm -rf
	  ZIP=zip
   endif
endif

## Variáveis genéricas
CC=gcc
CFLAGS ?= -g
ALL_CFLAGS=-Wall -pedantic-errors -lm -I$(INC) $(CFLAGS)
SRC=src
OBJ=obj
INC=include
SRCS=$(wildcard $(SRC)/*.c)
OBJS=$(patsubst $(SRC)/%.c,$(OBJ)/%.o,$(SRCS))
BINDIR=bin
BIN=$(BINDIR)/main.exe
SUBMITNAME=projeto.zip

all: $(BIN)

forWindows: CC=x86_64-w64-mingw32-gcc
forWindows: all

release: ALL_CFLAGS=-Wall -pedantic-errors -lm -I$(INC) -O2 -DNDEBUG
release: clean
release: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(ALL_CFLAGS) $(OBJS) -o $@

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(ALL_CFLAGS) -c $< -o $@

submit:
	$(RM) $(SUBMITNAME)
	$(ZIP) $(SUBMITNAME) *

run: $(BIN)
	$(call FixPath,$(BIN))

clean:
	$(RM) $(call FixPath,$(BINDIR)/*.exe $(OBJ)/*.o $(SUBMITNAME))

## Apenas no Linux
genconfig-linux: clean
	bear -- make clean all
