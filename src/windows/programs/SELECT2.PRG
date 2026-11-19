* SELECT2.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SELECT2.FXP, compiled 1995-04-04 18:02).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE select2
PARAMETERS m.but
DO CASE
	CASE m.but == 1
		IF changed
			IF alertit("Save Changes to Deck")
				DO decksave
			ENDIF
		ENDIF
		IF alertit("Exit Deckbuilder?")
			m.run = 2
			DEACTIVATE WINDOW ("cards")
			DO checkbuild
		ENDIF
	CASE m.but == 2
		PUSH KEY CLEAR
		DO "filter.prg"
		SHOW GETS
		SHOW WINDOW SAY cards
		POP KEY
	CASE m.but == 3
		PUSH KEY CLEAR
		DO "viewb.prg"
		POP KEY
	CASE m.but == 4
		IF size == 1
			size = 2
		ELSE
			size = 1
		ENDIF
		DO display
	CASE m.but == 5
		DO "finder.prg"
		SHOW WINDOW SAY ("cards")
		SHOW GETS OFF
	CASE m.but == 6
		DO help
ENDCASE
