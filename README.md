# IniFiction
This is the GitHub repository for the Haxelib IniFiction. IniFiction is a library that allows reading and writing of ini files. The library uses inheritance to make working in an object oriented codebase easier without needing to write adapters or something similar (you still can of course).

The library supports `[sections]` and `; comments`, and automatically uses an approperiate newline character for the OS it runs on. The library supports all Haxe targets that have access to #sys.

# Installation
Before using this library you should know what [Haxe](https://haxe.org/) is and have the Haxe toolkit installed.

1. Type `haxelib install IniFiction` in a command prompt/shell.
2. Add `--library IniFiction` to your .hxml file.

## Usage
You can get started by creating a new ini file object:
```haxe
var ini = new IniFile("MyIniFile", "C:/my/path");
```
If the path is an existing ini file, call the load method:
```haxe
ini.load();
```
You can add key/value data by creating a Key object:
```haxe
var key = new Key("MyKey", "MyValue");
```
This key can be added to the ini file, and saved to have the file reflect the change:
```haxe
ini.keys.add(key);
ini.save();
```
Sections can be added in a similar way:
```haxe
var section = new Section("MySection", ini.lineSeparator);
ini.sections.add(section);
ini.save();
```
To add keys to your section, use the same method as when adding keys to the file itself, but on the section (remember that the section was already added to the ini object):
```haxe
section.keys.add(key);
ini.save();
```
Comments can be added using the Key object:
```haxe
var comment = new Key("; Hello World!");
ini.keys.add(comment);
ini.save();
```

These code snippets should result in the following ini file:

`MyIniFile.ini`
```ini
MyKey=MyValue
; Hello World!

[MySection]
MyKey=MyValue
```
Calling `ini.save()` will create folders that do not exists to achieve the given path.

There are currently no formatting options available at this time, aside from what is shown above. Each entry writes to a new line and each section is prepended by an empty line. Entries not in a section will always appear above all sections. Values are written and read as `String`.

### Conditional compilation
The library supports 2 conditional compilation flags:
```hxml
# This will output warnings to the console (recommended).
-D warn

# This will output debug logs to the console (e.g. file initialised, loaded, saved, etc.).
-D inifiction_log
```

# Contact/support
[Join my Discord](https://discord.gg/2KedGjpQMR) for support, questions or suggestions. The Discord will also keep you updated on my other projects. This was a hobby project of mine from 2019.

You can also use the Issues tab to report issues.

# License
You are free to use this library as it is licensed MIT.
