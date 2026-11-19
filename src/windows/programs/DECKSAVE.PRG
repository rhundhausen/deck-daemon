* DECKSAVE.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module DECKSAVE.FXP, compiled 1995-04-11 09:19).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE decksave
DO showall
USE IN 0 "daemon4.ddw" ALIAS detail
SELECT detail
WAIT WINDOW NOWAIT "Saving Deck"
SELECT cards
o_order = ORDER()
SET ORDER TO ("cardnumber")
SELECT detail
SCAN FOR detail.deck == m.decknumber
	IF SEEK(detail.card, "CARDS")
		REPLACE cards.deck WITH cards.deck - detail.quantity
	ENDIF
ENDSCAN
SELECT cards
IF NOT EMPTY(o_order)
	SET ORDER TO (o_order)
ENDIF
SELECT detail
DELETE ALL FOR detail.deck == m.decknumber
PACK
SELECT cards
SCAN FOR NOT cards.count == 0
	SELECT detail
	APPEND BLANK
	REPLACE detail.deck WITH m.decknumber
	REPLACE detail.card WITH cards.cardnumber
	REPLACE detail.quantity WITH cards.count
	SELECT cards
	x = cards.deck + cards.count
	REPLACE cards.deck WITH x
	REPLACE cards.count WITH 0
ENDSCAN
SELECT detail
USE
USE IN 0 "daemon3.ddw" INDEX "daemon3.ddx"
SELECT daemon3
LOCATE FOR daemon3.deck = m.deckname
REPLACE daemon3.cards WITH m.cards
USE
changed = .F.
SELECT cards
WAIT CLEAR
RETURN .T.
