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

# Building

Build reclass

```bash
$ make
```

Build and install reclass

```bash
$ make install
```
