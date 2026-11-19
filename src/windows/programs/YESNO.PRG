* YESNO.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module YESNO.FXP, compiled 1995-03-18 17:10).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE yesno
PARAMETERS m.message
IF NOT WEXIST("_qya0nv25j")
	DEFINE WINDOW _qya0nv25j AT 0.000, 0.000 SIZE 6.769, 64.200 FONT "MS Sans Serif", 8 FLOAT OF NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qya0nv25j CENTER
ENDIF
IF WVISIBLE("_qya0nv25j")
	ACTIVATE WINDOW _qya0nv25j SAME
ELSE
	ACTIVATE WINDOW _qya0nv25j NOSHOW
ENDIF
@ 1.000, 4.000 SAY m.message FONT "MS Sans Serif", 8 STYLE "T" SIZE 1.000, 56.000 PICTURE "@I"
@ 3.692, 19.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.833, 0.667 PICTURE "@*HT \<Yes;\<No"
IF NOT WVISIBLE("_qya0nv25j")
	ACTIVATE WINDOW _qya0nv25j
ENDIF
READ CYCLE
RELEASE WINDOW _qya0nv25j
RETURN (m.but == 1)
