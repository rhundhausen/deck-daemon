* IMPORT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module IMPORT.FXP, compiled 1995-04-05 10:00).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE import
PARAMETERS choice
WAIT WINDOW NOWAIT "Setting Up..."
SELECT cards
m.ioldfilter = FILTER()
m.ioldorder = ORDER()
m.ioldrec = RECNO()
SET FILTER TO
m.iquan = 0
handle = 0
IF choice <> 2
	m.dport = -1
ELSE
	m.dport = 0
ENDIF
CALCULATE FOR cards.cardnumber < 900000 TO m.cardnumber MAX ALIAS cards.cardnumber ALL
m.cardnumber = m.cardnumber + 1
imported = 0
rejected = 0
USE IN 0 "daemon2.ddw" ALIAS "detail" INDEX "daemon2.ddx"
SELECT cards
INDEX ON series + card + color + type TO "checkit.crd" COMPACT ADDITIVE
SET ORDER TO '"checkit"'
SELECT detail
INDEX ON name + short + type TO "checkit.dtl" COMPACT ADDITIVE
SET ORDER TO '"checkit"'
WAIT CLEAR
DO CASE
	CASE choice == 1
		path = GETFILE("lst", "Where is the Update?")
		IF NOT EMPTY(path)
			IF RIGHT(path, 10) = "DAEMON1.DD"
				DO oimport WITH path
			ELSE
				DO cimport WITH path
			ENDIF
		ENDIF
	CASE choice == 2
		path = GETFILE("lst", "Where is the Update?")
		IF NOT EMPTY(path)
			USE IN 0 "daemon3.ddw" INDEX "daemon3.ddx"
			USE IN 0 "daemon4.ddw"
			USE IN 0 "daemon9.ddw" ALIAS list
			SELECT list
			ZAP
			DO dimport WITH path
			SELECT daemon3
			USE
			SELECT daemon4
			USE
			SELECT list
			USE
		ENDIF
	CASE choice == 3
		path = GETFILE("cod", "Where is the Update?")
		IF NOT EMPTY(path)
			USE IN 0 "daemon8.ddw" AGAIN ALIAS pdetail INDEX "daemon8.ddx" ORDER '"LOOKUP"'
			USE IN 0 "daemon9.ddw" ALIAS list
			DO pimport WITH path
			SET EXACT ON    && ? decompiler guessed a keyword on this line
			SELECT pdetail
			USE
			SELECT list
			USE
		ENDIF
	CASE choice == 4
		DO oimport WITH path
	CASE choice == 5
		DO cimport WITH path
ENDCASE
IF handle > 0
	= FCLOSE(handle)
ENDIF
DO sb_close
SELECT cards
CLOSE DATABASES    && ? decompiler guessed a keyword on this line
SELECT detail
USE
ERASE "checkit.crd"
ERASE "checkit.dtl"
DO checkit
SELECT cards
SET INDEX TO "daemon1.ddx"
WAIT CLEAR
DO setup
IF choice = 1
	WAIT WINDOW TIMEOUT 7 TRANSFORM(imported, "999,999") + " Cards Imported!" + CHR(13) + TRANSFORM(rejected, "999,999") + " Duplicates Rejected!"
ELSE
	IF NOT EMPTY(imported)
		WAIT WINDOW TIMEOUT 3 TRANSFORM(imported, "999,999") + " Cards Imported!"
	ENDIF
ENDIF
SELECT cards
IF NOT EMPTY(m.ioldorder)
	SET ORDER TO (m.ioldorder)
ENDIF
GO TOP
IF NOT EMPTY(m.ioldfilter)
	SET FILTER TO &ioldfilter
ENDIF
