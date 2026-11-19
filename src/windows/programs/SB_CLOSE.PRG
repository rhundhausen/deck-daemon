* SB_CLOSE.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SB_CLOSE.FXP, compiled 1995-03-20 10:50).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

IF WEXIST("STAT_BAR")
	RELEASE WINDOW ("STAT_BAR")
	RELEASE sb_bar
	RELEASE sb_text
ENDIF
