* STARTUP.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module STARTUP.FXP, compiled 1995-03-20 10:47).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

REINDEX
IF NOT FILE(SYS(2004) + "STARTUP.LST")
	IF errors("Starting", 9004, 2) = 2
		DO exiter WITH .T.
	ENDIF
	RETURN
ENDIF
path = SYS(2004) + "STARTUP.LST"
DO import WITH 5
