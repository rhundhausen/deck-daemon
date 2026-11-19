* BUY.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module BUY.FXP, compiled 1995-04-13 01:25).
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
IF NOT WEXIST("buy") OR UPPER(WTITLE("BUY")) == "BUY.PJX" OR UPPER(WTITLE("BUY")) == "BUY.SCX" OR UPPER(WTITLE("BUY")) == "BUY.MNX" OR UPPER(WTITLE("BUY")) == "BUY.PRG" OR UPPER(WTITLE("BUY")) == "BUY.FRX" OR UPPER(WTITLE("BUY")) == "BUY.QPR"
	DEFINE WINDOW buy AT 0.000, 0.000 SIZE 21.438, 111.200 FONT "Times New Roman", 9 STYLE "I" FLOAT CLOSE TITLE "Trade Detail" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW buy CENTER
ENDIF
USE IN 0 "daemon6.ddw" ALIAS detail INDEX "daemon6.ddx"
USE IN 0 "daemon5.ddw" ALIAS dealer INDEX "daemon5.ddx" ORDER "dealer"
IF NOT USED("daemon8") AND m.rcsystem <> 0
	USE IN 0 "daemon8.ddw" INDEX "daemon8.ddx" ORDER '"lookup"'
ENDIF
SELECT dealer
GO TOP
m.quantity = 1
m.paid = m.dsystem
m.reserved = .F.
m.date = DATE()
m.dealer = dealer.dealer
m.condition = "Near Mint"
m.reference = ""
m.worth = 0
SET NEAR ON    && ? decompiler guessed a keyword on this line
IF WVISIBLE("buy")
	ACTIVATE WINDOW buy SAME
ELSE
	ACTIVATE WINDOW buy NOSHOW
ENDIF
@ 0.563, 4.400 SAY "Purchased / Traded From:" FONT "Times New Roman", 9 STYLE m.isystem + "T"
@ 9.625, 5.400 SAY "Card Condition" FONT "Times New Roman", 9 STYLE m.isystem + "T"
@ 9.750, 24.000 SAY "Quantity" + CHR(13) + "Purchased" FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 2.000, 12.000, 0.000
@ 14.438, 23.600 SAY "Price Paid" + CHR(13) + "Per Card" FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 2.000, 10.800, 0.000
@ 13.375, 59.000 SAY "Total" FONT "Times New Roman", 9 STYLE m.isystem + "T"
@ 12.375, 24.000 SAY "Date" FONT "Times New Roman", 9 STYLE m.isystem + "T"
@ 14.375, 56.600 TO 14.375, 66.400 STYLE "1" PEN 1, 8
@ 2.813, 71.200 COLOR RGB(,,,128,0,0) TO 17.376, 108.400 STYLE "16" PATTERN 1 PEN 2, 8
@ 2.063, 68.800 COLOR RGB(,,,128,0,0) TO 16.626, 106.000 STYLE "16" PATTERN 1 PEN 2, 8
@ 8.000, 69.400 TO 14.438, 105.600 PEN 2, 8
@ 0.188, 71.800 SAY "Card Buy/Trade " FONT "Times New Roman", 18 STYLE m.isystem + "T"
@ 10.625, 3.600 TO 17.438, 22.000 STYLE "T" PATTERN 1 PEN 1, 8
@ 17.250, 23.600 SAY "Reference:" FONT "Times New Roman", 9 STYLE m.isystem + "T"
@ 2.188, 4.200 GET m.dealer DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.538, 28.167 FROM a_dealer PICTURE "@^" VALID _qz00r14kd() WHEN _qz00r14ja()
@ 11.063, 5.200 GET m.condition DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.308, 14.000, 0.154 PICTURE "@*RVN Mint;Near Mint;Fine;Good;Poor" VALID _qz00r14lz()
@ 10.375, 36.400 COLOR, RGB(,,,255,255,255) GET m.quantity DEFAULT 1.000 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.875, 4.600 RANGE 1, PICTURE "@K 999" ENABLE 1.000, 1, 100 VALID _qz00r14n3() MESSAGE "Must enter a Value"    && ? decompiler guessed a keyword on this line
@ 12.500, 36.200 GET m.date DEFAULT {} FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 11.200 PICTURE "@K"
@ 15.063, 36.600 COLOR, RGB(,,,255,255,255) GET m.paid DEFAULT 0.000 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.875, 13.200 RANGE 0, PICTURE "@K$ 9999.99" ENABLE 0.1, 0, 9999.99 VALID _qz00r14oz() MESSAGE "Negative Price Not Allowed!"    && ? decompiler guessed a keyword on this line
@ 15.000, 57.000 SAY m.paid * m.quantity FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 8.800 PICTURE "@Z$"
@ 17.250, 36.400 GET m.reference DEFAULT " " FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 29.600 PICTURE "@K"
@ 4.438, 4.800 SAY dealer.addr FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 42.200
@ 5.750, 4.800 SAY dealer.cityst FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 42.400
@ 7.063, 4.800 SAY dealer.phone FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 23.600
@ 2.688, 70.400 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000
@ 2.688, 93.000 COLOR RGB(255,255,0,128,0,0) SAY cards.cost + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.500 PICTURE "@J"
@ 4.000, 70.400 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000
@ 5.375, 70.400 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series), "", m.series) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 17.000
@ 4.000, 93.400 COLOR RGB(255,255,0,128,0,0) SAY cards.color + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000 PICTURE "@J"
@ 5.375, 90.200 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 18.000 PICTURE "@J"
@ 6.875, 81.800 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000 PICTURE "@I"
@ 8.188, 70.200 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 43.000
@ 18.188, 77.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 8.667, 0.667 PICTURE "@*HN \<OK;\?\<Cancel" VALID _qz00r14wi()
@ 1.375, 2.600 TO 9.000, 52.200 PEN 1, 8
@ 18.188, 3.800 SAY IIF(m.worth <> 0, TRANSFORM(m.worth, "@$ "), "") FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 18.000 PICTURE "@I"
@ 19.375, 1.000 SAY IIF(NOT EMPTY(m.worth), m.pnsystem, "") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 30.500 PICTURE "@I"
IF NOT WVISIBLE("buy")
	ACTIVATE WINDOW buy
ENDIF
READ CYCLE SHOW _qz00r150k() DEACTIVATE _qz00r150i()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW buy
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SET NEAR OFF    && ? decompiler guessed a keyword on this line
SELECT detail
USE
SELECT dealer
USE
SELECT cards
IF NOT WEXIST("cards")
	DO display IN "LIST"
ENDIF


PROCEDURE _qz00r14ja
= SEEK(m.dealer)
SHOW GETS OFF WINDOW buy


PROCEDURE _qz00r14kd
IF m.dealer = "New"
	m.what = "Dealer"
	DO "nedit.prg"
	m.dealer = dealer.dealer
	SHOW GETS WINDOW buy
	SET NEAR ON    && ? decompiler guessed a keyword on this line
	RETURN .F.
ENDIF
= SEEK(m.dealer, "dealer")
SHOW GETS OFF WINDOW buy
_CUROBJ = OBJNUM(m.condition)


PROCEDURE _qz00r14lz
SHOW GETS OFF WINDOW ("buy")


PROCEDURE _qz00r14n3
IF cards.total + m.quantity > 9000
	?? CHR(7) + CHR(7)
	WAIT WINDOW TIMEOUT 10 "Total Card Quantity is beyond system capacity!"
	m.quantity = 0
	RETURN
ENDIF
SHOW GETS OFF WINDOW buy


PROCEDURE _qz00r14oz
SHOW GETS OFF WINDOW buy


PROCEDURE _qz00r14wi
DO CASE
	CASE m.but == 1
		IF m.quantity <= 0
			?? CHR(7)
			WAIT WINDOW NOWAIT "Quantity is Required!"
			_CUROBJ = OBJNUM(m.quantity)
		ELSE
			SELECT detail
			APPEND BLANK
			REPLACE detail.sale WITH .F.
			REPLACE detail.cardnumber WITH cards.cardnumber
			REPLACE detail.quantity WITH m.quantity
			REPLACE detail.trade WITH m.reserved
			REPLACE detail.paid WITH m.paid
			REPLACE detail.date WITH m.date
			REPLACE detail.dealer WITH m.dealer
			REPLACE detail.condition WITH m.condition
			REPLACE cards.total WITH cards.total + m.quantity
			REPLACE detail.reference WITH m.reference
			IF m.rcsystem <> 0 AND m.worth <> 0
				REPLACE detail.worth WITH m.worth
				REPLACE detail.guide WITH m.pnsystem
			ENDIF
			IF NOT m.reserved
				REPLACE cards.quantity WITH cards.quantity + m.quantity
				REPLACE cards.deck WITH cards.deck - m.quantity
			ENDIF
			REPLACE cards.wanted WITH IIF(cards.wanted < m.quantity, 0, cards.wanted - m.quantity)
			CLEAR READ
		ENDIF
	CASE m.but == 2
		CLEAR READ
ENDCASE


PROCEDURE _qz00r150i
CLEAR READ


PROCEDURE _qz00r150k
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF m.rcsystem <> 0
	IF SEEK(STR(m.rcsystem, 10) + STR(cards.cardnumber, 10), "daemon8")
		DO CASE
			CASE rtsystem == 1
				m.wor = daemon8.hi
			CASE rtsystem == 2
				m.wor = daemon8.med
			CASE rtsystem == 3
				m.wor = daemon8.low
		ENDCASE
		DO CASE
			CASE m.condition == "Mint"
				m.per = m.r1system
			CASE m.condition == "Near Mint"
				m.per = m.r2system
			CASE m.condition == "Fine"
				m.per = m.r3system
			CASE m.condition == "Good"
				m.per = m.r4system
			CASE m.condition == "Poor"
				m.per = m.r5system
		ENDCASE
		m.worth = m.wor * (m.per / 100)
	ENDIF
ENDIF
IF SYS(2016) = "BUY" OR SYS(2016) = "*"
	ACTIVATE WINDOW buy SAME
	@ 15.000, 57.000 CLEAR TO 15.938, 65.800
	@ 15.000, 57.000 SAY m.paid * m.quantity FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 8.800, 0.000 PICTURE "@Z$"
	@ 4.438, 4.800 CLEAR TO 5.376, 47.000
	@ 4.438, 4.800 SAY dealer.addr FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 42.200, 0.000
	@ 5.750, 4.800 CLEAR TO 6.688, 47.200
	@ 5.750, 4.800 SAY dealer.cityst FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 42.400, 0.000
	@ 7.063, 4.800 CLEAR TO 8.001, 28.400
	@ 7.063, 4.800 SAY dealer.phone FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 23.600, 0.000
	@ 2.688, 70.400 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000, 0.000
	@ 2.688, 93.000 COLOR RGB(255,255,0,128,0,0) SAY cards.cost + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.500, 0.000 PICTURE "@J"
	@ 4.000, 70.400 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.000, 0.000
	@ 5.375, 70.400 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(m.series), "", m.series) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 17.000, 0.000
	@ 4.000, 93.400 COLOR RGB(255,255,0,128,0,0) SAY cards.color + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000, 0.000 PICTURE "@J"
	@ 5.375, 90.200 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 18.000, 0.000 PICTURE "@J"
	@ 6.875, 81.800 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.000, 0.000 PICTURE "@I"
	@ 8.188, 70.200 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 43.000, 0.000
	@ 18.188, 3.800 CLEAR TO 19.126, 21.800
	@ 18.188, 3.800 SAY IIF(m.worth <> 0, TRANSFORM(m.worth, "@$ "), "") FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 18.000, 0.000 PICTURE "@I"
	@ 19.375, 1.000 CLEAR TO 20.375, 31.500
	@ 19.375, 1.000 SAY IIF(NOT EMPTY(m.worth), m.pnsystem, "") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 30.500, 0.000 PICTURE "@I"
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
