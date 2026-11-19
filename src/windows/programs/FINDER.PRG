* FINDER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module FINDER.FXP, compiled 1995-04-11 09:20).
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
IF NOT WEXIST("finder") OR UPPER(WTITLE("FINDER")) == "FINDER.PJX" OR UPPER(WTITLE("FINDER")) == "FINDER.SCX" OR UPPER(WTITLE("FINDER")) == "FINDER.MNX" OR UPPER(WTITLE("FINDER")) == "FINDER.PRG" OR UPPER(WTITLE("FINDER")) == "FINDER.FRX" OR UPPER(WTITLE("FINDER")) == "FINDER.QPR"
	DEFINE WINDOW finder AT 0.000, 0.000 SIZE 24.313, 96.400 FONT "Times New Roman", 9 STYLE "I" FLOAT CLOSE TITLE "Finder" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW finder CENTER
ENDIF
o_rec = RECNO()
o_order = ORDER()
DIMENSION a_cards(1, 2)
a_cards(1, 1) = ""
m.found = 0
m.text = ""
SET ORDER TO '"card"'
IF WVISIBLE("finder")
	ACTIVATE WINDOW finder SAME
ELSE
	ACTIVATE WINDOW finder NOSHOW
ENDIF
@ 3.563, 56.800 SAY "Locate In:" FONT "Times New Roman", 9 STYLE isystem + "T"
@ 0.875, 56.800 SAY "Locate Text:" FONT "Times New Roman", 9 STYLE isystem + "T"
@ 4.688, 56.200 TO 7.438, 66.800 STYLE "T" PATTERN 1 PEN 1, 8
@ 9.188, 53.800 COLOR RGB(,,,128,0,0) TO 23.751, 91.000 STYLE "16" PATTERN 1 PEN 2, 8
@ 8.438, 51.400 COLOR RGB(,,,128,0,0) TO 23.001, 88.600 STYLE "16" PATTERN 1 PEN 2, 8
@ 14.375, 52.000 TO 20.813, 88.200 PEN 2, 8
@ 2.250, 56.600 GET m.what DEFAULT " " FONT "Times New Roman", 9 STYLE isystem + "T" SIZE 0.938, 27.200 PICTURE "@!T" VALID _qya0nr256() WHEN _qya0nr23u()
@ 4.188, 72.000 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.769, 8.833, 0.308 PICTURE "@*VN \<Search;\<Cancel" VALID _qya0nr26d()
@ 4.875, 57.600 GET m.where DEFAULT 1 FONT "Times New Roman", 9 STYLE isystem + "T" SIZE 1.063, 9.000, 0.250 PICTURE "@*RVN Title;Text" WHEN _qya0nr2a6()
@ 10.250, 53.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.card) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 41.250
@ 8.813, 75.200 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", IIF(zsystem, castcost(9, 84, 3), cards.cost + "   ")) FONT "Times New Roman", 8 STYLE isystem SIZE 0.929, 13.750 PICTURE "@J"
@ 11.563, 53.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.type) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 26.000
@ 12.938, 53.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series) OR m.found = 0, "", m.series) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 17.000
@ 11.563, 77.200 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.color + " ") FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 11.000 PICTURE "@J"
@ 12.938, 74.600 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.rarity + " ") FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 14.000 PICTURE "@J"
@ 8.750, 53.400 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open" OR m.found = 0, "", cards.restrictio) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 14.000 PICTURE "@I"
@ 14.500, 52.800 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.descriptio) FONT "Times New Roman", 8 STYLE isystem SIZE 7.000, 43.000
@ 2.000,5.600 GET m.found  PICTURE "@&N"  FROM a_cards  SIZE 19.125,42.200  DEFAULT 1  FONT "Times New Roman", 9  STYLE isystem+"T"  WHEN _qya0nr2g3()  VALID _qya0nr2h0()  DISABLE
@ 0.563, 5.600 SAY m.text FONT "Times New Roman", 9 STYLE isystem + "T" SIZE 0.938, 41.400 PICTURE "@I"
@ 22.125, 5.800 SAY IIF(NOT EMPTY(FILTER()), "Finder is using Filtered Data!", "") FONT "Times New Roman", 10 STYLE "B" + isystem + "T" SIZE 0.941, 41.600 PICTURE "@I"
@ 1.688, 54.600 TO 8.001, 85.200 PEN 1, 8
IF NOT WVISIBLE("finder")
	ACTIVATE WINDOW finder
ENDIF
READ CYCLE SHOW _qya0nr2j9() DEACTIVATE _qya0nr2j7()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW finder
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SET ORDER TO (o_order)


PROCEDURE _qya0nr23u
m.found = 0
DIMENSION a_cards(1, 2)
a_cards(1, 1) = ""
SHOW GET m.found DISABLE
SHOW GET m.but, 1 ENABLE
SHOW GETS OFF
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qya0nr256
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qya0nr26d
IF m.but == 1
	m.what = ALLTRIM(UPPER(m.what))    && ? decompiler guessed a keyword on this line
	SHOW GET m.but, 1 DISABLE
	m.text = "Searching. . ."
	SHOW GETS OFF
	IF m.where == 1
		SCAN FOR (m.what $ UPPER(cards.card))    && ? decompiler guessed a keyword on this line
			m.found = m.found + 1
			DIMENSION a_cards(m.found, 2)
			a_cards(m.found, 1) = cards.card
			a_cards(m.found, 2) = RECNO()
			SHOW GET m.found ENABLE
			SHOW GETS OFF
			IF m.found = 200
				= errormsg("Searching", "Overflow! Narrow Search Text!", 1)
				EXIT
			ENDIF
		ENDSCAN
	ELSE
		SCAN FOR (m.what $ UPPER(cards.descriptio))    && ? decompiler guessed a keyword on this line
			m.found = m.found + 1
			DIMENSION a_cards(m.found, 2)
			a_cards(m.found, 1) = cards.card
			a_cards(m.found, 2) = RECNO()
			SHOW GET m.found ENABLE
			SHOW GETS OFF
			IF m.found = 200
				= errormsg("Searching", "Overflow! Narrow Search Text!", 1)
				EXIT
			ENDIF
		ENDSCAN
	ENDIF
	IF m.found >= 1
		m.text = ALLTRIM(STR(m.found)) + " Cards Found"    && ? decompiler guessed a keyword on this line
		IF m.found = 200
			m.text = m.text + " {Overflow}"
		ENDIF
		SHOW GETS OFF
		SHOW GET m.found ENABLE
		_CUROBJ = OBJNUM(m.found)
	ELSE
		m.text = "No Match found"
		m.found = 0
		SHOW GETS
		_CUROBJ = 1
	ENDIF
ELSE
	GO o_rec
	CLEAR READ
ENDIF


PROCEDURE _qya0nr2a6
m.text = ""
m.found = 0
DIMENSION a_cards(1, 2)
a_cards(1, 1) = ""
SHOW GET m.found DISABLE
SHOW GET m.but, 1 ENABLE
SHOW GETS OFF


PROCEDURE _qya0nr2g3
GO a_cards(m.found, 2)
SHOW GETS OFF WINDOW finder


PROCEDURE _qya0nr2h0
CLEAR READ


PROCEDURE _qya0nr2j7
CLEAR READ


PROCEDURE _qya0nr2j9
PRIVATE currwind
STORE WOUTPUT() TO currwind
x = ASCAN(b_series, cards.series)
IF NOT x = 0
	m.series = a_series(x)
ELSE
	m.series = ""
ENDIF
IF SYS(2016) = "FINDER" OR SYS(2016) = "*"
	ACTIVATE WINDOW finder SAME
	@ 10.250, 53.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.card) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 41.250, 0.000
	@ 8.913, 73.200 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", IIF(zsystem, castcost(9, 84, 3), cards.cost + "   ")) FONT "Times New Roman", 10 STYLE isystem SIZE 0.929, 13.750, 0.000 PICTURE "@J"
	@ 11.563, 53.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.type) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 26.000, 0.000
	@ 12.938, 53.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series) OR m.found = 0, "", m.series) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 17.000, 0.000
	@ 11.563, 77.200 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.color + " ") FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 11.000, 0.000 PICTURE "@J"
	@ 12.938, 74.600 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.rarity + " ") FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 14.000, 0.000 PICTURE "@J"
	@ 8.750, 53.400 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open" OR m.found = 0, "", cards.restrictio) FONT "Times New Roman", 8 STYLE isystem SIZE 1.000, 14.000, 0.000 PICTURE "@I"
	@ 14.500, 52.800 COLOR RGB(255,255,0,128,0,0) SAY IIF(m.found = 0, "", cards.descriptio) FONT "Times New Roman", 8 STYLE isystem SIZE 7.000, 43.000, 0.000
	@ 0.563, 5.600 CLEAR TO 1.501, 47.000
	@ 0.563, 5.600 SAY m.text FONT "Times New Roman", 9 STYLE isystem + "T" SIZE 0.938, 41.400, 0.000 PICTURE "@I"
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
