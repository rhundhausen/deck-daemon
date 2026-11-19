* PREBUILD.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PREBUILD.FXP, compiled 1995-04-06 00:03).
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
IF NOT WEXIST("prebuild") OR UPPER(WTITLE("PREBUILD")) == "PREBUILD.PJX" OR UPPER(WTITLE("PREBUILD")) == "PREBUILD.SCX" OR UPPER(WTITLE("PREBUILD")) == "PREBUILD.MNX" OR UPPER(WTITLE("PREBUILD")) == "PREBUILD.PRG" OR UPPER(WTITLE("PREBUILD")) == "PREBUILD.FRX" OR UPPER(WTITLE("PREBUILD")) == "PREBUILD.QPR"
	DEFINE WINDOW prebuild AT 0.000, 0.000 SIZE 18.875, 77.000 FONT "Times New Roman", 10 STYLE "I" FLOAT OF TITLE "Deck Builder" NOGROW SYSTEM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW prebuild CENTER
ENDIF
IF NOT USED("daemon3")
	USE IN 0 "daemon3.ddw" INDEX "daemon3.ddx" ORDER ("DECK")
	SELECT daemon3
ENDIF
m.deckname = daemon3.deck
m.run = 1
DEFINE POPUP _qyn10z6ia PROMPT PROMPT FIELD daemon3.deck NOSHOW
IF WVISIBLE("prebuild")
	ACTIVATE WINDOW prebuild SAME
ELSE
	ACTIVATE WINDOW prebuild NOSHOW
ENDIF
@ 0.500, 17.600 COLOR RGB(,,,255,255,255) SAY "Deck Builder For Windows" FONT "Times New Roman", 14 STYLE m.isystem + "T"
@ 10.750, 45.600 COLOR RGB(,,,255,255,255) SAY "Wins" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 10.750, 60.800 COLOR RGB(,,,255,255,255) SAY "Losses" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 7.250, 45.200 COLOR RGB(,,,255,255,255) SAY "Cards" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 7.250, 61.600 COLOR RGB(,,,255,255,255) SAY "Deck" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 3.750,5.200 GET m.deckname  PICTURE "@&N"  POPUP _qyn10z6ia  SIZE 11.250,34.600  DEFAULT " "  FONT "Times New Roman", 10  STYLE m.isystem+"T"  WHEN _qyn10z6lg()  VALID _qyn10z6mi()  COLOR RGB(,,,255,255,255),RGB(,,,255,255,255)
@ 5.500, 50.800 COLOR RGB(,,,255,255,255) SAY daemon3.type FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 15.800 PICTURE "@I"
@ 4.000, 45.200 COLOR RGB(,,,255,255,255) SAY daemon3.deck FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 26.400 PICTURE "@I"
@ 8.500, 62.000 COLOR RGB(,,,255,255,255) SAY daemon3.count FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 4.600
@ 8.500, 46.000 COLOR RGB(,,,255,255,255) SAY daemon3.cards FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 4.800
@ 11.938, 44.600 COLOR, RGB(,,,255,255,255) GET daemon3.wins DEFAULT 0.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 6.000 RANGE 0, PICTURE "@K 9999" ENABLE 1.000, 0, 9999 MESSAGE "Can't Have a Negative Quantity!"    && ? decompiler guessed a keyword on this line
@ 11.938, 60.600 COLOR, RGB(,,,255,255,255) GET daemon3.losses DEFAULT 0.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 6.000 RANGE 0, PICTURE "@K 9999" ENABLE 1.000, 0, 9999 MESSAGE "Can't Have a Negative Quantity!"    && ? decompiler guessed a keyword on this line
@ 16.563, 2.600 COLOR,,,,,,,, RGB(,,,255,255,255) GET m.delete DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.769, 8.333, 0.667 PICTURE "@*HN \<Delete" VALID _qyn10z6pt()
@ 16.625, 39.800 COLOR,,,,,,,, RGB(,,,255,255,255) GET m.prebut DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.769, 8.667, 0.667 PICTURE "@*HN \<Edit;\<New;\?\<Cancel" VALID _qyn10z6rs()
@ 13.563, 52.000 COLOR,,,,,,,, RGB(,,,255,255,255) GET m.view DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem SIZE 2.375, 8.600, 0.800 PICTURE "@*BHN " + (LOCFILE("eye.bmp", "BMP|ICO|PCT|ICN", "Where is eye?")) VALID _qyn10z6v2()
@ 16.625, 21.400 GET m.change DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.333, 0.667 PICTURE "@*HN C\<hange" VALID _qyn10z6we()
IF NOT WVISIBLE("prebuild")
	ACTIVATE WINDOW prebuild
ENDIF
READ CYCLE SHOW _qyn10z6y9() ACTIVATE _qyn10z6y2() MODAL    && ? decompiler guessed a keyword on this line
RELEASE WINDOW prebuild
RELEASE POPUP _qyn10z6ia
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SELECT daemon3
USE
SELECT cards
GO TOP


PROCEDURE _qyn10z6lg
SHOW GETS WINDOW "prebuild"


PROCEDURE _qyn10z6mi
DO loadit
m.run = 3
CLEAR READ


PROCEDURE _qyn10z6pt
IF alertit("Delete Deck " + daemon3.deck)
	IF NOT EMPTY(daemon3.deck)
		m.decknumber = daemon3.number
		USE IN 0 "daemon4.ddw"
		WAIT WINDOW NOWAIT "Deleting Deck"
		SELECT cards
		po_order = ORDER()
		SET ORDER TO ("cardnumber")
		SELECT daemon4
		SCAN FOR daemon4.deck == m.decknumber
			IF SEEK(daemon4.card, "CARDS")
				REPLACE cards.deck WITH cards.deck - daemon4.quantity
			ENDIF
			DELETE
		ENDSCAN
		SELECT cards
		IF NOT EMPTY(po_order)
			SET ORDER TO (po_order)
		ENDIF
		SELECT daemon4
		USE
		SELECT daemon3
		DELETE
		PACK
		m.deckname = daemon3.deck
		SHOW GETS
	ENDIF
ENDIF
_CUROBJ = 1


PROCEDURE _qyn10z6rs
DO CASE
	CASE m.prebut = 1
		DO loadit
		m.run = 3
		CLEAR READ
	CASE m.prebut = 2
		m.run = 2
		DO "type.prg"
		m.run = 1
		SHOW GETS OFF
		_CUROBJ = 1
	CASE m.prebut = 3
		m.run = 1
		CLEAR READ
ENDCASE


PROCEDURE _qyn10z6v2
DO loadit
DO "deck.prg"
IF m.run == 3
	CLEAR READ
ENDIF


PROCEDURE _qyn10z6we
DO "changeit.prg"


PROCEDURE _qyn10z6y2
SHOW GETS


PROCEDURE _qyn10z6y9
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF EOF("daemon3") AND BOF("daemon3")
	SHOW GET m.view DISABLE
	SHOW GET m.prebut, 1 DISABLE
	SHOW GET m.deckname DISABLE
	SHOW GET m.delete DISABLE
	SHOW GET m.change, 1 DISABLE
ELSE
	IF daemon3.cards > 0
		SHOW GET m.view ENABLE
		SHOW GET m.change ENABLE
	ELSE
		SHOW GET m.view DISABLE
		SHOW GET m.change DISABLE
	ENDIF
	SHOW GET m.prebut, 1 ENABLE
	SHOW GET m.deckname ENABLE
	SHOW GET m.delete ENABLE
ENDIF
IF RECCOUNT("daemon3") > 200
	SHOW GET m.prebut, 2 DISABLE
ENDIF
IF SYS(2016) = "PREBUILD" OR SYS(2016) = "*"
	ACTIVATE WINDOW prebuild SAME
	@ 5.500, 50.800 CLEAR TO 6.438, 66.600
	@ 5.500, 50.800 COLOR RGB(,,,255,255,255) SAY daemon3.type FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 15.800, 0.000 PICTURE "@I"
	@ 4.000, 45.200 CLEAR TO 4.938, 71.600
	@ 4.000, 45.200 COLOR RGB(,,,255,255,255) SAY daemon3.deck FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 26.400, 0.000 PICTURE "@I"
	@ 8.500, 62.000 CLEAR TO 9.438, 66.600
	@ 8.500, 62.000 COLOR RGB(,,,255,255,255) SAY daemon3.count FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 4.600, 0.000
	@ 8.500, 46.000 CLEAR TO 9.438, 50.800
	@ 8.500, 46.000 COLOR RGB(,,,255,255,255) SAY daemon3.cards FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.938, 4.800, 0.000
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
