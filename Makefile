PREFIX ?= $(HOME)/.local
BINDIR := $(PREFIX)/bin

.PHONY: install uninstall test

install:
	install -Dm755 heroglyph $(BINDIR)/heroglyph

uninstall:
	rm -f $(BINDIR)/heroglyph

test:
	dash -n heroglyph
	./heroglyph "test" >/dev/null
