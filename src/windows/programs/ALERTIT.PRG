* ALERTIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module ALERTIT.FXP, compiled 1995-02-10 08:45).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

PARAMETERS m.title
PUSH KEY CLEAR
IF NOT WEXIST("alert") OR UPPER(WTITLE("ALERT")) == "ALERT.PJX" OR UPPER(WTITLE("ALERT")) == "ALERT.SCX" OR UPPER(WTITLE("ALERT")) == "ALERT.MNX" OR UPPER(WTITLE("ALERT")) == "ALERT.PRG" OR UPPER(WTITLE("ALERT")) == "ALERT.FRX" OR UPPER(WTITLE("ALERT")) == "ALERT.QPR"
	DEFINE WINDOW alert AT 0.000, 0.000 SIZE 6.308, 57.600 FONT "MS Sans Serif", 8 FLOAT OF TITLE (WTITLE("")) NOGROW    && ? decompiler guessed a keyword on this line
	MOVE WINDOW alert CENTER
ENDIF
IF WVISIBLE("alert")
	ACTIVATE WINDOW alert SAME
ELSE
	ACTIVATE WINDOW alert NOSHOW
ENDIF
@ 0.769, 2.600 SAY m.title FONT "Times New Roman", 11 STYLE "TB" SIZE 0.947, 43.000 PICTURE "@I"
@ 3.692, 17.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 8.667, 0.667 PICTURE "@*H \<OK;\<Cancel"
IF NOT WVISIBLE("alert")
	ACTIVATE WINDOW alert
ENDIF
READ CYCLE MODAL
RELEASE WINDOW alert
POP KEY
IF m.but == 1
	RETURN .T.
ELSE
	RETURN .F.
ENDIF
