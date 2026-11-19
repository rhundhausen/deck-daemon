* PCHECK.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PCHECK.FXP, compiled 1995-03-12 17:23).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE pcheck
PARAMETERS string
IF string = "-----"
	RETURN
ENDIF
PRIVATE x
x = ASCAN(a_def, string)
IF x <> 0
	a_print(x, 1) = NOT a_print(x, 1)
	IF a_print(x, 1)
		pavail = pavail - ABS(a_print(x, 3))    && ? decompiler guessed a keyword on this line
	ELSE
		pavail = pavail + ABS(a_print(x, 3))    && ? decompiler guessed a keyword on this line
	ENDIF
	RETURN
ENDIF
= errors("Switching Options", 9001, 1)
RETURN TO main
