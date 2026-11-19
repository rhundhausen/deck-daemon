* SUMMARY.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SUMMARY.FXP, compiled 1995-03-12 21:29).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

PRIVATE m.currarea, m.talkstat, m.compstat
IF SET("TALK") = "ON"
	SET TALK OFF
	m.talkstat = "ON"
ELSE
	m.talkstat = "OFF"
ENDIF
m.compstat = SET("COMPATIBLE")
SET COMPATIBLE OFF
m.rborder = SET("READBORDER")
SET READBORDER ON
IF NOT WEXIST("_qya0nw7z1")
	DEFINE WINDOW _qya0nw7z1 AT 0.000, 0.000 SIZE 22.846, 98.400 FONT "MS Sans Serif", 8 FLOAT CLOSE TITLE "Rebuild Error Summary" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qya0nw7z1 CENTER
ENDIF
IF WVISIBLE("_qya0nw7z1")
	ACTIVATE WINDOW _qya0nw7z1 SAME
ELSE
	ACTIVATE WINDOW _qya0nw7z1 NOSHOW
ENDIF
@ 3.769, 9.800 SAY TRANSFORM(m.bseries, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.400
@ 5.615, 9.800 SAY TRANSFORM(m.eseries, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 5.615, 19.000 SAY "ReLinked" FONT "MS Sans Serif", 8 STYLE "T"
@ 2.769, 7.000 TO 8.384, 33.600 STYLE "T" PEN 1, 8
@ 1.923, 14.200 SAY "Card Series." FONT "MS Sans Serif", 8 STYLE "T"
@ 3.769, 38.600 SAY TRANSFORM(m.bcolor, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.400
@ 5.615, 38.600 SAY TRANSFORM(m.ecolor, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 5.615, 47.800 SAY "ReLinked" FONT "MS Sans Serif", 8 STYLE "T"
@ 2.769, 35.800 TO 8.384, 62.400 STYLE "T" PEN 1, 8
@ 1.923, 43.400 SAY "Card Colors" FONT "MS Sans Serif", 8 STYLE "T"
@ 3.769, 67.400 SAY TRANSFORM(m.btype, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.400
@ 5.615, 67.400 SAY TRANSFORM(m.etype, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 5.615, 76.600 SAY "ReLinked" FONT "MS Sans Serif", 8 STYLE "T"
@ 2.769, 64.600 TO 8.384, 91.200 STYLE "T" PEN 1, 8
@ 1.923, 71.800 SAY "Card Types" FONT "MS Sans Serif", 8 STYLE "T"
@ 11.154, 9.800 SAY TRANSFORM(m.bartist, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.400
@ 13.000, 9.800 SAY TRANSFORM(m.eartist, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 13.000, 19.000 SAY "ReLinked" FONT "MS Sans Serif", 8 STYLE "T"
@ 10.154, 7.000 TO 15.769, 33.600 STYLE "T" PEN 1, 8
@ 9.308, 14.000 SAY "Card Artists" FONT "MS Sans Serif", 8 STYLE "T"
@ 10.154, 35.800 TO 15.769, 62.400 STYLE "T" PEN 1, 8
@ 10.154, 64.600 TO 15.769, 91.200 STYLE "T" PEN 1, 8
@ 11.154, 38.600 SAY TRANSFORM(m.ename, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 9.308, 43.200 SAY "Card Names" FONT "MS Sans Serif", 8 STYLE "T"
@ 11.154, 67.400 SAY TRANSFORM(m.edeck, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 11.154, 75.600 SAY "Cards Outdated" FONT "MS Sans Serif", 8 STYLE "T"
@ 9.308, 74.200 SAY "Decks" FONT "MS Sans Serif", 8 STYLE "T"
@ 13.000, 72.400 SAY TRANSFORM(m.edecknm, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 13.000, 68.000 SAY "In" FONT "MS Sans Serif", 8 STYLE "T"
@ 13.000, 81.200 SAY "Decks" FONT "MS Sans Serif", 8 STYLE "T"
@ 20.462, 43.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 10.333, 0.667 PICTURE "@*HT \<OK"
@ 3.769, 19.200 SAY "Found Blank" FONT "MS Sans Serif", 8 STYLE "T"
@ 3.769, 48.000 SAY "Found Blank" FONT "MS Sans Serif", 8 STYLE "T"
@ 3.769, 76.800 SAY "Found Blank" FONT "MS Sans Serif", 8 STYLE "T"
@ 11.154, 19.200 SAY "Found Blank" FONT "MS Sans Serif", 8 STYLE "T"
@ 11.154, 48.000 SAY "Found Blank" FONT "MS Sans Serif", 8 STYLE "T"
@ 17.538,65.000 GET m.dbut  PICTURE "@&N"  FROM anames  SIZE 4.615,26.200  DEFAULT 1  FONT "MS Sans Serif", 8  COLOR RGB(,,,255,255,255),RGB(,,,255,255,255)
@ 16.615, 70.400 SAY "Decks Affected" FONT "MS Sans Serif", 8 STYLE "T"
@ 14.462, 67.600 SAY TRANSFORM(m.ldeck, "9,999") FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 6.600
@ 14.462, 75.800 SAY "Cards Unlinked" FONT "MS Sans Serif", 8 STYLE "T"
@ 20.308, 7.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 13.500, 0.667 PICTURE "@*HN Print Report" VALID _qya0nw8f4()
IF NOT WVISIBLE("_qya0nw7z1")
	ACTIVATE WINDOW _qya0nw7z1
ENDIF
READ CYCLE DEACTIVATE _qya0nw8h1() WHEN _qya0nw8h0()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW _qya0nw7z1
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE _qya0nw8f4
USE IN 0 "daemon9.ddw" ALIAS list
m.pscreen = .F.
m.pprint = .F.
DO "except.prg"
SELECT list
header = "Rebuild Errorlog"
IF m.pscreen
	REPORT FORM "EXCEPT" PREVIEW NOCONSOLE
ENDIF
IF m.pprint
	REPORT FORM "EXCEPT" TO PRINTER PROMPT NOCONSOLE
ENDIF
USE
SELECT cards


PROCEDURE _qya0nw8h0
IF m.edeck = 0
	SHOW GET m.dbut DISABLE
ENDIF


PROCEDURE _qya0nw8h1
CLEAR READ
