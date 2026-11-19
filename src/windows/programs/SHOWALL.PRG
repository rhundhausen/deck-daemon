* SHOWALL.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SHOWALL.FXP, compiled 1995-03-06 11:11).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

DO showall IN "filter.prg"
IF WEXIST("cards")
	SHOW WINDOW SAY ("cards")
ENDIF
