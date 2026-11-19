* POPUP.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module POPUP.FXP, compiled 1995-03-18 13:57).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE popup
PARAMETERS y, x
ON KEY LABEL esc clear read
IF NOT WEXIST("popup")
	DEFINE WINDOW popup AT y, x SIZE 9.857, 22.250 FONT "Times New Roman", 8 STYLE "I" POPUP OF IN printit NOGROW    && ? decompiler guessed a keyword on this line
ENDIF
IF WVISIBLE("popup")
	ACTIVATE WINDOW popup SAME
ELSE
	ACTIVATE WINDOW popup NOSHOW
ENDIF
@ 0.071,0.250 GET m.item  PICTURE "@&N"  POPUP printlist  SIZE 7.000,14.550  DEFAULT " "  FONT "Times New Roman", 10  STYLE "B"  VALID _qxl0u3s73()
@ 8.286, 1.450 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.538, 13.167, 0.667 PICTURE "@*HT \<Cancel" VALID _qym0tkhug()
IF NOT WVISIBLE("popup")
	ACTIVATE WINDOW popup
ENDIF
READ CYCLE
RELEASE WINDOW popup
DO keys


PROCEDURE _qxl0u3s73
CLEAR READ


PROCEDURE _qym0tkhug
m.item = "Cancel"
