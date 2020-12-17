# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/fr/1.0.0/) and this project adheres to
[Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [Unreleased]

- NOTHING

## [4.1.0] — 2020-12-17

### Changed

- Compilation of `highlight`/`lua` (thanks @Tatsh).

## [4.0.3] — 2020-12-17

### Added

- `xsl` support.

## [4.0.2] — 2020-12-16

### Fixed

- Version number in the final binary.

## [4.0.1] — 2020-12-16

### Added

- `tf` support.

### Fixed

- CI (thanks @jeffbyrnes).

## [4.0.0] — 2020-12-15
 
**Big Sur support via integrated Lua and Highlight!  
Thanks to @tatsh for his amazing work!**

### Added

- `ruby` support.
- `lisp` support.
- `automake` support.
- `powershell` support (thanks @abulgatz).

### Fixed

- CI (thanks @tatsh).

## [3.1.1] — 2020-09-09

### Fixed

- `java` support.
- `C++` support.
- `Objective-C++` support.
- Others took [here](https://github.com/meissnem/QLColorCode/blob/master/Info.plist).

## [3.1.0] — 2020-09-09

### Added

- `kts` (kotlin) support.
- `xsh` support.
- `pyc` support (decompilation with `uncompyle6` [has to be in `/usr/local/bin`]).
- `rst` support.
- `perl` support.
- `bats` (Bash Automated Testing System) support.

### Fixed

- `fish` support.
- `bat` (Windows Batch) support.
- `diff` support.
- `bash` support.

## [3.0.3] — 2020-09-09

### Fixed

- `xquery` support for forgotten extensions (thanks leo@leostuder.ch).

## [3.0.2] — 2020-09-08

### Added

- `xsd`/`xquery`/`xml`/`xsl` support.

### Changed

- Minimum rendering size is now `9`.

## [3.0.1] — 2020-09-04

### Added

- `bazel` support.

### Changed

- `CHANGELOG.md` follows "Keep a Changelog".

### Removed

- `jad` support.

## [3.0.0] — 2020-08-16

### Added

- `JetBrain IML Project file` support (as standard XML files).
- `YAML` support (thanks @JJGO).
- `Crystal` Support (thanks @crjaensch).
- `HS`/`Cabal`/`VueJS`/`Go`/`Rust`/`C`/`C++`/`Objective-C`/`Lua`/`CSH`/`ZSH`/`Python`/`CFG` support.
- Support Mojave Dark mode (thanks @darkbrow).

### Removed

- Plain-Text files support to allow QLStephen processing.

### Fixed

- Fix `Height`/`Width`/`MinimumSize` (thanks @darkbrow).

## [2.1.0] — 2018-06-19

### Added

- Option to preview file as `RTF` (thanks @silum).
- `Kotlin/Gradle` (thanks @sonique6784).
- `C#/Scala` support.
- `reduce_filesize` plugin by default.

### Removed

- `JSON` support (thanks @erdtsksn).

## [2.0.9] — 2017-10-02

### Added

- `PHP`/`JS` support (thanks @sloanlance).
- `C#`/`F#` support (thanks @breiter).

## [2.0.8] — 2016-10-05

### Removed

- `bash_ref_linuxmanpages_com` plugin.

## [2.0.7] — 2016-04-16

### Fixed

- autodetect path on 10.11 (thanks @cc941201).
- `LaTeX` and `Arduino` support.

## [2.0.6] — 2016-03-21

### Added

- `Logos` source file support (as plain text).
- `ViM Scripts` source file support.
- Ability to use an optional theme only for thumbnails (thanks @vilhelmen).
- Autodetect `highlight` path (thanks @saagarjha).

### Changed

- Code is now GPL 3.

## [2.0.5] — 2016-01-19

Lots of minor changes

## [2.0.4] — 2012-09-05

First version of Anthony GELIBERT.

### Added

- New setting to specify the HL path (`/opt/local/bin/highlight` by default).
- Some other formats to render.

### Changed

- Update the XCode Project to 10.8.
- Update the script `colorize.sh` to obtain ZSH by the environment rather than an hardcoded path.
- Update the script `colorize.sh` to call ZSH by `zsh -f` rather than simply `zsh`.

### Fixed

- Correct some code according to `CLang static analyzer`.

## [2.0.2] — 2009-09-18

### Added

- Include a link to Andre Simon's page with previews of color styles.

### Changed

- Modified `ReadMe.txt` to include the latest info on the `Xcode 3.2` conflict

## [2.0.1] — 2009-09-18

### Added

- Added qlcc_debug option. To enable, use: `defaults write org.n8gray.qlcolorcode qlcc_debug 1` To disable, use:
  `defaults delete org.n8gray.qlcolorcode qlcc_debug`

### Changed

- Stop redirecting `stdout` of `colorize.sh` to `stdin`. Error output will appear in the console instead of the preview.

### Fixed

- Build of `highlight` to run on Leopard.

## [2.0.0] — 2009-09-17

### Added

- A note about conflict with Xcode 3.2's source code QL plugin. If you're having problems with QLCC on Snow Leopard
  please read it!
- Support for `Scala`, `Groovy`, `Interactive Data Language`, and `Coldfusion`.
- Build for `x86_64` in addition to `i386` and `ppc`.

### Changed

- Upgrade `highlight` from `2.6.6` to `2.12` -- This was long overdue. It's nice not to have to patch highlight anymore!

### Removed

- Customized `.css` language definition -- it was fixed upstream.

### Fixed

- Fixed a bug that caused `QLCC` to fail on files whose names contained '`%`'.

## [1.1] — 2009-01-10

### Added

- Enabled "safe" plain-text handling. In other words, files like foo.txt will be supported, but not files without
  extensions. The only way to handle extensionless files is to handle -everything-. This can be done, but it requires a
  more defensive style of operation.
- Support for `textEncoding` option to set encoding for highlight portion of renderer, with default `UTF-8`.
- Support for `webkitTextEncoding` option to set encoding for webkit portion of renderer, with default `UTF-8`.
- Support for `.cs`, `.el`, `.jnlp` (xml), `.e` (eiffel), and `.vb`.

### Fixed

- Fixed support for `Verilog` files.

## [1.0] — 2008-01-07

### Added

- `Actionscript`, `Lisp`, `IDL`, `Verilog`, `VHDL`, `XHTML` (any others I forgot?).
- `.cls` and `.sty` as LaTeX extensions.
- `maxFileSize` option to keep us from hanging on huge files.

### Fixed

- Hopefully fixed the crasher bug by keeping us single-threaded.

## [0.4] — 2008-01-07

### Added

- Added `Tcl`, `Lua`, and `JSP` support.

### Changed

- Can now configure appearance with `defaults write org.n8gray.QLColorCode ...` commands.

### Fixed

- Improved `OCaml`, `C/C++` and `Obj-C` modes.

## [0.3] — 2007-12-15

### Added

- Added `.command` as an alternate extension for shell scripts.
- Added `.mll` and `.mly` extensions for `OCaml`.
- Include customized `.css` and `.c` language definition files.
- Created a `slateGreen` theme that matches my editor colors.

### Changed

- If highlight fails to colorize a file render it as plain text.

### Fixed

- Ensure highlight is compiled as a Universal Binary.

## [0.2] — 2007-12-14

### Added

- Added thumbnailing support.
- Added UTIs for `.css`, `.sql`, `.erl`, and `.sml`.

### Changed

- Switched from Pygments to Highlight. This should increase speed-and-language coverage.
- Changed `.tex` `UTI` to agree with TeXShop's.
- (Try to) let the system pick a different plugin if ours fails.

## [0.1]

Initial release
