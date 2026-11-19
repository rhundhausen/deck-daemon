* NEW.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module NEW.FXP, compiled 1995-03-19 22:33).
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
IF NOT WEXIST("new") OR UPPER(WTITLE("NEW")) == "NEW.PJX" OR UPPER(WTITLE("NEW")) == "NEW.SCX" OR UPPER(WTITLE("NEW")) == "NEW.MNX" OR UPPER(WTITLE("NEW")) == "NEW.PRG" OR UPPER(WTITLE("NEW")) == "NEW.FRX" OR UPPER(WTITLE("NEW")) == "NEW.QPR"
	DEFINE WINDOW new AT 0.000, 0.000 SIZE 10.875, 57.600 FONT "Times New Roman", 10 STYLE "I" POPUP OF NOGROW SYSTEM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW new CENTER
ENDIF
m.deckname = ""
SET NEAR ON    && ? decompiler guessed a keyword on this line
IF WVISIBLE("new")
	ACTIVATE WINDOW new SAME
ELSE
	ACTIVATE WINDOW new NOSHOW
ENDIF
@ 0.500, 16.800 COLOR RGB(,,,255,255,255) SAY "Deck Data" FONT "Times New Roman", 14 STYLE "BIT"
@ 3.000, 17.200 COLOR, RGB(,,,255,255,255) GET m.deckname DEFAULT " " FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 30.400 PICTURE "@KT XXXXXXXXXXXXXXXXXXXX" VALID _qyn119k8p()
@ 5.438, 27.000 COLOR, RGB(,,,255,255,255) GET m.deck DEFAULT 0.000 FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.875, 6.000 RANGE m.mini, m.max PICTURE "@K 999" ENABLE 1.000, m.mini, m.max MESSAGE "Please enter Valid number for this deck type"    && ? decompiler guessed a keyword on this line
@ 3.000, 2.000 COLOR RGB(,,,255,255,255) SAY "Deck Name" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 5.250, 4.800 COLOR RGB(,,,255,255,255) SAY "# of cards in deck" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.750, 38.800 COLOR RGB(,,,255,255,255) SAY m.decktype FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 15.800
@ 9.000, 25.800 COLOR,,,,,,,, RGB(,,,255,255,255) GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 5.000, 0.667 PICTURE "@*HN \<OK" VALID _qyn119kbo()
IF NOT WVISIBLE("new")
	ACTIVATE WINDOW new
ENDIF
READ CYCLE DEACTIVATE _qyn119kdt()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW new
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE rules
DO CASE
	CASE m.decktype = "Tournament"
		m.r_nonland = 4
		m.r_restrict = 1
		m.r_banned = 0
	CASE m.decktype = "Open Deck"
		m.r_nonland = 9999
		m.r_restrict = 9999
		m.r_banned = 9999
	CASE m.decktype = "Grand Melee"
		m.r_nonland = 6
		m.r_restrict = 1
		m.r_banned = 0
	CASE m.decktype = "Sideboard"
		m.r_nonland = 4
		m.r_restrict = 1
		m.r_banned = 0
	OTHERWISE
		TEXT
ENDCASE


PROCEDURE _qyn119k8p
m.deckname = PROPER(m.deckname)    && ? decompiler guessed a keyword on this line
LOCATE FOR daemon3.deck = m.deckname
IF FOUND("daemon3")
	WAIT WINDOW TIMEOUT 10 "Deck Name Already used!"
	m.deckname = ""
	_CUROBJ = 1
ENDIF


PROCEDURE _qyn119kbo
IF EMPTY(m.deckname)
	CLEAR READ
	RETURN .T.
ENDIF
m.decknumber = 0
CALCULATE TO m.decknumber MAX ALIAS daemon3.number ALL
APPEND BLANK
m.decknumber = m.decknumber + 1
REPLACE daemon3.number WITH m.decknumber
REPLACE daemon3.deck WITH m.deckname
REPLACE daemon3.type WITH m.decktype
REPLACE daemon3.count WITH m.deck
CLEAR READ


PROCEDURE _qyn119kdt
CLEAR READ
GO TOP
