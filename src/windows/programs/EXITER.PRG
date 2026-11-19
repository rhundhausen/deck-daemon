* EXITER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module EXITER.FXP, compiled 1995-07-05 21:25).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE exiter
PARAMETERS exitflag
IF exitflag
	DO cleanitup
	QUIT
ELSE
	IF alertit("Exit Deck Daemon?")
		DO cleanitup
		QUIT
	ENDIF
ENDIF


PROCEDURE cleanitup
MOVE WINDOW screen TO -1000, -1000
CLOSE ALL
CLEAR ALL
CLEAR
SET SYSMENU TO DEFAULT
ON SHUTDOWN    && ? decompiler guessed a keyword on this line
ON ERROR
ON KEY
