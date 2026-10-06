# Linux / macOS build of the MELPe (STANAG 4591) fixed-point coder: one `melpe` binary.
#   make            # -> melpe
#   make clean
# The basic ops (mathhalf.c) rely on wrapping signed overflow:
# without -fwrapv an optimizing compiler turns some of their loops into infinite ones.
CC ?= cc
CFLAGS ?= -O2
CFLAGS += -fwrapv -I.
SRCS := $(wildcard *.c)
OBJS := $(SRCS:.c=.o)

melpe: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -lm

%.o: %.c $(wildcard *.h)
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f melpe $(OBJS)

.PHONY: clean
