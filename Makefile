# gleex makefile

STD=-std=c99
WFLAGS=-Wall -Wextra
OPT=-O2
IDIR=-I. -Iinclude -Iglee/src/glee_common.h
CC=gcc
NAME=libgleex
SRC=src/*.c
DLIB=glfw z png jpeg freetype
SLIB=glee imgtool

LIBS=$(SLIB) $(DLIB)
LDIR=lib
LSTATIC=$(patsubst %,lib%.a,$(SLIB))
LPATHS=$(patsubst %,$(LDIR)/%,$(LSTATIC))
LFLAGS=$(patsubst %,-L%,$(LDIR))
LFLAGS += $(patsubst %,-l%,$(LIBS))

CFLAGS=$(STD) $(WFLAGS) $(OPT) $(IDIR)
OS=$(shell uname -s)

ifeq ($(OS),Darwin)
	LFLAGS += -framework OpenGL -dynamiclib
	LIB=$(NAME).dylib
else
	LFLAGS += -lGL -lGLEW -shared -fPIC
	LIB=$(NAME).so
endif

$(NAME).a: $(SRC)
	$(CC) $(CFLAGS) -c $^ && ar -crv $@ *.o && rm *.o

$(LDIR):
	mkdir $@

$(LDIR)%.a: %
	cd $^ && make && mv $@ ../

$(LDIR)/$(LDIR)%.a: $(LDIR)%.a $(LDIR)
	mv $< $@

shared: $(SRC) $(LPATHS)
	$(CC) -o $(LIB) $(SRC) $(CFLAGS) $(LFLAGS)

clean:
	rm -r $(LDIR) && rm $(NAME).a && rm imgtool/imgtool
	
