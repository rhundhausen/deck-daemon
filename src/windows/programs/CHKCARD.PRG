* CHKCARD.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CHKCARD.FXP, compiled 1995-03-19 01:00).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE chkcard
PARAMETERS chkpath, chkmany, kind
PRIVATE scanned
scanned = 0
handle = FOPEN(chkpath, 2)
IF handle < 1
	= errormsg("Scanning File", "Could Not Open File!", 1)
	RETURN TO import
ENDIF
DO WHILE .T.
	= FGETS(handle, 2)
	IF FEOF(handle)
		= FCLOSE(handle)
		WAIT WINDOW NOWAIT TRANSFORM(scanned, "999,999") + " Records Verified!"
		RETURN scanned
	ENDIF
	m.text = FREAD(handle, chkmany + 50)
	ferror = FERROR()
	IF ferror <> 0
		DO errors WITH "Scanning File", ferror + 800, 1
	ENDIF
	IF LEN(m.text) <> (chkmany - 2)
		= errormsg("Scanning File", "Doesn't seem to be a " + kind + " Update file!", 1)
		RETURN TO import
	ENDIF
	scanned = scanned + 1
	WAIT WINDOW NOWAIT "Scanning Record : " + TRANSFORM(scanned, "999,999")
ENDDO
