# Linux / macOS build of the MELPe (STANAG 4591) fixed-point coder: one `melpe` binary.
#   make            # -> melpe
#   make clean
# The basic ops (Win32/mathhalf.c, portable C) rely on wrapping signed overflow:
# without -fwrapv an optimizing compiler turns some of their loops into infinite ones.
CC ?= cc
CFLAGS ?= -O2
CFLAGS += -fwrapv -I.
# sc12enc/sc12dec/sc24enc/sc24dec are stale drivers; sc1200.c is the current one.
SRCS := $(filter-out sc12enc.c sc12dec.c sc24enc.c sc24dec.c,$(wildcard *.c)) Win32/mathhalf.c
OBJS := $(SRCS:.c=.o)

melpe: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -lm

%.o: %.c $(wildcard *.h)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f melpe $(OBJS)

.PHONY: clean
