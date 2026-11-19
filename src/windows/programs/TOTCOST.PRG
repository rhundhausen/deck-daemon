* TOTCOST.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module TOTCOST.FXP, compiled 1995-03-02 21:59).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE totcost
PARAMETERS ccost
totcost = VAL(LEFT(ccost, 2))
FOR x = 1 TO LEN(ccost)
	temp = SUBSTR(ccost, x, 1)
	IF ISALPHA(temp)    && ? decompiler guessed a keyword on this line
		totcost = totcost + 1
	ENDIF
ENDFOR
RETURN totcost
