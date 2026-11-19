* LOADIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module LOADIT.FXP, compiled 1995-03-14 19:51).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

o_alias = ALIAS()
m.black = 0
m.blue = 0
m.green = 0
m.red = 0
m.white = 0
m.gold = 0
m.artifact = 0
m.enchant = 0
m.instant = 0
m.interrupt = 0
m.land = 0
m.sorcery = 0
m.summon = 0
m.restricted = 0
m.banned = 0
m.deck = 0
m.cards = 0
IF NOT EMPTY(daemon3.deck)
	m.decktype = daemon3.type
	m.deckname = daemon3.deck
	m.cards = 0
	m.deck = daemon3.count
	m.decknumber = daemon3.number
	DO rules IN "new.prg"
	WAIT WINDOW NOWAIT "Loading Deck " + ALLTRIM(m.deckname)    && ? decompiler guessed a keyword on this line
	m.notfound = 0
	USE IN 0 "daemon4.ddw" ALIAS detail
	SELECT cards
	BLANK FIELDS count ALL
	FLUSH
	SET ORDER TO '"CARDNUMBER"'
	SELECT detail
	SCAN FOR detail.deck = m.decknumber
		IF NOT SEEK(detail.card, "cards")
			m.notfound = m.notfound + 1
		ELSE
			REPLACE cards.count WITH detail.quantity
			DO deckinfo WITH detail.quantity
		ENDIF
	ENDSCAN
	IF NOT EMPTY(m.notfound)
		WAIT WINDOW TIMEOUT 10 "Deck is out of date: " + ALLTRIM(STR(m.notfound)) + " Cards "    && ? decompiler guessed a keyword on this line
	ENDIF
	SELECT detail
	USE
	WAIT CLEAR
ENDIF
SELECT (o_alias)
