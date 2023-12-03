CC=clang
CFLAGS=-Wall -Wpedantic -std=c11 -g

main: main.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf *.dSYM
