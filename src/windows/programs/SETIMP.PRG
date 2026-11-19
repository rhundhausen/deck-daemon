* SETIMP.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SETIMP.FXP, compiled 1995-04-26 00:47).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE setimp
m.iquan = m.iquan + 1
m.series = PROPER(m.series)    && ? decompiler guessed a keyword on this line
m.seriesnm = PROPER(m.seriesnm)    && ? decompiler guessed a keyword on this line
m.card = PROPER(m.card)    && ? decompiler guessed a keyword on this line
m.color = PROPER(m.color)    && ? decompiler guessed a keyword on this line
m.type = PROPER(m.type)    && ? decompiler guessed a keyword on this line
DO CASE
	CASE m.rarity == "U"
		m.rarity = "UnCommon"
	CASE m.rarity == "R"
		m.rarity = "Rare"
	CASE m.rarity == "C"
		m.rarity = "Common"
	OTHERWISE
		= errormsg("Importing", "File not in Deck Daemon Format!", 1)
		RETURN TO import
ENDCASE
DO CASE
	CASE m.restrictio == "B"
		m.restrictio = "Banned"
	CASE m.restrictio == "R"
		m.restrictio = "Restricted"
	CASE m.restrictio == " " OR m.restrictio == "O"
		m.restrictio = "Open"
	OTHERWISE
		= errormsg("Importing", "File not in Deck Daemon Format!", 1)
		RETURN TO import
ENDCASE
m.cost = UPPER(m.cost)
m.artist = PROPER(m.artist)    && ? decompiler guessed a keyword on this line
IF m.dport < 0
	DO sb_updt WITH m.iquan, howmuch
ELSE
	m.dport = m.dport + 1
	WAIT WINDOW NOWAIT "Added : " + TRANSFORM(m.dport, "999,999") + " Cards to Database"
ENDIF
DO importer
RETURN
