CC=clang
CFLAGS=-Wall -Wpedantic -std=c11 -g

stek: stek.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.dSYM
