#
# Makefile for i7z, GPL v2, License in COPYING
#

#makefile updated from patch by anestling

CFLAGS ?= -O3
CFLAGS += -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -DBUILD_MAIN

LBITS := $(shell getconf LONG_BIT)
ifeq ($(LBITS),64)
   CFLAGS += -Dx64_BIT
else
   CFLAGS += -Dx86
endif

CC       ?= gcc

LIBS  += -lncurses -lpthread -lrt -lm
INCLUDEFLAGS = 

BIN	= i7z
# PERFMON-BIN = perfmon-i7z #future version to include performance monitor, either standalone or integrated
SRC	= i7z.c helper_functions.c i7z_Single_Socket.c i7z_Dual_Socket.c
OBJ	= $(SRC:.c=.o)

prefix ?= /usr
sbindir = $(prefix)/sbin/
docdir = $(prefix)/share/doc/$(BIN)/
mandir ?= $(prefix)/share/man/

all: $(BIN)

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BIN) $(OBJ) $(LIBS)

#http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644728 for -ltinfo on debian
static-bin: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BIN) $(OBJ) -static-libgcc -DNCURSES_STATIC -static -lpthread -lncurses -lrt -lm -ltinfo

# perfmon-bin: $(OBJ)
# 	$(CC) $(CFLAGS) $(LDFLAGS) -o $(PERFMON-BIN) perfmon-i7z.c helper_functions.c $(LIBS)

clean:
	rm -f *.o $(BIN)

distclean: clean
	rm -f *~ \#*

install:  $(BIN)
	install -D -m 0644 doc/i7z.man $(DESTDIR)$(mandir)man1/i7z.1
	install -D -m 755 $(BIN) $(DESTDIR)$(sbindir)$(BIN)
	install -d $(DESTDIR)$(docdir)
	install -m 0644 README.txt put_cores_offline.sh put_cores_online.sh MAKEDEV-cpuid-msr $(DESTDIR)$(docdir)
