* EXCEPT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module EXCEPT.FXP, compiled 1995-03-19 17:02).
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
IF NOT WEXIST("_qya0p6758")
	DEFINE WINDOW _qya0p6758 AT 0.000, 0.000 SIZE 8.769, 58.200 FONT "MS Sans Serif", 8 FLOAT OF TITLE "Exceptions List" NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qya0p6758 CENTER
ENDIF
IF WVISIBLE("_qya0p6758")
	ACTIVATE WINDOW _qya0p6758 SAME
ELSE
	ACTIVATE WINDOW _qya0p6758 NOSHOW
ENDIF
@ 1.923, 9.000 GET m.pprint DEFAULT 0 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.308, 32.333 PICTURE "@*C Print Exceptions list to printer"
@ 3.769, 9.000 GET m.pscreen DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.308, 33.333 PICTURE "@*C View Exceptions list on screen"
@ 6.462, 18.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 8.667, 0.667 PICTURE "@*HT \<OK;\<Cancel" VALID _qya0p679y()
IF NOT WVISIBLE("_qya0p6758")
	ACTIVATE WINDOW _qya0p6758
ENDIF
READ CYCLE
RELEASE WINDOW _qya0p6758
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE _qya0p679y
IF m.but == 2
	m.pscreen = .F.
	m.pprint = .F.
ENDIF
