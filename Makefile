CC=clang
CFLAGS=-Wall -Wpedantic -std=c11 -g

steklo: steklo.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.dSYM
