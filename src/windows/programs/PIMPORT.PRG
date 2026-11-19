* PIMPORT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PIMPORT.FXP, compiled 1995-06-25 12:09).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE pimport
PARAMETERS path
PRIVATE point
m.done = 0
DIMENSION except(1)
point = 0
howmuch = chkcard(path, 120, "Prices")
handle = FOPEN(path, 2)
IF handle < 1
	= errormsg("Importing Prices", "Error Opening File!", 1)
	RETURN
ENDIF
nmsource = ""
nmnumber = 0
IF UPPER(getit(4)) <> "M:TG"
	= errormsg("Importing Prices", "This is not a Magic(r) price update!", 1)
	RETURN
ENDIF
= getit(72)
nmsource = getit(20)
SELECT price
IF NOT SEEK(nmsource)
	CALCULATE TO nmnumber MAX ALIAS price.reference ALL
	nmnumber = nmnumber + 1
	APPEND BLANK
	REPLACE price.name WITH nmsource
	REPLACE price.reference WITH nmnumber
ELSE
	= errormsg("Importing Prices", nmsource + " Already Exists!", 1)
	RETURN
ENDIF
SELECT list
ZAP
SELECT pdetail
= FCLOSE(handle)
handle = FOPEN(path, 2)
IF handle < 1
	= errormsg("Importing Prices", "Error Opening File!", 1)
	RETURN
ENDIF
DO sb_init WITH "Importing Prices..."
SELECT cards
SET EXACT OFF    && ? decompiler guessed a keyword on this line
DO WHILE .T.
	m.game = FGETS(handle, 4)
	IF FEOF(handle)
		EXIT
	ENDIF
	m.series = PROPER(getit(15))    && ? decompiler guessed a keyword on this line
	m.type = getit(1)
	m.name = PROPER(LEFT(getit(40), 30))    && ? decompiler guessed a keyword on this line
	m.color = PROPER(getit(5))    && ? decompiler guessed a keyword on this line
	= getit(3)
	= getit(3)
	= getit(5)
	= getit(20)
	m.low = VAL(getit(8))
	m.med = VAL(getit(8))
	m.hi = VAL(getit(8))
	= FGETS(handle, 2)
	IF m.type == "C"
		x = ASCAN(a_series, m.series)
		IF x <> 0
			m.ser = b_series(x)
			IF SEEK(m.ser + m.name + m.color, "CARDS")
				INSERT INTO "pdetail" (reference, cardnumber, low, med, hi ) VALUES (STR(nmnumber, 10), cards.cardnumber, m.low, m.med, m.hi )
			ELSE
				DO pexcept WITH 1
			ENDIF
		ELSE
			DO pexcept WITH 2
		ENDIF
	ENDIF
	m.done = m.done + 1
	DO sb_updt WITH m.done, m.howmuch, nmsource
ENDDO
SET EXACT ON    && ? decompiler guessed a keyword on this line
DO sb_close
= FCLOSE(handle)
SELECT cardnumber, series, card FROM cards WHERE NOT cardnumber IN (SELECT cardnumber FROM pdetail WHERE reference == STR(nmnumber, 10)) ORDER BY series, card INTO CURSOR orphans
IF _TALLY > 0
	SELECT orphans
	GO TOP
	INSERT INTO "LIST" (text ) VALUES (REPLICATE("-", 75) )
	tmp_series = ""
	DO WHILE NOT EOF("orphans")
		IF orphans.series <> tmp_series
			tmp_series = orphans.series
			tmp_recno = RECNO("orphans")
			GO TOP
			COUNT FOR orphans.series == tmp_series TO tmp_counta
			GO tmp_recno
			SELECT cards
			GO TOP
			COUNT FOR cards.series == tmp_series TO tmp_countb
			SELECT orphans
			IF tmp_countb == tmp_counta
				INSERT INTO "LIST" (text ) VALUES ("No price match found for : " + orphans.series + " **** Complete Series" )
				DO WHILE orphans.series == tmp_series
					SKIP
				ENDDO
				LOOP
			ENDIF
		ENDIF
		INSERT INTO "LIST" (text ) VALUES ("No price match found for : " + orphans.series + "         " + orphans.card )
		SKIP
	ENDDO
	USE
	SELECT cards
ENDIF
IF _TALLY > 50
	DO errormsg WITH "Importing Prices", ALLTRIM(STR(_TALLY)) + " Cards Had no price guide match", 1    && ? decompiler guessed a keyword on this line
ENDIF
IF EOF("list") AND BOF("list")
	RETURN
ELSE
	m.pprint = .F.
	m.pscreen = .T.
	DO WHILE m.pprint OR m.pscreen
		DO "except.prg"
		SELECT list
		header = "Price import Exception List"
		IF m.pscreen
			REPORT FORM "EXCEPT" PREVIEW NOCONSOLE
		ENDIF
		IF m.pprint
			REPORT FORM "EXCEPT" TO PRINTER PROMPT NOCONSOLE
		ENDIF
	ENDDO
ENDIF
RETURN


PROCEDURE pexcept
PARAMETERS x
SELECT list
IF x == 1
	APPEND BLANK
	REPLACE list.text WITH "Card Not Found  :  " + m.series + "  " + m.name
ELSE
	IF EMPTY(ASCAN(except, m.series))
		point = point + 1
		DIMENSION except(point)
		except(point) = m.series
		APPEND BLANK
		REPLACE list.text WITH "Series not found:  " + m.series + "  Nothing imported this series!"
	ENDIF
ENDIF
SELECT pdetail
RETURN
