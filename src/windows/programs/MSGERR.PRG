* MSGERR.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module MSGERR.FXP, compiled 1995-06-26 22:55).
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
IF NOT WEXIST("_r1e1d5dq3")
	DEFINE WINDOW _r1e1d5dq3 AT 0.000, 0.000 SIZE 13.692, 62.200 FONT "MS Sans Serif", 8 FLOAT OF NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
ENDIF
PRIVATE m.but
m.but = 1
IF WVISIBLE("_r1e1d5dq3")
	ACTIVATE WINDOW _r1e1d5dq3 SAME
ELSE
	ACTIVATE WINDOW _r1e1d5dq3 NOSHOW
ENDIF
@ 0.615, 16.800 SAY "Deck Daemon Error" FONT "MS Sans Serif", 12 STYLE "T"
@ 2.846, 3.600 SAY MESSAGE() FONT "MS Sans Serif", 8 SIZE 1.000, 54.400 PICTURE "@I"
@ 5.615, 12.400 SAY x FONT "MS Sans Serif", 8 SIZE 1.000, 8.800
@ 7.308, 12.400 SAY m.eprogram FONT "MS Sans Serif", 8 SIZE 1.000, 35.200
@ 9.308, 12.400 SAY elinenum FONT "MS Sans Serif", 8 SIZE 1.000, 16.000
@ 11.077, 16.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.846, 7.167, 0.667 PICTURE "@*HT \<Abort;\<Retry;\<Fail"
@ 5.615, 2.000 SAY "Error #" FONT "MS Sans Serif", 8 STYLE "T"
@ 7.462, 2.000 SAY "Proc." FONT "MS Sans Serif", 8 STYLE "T"
@ 9.308, 2.000 SAY "Line." FONT "MS Sans Serif", 8 STYLE "T"
IF NOT WVISIBLE("_r1e1d5dq3")
	ACTIVATE WINDOW _r1e1d5dq3
ENDIF
READ CYCLE SHOW _r1e1d5dws() MODAL    && ? decompiler guessed a keyword on this line
RELEASE WINDOW _r1e1d5dq3
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
RETURN m.but


PROCEDURE _r1e1d5dws
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF SYS(2016) = "_R1E1D5DQ3" OR SYS(2016) = "*"
	ACTIVATE WINDOW _r1e1d5dq3 SAME
	@ 5.615, 12.400 SAY x FONT "MS Sans Serif", 8 SIZE 1.000, 8.800, 0.000
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
