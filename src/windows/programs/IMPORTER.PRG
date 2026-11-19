* IMPORTER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module IMPORTER.FXP, compiled 1995-04-05 13:56).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE importer
SELECT cards
IF NOT SEEK(m.series + m.card + m.color + m.type)
	m.total = m.quantity
	m.costtotal = totcost(m.cost)
	m.deck = -(m.total)    && ? decompiler guessed a keyword on this line
	INSERT INTO "cards" FROM MEMVAR
	FLUSH
	cardnumber = cardnumber + 1
	imported = imported + 1
ELSE
	REPLACE cards.total WITH cards.total + m.quantity
	REPLACE cards.quantity WITH cards.quantity + m.quantity
	rejected = rejected + 1
ENDIF
SELECT detail
IF NOT SEEK(m.seriesnm + m.series + "S")
	APPEND BLANK
	REPLACE detail.name WITH m.seriesnm
	REPLACE detail.short WITH m.series
	REPLACE detail.type WITH "S"
ENDIF
IF NOT SEEK(PADR(m.color, 20) + "    " + "C")
	APPEND BLANK
	REPLACE detail.name WITH m.color
	REPLACE detail.type WITH "C"
ENDIF
IF NOT SEEK(m.type + "    " + "T")
	APPEND BLANK
	REPLACE detail.name WITH m.type
	REPLACE detail.type WITH "T"
ENDIF
IF NOT SEEK(m.artist + "    " + "A")
	APPEND BLANK
	REPLACE detail.name WITH m.artist
	REPLACE detail.type WITH "A"
ENDIF
