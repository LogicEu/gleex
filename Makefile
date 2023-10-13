# gleex makefile

STD=-std=c99
WFLAGS=-Wall -Wextra
OPT=-O2
IDIR=-I. -Iinclude
CC=gcc
NAME=libgleex
SRC=src/*.c
DLIB=glfw z png jpeg freetype
SLIB=glee imgtool

SCRIPT=build.sh

LIBS=$(SLIB) $(DLIB)
LDIR=lib
LSTATIC=$(patsubst %,lib%.a,$(SLIB))
LPATHS=$(patsubst %,$(LDIR)/%,$(LSTATIC))
_LFLAGS= $(patsubst %,-L%,$(LDIR)/)
_LFLAGS += $(patsubst %,-l%,$(LIBS))

OS=$(shell uname -s)

ifeq ($(OS),Darwin)
	LFLAGS=-Wl,-all_load $(_LFLAGS) -framework OpenGL -dynamiclib
	LIB=$(NAME).dylib
else
	LFLAGS=$(_LFLAGS) -lGL -lGLEW -shared -fPIC
	LIB=$(NAME).so
endif

CFLAGS=$(STD) $(WFLAGS) $(OPT) $(IDIR)

$(NAME).a: $(SRC)
	$(CC) $(CFLAGS) -c $^ && ar -cr $@ *.o && rm *.o

$(LDIR):
	@[ -d $@ ] || mkdir $@ && echo "mkdir $@"

$(LDIR)%.a: %
	cd $^ && make && mv $@ ../

$(LDIR)/$(LDIR)%.a: $(LDIR)%.a $(LDIR)
	mv $< $@

shared: $(SRC) $(LPATHS)
	$(CC) -o $(LIB) $(SRC) $(CFLAGS) $(LFLAGS)

clean: $(SCRIPT)
	./$^ $@

install: $(SCRIPT)
	./$^ $@

uninstall: $(SCRIPT)
	./$^ $@
	
