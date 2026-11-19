* ADDIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module ADDIT.FXP, compiled 1995-04-03 22:07).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE addit
PARAMETERS x
PUSH KEY CLEAR
IF x = 999999
	x = -(cards.count)    && ? decompiler guessed a keyword on this line
ENDIF
DO CASE
	CASE (m.cards < m.deck) AND (m.cards + x >= m.deck)
		x = m.deck - m.cards
	CASE NOT (m.cards < m.deck) AND (x > 0)
		POP KEY
		? CHR(7)
		RETURN .T.
ENDCASE
DO CASE
	CASE (cards.restrictio = "Open") AND NOT (cards.type = "Land")
		IF cards.count + x > m.r_nonland
			x = m.r_nonland - cards.count
		ENDIF
	CASE (cards.restrictio = "Restricted")
		IF cards.count + x > m.r_restrict
			x = m.r_restrict - cards.count
		ENDIF
	CASE (cards.restrictio = "Banned")
		IF cards.count + x > m.r_banned
			x = m.r_banned - cards.count
		ENDIF
ENDCASE
IF x = 0
	?? CHR(7)
ENDIF
REPLACE cards.count WITH cards.count + x
DO deckinfo WITH x
changed = .T.
SHOW GETS OFF
POP KEY
RETURN .T.
