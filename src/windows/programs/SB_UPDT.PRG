* SB_UPDT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SB_UPDT.FXP, compiled 1995-04-26 00:51).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE sb_updt
PARAMETERS m.sbdone, m.sbtotal, m.msg
IF m.sbdone = 0 OR m.sbtotal = 0
	RETURN
ENDIF
IF NOT WEXIST("STAT_BAR")
	RETURN
ENDIF
IF EMPTY(m.msg)
	m.msg = ""
ENDIF
IF m.msg <> m.sb_text
	@ 2.308, 5.400 SAY m.msg FONT "MS Sans Serif", 8 SIZE 1.000, 89.200 PICTURE "@I"
	m.sb_text = m.msg
ENDIF
m.sb_pos = 5 + 90.200 * IIF(m.sbdone >= m.sbtotal, 1, m.sbdone / m.sbtotal)
IF m.sb_pos > m.sb_bar
	@ 4.308, m.sb_bar - 1.2 COLOR RGB(0,255,255,0,255,255) TO 6.693, (m.sb_pos) PATTERN 1 PEN 1, 8
	m.sb_bar = m.sb_pos + 1
ENDIF
