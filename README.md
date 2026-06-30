# reclass

An incredibly performant, independent utility tool that un-obfuscates minified class names on-the-fly. This tool is particularly useful for creating stable, future proof themes.

This tool is entirely plugin loader agnostic, and supports both the Steam deck and client.

Before:
```html
<div class="_27qasW5wLU4h4nUgawpo1q"></div>
```
After:
```html
<div class="_27qasW5wLU4h4nUgawpo1q FocusNavigationRoot"></div>
```

## Building

Build reclass

```bash
$ make
```

Build and install reclass

```bash
$ make install
```

## Third party libraries

* [libsnare.h](https://github.com/shdwmtr/libsnare.h) - A c/cxx/asm compatible single-header hooking library for x86/x64/arm64. inline hooks and PLT/IAT hooks. linux/windows/macos.
