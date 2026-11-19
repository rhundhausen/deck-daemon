* SETVARS.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SETVARS.FXP, compiled 1995-07-05 19:45).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE setvars
IF FILE("daemonq.ddw") AND FILE("daemonr.ddw")
	RESTORE FROM ("daemonq.ddw") ADDITIVE
	RESTORE FROM ("daemonr.ddw") ADDITIVE
ELSE
	m.psystem = .T.
	m.usystem = ""
	m.asystem = ""
	m.csystem = ""
	m.isystem = "I"
	m.lsystem = .T.
	m.dsystem = 0.25
	m.ksystem = 0.25
	m.ssystem = 0.10
	m.zsystem = .T.
	m.bsystem = .T.
	m.r1system = 150
	m.r2system = 100
	m.r3system = 80
	m.r4system = 60
	m.r5system = 25
	m.rcsystem = 0
	m.rtsystem = 1
	m.rdsystem = .F.
	m.susystem = .T.
	m.pnsystem = "None Selected"
	m.esystem = "cards.series,cards.type,cards.color,cards.card," + "cards.rarity,cards.restriction,cards.cost,cards.artist," + "cards.total"
	m.ussystem = "series+type+color+card"
	m.eksystem = "Series,Type,Color,Card Name,"
	SAVE TO ("VERSION.DDW") ALL LIKE "ddversion"
ENDIF
