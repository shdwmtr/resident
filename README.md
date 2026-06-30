# reclass

A independent utility tool that restores minified class names back into their original human readable, internal form before minification. This tool is particularly useful for themes for the Steam Client.

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
