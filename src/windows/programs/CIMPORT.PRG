* CIMPORT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CIMPORT.FXP, compiled 1995-04-26 00:56).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE cimport
PARAMETERS path
PRIVATE m.series, m.seriesnm, m.card, m.color
PRIVATE m.type, m.rarity, m.restrictio, m.cost
PRIVATE m.artist, m.descriptio
howmuch = chkcard(path, 351, "Cards") + 50
handle = FOPEN(path, 2)
IF handle < 1
	= errormsg("Importing Cards", "Error Opening File!", 1)
	RETURN
ENDIF
SELECT cards
IF EOF() AND BOF()
	DO sb_init WITH "Setting Up Data Files, Takes about 5 minutes"
ELSE
	DO sb_init WITH "Importing Update..."
ENDIF
DELETE TAG all OF "daemon1.ddx"
m.quantity = 0
m.wanted = 0
DO WHILE .T.
	m.series = FGETS(handle, 4)
	IF FEOF(handle)
		EXIT
	ENDIF
	m.seriesnm = getit(20)
	m.card = getit(30)
	m.color = getit(5)
	m.type = getit(20)
	m.rarity = getit(1)
	m.restrictio = getit(1)
	m.cost = getit(10)
	m.artist = getit(20)
	m.descriptio = getit(240)
	temp = FGETS(handle, 2)
	DO setimp
ENDDO
DO sb_updt WITH m.iquan, howmuch, "Indexing"
DO checkit
DO sb_updt WITH howmuch, howmuch, "Indexing"
DO sb_close
RETURN "OK"
