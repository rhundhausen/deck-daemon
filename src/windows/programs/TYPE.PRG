* TYPE.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module TYPE.FXP, compiled 1995-03-12 21:59).
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
IF NOT WEXIST("type") OR UPPER(WTITLE("TYPE")) == "TYPE.PJX" OR UPPER(WTITLE("TYPE")) == "TYPE.SCX" OR UPPER(WTITLE("TYPE")) == "TYPE.MNX" OR UPPER(WTITLE("TYPE")) == "TYPE.PRG" OR UPPER(WTITLE("TYPE")) == "TYPE.FRX" OR UPPER(WTITLE("TYPE")) == "TYPE.QPR"
	DEFINE WINDOW type AT 0.000, 0.000 SIZE 9.563, 41.200 FONT "Times New Roman", 9 STYLE "I" POPUP OF NOGROW SYSTEM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW type CENTER
ENDIF
m.decktype = "Tournament"
IF WVISIBLE("type")
	ACTIVATE WINDOW type SAME
ELSE
	ACTIVATE WINDOW type NOSHOW
ENDIF
@ 1.813, 10.600 GET m.decktype DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.308, 16.500, 0.308 PICTURE "@*RVN \<Tournament;\<Grand Melee;O\<pen Deck;\<Sideboard"
@ 7.625, 17.600 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 5.000, 0.667 PICTURE "@*HT \<OK" VALID _qy80z5rvt()
@ 0.000, 11.400 SAY "Deck Type" FONT "Times New Roman", 16 STYLE "B" + isystem + "T"
IF NOT WVISIBLE("type")
	ACTIVATE WINDOW type
ENDIF
READ CYCLE DEACTIVATE _qy80z5rzl()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW type
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE settype
DO CASE
	CASE m.decktype = "Tournament"
		m.deck = 60
		m.mini = 60
		m.max = 999999
	CASE m.decktype = "Open Deck"
		m.deck = 60
		m.mini = 0
		m.max = 999999
	CASE m.decktype = "Grand Melee"
		m.deck = 100
		m.mini = 100
		m.max = 999999
	CASE m.decktype = "Sideboard"
		m.deck = 15
		m.mini = 15
		m.max = 15
ENDCASE


PROCEDURE _qy80z5rvt
RELEASE WINDOW type
DO settype
DO "new.prg"


PROCEDURE _qy80z5rzl
CLEAR READ
