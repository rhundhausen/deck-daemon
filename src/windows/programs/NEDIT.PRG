* NEDIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module NEDIT.FXP, compiled 1995-04-11 09:40).
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
SET READBORDER OFF
IF NOT WEXIST("nedit") OR UPPER(WTITLE("NEDIT")) == "NEDIT.PJX" OR UPPER(WTITLE("NEDIT")) == "NEDIT.SCX" OR UPPER(WTITLE("NEDIT")) == "NEDIT.MNX" OR UPPER(WTITLE("NEDIT")) == "NEDIT.PRG" OR UPPER(WTITLE("NEDIT")) == "NEDIT.FRX" OR UPPER(WTITLE("NEDIT")) == "NEDIT.QPR"
	DEFINE WINDOW nedit AT 0.000, 0.000 SIZE 18.000, 88.000 FONT "Times New Roman", 9 STYLE "I" FLOAT OF NOGROW    && ? decompiler guessed a keyword on this line
	MOVE WINDOW nedit CENTER
ENDIF
PRIVATE editfilter, m.choose, m.addrec, m.modify, m.type, editalias
editalias = ALIAS()
SELECT cards
editfilter = FILTER()
SET FILTER TO
USE IN 0 "daemon2.ddw" ALIAS list INDEX "daemon2.ddx" ORDER '"name"'
SELECT list
DO CASE
	CASE m.what = "Dealer"
		SET FILTER TO type = "D"
		m.type = "D"
	CASE m.what = "Series"
		SET FILTER TO type = "S"
		m.type = "S"
	CASE m.what = "Color"
		SET FILTER TO type = "C"
		m.type = "C"
	CASE m.what = "Artist"
		SET FILTER TO type = "A"
		m.type = "A"
	CASE m.what = "Type"
		SET FILTER TO type = "T"
		m.type = "T"
ENDCASE
GO TOP
m.choose = list.name
m.addrec = .F.
m.modify = .F.
DEFINE POPUP _qz00r17mq PROMPT PROMPT FIELD list.name NOSHOW
IF WVISIBLE("nedit")
	ACTIVATE WINDOW nedit SAME
ELSE
	ACTIVATE WINDOW nedit NOSHOW
ENDIF
@ 8.688, 33.600 TO 8.688, 84.200 STYLE "1" PEN 1, 8
@ 4.500,5.000 GET m.choose  PICTURE "@&N"  POPUP _qz00r17mq  SIZE 12.375,26.200  DEFAULT " "  FONT "Times New Roman", 9  STYLE m.isystem+"T"  WHEN _qz00r17od()  VALID _qz00r17qe()  COLOR RGB(,,,255,255,255),RGB(,,,255,255,255)
@ 6.000, 46.000 COLOR, RGB(,,,255,255,255) GET m.short DEFAULT " " FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 11.200 PICTURE "@T XXXX" VALID _qz00r17rq() WHEN (m.what = "Series") AND (m.addrec OR m.modify) MESSAGE "Series Abrev. Already Defined!"    && ? decompiler guessed a keyword on this line
@ 7.500, 46.000 COLOR, RGB(,,,255,255,255) GET m.name DEFAULT " " FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 35.200 PICTURE "@T XXXXXXXXXXXXXXXXXXXX" VALID _qz00r17to() WHEN m.addrec OR m.modify MESSAGE m.what + " Name Already Defined!"    && ? decompiler guessed a keyword on this line
@ 9.000, 46.000 COLOR, RGB(,,,255,255,255) GET m.addr DEFAULT " " FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 39.600 PICTURE "@T XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" WHEN (m.what = "Dealer") AND (m.addrec OR m.modify)
@ 10.500, 46.000 COLOR, RGB(,,,255,255,255) GET m.cityst DEFAULT " " FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 39.600 PICTURE "@T XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" WHEN (m.what = "Dealer") AND (m.addrec OR m.modify)
@ 12.000, 46.000 COLOR, RGB(,,,255,255,255) GET m.phone DEFAULT " " FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 39.600 PICTURE "@T XXXXXXXXXXXXXXXXXXXX" WHEN (m.what = "Dealer") AND (m.addrec OR m.modify)
@ 14.250, 35.000 COLOR,,,,,,,, RGB(,,,255,255,255) GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.769, 9.167, 0.667 PICTURE "@*HN \<Add;\<Modify;\<Delete;E\<xit" VALID _qz00r17ww()
@ 9.000, 34.000 COLOR RGB(,,,255,255,255) SAY IIF(m.what = "Dealer", "Address:", "") FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 9.800
@ 10.500, 34.000 COLOR RGB(,,,255,255,255) SAY IIF(m.what = "Dealer", "City/St:", "") FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 9.800
@ 12.000, 34.000 COLOR RGB(,,,255,255,255) SAY IIF(m.what = "Dealer", "Phone# :", "") FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 9.800
@ 1.000, 15.200 COLOR RGB(,,,255,255,255) SAY m.what + " Maintenance" FONT "Times New Roman", 20 STYLE m.isystem + "T" SIZE 0.969, 26.091 PICTURE "@I"
@ 6.000, 34.000 COLOR RGB(,,,255,255,255) SAY IIF(m.what = "Series", "Abrev. :", "") FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 9.000
@ 7.500, 34.000 COLOR RGB(,,,255,255,255) SAY m.what + " :" FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 0.938, 9.200
IF NOT WVISIBLE("nedit")
	ACTIVATE WINDOW nedit
ENDIF
READ CYCLE SHOW _qz00r186y() DEACTIVATE _qz00r186x()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW nedit
RELEASE POPUP _qz00r17mq
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SELECT list
USE
IF NOT EMPTY(editfilter)
	SELECT cards
	SET FILTER TO &editfilter
ENDIF
IF NOT EMPTY(editalias)
	SELECT (editalias)
ENDIF
DO setup


PROCEDURE _qz00r17od
IF NOT (m.addrec OR m.modify)
	SELECT list
	SCATTER MEMVAR FIELDS name, short
	IF m.what = "Dealer"
		SELECT dealer
		= SEEK(m.choose)
		IF FOUND()
			SCATTER MEMVAR
		ELSE
			SCATTER BLANK MEMVAR
		ENDIF
	ELSE
		m.dealer = ""
		m.addr = ""
		m.cityst = ""
		m.phone = ""
	ENDIF
	SHOW GETS WINDOW nedit
	RETURN
ELSE
	RETURN .F.
ENDIF


PROCEDURE _qz00r17qe
RETURN


PROCEDURE _qz00r17rq
m.short = PROPER(m.short)    && ? decompiler guessed a keyword on this line
IF NOT m.modify
	LOCATE FOR list.short == PADR(m.short, 4)
	RETURN NOT FOUND()
ENDIF


PROCEDURE _qz00r17to
m.name = PROPER(m.name)    && ? decompiler guessed a keyword on this line
IF m.what == "Color"
	m.name = LEFT(m.name, 5)
ENDIF
IF m.what = "Artist"
	IF NOT ("," $ m.name)    && ? decompiler guessed a keyword on this line
		x = RAT(" ", m.name)    && ? decompiler guessed a keyword on this line
		IF NOT EMPTY(x)
			m.last = ALLTRIM(RIGHT(m.name, x))    && ? decompiler guessed a keyword on this line
			m.first = ALLTRIM(LEFT(m.name, (LEN(m.name) - x)))    && ? decompiler guessed a keyword on this line
			m.name = m.last + ", " + m.first
		ENDIF
	ENDIF
ENDIF
SHOW GETS WINDOW nedit
IF m.addrec
	LOCATE FOR list.name == PADR(m.name, 20)
	RETURN NOT FOUND()
ENDIF


PROCEDURE _qz00r17ww
DO CASE
	CASE m.but == 1 AND NOT (m.addrec OR m.modify)
		m.addrec = .T.
		_CUROBJ = 1
		SHOW GET m.but, 1 PROMPT "\<Save"
		SHOW GET m.but, 2 DISABLE PROMPT ""
		SHOW GET m.but, 3 DISABLE PROMPT ""
		SHOW GET m.but, 4 PROMPT "\<Cancel"
		SHOW GET m.choose DISABLE
		m.short = ""
		m.name = ""
		m.addr = ""
		m.cityst = ""
		m.phone = ""
		SHOW GETS WINDOW nedit
		_CUROBJ = 2
	CASE m.but == 1 AND (m.addrec OR m.modify)
		IF m.addrec
			SELECT list
			IF NOT EMPTY(m.name) AND (m.what <> "Series" OR NOT EMPTY(m.short))
				SELECT list
				APPEND BLANK
				REPLACE list.short WITH m.short
				REPLACE list.name WITH m.name
				REPLACE list.type WITH m.type
				IF m.what == "Dealer"
					SELECT dealer
					APPEND BLANK
					REPLACE dealer.dealer WITH m.name
					REPLACE dealer.addr WITH m.addr
					REPLACE dealer.cityst WITH m.cityst
					REPLACE dealer.phone WITH m.phone
					SELECT list
				ENDIF
			ELSE
				WAIT WINDOW NOWAIT "Entry Not Complete!"
				RETURN .F.
			ENDIF
		ELSE
			WAIT WINDOW NOWAIT "Updating the Database..."
			SELECT cards
			DO CASE
				CASE m.what == "Series" AND m.short <> list.short
					REPLACE cards.series WITH m.short ALL FOR cards.series == list.short
				CASE m.what == "Color" AND m.name <> list.name
					REPLACE cards.color WITH m.name ALL FOR cards.color == LEFT(list.name, 5)
				CASE m.what == "Type" AND m.name <> list.name
					REPLACE cards.type WITH m.name ALL FOR cards.type == list.name
				CASE m.what == "Artist" AND m.name <> list.name
					REPLACE cards.artist WITH m.name ALL FOR cards.artist == list.name
				CASE m.what == "Dealer"
					SELECT detail
					REPLACE detail.dealer WITH m.name ALL FOR detail.dealer == list.name
					SELECT dealer
					IF NOT SEEK(list.name)
						APPEND BLANK
					ENDIF
					REPLACE dealer.dealer WITH m.name
					REPLACE dealer.addr WITH m.addr
					REPLACE dealer.cityst WITH m.cityst
					REPLACE dealer.phone WITH m.phone
					SELECT cards
					GO TOP
			ENDCASE
			SELECT list
			REPLACE list.name WITH m.name
			REPLACE list.short WITH m.short
			REPLACE list.type WITH m.type
		ENDIF
		m.modify = .F.
		m.addrec = .F.
		SHOW GET m.but, 1 PROMPT "\<Add"
		SHOW GET m.but, 2 ENABLE PROMPT "\<Modify"
		SHOW GET m.but, 3 ENABLE PROMPT "\<Delete"
		SHOW GET m.but, 4 PROMPT "E\<xit"
		SHOW GET m.choose ENABLE
		_CUROBJ = 1
		FLUSH
		SCATTER MEMVAR
		IF m.what = "Dealer"
			SELECT dealer
			SCATTER MEMVAR
		ENDIF
		m.choose = m.name
		WAIT CLEAR
	CASE m.but == 2
		m.modify = .T.
		SHOW GET m.but, 1 PROMPT "\<Save"
		SHOW GET m.but, 2 DISABLE PROMPT ""
		SHOW GET m.but, 3 DISABLE PROMPT ""
		SHOW GET m.but, 4 PROMPT "\<Cancel"
		SHOW GET m.choose DISABLE
		_CUROBJ = 2
	CASE m.but == 3
		IF alertit("All related Records Will be deleted!")
			DO edelete
		ENDIF
		_CUROBJ = 1
	CASE m.but == 4 AND NOT (m.modify OR m.addrec)
		CLEAR READ
	CASE m.but == 4 AND (m.modify OR m.addrec)
		m.modify = .F.
		m.addrec = .F.
		_CUROBJ = 1
		SHOW GET m.but, 1 PROMPT "\<Add"
		SHOW GET m.but, 2 ENABLE PROMPT "\<Modify"
		SHOW GET m.but, 3 ENABLE PROMPT "\<Delete"
		SHOW GET m.but, 4 PROMPT "E\<xit"
		SHOW GET m.choose ENABLE
ENDCASE
IF m.modify OR m.addrec
	SET NEAR ON    && ? decompiler guessed a keyword on this line
ELSE
	SET NEAR OFF    && ? decompiler guessed a keyword on this line
ENDIF


PROCEDURE _qz00r186x
CLEAR READ


PROCEDURE _qz00r186y
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF EOF("LIST")
	SHOW GET m.but, 2 DISABLE
	SHOW GET m.but, 3 DISABLE
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
