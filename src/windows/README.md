# Deck Daemon for Windows: recovered source

The original FoxPro source for Deck Daemon for Windows was lost. This folder holds source **recovered by decompiling** the released program, `releases/windows/DAEMON.EXE` (and the small `TOOLS.EXE`), built with Microsoft FoxPro 2.6 for Windows in 1995.

It is not the original source text. It is a faithful reconstruction of what the compiled program does, written back out as FoxPro code.

## Layout

| Folder | Contents | Recovered from |
| --- | --- | --- |
| `programs/` | 83 programs (`.PRG`), including `MAIN.PRG`, the entry point | compiled `.FXP` modules |
| `screens/` | 5 generated screen programs (`.SPR`) | compiled `.SPX` modules |
| `menus/` | 2 generated menu programs (`.MPR`) | compiled `.MPX` modules |
| `reports/` | 6 report definitions (`.FRX` with `.FRT` memo files) | copied byte for byte |
| `resources/` | toolbar bitmaps, `DAEMON.ICO`, `CONFIG.FPW` | copied byte for byte |
| `tools/` | `TOOLS.PRG`, `TOOLS.SPR` and its `CONFIG.FPW` | `TOOLS.EXE` |

Each recovered file starts with a header naming the compiled module it came from and the date it was compiled.

The source files are ANSI (Windows code page 1252) with CRLF line endings, as FoxPro 2.6 for Windows expects.

## What was recovered, and what was not

**Recovered completely:**
- All 90 compiled modules in `DAEMON.EXE` and both in `TOOLS.EXE`: 6,708 lines of code.
- Every command, expression, string, number, variable, field, array and procedure name. FoxPro keeps names in its compiled code, so the identifiers are the author's own.
- Control flow (`IF`, `DO CASE`, `DO WHILE`, `FOR`, `SCAN`), re-indented for reading.
- SQL `SELECT` statements, including one subquery, and `INSERT INTO`.
- Lines the compiler kept as text because they use `&` macro substitution. These are exactly as written.
- The report files, bitmaps and configuration files, which are stored unchanged inside the executable.

**Not recoverable:**
- Comments, blank lines, indentation and line breaks. The compiler discards them. Long statements that were split with `;` appear on one line.
- The Screen Builder (`.SCX`), Menu Builder (`.MNX`) and project (`.PJX`) design files. Only the code generated from them (`.SPR`, `.MPR`) was compiled into the program. That code runs, but it can't be opened in the visual designers.
- `#DEFINE` constants, which the compiler replaces with their values.

**Uncertain:** 274 lines end with `&& ? decompiler guessed a keyword on this line`. On those lines one keyword was inferred from context rather than proven, so check them before relying on them. Most are window options in `DEFINE WINDOW` and `MODIFY WINDOW` (such as `FLOAT`, `CLOSE`, `NOGROW` or `SYSTEM`), a few `SET` options, and a handful of rarely used functions. Everything else decoded consistently.

**Untested:** the recovered code has not been compiled or run in FoxPro 2.6.

## How it was done

There is no public description of the FoxPro 2.6 compiled format, so it was worked out from the files themselves:

1. **Executable layout.** `DAEMON.EXE` is a small Windows 3.x loader with a FoxPro application image appended. That image has a directory of 122 embedded files: compiled modules, reports, bitmaps and configuration.
2. **Module layout.** Each compiled module has a main block and procedure blocks. Each block is a series of tokenized lines plus a table of the names it uses.
3. **Expressions** are stored in postfix order (operands first, then the operator or function), so they can be rebuilt with a simple stack.
4. **Token numbers.** The command tokens turned out to be the old dBASE/FoxBASE command list in alphabetical order (`?`, `??`, `@`, `ACCEPT`, `APPEND`, ... `ZAP`), and the function and keyword tokens follow the same pattern. Newer FoxPro 2.x commands and keywords were mapped by comparing them with code that FoxPro's own screen and menu generators always produce, and with the macro lines kept as text.

The decompiler and extractor are kept locally in `src/windows/disassembler/`, which is excluded from the repository by `.gitignore`.

## Authorship

Deck Daemon for Windows was written by **Dave Armga** in 1995 as a work made for hire for Bard's Quest Software, Inc. It was modeled on Richard Hundhausen's Deck Daemon for DOS; the About screen (`screens/ABOUT.SPR`) calls the DOS program "the template to which Deck Daemon for Windows was designed" and is signed "Dave Armga 1995".

The code in this folder is Dave's. The decompiler only translated his compiled program back into source text: no logic was added, rewritten or invented, and the identifiers, strings and structure are his. Where the decompiler had to infer a keyword, the line is marked with `&& ?` as described above.

## License

Released under the [MIT License](../../LICENSE), like the rest of `src/`. The FoxPro runtime needed to run the program is Microsoft's and is not covered; see [NOTICE](../../NOTICE).
