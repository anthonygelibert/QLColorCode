# QLColorCode

[![Build Status](https://travis-ci.org/anthonygelibert/QLColorCode.svg?branch=master)](https://travis-ci.org/anthonygelibert/QLColorCode)

**Original project:** <http://code.google.com/p/qlcolorcode/>

This is a Quick Look plug-in that renders source code with syntax highlighting, using the
[Highlight library](http://www.andre-simon.de).

To install the plug-in, just drag it to `~/Library/QuickLook`. You may need to create that folder if it doesn't already
exist.

Alternatively, if you use [Homebrew Cask](https://github.com/caskroom/homebrew-cask), install with
`brew cask install qlcolorcode`. Also available on [MacPorts](https://www.macports.org): `port install QLColorCode`.

**To build the project, you must have Boost headers on your system in `/opt/local/include` or `/usr/local/include`.**

Note that the build may fail if you have a version of `liblua.a` in a library
path such as `/usr/local/lib`. In that case, temporarily uninstall Lua using
the appropriate package manager.

## Settings

If you want to configure `QLColorCode`, there are several `defaults` commands that could be useful:

Setting the text encoding (default is `UTF-8`). Two settings are required. The first sets Highlight's encoding, the
second sets Webkit's:

    defaults write org.n8gray.QLColorCode textEncoding UTF-16
    defaults write org.n8gray.QLColorCode webkitTextEncoding UTF-16

Setting the font (default is `Menlo`):

    defaults write org.n8gray.QLColorCode font Monaco

Setting the font size (default is `10`):

    defaults write org.n8gray.QLColorCode fontSizePoints 9

Setting the color style for `light` and `dark` mode (see
[all available themes](http://www.andre-simon.de/doku/highlight/theme-samples.php)):

    defaults write org.n8gray.QLColorCode lightTheme solarized-light
    defaults write org.n8gray.QLColorCode darkTheme solarized-dark

Setting the thumbnail color style (deactivated by default):

    defaults write org.n8gray.QLColorCode hlThumbTheme ide-xcode

Setting the maximum size (in bytes, deactivated by default) for previewed files:

    defaults write org.n8gray.QLColorCode maxFileSize 1000000

zSetting any extra command-line flags for Highlight (see below):

    defaults write org.n8gray.QLColorCode extraHLFlags '-l -W'

Here are some useful 'highlight' command-line flags (from the man page):

       -F, --reformat=<style>
              reformat output in given style.   <style>=[ansi,  gnu,  kr,
              java, linux]

       -J, --line-length=<num>
              line length before wrapping (see -W, -V)

       -j, --line-number-length=<num>
              line number length incl. left padding

       -l, --line-numbers
              print line numbers in output file

       -t  --replace-tabs=<num>
              replace tabs by num spaces

       -V, --wrap-simple
              wrap long lines without indenting function  parameters  and
              statements

       -W, --wrap
              wrap long lines

       -z, --zeroes
              fill leading space of line numbers with zeroes

       --kw-case=<upper|lower|capitalize>
              control case of case insensitive keywords

It is also possible to have the HTML preview converted to RTF. Using RTF allows the contents of the file to be displayed
instead of an icon -- similar to QLStephen.

    defaults write org.n8gray.QLColorCode rtfRender true

## Additional information

### Additional features

#### Decompile

QLColorCode decompiles some formats:

- **Compiled AppleScript**. It requires `osadecompile` installed at `/usr/bin/osadecompile`.
- **Binary PLIST**. It requires `plutil` installed at `/usr/bin/plutil`.

### Highlight

#### Plug-ins

QLColorCode enables some Highlight plug-ins :

- In all languages: `outhtml_codefold` and `reduce_filesize`.
- Java (sources and classes): `java_library`.
- C/C++: `cpp_syslog`, `cpp_ref_cplusplus_com` and `cpp_ref_local_includes`.
- Perl: `perl_ref_perl_org`.
- Python: `python_ref_python_org`.
- Shell: `bash_functions`.
- Scala: `scala_ref_scala_lang_org`.

#### Handled languages

Highlight can handle lots and lots of languages, but this plug-in will only be invoked for file types that the OS knows
are type "source-code". Since the OS only knows about a limited number of languages, I've added Universal Type
Identifier (UTI) declarations for several "interesting" languages. If I've missed your favorite language, take a look at
the Info.plist file inside the plug-in bundle and look for the UTImportedTypeDeclarations section. I haven't added all
the languages that Highlight can handle because it's rumored that having two conflicting UTI declarations for the same
file extension can cause problems. Note that if you do edit the Info.plist file you need to nudge the system to tell it
something has changed. Moving the plug-in to the desktop then back to its installed location should do the trick.

As an aside, by changing colorize.sh you can use this plug-in to render any file type that you can convert to HTML. Have
fun, and let me know if you do anything cool!

##### Adding Language Types

If QLColorCode doesn't display PHP and JavaScript code properly, their types may need to be added to Info.plist. Finding
the right type string to use is the tricky part. Getting the type strings and getting Info.plist edits to take effect is
easy by following the steps below, which explain how to add support for PHP:

1. In Terminal.app (or any shell prompt), enter the command:

```bash
mdls -name kMDItemContentType /full/path/to/file.php
```

Use the path to any PHP file. The response will be:

```txt
kMDItemContentType = "public.php-script"
```

The string `public.php-script` is the type string needed in a later step.

2. Again at a shell prompt, enter the command:

```bash
open ~/Library/QuickLook/QLColorCode.qlgenerator/Contents/Info.plist
```

This will open Info.plist in Xcode.app.

3. In Xcode.app's edit window for Info.plist, go to:

`Document types > Item 0 > Document Content Type UTIs`

(If the editor is showing raw keys, that's: CFBundleDocumentTypes > Item 0 > LSItemContentTypes)

4. Add an item for `public.php-script`, the type string found in the first step.
5. Save the updated Info.plist file.
6. Try it in Finder. (It's usually unnecessary to move/return the QLColorCode extension, restart QuickLook, or restart
   the Finder, but it wouldn't be surprising that some users might need to do so.)
