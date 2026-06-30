CC      ?= cc
CFLAGS  := -std=c11 -Wall -Wextra
LDFLAGS :=

RELEASE_FLAGS := -O3 -march=native -flto -DNDEBUG -fvisibility=hidden -fno-unwind-tables -fno-asynchronous-unwind-tables

ifeq ($(OS),Windows_NT)
    OUT     := reclass.dll
    SHFLAGS := -shared
    # query 32-bit registry view first (Steam is a 32-bit app on Windows)
    STEAM_DIR := $(shell powershell -NoProfile -Command \
        "(Get-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam' -ErrorAction SilentlyContinue).InstallPath")
    ifeq ($(STEAM_DIR),)
        STEAM_DIR := $(shell powershell -NoProfile -Command \
            "(Get-ItemProperty 'HKCU:\SOFTWARE\Valve\Steam' -ErrorAction SilentlyContinue).InstallPath")
    endif
    INSTALL_PATH := $(STEAM_DIR)\$(OUT)
    RM   := del /f
    COPY := copy /y
else
    OUT     := reclass.so
    SHFLAGS := -shared -fPIC
    INSTALL_PATH := $(HOME)/.steam/steam/ubuntu12_64/libXtst.so.6
    RM   := rm -f
    COPY := cp
    X11_CFLAGS := $(shell pkg-config --cflags x11 xtst 2>/dev/null)
endif

.PHONY: all release test install clean

all: $(OUT)

release: $(OUT) reclass_test

$(OUT): reclass.c thirdparty/libsnare.h
	$(CC) $(CFLAGS) $(RELEASE_FLAGS) $(SHFLAGS) $(X11_CFLAGS) -o $@ $<

reclass_test: reclass.c
	$(CC) $(CFLAGS) $(RELEASE_FLAGS) -DRECLASS_MAIN -o $@ $<

test: reclass_test
	./reclass_test tests/chunk~2dcc5aaf7.js

install: $(OUT)
	$(COPY) $< "$(INSTALL_PATH)"

clean:
	$(RM) $(OUT) reclass_test *.patched.js
