* REBUILD.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module REBUILD.FXP, compiled 1995-04-01 12:48).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

PRIVATE m.eseries, m.etype, m.ecolor, m.eartist, m.ename, m.edeck
PRIVATE m.eflag, m.epointer, m.ldeck
PRIVATE m.bseries, m.btype, m.bcolor, m.bartist, m.deckold, m.edecknm
DIMENSION anames(1)
m.epointer = 0
m.eseries = 0
m.etype = 0
m.ecolor = 0
m.eartist = 0
m.ename = 0
m.edeck = 0
m.ldeck = 0
m.bseries = 0
m.btype = 0
m.bcolor = 0
m.bartist = 0
m.deckold = ""
m.edecknm = 0
m.eflag = .F.
m.realias = ALIAS()
SELECT cards
m.reorder = ORDER()
m.refilt = FILTER()
SET FILTER TO
USE IN 0 "daemon2.ddw" INDEX "daemon2.ddx"
USE IN 0 "daemon3.ddw" INDEX "daemon3.ddx"
USE IN 0 "daemon4.ddw"
USE IN 0 "daemon5.ddw" INDEX "daemon5.ddx"
USE IN 0 "daemon6.ddw" INDEX "daemon6.ddx"
IF NOT USED("daemon8")
	USE IN 0 "daemon8.ddw" INDEX "daemon8.ddx"
ENDIF
USE IN 0 "daemon9.ddw"
SELECT daemon9
ZAP
SELECT daemon4
COUNT TO m.total
SELECT daemon8
COUNT TO m.temp
m.total = m.total + m.temp
m.total = m.total + 950
SELECT cards
COUNT TO m.temp
m.total = m.total + m.temp
done = 0
DO sb_init WITH "Rebuilding Databases:"
SELECT cards
= done(1, "Packing 01")
PACK
= done(50, "Re-Indexing 01")
DELETE TAG all
DO checkit
SET INDEX TO "daemon1.ddx"
= done(50, "Packing 02")
SELECT daemon2
PACK
= done(50, "Re-Indexing 02")
DELETE TAG all
DO checkit
SET INDEX TO "daemon2.ddx"
= done(50, "Packing 03")
SELECT daemon3
PACK
= done(50, "Re-Indexing 03")
DELETE TAG all
DO checkit
SET INDEX TO "daemon3.ddx"
= done(50, "Packing 04")
SELECT daemon4
PACK
= done(100, "Packing 05")
SELECT daemon5
PACK
= done(50, "Re-Indexing 05")
DELETE TAG all
DO checkit
= done(50, "Packing 06")
USE
SELECT daemon6
PACK
= done(50, "Re-Indexing 06")
DELETE TAG all
DO checkit
= done(50, "Packing 07")
USE
SELECT price
PACK
= done(50, "Re-Indexing 07")
DELETE TAG all
DO checkit
SET INDEX TO "daemon7.ddx" ORDER '"REFERENCE"'
= done(50, "packing 08")
SELECT daemon8
PACK
= done(50, "Re-Indexing 08")
DELETE TAG all
DO checkit
SET INDEX TO "daemon8.ddx"
= done(50, "Cleaning 09")
SELECT cards
GO TOP
DO WHILE NOT EOF()
	SET ORDER TO "short" IN daemon2
	IF NOT SEEK(cards.series, "daemon2") OR EMPTY(cards.series)
		= interror("Series")
	ENDIF
	SET ORDER TO "name" IN daemon2
	IF NOT SEEK(PADR(cards.color, 20), "daemon2")
		= interror("Color")
	ENDIF
	IF NOT SEEK(cards.type, "daemon2")
		= interror("Type")
	ENDIF
	IF NOT SEEK(cards.artist, "daemon2")
		= interror("Artist")
	ENDIF
	IF EMPTY(cards.card)
		= interror("Name")
	ENDIF
	SKIP
	= done(1, "Checking Integrity 01")
ENDDO
PACK
SELECT daemon8
GO TOP
DO WHILE NOT EOF("daemon8")
	IF NOT SEEK(VAL(daemon8.reference), "price")
		DELETE
	ENDIF
	SKIP
	= done(1, "Checking Integrity 02")
ENDDO
PACK
USE
= done(50, "ReCalculate Decks")
SELECT cards
REPLACE cards.deck WITH -(cards.total) ALL    && ? decompiler guessed a keyword on this line
SET ORDER TO "cardnumber"
SELECT daemon4
GO TOP
DO WHILE NOT EOF()
	SELECT daemon3
	LOCATE FOR daemon3.number = daemon4.deck
	IF NOT FOUND()
		DELETE
		m.ldeck = m.ldeck + 1
		m.eflag = .T.
	ELSE
		SELECT daemon4
		IF NOT SEEK(daemon4.card, "cards")
			= interror("Deck")
		ENDIF
		REPLACE cards.deck WITH cards.deck + daemon4.quantity
	ENDIF
	SELECT daemon4
	SKIP
	= done(1, "ReCalculate Decks")
ENDDO
SELECT daemon2
USE
SELECT daemon3
USE
SELECT daemon4
USE
SELECT daemon9
USE
SELECT cards
SET ORDER TO (m.reorder)
IF NOT EMPTY(refilt)
	SET FILTER TO &refilt
ENDIF
SELECT (m.realias)
WAIT CLEAR
DO sb_close
RELEASE aname
IF m.eflag
	DO "summary.prg"
ENDIF


PROCEDURE done
PARAMETERS counter, text
done = done + counter
DO sb_updt WITH done, m.total, text
RETURN
