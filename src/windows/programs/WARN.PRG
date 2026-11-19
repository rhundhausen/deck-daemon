* WARN.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module WARN.FXP, compiled 1994-12-20 04:16).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE warn
PARAMETERS temp
WAIT WINDOW NOWAIT temp
?? CHR(7)
RETURN
