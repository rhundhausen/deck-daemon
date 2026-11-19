* DRAW.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module DRAW.FXP, compiled 1995-05-16 23:25).
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
IF NOT WEXIST("draw") OR UPPER(WTITLE("DRAW")) == "DRAW.PJX" OR UPPER(WTITLE("DRAW")) == "DRAW.SCX" OR UPPER(WTITLE("DRAW")) == "DRAW.MNX" OR UPPER(WTITLE("DRAW")) == "DRAW.PRG" OR UPPER(WTITLE("DRAW")) == "DRAW.FRX" OR UPPER(WTITLE("DRAW")) == "DRAW.QPR"
	DEFINE WINDOW draw AT 0.000, 0.000 SIZE 25.786, 125.000 FONT "Times New Roman", 8 STYLE m.isystem FLOAT CLOSE TITLE "Random Draw" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW draw CENTER
ENDIF
DIMENSION a_draw(1, 6)
a_draw(1, 1) = "Top of Deck"
COUNT TO m.total
SUM TO totcards cards.count
GO TOP
x = 1
DO WHILE NOT EOF()
	DIMENSION a_done(x, 2)
	a_done(x, 1) = cards.count
	a_done(x, 2) = RECNO()
	x = x + 1
	SKIP
ENDDO
drawnum = IIF(totcards > 8, 8, totcards)
curcard = 1
current = 1
IF WVISIBLE("draw")
	ACTIVATE WINDOW draw SAME
ELSE
	ACTIVATE WINDOW draw NOSHOW
ENDIF
@ 3.071, 63.250 COLOR RGB(,,,128,0,0) TO 19.714, 109.500 STYLE "16" PATTERN 1 PEN 2, 8
@ 2.429, 61.000 COLOR RGB(,,,128,0,0) TO 19.072, 107.250 STYLE "16" PATTERN 1 PEN 2, 8
@ 1.786, 58.750 COLOR RGB(,,,128,0,0) TO 18.429, 105.000 STYLE "16" PATTERN 1 PEN 2, 8
@ 10.643, 70.500 TO 10.643, 70.500 STYLE "16" PEN 1, 8
@ 8.500, 59.000 TO 15.857, 104.250 PEN 2, 8
@ 0.429,5.000 GET m.curcard  PICTURE "@&N"  FROM a_draw  SIZE 21.714,38.750  DEFAULT 1  FONT "Times New Roman", 8  STYLE m.isystem  WHEN _qym0sq8rc()  VALID _qym0sq8sg()  DISABLE  COLOR RGB(,,,255,255,255),RGB(,,,255,255,255)
@ 22.929, 14.000 COLOR, RGB(,,,255,255,255) GET m.drawnum DEFAULT 0.000 FONT "Times New Roman", 8 STYLE m.isystem SIZE 0.857, 7.500 RANGE 0, 30 PICTURE "@K 99" ENABLE 1.000, 0, 30 VALID _qym0sq8ts() MESSAGE "Invalid Number of Cards to Draw!"    && ? decompiler guessed a keyword on this line
@ 22.500, 43.500 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.923, 16.667, 1.167 PICTURE "@*HN \<Draw;\<Shuffle;\<Cancel" VALID _qym0sq8v3()
@ 2.071, 59.250 GET m.tapped DEFAULT 0 FONT "Times New Roman", 8 STYLE m.isystem SIZE 15.643, 44.250, 1.000 PICTURE "@*IHN " VALID _qym0sq8yh()
@ 20.714, 58.500 SAY IIF(a_draw(curcard, 2), "This card Tapped", "") FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.125, 39.800 PICTURE "@I"
@ 3.571, 60.500 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 40.750
@ 2.143, 90.750 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT zsystem, cards.cost, castcost(2, 100, 4)) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000 PICTURE "@J"
@ 5.071, 60.250 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000
@ 6.643, 60.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series), "", m.series) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 17.000
@ 5.071, 90.500 COLOR RGB(255,255,0,128,0,0) SAY cards.color FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000 PICTURE "@J"
@ 6.643, 87.250 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000 PICTURE "@J"
@ 2.143, 60.750 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000 PICTURE "@I"
@ 8.714, 60.000 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 43.000
@ 16.286, 73.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.count = 0, "", cards.count) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 16.250 PICTURE "@I"
@ 0.286, 57.500 SAY "Cards left to draw :" + ALLTRIM(STR(totcards - current + 1)) FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 50.750 PICTURE "@I"    && ? decompiler guessed a keyword on this line
IF NOT WVISIBLE("draw")
	ACTIVATE WINDOW draw
ENDIF
READ CYCLE SHOW _qym0sq92x() DEACTIVATE _qym0sq92v()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW draw
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE checkitem
IF current > 1
	IF LEFT(a_draw(curcard, 1), 1) = CHR(2)
		a_draw(curcard, 1) = "   " + RIGHT(a_draw(curcard, 1), 30)
		a_draw(curcard, 2) = .F.
	ELSE
		a_draw(curcard, 1) = CHR(2) + RIGHT(a_draw(curcard, 1), 30)
		a_draw(curcard, 2) = .T.
	ENDIF
ENDIF
SHOW GETS WINDOW draw


PROCEDURE reset
PRIVATE x
DIMENSION a_draw(1, 6)
a_draw(1, 1) = "Top of Deck"
a_draw(1, 2) = .F.
COUNT TO m.total
SUM TO totcards cards.count
GO TOP
x = 1
DO WHILE NOT EOF()
	DIMENSION a_done(x, 2)
	a_done(x, 1) = cards.count
	a_done(x, 2) = RECNO()
	x = x + 1
	SKIP
ENDDO
drawnum = 8
curcard = 1
current = 1
SHOW GET m.drawnum ENABLE
SHOW GETS WINDOW draw


PROCEDURE _qym0sq8rc
GO a_draw(m.curcard, 3)
SHOW GETS OFF WINDOW draw


PROCEDURE _qym0sq8sg
_CUROBJ = 1
RETURN checkitem()


PROCEDURE _qym0sq8ts
m.drawnum = IIF(m.drawnum > (totcards - current + 1), totcards - current + 1, m.drawnum)


PROCEDURE _qym0sq8v3
DO CASE
	CASE m.but == 1
		IF m.drawnum > 0
			SHOW GET curcard ENABLE
		ENDIF
		DO WHILE m.drawnum <> 0
			x = INT(RAND() * (m.totcards - current + 1)) + 1
			xi = 0
			DO WHILE x > 0
				xi = xi + 1
				x = x - a_done(xi, 1)
			ENDDO
			GO a_done(xi, 2)
			a_done(xi, 1) = a_done(xi, 1) - 1
			DIMENSION a_draw(current, 3)
			a_draw(current, 1) = "   " + cards.card
			a_draw(current, 2) = .F.
			a_draw(current, 3) = RECNO()
			curcard = current
			current = current + 1
			m.drawnum = m.drawnum - 1
			SHOW GETS WINDOW draw
			IF current > totcards
				EXIT
			ENDIF
		ENDDO
		m.drawnum = 1
		SHOW GET m.drawnum
		IF current > totcards
			SHOW GET m.but, 1 DISABLE
			SHOW GET m.drawnum DISABLE
		ENDIF
		_CUROBJ = 1
	CASE m.but == 2
		DO reset
		SHOW GET m.but ENABLE
		SHOW GET m.curcard DISABLE
	CASE m.but == 3
		CLEAR READ
ENDCASE


PROCEDURE _qym0sq8yh
DO checkitem
_CUROBJ = 1


PROCEDURE _qym0sq92v
CLEAR READ


PROCEDURE _qym0sq92x
PRIVATE currwind
STORE WOUTPUT() TO currwind
x = ASCAN(b_series, cards.series)
IF NOT current = 1 AND NOT x = 0
	m.series = a_series(x)
ELSE
	m.series = ""
ENDIF
IF SYS(2016) = "DRAW" OR SYS(2016) = "*"
	ACTIVATE WINDOW draw SAME
	@ 20.714, 58.500 CLEAR TO 21.839, 98.300
	@ 20.714, 58.500 SAY IIF(a_draw(curcard, 2), "This card Tapped", "") FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.125, 39.800, 0.000 PICTURE "@I"
	@ 3.571, 60.500 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 40.750, 0.000
	@ 2.143, 90.750 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT zsystem, cards.cost, castcost(2, 100, 4)) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000, 0.000 PICTURE "@J"
	@ 5.071, 60.250 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000, 0.000
	@ 6.643, 60.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series), "", m.series) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 17.000, 0.000
	@ 5.071, 90.500 COLOR RGB(255,255,0,128,0,0) SAY cards.color FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000, 0.000 PICTURE "@J"
	@ 6.643, 87.250 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000, 0.000 PICTURE "@J"
	@ 2.143, 60.750 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000, 0.000 PICTURE "@I"
	@ 8.714, 60.000 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 43.000, 0.000
	@ 16.286, 73.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.count = 0, "", cards.count) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 16.250, 0.000 PICTURE "@I"
	@ 0.286, 57.500 CLEAR TO 1.286, 108.250
	@ 0.286, 57.500 SAY "Cards left to draw :" + ALLTRIM(STR(totcards - current + 1)) FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 50.750, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
