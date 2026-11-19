* DIMPORT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module DIMPORT.FXP, compiled 1995-06-25 12:19).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE dimport
PARAMETERS path
PRIVATE m.volume, m.dname, m.dtype, m.dcount, m.dqty, m.series
PRIVATE m.seriesnm, m.card, m.color, m.type, m.rarity, m.restrictio
PRIVATE m.cost, m.artist, m.descriptio, m.dcurrent
dcurrent = ""
m.numdeck = 0
howmuch = chkcard(path, 395, "Deck")
handle = FOPEN(path)
IF handle < 1
	= errormsg("Importing Decks", "Cound not open File!", 1)
	RETURN TO import
ENDIF
DO sb_init WITH "Importing Decks"
m.quantity = 0
DO WHILE .T.
	m.volume = FGETS(handle, 4)
	IF FEOF(handle)
		EXIT
	ENDIF
	m.dname = PROPER(getit(20))    && ? decompiler guessed a keyword on this line
	m.dtype = PROPER(getit(12))    && ? decompiler guessed a keyword on this line
	m.dcount = VAL(getit(4))
	m.dqty = VAL(getit(4))
	m.series = PROPER(getit(4))    && ? decompiler guessed a keyword on this line
	m.seriesnm = getit(20)
	m.card = PROPER(getit(30))    && ? decompiler guessed a keyword on this line
	m.color = PROPER(getit(5))    && ? decompiler guessed a keyword on this line
	m.type = PROPER(getit(20))    && ? decompiler guessed a keyword on this line
	m.rarity = getit(1)
	m.restrictio = getit(1)
	m.cost = getit(10)
	m.artist = getit(20)
	m.descriptio = getit(240)
	= FGETS(handle, 2)
	IF ALLTRIM(m.dname) <> LEFT(m.dcurrent, LEN(ALLTRIM(m.dname)))    && ? decompiler guessed a keyword on this line
		SELECT daemon3
		nlength = LEN(ALLTRIM(m.dname))    && ? decompiler guessed a keyword on this line
		dtemp = 1
		LOCATE FOR daemon3.deck = m.dname
		DO WHILE FOUND()
			m.dname = ALLTRIM(LEFT(m.dname, nlength)) + ALLTRIM(TRANSFORM(dtemp, "**"))    && ? decompiler guessed a keyword on this line
			dtemp = dtemp + 1
			LOCATE FOR daemon3.deck = m.dname
		ENDDO
		m.numdeck = m.numdeck + 1
		m.dcurrent = m.dname
		CALCULATE ALL TO dnumber MAX ALIAS daemon3.number ALL
		dnumber = dnumber + 1
		APPEND BLANK
		REPLACE daemon3.number WITH (dnumber)
		REPLACE daemon3.deck WITH m.dname
		REPLACE daemon3.type WITH m.dtype
		REPLACE daemon3.count WITH m.dcount
	ENDIF
	FLUSH
	SELECT cards
	IF NOT SEEK(m.series + m.card + m.color + m.type)
		CALCULATE ALL FOR cards.cardnumber < 900000 TO m.cardnumber MAX ALIAS cards.cardnumber ALL
		m.cardnumber = m.cardnumber + 1
		SELECT list
		APPEND BLANK
		REPLACE text WITH "Added Card  : " + m.seriesnm + "      " + m.card
		SELECT cards
		DO setimp
	ELSE
		cardnumber = cards.cardnumber
		m.iquan = m.iquan + 1
		DO sb_updt WITH m.iquan, howmuch, "Importing Deck " + m.dcurrent
	ENDIF
	REPLACE cards.deck WITH cards.deck + m.dqty
	SELECT daemon4
	APPEND BLANK
	REPLACE daemon4.deck WITH dnumber
	REPLACE daemon4.card WITH cards.cardnumber
	REPLACE daemon4.quantity WITH m.dqty
	REPLACE daemon3.cards WITH daemon3.cards + m.dqty
ENDDO
DO sb_close
WAIT WINDOW TIMEOUT 6 ALLTRIM(STR(m.numdeck)) + " Decks added " + ALLTRIM(STR(imported)) + " Cards added"    && ? decompiler guessed a keyword on this line
imported = 0
IF EOF("list") AND BOF("list")
	RETURN
ELSE
	m.pprint = .F.
	m.pscreen = .T.
	DO WHILE m.pscreen OR m.pprint
		DO "except.prg"
		SELECT list
		header = "Decks import Exception List"
		IF m.pscreen
			REPORT FORM "EXCEPT" PREVIEW NOCONSOLE
		ENDIF
		IF m.pprint
			REPORT FORM "EXCEPT" TO PRINTER PROMPT NOCONSOLE
		ENDIF
	ENDDO
ENDIF
RETURN
