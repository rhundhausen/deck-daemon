* OIMPORT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module OIMPORT.FXP, compiled 1995-06-06 11:30).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE oimport
PARAMETERS path
path = LEFT(path, LEN(path) - 10)
IF NOT FILE(path + "daemon1.dd")
	= errormsg("Locating file", "Daemon1.dd Not Found", 1)
	RETURN "ERROR"
ENDIF
IF NOT FILE(path + "daemon2.dd")
	= errormsg("Locating file", "Daemon2.dd Not Found", 1)
	RETURN "ERROR"
ENDIF
USE IN 0 (path + "daemon1.dd") ALIAS "IMP"
USE IN 0 (path + "daemon2.dd") ALIAS "DET"
SELECT imp
COUNT TO howmuch
m.wanted = 0
GO TOP
DO sb_init WITH "Importing From Ver 1.2"
DO WHILE NOT EOF()
	SELECT imp
	SCATTER MEMVAR
	m.descriptio = m.desc
	m.rarity = LEFT(m.flags, 1)
	m.restrictio = SUBSTR(m.flags, 3, 1)
	SELECT det
	LOCATE FOR det.short = m.series
	IF FOUND()
		m.seriesnm = det.name
	ELSE
		m.seriesnm = "Added by System!"
	ENDIF
	SELECT imp
	m.card = ALLTRIM(m.card)    && ? decompiler guessed a keyword on this line
	IF RIGHT(m.card, 1) == "*"
		m.card = LEFT(m.card, LEN(m.card) - 1)
	ENDIF
	m.card = PADR(m.card, 30)
	DO setimp
	SELECT imp
	SKIP
ENDDO
SELECT imp
USE
SELECT det
USE
DO sb_close
RETURN "OK"
