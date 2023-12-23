CC=clang
CFLAGS=-Wall -Wpedantic -std=c11 -D_DEFAULT_SOURCE -g

stek: stek.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.dSYM
