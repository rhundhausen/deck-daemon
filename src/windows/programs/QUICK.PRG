* QUICK.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module QUICK.FXP, compiled 1995-03-22 22:44).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE quick
IF NOT WEXIST("_qyq1buece")
	DEFINE WINDOW _qyq1buece AT 0.143, 118.750 SIZE 5.000, 31.800 FONT "Times New Roman", 9 STYLE "I" POPUP OF NOGROW    && ? decompiler guessed a keyword on this line
ENDIF
PRIVATE m.quick
m.quick = 1
IF WVISIBLE("_qyq1buece")
	ACTIVATE WINDOW _qyq1buece SAME
ELSE
	ACTIVATE WINDOW _qyq1buece NOSHOW
ENDIF
@ 1.813, 10.400 COLOR, RGB(,,,255,255,255) GET m.quick DEFAULT 0.000 FONT "Times New Roman", 14 STYLE "I" SIZE 0.909, 5.250 RANGE 0, IIF(m.have = 2, cards.total, 999) PICTURE "@K 9999" ENABLE 1.000, 0, IIF(m.have = 2, cards.total, 999) VALID _qyq1buesk() WHEN _qyq1buerj() MESSAGE "Value out of Range"    && ? decompiler guessed a keyword on this line
@ 0.313, 0.400 SAY IIF(m.have = 2, "Quick Subtract", "Quick Add") FONT "Times New Roman", 9 STYLE "IT" SIZE 0.938, 30.400 PICTURE "@I"
@ 3.500, 11.600 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.538, 7.167, 0.667 PICTURE "@*HT \<Done"
IF NOT WVISIBLE("_qyq1buece")
	ACTIVATE WINDOW _qyq1buece
ENDIF
READ CYCLE
RELEASE WINDOW _qyq1buece
RETURN m.quick


PROCEDURE _qyq1buerj
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyq1buesk
SET NEAR OFF    && ? decompiler guessed a keyword on this line
CLEAR READ
