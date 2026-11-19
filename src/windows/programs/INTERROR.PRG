* INTERROR.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module INTERROR.FXP, compiled 1995-02-16 11:33).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE interror
PARAMETERS m.int
PRIVATE intalias, intrecno
intalias = ALIAS()
IF NOT EOF()
	intrecno = RECNO()
ELSE
	intrecno = 0
ENDIF
m.eflag = .T.
DO CASE
	CASE m.int == "Type"
		IF EMPTY(cards.type)
			DO note WITH "No Type Defined for " + cards.series + " " + cards.card
			REPLACE cards.type WITH "AAAAA"
			m.btype = m.btype + 1
		ELSE
			IF RIGHT(cards.type, 5) <> "AAAAA"
				SELECT daemon2
				APPEND BLANK
				REPLACE daemon2.name WITH cards.type
				REPLACE daemon2.type WITH "T"
				DO note WITH "Definition for Type : " + ALLTRIM(cards.type) + " added"    && ? decompiler guessed a keyword on this line
				m.etype = m.etype + 1
			ENDIF
		ENDIF
	CASE m.int == "Series"
		IF EMPTY(cards.series)
			REPLACE cards.series WITH "AAAA"
			DO note WITH "No series Defined for " + cards.card
			m.bseries = m.bseries + 1
		ELSE
			IF cards.series <> "AAAA"
				SELECT daemon2
				APPEND BLANK
				REPLACE daemon2.name WITH "Aa_systemadded"
				REPLACE daemon2.short WITH cards.series
				REPLACE daemon2.type WITH "S"
				DO note WITH "Definition for Series : " + cards.series + " added"
				m.eseries = m.eseries + 1
			ENDIF
		ENDIF
	CASE m.int == "Color"
		IF EMPTY(cards.color)
			REPLACE cards.color WITH "AAAAA"
			DO note WITH "No color defined for " + cards.card
			m.bcolor = m.bcolor + 1
		ELSE
			IF RIGHT(cards.color, 5) <> "AAAAA"
				SELECT daemon2
				APPEND BLANK
				REPLACE daemon2.name WITH cards.color
				REPLACE daemon2.type WITH "C"
				DO note WITH "Definition for Color : " + cards.color + " added"
				m.ecolor = m.ecolor + 1
			ENDIF
		ENDIF
	CASE m.int == "Artist"
		IF EMPTY(cards.artist)
			REPLACE cards.artist WITH "AAAAA"
			DO note WITH "No artist defined for " + cards.card
			m.bartist = m.bartist + 1
		ELSE
			IF RIGHT(cards.artist, 5) <> "AAAAA"
				SELECT daemon2
				APPEND BLANK
				REPLACE daemon2.name WITH cards.artist
				REPLACE daemon2.type WITH "A"
				DO note WITH "Definition for Artist : " + ALLTRIM(cards.artist) + " added"    && ? decompiler guessed a keyword on this line
				m.eartist = m.eartist + 1
			ENDIF
		ENDIF
	CASE m.int = "Name"
		REPLACE cards.card WITH "AAAAA add by system"
		m.ename = m.ename + 1
		DO note WITH "Nameless card under series : " + cards.series
	CASE m.int = "Deck"
		m.edeck = m.edeck + 1
		IF m.deckold <> daemon3.deck
			m.deckold = daemon3.deck
			m.edecknm = m.edecknm + 1
			m.epointer = m.epointer + 1
			DIMENSION anames(m.epointer)
			anames(m.epointer) = daemon3.deck
			DO note WITH "Out of Date Deck  : " + daemon3.deck
		ENDIF
	OTHERWISE
		= errors("Rebuilding", 9002, 1)
ENDCASE
SELECT (intalias)
IF NOT EMPTY(intrecno)
	GO (intrecno)
ENDIF


PROCEDURE note
PARAMETERS string
PRIVATE oldalias
oldalias = ALIAS()
SELECT daemon9
APPEND BLANK
REPLACE daemon9.text WITH string
SELECT (oldalias)
RETURN
