* GETIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module GETIT.FXP, compiled 1995-04-11 10:37).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE getit
PARAMETERS number
m.text = FREAD(handle, number)
IF LEN(m.text) <> number
	= errormsg("Importing", "File not in Deck Daemon Format!", 1)
	RETURN TO import
ENDIF
ferror = FERROR()
IF ferror = 0
	RETURN m.text
ELSE
	= errors("Importing", ferror, 1)
	RETURN TO import
ENDIF
