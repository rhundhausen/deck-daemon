* SB_INIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SB_INIT.FXP, compiled 1995-04-26 00:51).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE sb_init
PARAMETERS m.msg
IF EMPTY(m.msg)
	m.msg = "Please Wait"
ENDIF
PUBLIC sb_bar, sb_text
sb_bar = 6.200
sb_text = ""
IF NOT WEXIST("_qxe0sdipr")
	DEFINE WINDOW stat_bar AT 0.000, 0.000 SIZE 7.538, 100.600 FONT "MS Sans Serif", 8 COLOR RGB(,,,192,192,192) FLOAT OF TITLE "Working..." NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
	MOVE WINDOW stat_bar CENTER
ENDIF
IF WVISIBLE("stat_bar")
	ACTIVATE WINDOW stat_bar SAME
ELSE
	ACTIVATE WINDOW stat_bar NOSHOW
ENDIF
@ 4.308, 5.000 COLOR RGB(255,255,255,255,255,255) TO 6.693, 95.200 PATTERN 1 PEN 1, 8
@ 4.154, 4.600 COLOR RGB(0,0,0,0,0,0) TO 4.154, 95.200 STYLE "1" PEN 2, 8
@ 4.231, 4.600 COLOR RGB(0,0,0,0,0,0) TO 6.693, 4.600 PEN 2, 8
@ 0.462, 5.400 COLOR RGB(0,0,0,192,192,192) SAY m.msg FONT "MS Sans Serif", 10 STYLE "B" SIZE 1.000, 55.750 PICTURE "@I"
IF NOT WVISIBLE("stat_bar")
	ACTIVATE WINDOW stat_bar
ENDIF
