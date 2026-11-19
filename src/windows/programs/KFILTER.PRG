* KFILTER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module KFILTER.FXP, compiled 1995-03-19 16:09).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE kfilter
PARAMETERS temp
IF temp = "LIST" OR temp = "BUILDER"
	temp = UPPER(PROMPT())    && ? decompiler guessed a keyword on this line
	DO CASE
		CASE temp = "SERIES"
			IF m.fseries = "All"
				x = ASCAN(b_series, cards.series)
				m.fseries = a_series(x)
			ELSE
				m.fseries = "All"
			ENDIF
		CASE temp = "COLOR"
			IF m.fcolor = "All"
				m.fcolor = cards.color
			ELSE
				m.fcolor = "All"
			ENDIF
		CASE temp = "TYPE"
			IF m.ftype = "All"
				m.ftype = cards.type
			ELSE
				m.ftype = "All"
			ENDIF
		CASE temp = "ARTIST"
			IF m.fartist = "All"
				m.fartist = cards.artist
			ELSE
				m.fartist = "All"
			ENDIF
		CASE temp = "RESTRICTIO"
			IF m.frestrict = "All"
				m.frestrict = cards.restrictio
			ELSE
				m.frestrict = "All"
			ENDIF
		CASE temp = "RARITY"
			IF m.frarity = "All"
				m.frarity = cards.rarity
			ELSE
				m.frarity = "All"
			ENDIF
		CASE temp = "WANTED"
			IF m.fwant = 1
				IF cards.wanted > 0
					m.fwant = 2
				ELSE
					m.fwant = 3
				ENDIF
			ELSE
				m.fwant = 1
			ENDIF
		CASE temp = "TOTAL"
			IF m.fhave = 1
				IF cards.total > 0
					m.fhave = 2
				ELSE
					m.fhave = 3
				ENDIF
			ELSE
				m.fhave = 1
			ENDIF
		OTHERWISE
			DO warn WITH ("Can Not Filter on this field")
	ENDCASE
	DO setfilter IN "filter.prg"
	SHOW WINDOW SAY ("cards list")
	SHOW GETS
ENDIF
