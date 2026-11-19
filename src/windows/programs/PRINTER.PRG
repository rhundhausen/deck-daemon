* PRINTER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PRINTER.FXP, compiled 1995-05-15 22:43).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE printer
PARAMETERS ptype
IF a_button(1) = "-----"
	WAIT WINDOW NOWAIT "Nothing to print!"
	RETURN
ENDIF
WAIT WINDOW NOWAIT "Setting up..."
IF a_print(13, 1)
	m.table = "cards,price where cards.cardnumber = price.cardnumber and price.reference = str(m.rcsystem,10)"
	USE IN 0 "daemon8.ddw" AGAIN ALIAS price INDEX "daemon8.ddx"
ELSE
	m.table = "cards"
ENDIF
header1 = ""
header2 = ""
body = ""
m.field = ""
m.sortr = ""
FOR j = 1 TO 7
	IF a_button(j) <> "-----"
		x = ASCAN(a_def, a_button(j))
		IF x = 0
			= errors("Building Print Query", 9001, 1)
			RETURN TO main
		ENDIF
		IF NOT (x = 1 AND a_print(2, 1))
			m.length = ABS(a_print(x, 3))    && ? decompiler guessed a keyword on this line
			header1 = header1 + PADR(a_print(x, 4), m.length)
			header2 = header2 + PADR(a_print(x, 5), m.length)
			body = body + "padr(" + a_print(x, 2) + "," + ALLTRIM(STR(m.length)) + ")+"    && ? decompiler guessed a keyword on this line
			m.field = m.field + psort(a_print(x, 6))
			IF j < 5
				m.sortr = m.sortr + psort(a_print(x, 7))
			ENDIF
		ENDIF
	ENDIF
ENDFOR
m.field = LEFT(m.field, LEN(m.field) - 1)
m.sortr = LEFT(m.sortr, LEN(m.sortr) - 1)
body = LEFT(body, (LEN(body) - 1))
IF EMPTY(pfilter)
	SELECT &field FROM &table INTO CURSOR QUERY NOCONSOLE ORDER BY &sortr
ELSE
	SELECT &field FROM &table INTO CURSOR QUERY HAVING &pfilter NOCONSOLE ORDER BY &sortr
ENDIF
SELECT query
IF ptype == 1
	REPORT FORM "daemon.frx" PREVIEW NOCONSOLE
ELSE
	REPORT FORM "daemon.frx" TO PRINTER PROMPT NOCONSOLE
ENDIF
IF a_print(13, 1)
	SELECT price
	USE
	IF USED("daemon8")
		SELECT daemon8
		USE
	ENDIF
ENDIF
SELECT query
USE
SELECT cards
RETURN


PROCEDURE psort
PARAMETERS string
string = string + ","
RETURN string
