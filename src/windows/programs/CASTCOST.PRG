* CASTCOST.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CASTCOST.FXP, compiled 1995-06-05 23:56).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE castcost
PARAMETERS y, x, z
PRIVATE text
@ y, x - 20 COLOR RGB(128,0,0,128,0,0) TO y + 1, x + 4 PATTERN 1 CURVATURE    && ? decompiler guessed a keyword on this line
IF EMPTY(cards.cost)
	@ y, x - 20 SAY ""
	RETURN ""
ENDIF
text = cards.cost
IF OCCURS("X", text) <> 0
	@ y, x COLOR RGB(192,192,192,,,) SAY CHR(181) FONT "Wingdings", 12 STYLE "T" SIZE 1, 4
	x = x - z
ENDIF
= howmany("W", 255, 255, 255)
= howmany("R", 255, 0, 0)
= howmany("G", 0, 255, 0)
= howmany("B", 0, 0, 0)
= howmany("U", 0, 0, 255)
IF ISDIGIT(LEFT(text, 1))
	@ y, x COLOR RGB(192,192,192,,,) SAY CHR(128 + VAL(LEFT(text, 2))) FONT "Wingdings", 12 STYLE "T" SIZE 1, 4
ENDIF
@ y, x - 6 * z SAY ""
RETURN ""


PROCEDURE howmany
PARAMETERS string, col1, col2, col3
num = OCCURS(string, text)
IF num <> 0
	@ y, x COLOR RGB(col1,col2,col3,,,) SAY CHR(139 + num) FONT "Wingdings", 12 STYLE "T" SIZE 1, 4
	x = x - z
ENDIF
RETURN
