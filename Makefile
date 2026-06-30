CC      ?= cc
CFLAGS  := -std=c11 -Wall -Wextra
LDFLAGS :=

RELEASE_FLAGS := -O3 -march=native -flto -DNDEBUG -fvisibility=hidden -fno-unwind-tables -fno-asynchronous-unwind-tables

MINGW_CC      := x86_64-w64-mingw32-gcc
MINGW_FLAGS   := -std=c11 -O3 -flto -DNDEBUG -fvisibility=hidden

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
endif

.PHONY: all release test install clean cross

all: $(OUT)

release: $(OUT) reclass_test

$(OUT): reclass.c thirdparty/libsnare.h
	$(CC) $(CFLAGS) $(RELEASE_FLAGS) $(SHFLAGS) -o $@ $<

reclass_test: reclass.c
	$(CC) $(CFLAGS) $(RELEASE_FLAGS) -DRECLASS_MAIN -o $@ $<

test: reclass_test
	./reclass_test tests/chunk~2dcc5aaf7.js

install: $(OUT)
	$(COPY) $< "$(INSTALL_PATH)"

cross: reclass.c thirdparty/libsnare.h
	$(MINGW_CC) $(MINGW_FLAGS) -shared -o reclass.dll $<

clean:
	$(RM) $(OUT) reclass_test *.patched.js
