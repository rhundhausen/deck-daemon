* DECK.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module DECK.FXP, compiled 1995-04-11 09:20).
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
IF NOT WEXIST("deckshow") OR UPPER(WTITLE("DECKSHOW")) == "DECKSHOW.PJX" OR UPPER(WTITLE("DECKSHOW")) == "DECKSHOW.SCX" OR UPPER(WTITLE("DECKSHOW")) == "DECKSHOW.MNX" OR UPPER(WTITLE("DECKSHOW")) == "DECKSHOW.PRG" OR UPPER(WTITLE("DECKSHOW")) == "DECKSHOW.FRX" OR UPPER(WTITLE("DECKSHOW")) == "DECKSHOW.QPR"
	DEFINE WINDOW deckshow AT 0.000, 0.000 SIZE 22.857, 130.250 FONT "Times New Roman", 8 STYLE "I" COLOR RGB(,,,255,255,255) FLOAT CLOSE TITLE m.deckname NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW deckshow CENTER
ENDIF
DO keys WITH .T.
o_alias = ALIAS()
SELECT cards
o_filter = FILTER()
o_order = ORDER()
o_rec = RECNO()
SET FILTER TO cards.count > 0
SET ORDER TO '"CARD"'
DEFINE POPUP _qz21bkx8u PROMPT PROMPT FIELD cards.card NOSHOW
IF WVISIBLE("deckshow")
	ACTIVATE WINDOW deckshow SAME
ELSE
	ACTIVATE WINDOW deckshow NOSHOW
ENDIF
@ 2.571, 83.250 COLOR RGB(,,,128,0,0) TO 19.214, 129.750 STYLE "16" PATTERN 1 PEN 2, 8
@ 1.714, 80.250 COLOR RGB(,,,128,0,0) TO 18.357, 126.750 STYLE "16" PATTERN 1 PEN 2, 8
@ 0.857, 77.250 COLOR RGB(,,,128,0,0) TO 17.500, 123.750 STYLE "16" PATTERN 1 PEN 2, 8
@ 1.500,8.750 GET m.but  PICTURE "@&N"  POPUP _qz21bkx8u  SIZE 14.625,39.400  DEFAULT " "  FONT "Times New Roman", 10  STYLE m.isystem  WHEN _qz21bkxb5()  VALID _qz21bkxcq()  COLOR RGB(,,,255,255,255),RGB(,,,255,255,255)
@ 7.643, 78.000 TO 15.000, 123.250 PEN 2, 8
@ 2.643, 79.250 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 41.500
@ 1.286, 109.750 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT zsystem, cards.cost, castcost(1, 117, 4)) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000 PICTURE "@J"
@ 4.143, 79.250 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000
@ 5.714, 79.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series), "", m.series) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 17.000
@ 4.143, 109.500 COLOR RGB(255,255,0,128,0,0) SAY cards.color FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000 PICTURE "@J"
@ 5.714, 106.250 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000 PICTURE "@J"
@ 1.286, 79.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000 PICTURE "@I"
@ 7.857, 79.000 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 43.000
@ 15.429, 92.250 COLOR RGB(255,255,0,128,0,0) SAY cards.count FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 16.250 PICTURE "@I"
@ 20.286, 16.250 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 15.333, 0.667 PICTURE "@*HN \<Edit Deck;\<Deck Stats;\<Random Draw;\<Cancel" VALID _qz21bkxgp()
IF NOT WVISIBLE("deckshow")
	ACTIVATE WINDOW deckshow
ENDIF
READ CYCLE SHOW _qz21bkxim() DEACTIVATE _qz21bkxik()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW deckshow
RELEASE POPUP _qz21bkx8u
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
DO keys
SET FILTER TO &o_filter
SET ORDER TO &o_order
GO (o_rec)
SELECT (o_alias)


PROCEDURE _qz21bkxb5
SHOW GETS OFF WINDOW deckshow


PROCEDURE _qz21bkxcq
IF m.run == 3
	o_rec = RECNO("cards")
	CLEAR READ
	SHOW GETS
ENDIF


PROCEDURE _qz21bkxgp
DO CASE
	CASE m.but == 1
		m.run = 3
		CLEAR READ
	CASE m.but == 2
		DO "stats.prg"
	CASE m.but == 3
		DO "draw.prg"
	CASE m.but == 4
		CLEAR READ
ENDCASE


PROCEDURE _qz21bkxik
CLEAR READ


PROCEDURE _qz21bkxim
PRIVATE currwind
STORE WOUTPUT() TO currwind
x = ASCAN(b_series, cards.series)
IF NOT x = 0
	m.series = a_series(x)
ENDIF
IF SYS(2016) = "DECKSHOW" OR SYS(2016) = "*"
	ACTIVATE WINDOW deckshow SAME
	@ 2.643, 79.250 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 41.500, 0.000
	@ 1.286, 109.750 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT zsystem, cards.cost, castcost(1, 117, 4)) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000, 0.000 PICTURE "@J"
	@ 4.143, 79.250 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000, 0.000
	@ 5.714, 79.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series), "", m.series) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 17.000, 0.000
	@ 4.143, 109.500 COLOR RGB(255,255,0,128,0,0) SAY cards.color FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 11.000, 0.000 PICTURE "@J"
	@ 5.714, 106.250 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000, 0.000 PICTURE "@J"
	@ 1.286, 79.250 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000, 0.000 PICTURE "@I"
	@ 7.857, 79.000 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 43.000, 0.000
	@ 15.429, 92.250 COLOR RGB(255,255,0,128,0,0) SAY cards.count FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 16.250, 0.000 PICTURE "@I"
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
