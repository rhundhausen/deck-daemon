* EDIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module EDIT.FXP, compiled 1995-03-23 10:23).
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
IF NOT WEXIST("edit") OR UPPER(WTITLE("EDIT")) == "EDIT.PJX" OR UPPER(WTITLE("EDIT")) == "EDIT.SCX" OR UPPER(WTITLE("EDIT")) == "EDIT.MNX" OR UPPER(WTITLE("EDIT")) == "EDIT.PRG" OR UPPER(WTITLE("EDIT")) == "EDIT.FRX" OR UPPER(WTITLE("EDIT")) == "EDIT.QPR"
	DEFINE WINDOW edit AT 0.000, 0.000 SIZE 17.529, 99.200 FONT "Times New Roman", 10 STYLE "BI" FLOAT CLOSE TITLE "Card Entry" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW edit CENTER
ENDIF
m.eefont = IIF(m.isystem = "I", "BIT", "T")
editorder = ORDER()
editfilter = FILTER()
m.name = ""
IF m.edit
	SCATTER MEMVAR
	x = ASCAN(b_series, cards.series)
	IF NOT x = 0
		m.series = a_series(x)
	ELSE
		= errors("Editing", 9006, 1)
		RETURN
	ENDIF
ELSE
	m.series = ""
	m.card = ""
	m.color = ""
	m.type = ""
	m.rarity = "Common"
	m.restrictio = "Open"
	m.cost = ""
	m.artist = ""
	m.descriptio = ""
ENDIF
SET FILTER TO
IF WVISIBLE("edit")
	ACTIVATE WINDOW edit SAME
ELSE
	ACTIVATE WINDOW edit NOSHOW
ENDIF
@ 0.706, 9.600 SAY "Series" FONT "Times New Roman", 10 STYLE m.eefont
@ 2.765, 4.800 SAY "Card name" FONT "Times New Roman", 10 STYLE m.eefont
@ 4.706, 4.000 SAY "Card Color" FONT "Times New Roman", 10 STYLE m.eefont
@ 6.588, 4.800 SAY "Card Type" FONT "Times New Roman", 10 STYLE m.eefont
@ 8.412, 2.400 SAY "Casting Cost" FONT "Times New Roman", 10 STYLE m.eefont
@ 10.353, 9.600 SAY "Artist" FONT "Times New Roman", 10 STYLE m.eefont
@ 12.000, 9.600 SAY "Rarity" FONT "Times New Roman", 10 STYLE m.eefont
@ 13.412, 4.800 SAY "Restriction" FONT "Times New Roman", 10 STYLE m.eefont
@ 1.647, 73.000 SAY "Description" FONT "Times New Roman", 10 STYLE m.eefont
@ 0.647, 19.200 GET m.series DEFAULT 1 FONT "Times New Roman", 10 STYLE m.eefont SIZE 1.529, 24.000 FROM a_series RANGE, ALEN(a_series) - 1 PICTURE "@^" VALID _qyq1dnuup()
@ 2.824, 19.600 GET m.card DEFAULT " " FONT "Times New Roman", 10 STYLE m.eefont SIZE 0.941, 40.800 PICTURE "@KT xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" VALID _qyq1dnuvv()
@ 4.412, 19.200 GET m.color DEFAULT 1 FONT "Times New Roman", 10 STYLE m.eefont SIZE 1.529, 12.200 FROM a_color RANGE, ALEN(a_color) - 1 PICTURE "@^" VALID _qyq1dnux4()
@ 6.294, 19.200 GET m.type DEFAULT 1 FONT "Times New Roman", 10 STYLE m.eefont SIZE 1.529, 29.000 FROM a_type RANGE, ALEN(a_type) - 1 PICTURE "@^" VALID _qyq1dnuyb()
@ 8.471, 19.600 GET m.cost DEFAULT " " FONT "Times New Roman", 10 STYLE m.eefont SIZE 0.941, 13.600 PICTURE "@K!T"
@ 10.059, 19.200 GET m.artist DEFAULT 1 FONT "Times New Roman", 10 STYLE m.eefont SIZE 1.529, 33.800 FROM a_artist RANGE, ALEN(a_artist) - 1 PICTURE "@^" VALID _qyq1dnv2b()
@ 2.824, 63.000 EDIT m.descriptio DEFAULT " " FONT "Times New Roman", 10 STYLE m.eefont SIZE 7.529, 33.400, 254.000 PICTURE "@K" NOMODIFY    && ? decompiler guessed a keyword on this line
@ 12.000, 19.200 GET m.rarity DEFAULT 1 FONT "Times New Roman", 10 STYLE m.eefont SIZE 1.000, 18.600, 0.800 PICTURE "@*RHN Common;UnCommon;Rare"
@ 13.412, 19.200 GET m.restrictio DEFAULT 1 FONT "Times New Roman", 10 STYLE m.eefont SIZE 1.000, 16.600, 1.800 PICTURE "@*RHN Open;Restricted;Banned"
@ 15.529, 40.000 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 7.667, 0.667 PICTURE "@*HN Save;Cancel" VALID _qyq1dnv4d()
@ 0.235, 63.000 SAY IIF(m.edit, "", "New Card Entry") FONT "Times New Roman", 14 STYLE m.eefont SIZE 0.957, 20.375 PICTURE "@I"
IF NOT WVISIBLE("edit")
	ACTIVATE WINDOW edit
ENDIF
READ CYCLE ACTIVATE _qyq1dnv9k() DEACTIVATE _qyq1dnv9m()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW edit
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
IF NOT EMPTY(editorder)
	SET ORDER TO (editorder)
ENDIF
IF NOT EMPTY(editfilter)
	SET FILTER TO &editfilter
ENDIF
FLUSH


PROCEDURE checkit
DO CASE
	CASE EMPTY(m.series)
		WAIT WINDOW NOWAIT "Series is a required entry!"
		_CUROBJ = 1
	CASE EMPTY(m.card)
		WAIT WINDOW NOWAIT "Card Name is a required entry!"
		_CUROBJ = 2
	CASE EMPTY(m.color)
		WAIT WINDOW NOWAIT "Card Color is a required entry!"
		_CUROBJ = 3
	CASE EMPTY(m.type)
		WAIT WINDOW NOWAIT "Card Type is a required entry!"
		_CUROBJ = 4
	OTHERWISE
		RETURN .T.
ENDCASE
?? CHR(7)
RETURN .F.


PROCEDURE _qyq1dnuup
SHOW GETS WINDOW ("edit")


PROCEDURE _qyq1dnuvv
m.card = PROPER(m.card)    && ? decompiler guessed a keyword on this line
SHOW GET m.card


PROCEDURE _qyq1dnux4
SHOW GETS WINDOW ("edit")


PROCEDURE _qyq1dnuyb
SHOW GETS WINDOW ("edit")


PROCEDURE _qyq1dnv2b
SHOW GETS WINDOW ("edit")


PROCEDURE _qyq1dnv4d
DO CASE
	CASE m.but == 1
		IF NOT checkit()
			RETURN .T.
		ENDIF
		IF NOT edit
			LOCATE FOR ((m.card == cards.card) AND (m.series == cards.series) AND (m.type == cards.type))
			IF FOUND()
				DO warn WITH "This card already exists!"
				RETURN
			ENDIF
			CALCULATE FOR cards.cardnumber > 1000000 TO m.cardnumber MAX ALIAS cards.cardnumber ALL
			IF EMPTY(m.cardnumber)
				m.cardnumber = 1000001
			ELSE
				m.cardnumber = m.cardnumber + 1
			ENDIF
			APPEND BLANK
		ENDIF
		x = ASCAN(a_series, m.series)
		m.series = b_series(x)
		m.costtotal = totcost(m.cost)
		GATHER MEMVAR
		CLEAR READ
	CASE m.but == 2
		CLEAR READ
ENDCASE


PROCEDURE _qyq1dnv9k
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyq1dnv9m
SET NEAR OFF    && ? decompiler guessed a keyword on this line
CLEAR READ
