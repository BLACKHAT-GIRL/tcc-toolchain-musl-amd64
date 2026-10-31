SHELL := /bin/bash

PREFIX ?= /opt/tcc-toolchain-amd64
SHELL_RC ?= $(HOME)/.bashrc
SHELL_RC_DISPLAY := ~/.bashrc
BIN_DIR := $(PREFIX)/bin
PATH_LINE := export PATH="$(BIN_DIR):$$PATH"

ifeq ($(shell id -u),0)
SUDO :=
else
SUDO := sudo
endif

.PHONY: all help install uninstall

all: help

help:
	@echo "TCC portable toolchain by Michele Corrêa <michele@blackhat.lat>"
	@echo
	@echo "Targets:"
	@echo "  make install    Install to $(PREFIX) and update $(SHELL_RC_DISPLAY)"
	@echo "  make uninstall  Remove $(PREFIX) and its PATH entry from $(SHELL_RC_DISPLAY)"
	@echo
	@echo "Variables:"
	@echo "  PREFIX=/custom/path"
	@echo "  SHELL_RC=/path/to/.bashrc"

install:
	@set -e; \
	if [[ ! -d "$(CURDIR)/bin" || ! -x "$(CURDIR)/bin/tcc" ]]; then \
		echo "error: invalid TCC toolchain source: $(CURDIR)" >&2; exit 1; \
	fi; \
	echo "Installing TCC toolchain to $(PREFIX)..."; \
	$(SUDO) mkdir -p "$(PREFIX)"; \
	$(SUDO) cp -a -- "$(CURDIR)/." "$(PREFIX)/"; \
	mkdir -p "$$(dirname "$(SHELL_RC)")"; \
	touch "$(SHELL_RC)"; \
	if ! grep -Fqx '$(PATH_LINE)' "$(SHELL_RC)"; then \
		printf '\n# TCC portable toolchain\n%s\n' '$(PATH_LINE)' >> "$(SHELL_RC)"; \
	fi; \
	echo "Installed. Start a new shell or run: source $(SHELL_RC_DISPLAY)"

uninstall:
	@set -e; \
	echo "Removing PATH entry from $(SHELL_RC)..."; \
	if [[ -f "$(SHELL_RC)" ]]; then \
		tmp="$$(mktemp)"; \
		awk -v line='$(PATH_LINE)' '$$0 != line && $$0 != "# TCC portable toolchain"' "$(SHELL_RC)" > "$$tmp"; \
		cat "$$tmp" > "$(SHELL_RC)"; \
		rm -f -- "$$tmp"; \
	fi; \
	echo "Removing $(PREFIX)..."; \
	if [[ -d "$(PREFIX)" ]]; then \
		$(SUDO) rm -rf --one-file-system -- "$(PREFIX)"; \
	fi; \
	echo "Uninstalled. Start a new shell or run: source $(SHELL_RC_DISPLAY)"
