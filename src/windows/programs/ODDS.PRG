* ODDS.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module ODDS.FXP, compiled 1995-01-05 04:08).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE odds
PARAMETERS y, x, count
IF y == x
	RETURN "       Can't Miss!"
ENDIF
countx = x
county = y
DO WHILE .T.
	d = MOD(y, x)
	IF d = 1
		x = countx
		y = county
		EXIT
	ENDIF
	IF d = 0
		y = county / x
		x = countx / x
		EXIT
	ENDIF
	y = x
	x = d
ENDDO
RETURN PADL(ALLTRIM(STR(x)), 9) + " IN " + PADL(ALLTRIM(STR(y)), 3)    && ? decompiler guessed a keyword on this line
