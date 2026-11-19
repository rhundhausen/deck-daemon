* MAIN.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module MAIN.FXP, compiled 1995-07-05 20:57).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

CLOSE ALL
CLEAR ALL
CLEAR
test = .F.
m.tempver = "1.0d"
= RAND(-1)
IF NOT test
	SET SYSMENU OFF
	MODIFY WINDOW screen AT 0, 0 SIZE 30.214, 160.000 FONT "Times New Roman", 8 STYLE "I" NONE FLOAT CLOSE MINIMIZE TITLE "Deck Daemon For Windows" CENTER ICON FILE "daemon.ico"    && ? decompiler guessed a keyword on this line
	MOVE WINDOW screen CENTER
ENDIF
SET NOTIFY ON    && ? decompiler guessed a keyword on this line
SET STATUS BAR OFF
SET TALK OFF
SET TYPEAHEAD OFF    && ? decompiler guessed a keyword on this line
SET EXACT ON    && ? decompiler guessed a keyword on this line
SET DELETED ON
SET CURSOR ON    && ? decompiler guessed a keyword on this line
SET BELL OFF    && ? decompiler guessed a keyword on this line
SET CENTURY ON    && ? decompiler guessed a keyword on this line
SET COMPATIBLE OFF
SET CONFIRM OFF    && ? decompiler guessed a keyword on this line
SET NEAR OFF    && ? decompiler guessed a keyword on this line
SET ECHO OFF    && ? decompiler guessed a keyword on this line
SET MESSAGE TO WINDOW    && ? decompiler guessed a keyword on this line
SET CLOCK ON    && ? decompiler guessed a keyword on this line
SET SAFETY OFF
SET MESSAGE OFF    && ? decompiler guessed a keyword on this line
SET HELP TO "daemon.hlp"
IF NOT test
	ON ERROR DO errorout WITH ERROR(),PROGRAM(),LINENO(1),SYS(16)
	ON SHUTDOWN DO exiter
	SET TYPEAHEAD OFF    && ? decompiler guessed a keyword on this line
	SET ESCAPE OFF    && ? decompiler guessed a keyword on this line
ENDIF
PUBLIC m.series, m.type, m.color, m.artist
PUBLIC m.black, m.blue, m.green, m.red, m.white, m.gold, m.decknumber
PUBLIC m.artifact, m.enchant, m.instant, m.interrupt, m.land, m.sorcery, m.summon
PUBLIC m.restricted, m.banned, m.cards, m.deck, m.deckname, m.decktype, m.run
PUBLIC m.mini, m.max, m.r_nonland, m.r_restrict, m.r_banned
PUBLIC m.fseries, m.ftype, m.fcolor, m.fartist, m.fhave, m.fwant, m.frestrict
PUBLIC m.frarity, m.fcost, m.rcost, m.lsystem, m.esystem, m.ssystem, m.fdeck, m.ctype
PUBLIC m.usystem, m.asystem, m.csystem, m.isystem, m.psystem, m.dsystem, m.bsystem, m.rtsystem
PUBLIC m.pnsystem, m.fchanged, m.susystem, m.zsystem, m.rcsystem, m.rdsystem, m.eksystem
PUBLIC m.r1system, m.r2system, m.r3system, m.r4system, m.r5system
PUBLIC a_series(1), b_series(1), a_type(1), a_color(1), a_artist(1), a_dealer(1)
PUBLIC m.ussystem
DO checkdbf
DO "opening.spr"
m.ddversion = ""
IF FILE("VERSION.DDW")
	RESTORE FROM ("version.ddw") ADDITIVE
ENDIF
IF m.ddversion <> tempver
	IF m.ddversion <> ""
		WAIT WINDOW TIMEOUT 3 "Updating from Ver " + m.ddversion + " to Ver " + tempver
	ELSE
		WAIT WINDOW TIMEOUT 3 "Setting up Ver. " + m.tempver
	ENDIF
	WAIT WINDOW NOWAIT "Please Wait"
	m.ddversion = tempver
	ERASE "daemon1.ddx"
	ERASE "daemon2.ddx"
	ERASE "daemon3.ddx"
	ERASE "daemon4.ddx"
	ERASE "daemon5.ddx"
	ERASE "daemon6.ddx"
	ERASE "daemon7.ddx"
	ERASE "daemon8.ddx"
	ERASE "daemonq.ddw"
	ERASE "daemonr.ddw"
ENDIF
DO setvars
m.run = 1
IF m.run <> 10
	DO checkit
	USE IN 0 "daemon1.ddw" ALIAS cards INDEX "daemon1.ddx"
	IF BOF() AND EOF()
		DO startup
	ELSE
		IF m.susystem
			WAIT WINDOW TIMEOUT 5 "HIT ANY KEY"
		ELSE
			RELEASE WINDOW "OPEN"
		ENDIF
	ENDIF
	SET ORDER TO ("USER")
	m.runrec = 0
	GO TOP
	DO setup
	DO keys
	DO WHILE NOT m.run = 10
		DO showall
		DO CASE
			CASE m.run = 1
				SELECT cards
				SET ORDER TO ("USER")
				IF NOT EMPTY(m.runrec)
					GO m.runrec
				ENDIF
				DO "menu.mpr"
				DO "list.prg"
				m.runrec = RECNO()
			CASE m.run = 2
				DO "build.mpr"
				DO "builder.prg"
			CASE m.run = 3
				DO "builder.prg"
		ENDCASE
		IF USED("daemon8")
			SELECT "daemon8"
			USE
			SELECT cards
		ENDIF
		CLEAR READ ALL
	ENDDO
ENDIF
DO exiter
