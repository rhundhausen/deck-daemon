* CHANGEIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CHANGEIT.FXP, compiled 1995-03-19 22:36).
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
m.deckname = daemon3.deck
m.oldname = daemon3.deck
m.deck = daemon3.count
SET NEAR ON    && ? decompiler guessed a keyword on this line
IF WVISIBLE("new")
	ACTIVATE WINDOW new SAME
ELSE
	ACTIVATE WINDOW new NOSHOW
ENDIF
@ 0.500, 16.800 COLOR RGB(,,,255,255,255) SAY "Deck Data" FONT "Times New Roman", 14 STYLE "BIT"
@ 3.000, 17.200 COLOR, RGB(,,,255,255,255) GET m.deckname DEFAULT " " FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 30.400 PICTURE "@KT XXXXXXXXXXXXXXXXXXXX" VALID _qyn14dz5y()
@ 5.438, 27.000 COLOR, RGB(,,,255,255,255) GET m.deck DEFAULT 0.000 FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.875, 6.000 RANGE daemon3.cards, 999 PICTURE "@K 999" ENABLE 1.000, daemon3.cards, 999 MESSAGE "Please enter Valid number for this deck type"    && ? decompiler guessed a keyword on this line
@ 3.000, 2.000 COLOR RGB(,,,255,255,255) SAY "Deck Name" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 5.250, 4.800 COLOR RGB(,,,255,255,255) SAY "# of cards in deck" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.750, 38.800 COLOR RGB(,,,255,255,255) SAY m.decktype FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 15.800
@ 9.000, 25.800 COLOR,,,,,,,, RGB(,,,255,255,255) GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 5.000, 0.667 PICTURE "@*HN \<OK" VALID _qyn14dz9c()
IF NOT WVISIBLE("new")
	ACTIVATE WINDOW new
ENDIF
READ CYCLE DEACTIVATE _qyn14dzb4()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW new
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyn14dz5y
m.deckname = PROPER(m.deckname)    && ? decompiler guessed a keyword on this line
IF m.deckname <> m.oldname
	LOCATE FOR daemon3.deck = m.deckname
	IF FOUND("daemon3")
		WAIT WINDOW TIMEOUT 10 "Deck Name Already used!"
		m.deckname = m.oldname
		_CUROBJ = 1
	ENDIF
ENDIF


PROCEDURE _qyn14dz9c
IF EMPTY(m.deckname)
	CLEAR READ
	RETURN .T.
ENDIF
REPLACE daemon3.deck WITH m.deckname
REPLACE daemon3.count WITH m.deck
CLEAR READ


PROCEDURE _qyn14dzb4
CLEAR READ
GO TOP
