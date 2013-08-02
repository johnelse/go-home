PREFIX?=/usr/local

.PHONY: install uninstall clean

dist/build/go-home/go-home:
	obuild configure
	obuild build

install:
	install -D dist/build/go-home/go-home $(PREFIX)/bin/go-home

uninstall:
	rm -f $(PREFIX)/bin/go-home

clean:
	rm -rf dist
