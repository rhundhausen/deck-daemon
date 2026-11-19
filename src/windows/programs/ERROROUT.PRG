* ERROROUT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module ERROROUT.FXP, compiled 1995-04-26 23:10).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE errorout
PARAMETERS x, m.eprogram, elinenum, epath
ON ERROR
temp = errormsg("", MESSAGE(), 3)
ON ERROR DO errorout WITH ERROR(),PROGRAM(),LINENO(1),SYS(16)
IF temp = 1
	DO WHILE (WONTOP() <> "")
		RELEASE WINDOW (WONTOP())
	ENDDO
	CLOSE ALTERNATE    && ? decompiler guessed a keyword on this line
	USE IN 0 "daemon1.ddw" ALIAS cards INDEX "daemon1.ddx"
	DO errorsave
	m.run = 1
	RETURN TO main
ENDIF
IF temp = 2
	RETRY
ENDIF
DO errorsave
ON SHUTDOWN    && ? decompiler guessed a keyword on this line
CLOSE ALL
QUIT


PROCEDURE errorsave
SET PRINTER TO "ERROR.TXT" ADDITIVE
SET PRINTER ON
SET CONSOLE OFF
?
? " --------------------------------------------"
? "Deck Daemon Internal Error"
? DTOC(DATE())
? TIME()
?
? "Description : " + MESSAGE()
? "Error #     : " + TRANSFORM(x, "999")
? "Reference   : " + m.eprogram
? "Line        : " + ALLTRIM(TRANSFORM(elinenum, "999,999,999"))    && ? decompiler guessed a keyword on this line
? "Path        : " + epath
SET CONSOLE ON
SET PRINTER OFF
SET PRINTER TO
RETURN .T.
