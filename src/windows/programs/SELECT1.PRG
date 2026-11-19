* SELECT1.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SELECT1.FXP, compiled 1995-06-24 17:38).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

PARAMETERS m.but
m.changed = .F.
DO CASE
	CASE m.but == 1
		IF alertit("Exit Deck Daemon?")
			m.run = 10
			ACTIVATE WINDOW tool1 TOP
			DO exiter WITH .T.
		ENDIF
	CASE m.but == 2 AND NOT EOF("cards")
		m.run = 2
		ACTIVATE WINDOW tool1 TOP
		CLEAR READ
	CASE m.but == 3
		DO "filter.prg"
		SHOW WINDOW SAY ("cards")
	CASE m.but == 4 AND NOT EOF("cards")
		SHOW GETS OFF WINDOW list
		DO "viewit.prg"
	CASE m.but == 5 AND NOT EOF("cards")
		DO "sort.prg"
		IF m.fchanged
			GO TOP
			DO display IN "list.prg"
		ENDIF
	CASE m.but == 6 AND NOT EOF("cards")
		m.edit = .T.
		DO "edit.prg"
		SHOW WINDOW SAY ("cards")
		SHOW GETS WINDOW list
	CASE m.but == 7
		m.edit = .F.
		DO "edit.prg"
		SHOW WINDOW SAY ("cards")
		SHOW GETS WINDOW list
	CASE m.but == 8 AND NOT EOF("cards")
		DO "finder.prg"
		SHOW WINDOW SAY ("cards")
	CASE m.but == 9 AND NOT EOF("cards")
		IF m.size == 1
			m.size = 2
			DO display
		ELSE
			m.size = 1
			DO display
		ENDIF
	CASE m.but == 10 AND NOT EOF("cards")
		DO "printit.prg"
	CASE m.but == 11
		DO "system.prg"
		DO display
	CASE m.but == 12
		DO help
ENDCASE
IF NOT USED("daemon8") AND m.rcsystem <> 0
	USE IN 0 "daemon8.ddw" INDEX "daemon8.ddx" ORDER '"lookup"'
ENDIF
IF m.changed
	DO display
ELSE
	SHOW GETS OFF
ENDIF
