* ERRORMSG.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module ERRORMSG.FXP, compiled 1995-04-02 13:44).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE errormsg
PARAMETERS m.title, m.message, m.htype
IF m.title <> ""
	m.title = "Problem Encountered while " + title
ELSE
	m.title = "System Error"
ENDIF
IF NOT WEXIST("_qxb10pxyx")
	DEFINE WINDOW _qxb10pxyx AT 0.000, 0.000 SIZE 9.000, 82.400 FONT "MS Sans Serif", 8 FLOAT OF TITLE m.title NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qxb10pxyx CENTER
ENDIF
IF WVISIBLE("_qxb10pxyx")
	ACTIVATE WINDOW _qxb10pxyx SAME
ELSE
	ACTIVATE WINDOW _qxb10pxyx NOSHOW
ENDIF
DO CASE
	CASE htype == 1
		@ 7, 38.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 5.000, 0.667 PICTURE "@*HT \<OK"
	CASE htype == 2
		@ 7, 29.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.667, 0.667 PICTURE "@*HT \<OK;\<Abort"
	CASE htype == 3
		@ 7, 24.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 8.667, 0.667 PICTURE "@*HT \<Abort;\<Retry;\<Fail"
ENDCASE
@ 0.846, 5.600 SAY m.message FONT "Times New Roman", 14 STYLE "T" SIZE 0.944, 59.167 PICTURE "@I"
IF NOT WVISIBLE("_qxb10pxyx")
	ACTIVATE WINDOW _qxb10pxyx
ENDIF
READ CYCLE MODAL
RELEASE WINDOW _qxb10pxyx
RETURN m.but
