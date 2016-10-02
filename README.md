# QLColorCode

[![Build Status](https://travis-ci.org/anthonygelibert/QLColorCode.svg?branch=master)](https://travis-ci.org/anthonygelibert/QLColorCode)

**Original project:** <http://code.google.com/p/qlcolorcode/>

This is a Quick Look plugin that renders source code with syntax highlighting,
using the [Highlight library](http://www.andre-simon.de).

To install the plugin, just drag it to `~/Library/QuickLook`.
You may need to create that folder if it doesn't already exist.

## Settings
If you want to configure `QLColorCode`, there are several `defaults` commands that could be useful:

Setting the text encoding (default is `UTF-8`).  Two settings are required.  The first sets Highlight's encoding, the second sets Webkit's:

    defaults write org.n8gray.QLColorCode textEncoding UTF-16
    defaults write org.n8gray.QLColorCode webkitTextEncoding UTF-16
    
Setting the font (default is `Menlo`):

    defaults write org.n8gray.QLColorCode font Monaco
    
Setting the font size (default is `10`):

    defaults write org.n8gray.QLColorCode fontSizePoints 9
    
Setting the color style (default is `edit-xcode`, see [all available themes](http://www.andre-simon.de/dokuwiki/doku.php?id=theme_examples)):

    defaults write org.n8gray.QLColorCode hlTheme ide-xcode
    
Setting the thumbnail color style (deactivated by default):

    defaults write org.n8gray.QLColorCode hlThumbTheme ide-xcode

Setting the maximum size (in bytes, deactivated by default) for previewed files:

    defaults write org.n8gray.QLColorCode maxFileSize 1000000

Setting any extra command-line flags for Highlight (see below):

    defaults write org.n8gray.QLColorCode extraHLFlags '-l -W'
    
Here are some useful 'highlight' command-line flags (from the man page):

       -F, --reformat=<style>
              reformat output in given style.   <style>=[ansi,  gnu,  kr,
              java, linux]

       -J, --line-length=<num>
              line length before wrapping (see -W, -V)

       -j, --line-number-length=<num>
              line number length incl. left padding

       -l, --linenumbers
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

**Warning:** my fork uses an external `Highlight`. It will attempt to find `highlight` on your `PATH` (so it should work out of the box for homebrew and MacPorts), but if it can't find it, it'll use `/opt/local/bin/highlight` (MacPorts default). This can be changed:
    
    defaults write org.n8gray.QLColorCode pathHL /path/to/your/highlight 

## Additional information

### Additional features

#### Decompile

QLColorCode decompiles some formats:

- **Java class**. It requires [jad](http://varaneckas.com/jad/) installed at `/usr/local/bin/jad`. 
- **Compiled AppleScript**. It requires `osadecompile` installed at `/usr/bin/osadecompile`.
- **Binary PLIST**. It requires `plutil` installed at `/usr/bin/plutil`. 

### Highlight

#### Plugins

QLColorCode enables some Highlight plugins :

- In all languages: `outhtml_modern_fonts` and `outhtml_codefold`.
- Java (sources and classes): `java_library`.
- C/C++: `cpp_syslog`, `cpp_ref_cplusplus_com` and `cpp_ref_local_includes`.
- Perl: `perl_ref_perl_org`.
- Python: `python_ref_python_org`.
- Shell: `bash_functions` and `bash_ref_linuxmanpages_com`.
- Scala: `scala_ref_scala_lang_org`.

#### Handled languages
Highlight can handle lots and lots of languages, but this plugin will only be 
invoked for file types that the OS knows are type "source-code".  Since the OS
only knows about a limited number of languages, I've added Universal Type 
Identifier (UTI) declarations for several "interesting" languages.  If I've 
missed your favorite language, take a look at the Info.plist file inside the
plugin bundle and look for the UTImportedTypeDeclarations section.  I
haven't added all the languages that Highlight can handle because it's rumored
that having two conflicting UTI declarations for the same file extension can
cause problems.  Note that if you do edit the Info.plist file you need to 
nudge the system to tell it something has changed.  Moving the plugin to the
desktop then back to its installed location should do the trick.

As an aside, by changing colorize.sh you can use this plugin to render any file
type that you can convert to HTML. Have fun, and let me know if you do anything
cool!
