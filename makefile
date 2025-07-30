PACKAGE_NAME := my-letter
STYLES := $(wildcard styles/*.sty)
CLASSES := $(wildcard classes/*.cls)
FILES := $(CLASSES) $(STYLES)

UNAME_S := $(shell uname -s)
ifeq ($(TEXMF),)
    ifeq ($(UNAME_S),Darwin)
        TEXMF := $(HOME)/Library/texmf
    else
        TEXMF := $(HOME)/texmf
    endif
endif

TEXMF = $(HOME)/Library/texmf
TARGET = $(TEXMF)/tex/latex/$(PACKAGE_NAME)

.PHONY: install uninstall

install:
	mkdir -p $(TARGET)
	@for file in $(FILES); do \
		ln -sf "$$(realpath $$file)" "$(TARGET)/$$(basename $$file)"; \
	done
# 	Not strictly necessary; however, it does not harm.
	texhash "$(TEXMF)"

uninstall:
	@for file in $(FILES); do \
		rm -f "$(TARGET)/$$(basename $$file)"; \
	done
# 	Not strictly necessary; however, it does not harm.
	texhash $(TEXMF)
