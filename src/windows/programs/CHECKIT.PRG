* CHECKIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CHECKIT.FXP, compiled 1995-03-12 16:47).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

old_alias = ALIAS()
IF NOT FILE("daemon1.ddx")
	USE IN 0 ("daemon1.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON card TAG card OF ("daemon1.ddx")
	INDEX ON cardnumber TAG cardnumber OF ("daemon1.ddx") ADDITIVE
	INDEX ON card + series + color + type TAG builder OF ("daemon1.ddx") ADDITIVE
	INDEX ON &ussystem			   TAG USER       OF ("daemon1.ddx") ADDITIVE
	USE
ENDIF
IF NOT FILE("daemon2.ddx")
	USE IN 0 ("daemon2.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON type TAG type OF ("daemon2.DDx")
	INDEX ON short TAG short OF ("daemon2.ddx") ADDITIVE
	INDEX ON name TAG name OF ("daemon2.ddx") ADDITIVE
	USE
ENDIF
IF NOT FILE("daemon3.ddx")
	USE IN 0 ("daemon3.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON deck TAG deck OF ("daemon3.ddx")
	INDEX ON number TAG number OF ("daemon3.ddx") ADDITIVE
	USE
ENDIF
IF NOT FILE("daemon5.ddx")
	USE IN 0 ("daemon5.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON dealer TAG dealer OF ("daemon5.ddx")
	USE
ENDIF
IF NOT FILE("daemon6.ddx")
	USE IN 0 ("daemon6.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON cardnumber TAG cardnumber OF ("daemon6.ddx")
	INDEX ON dealer TAG dealer OF ("daemon6.ddx") ADDITIVE
	USE
ENDIF
IF NOT FILE("daemon7.ddx")
	USE IN 0 ("daemon7.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON name TAG name OF ("daemon7.ddx")
	INDEX ON reference TAG reference OF ("daemon7.ddx") ADDITIVE
	USE
ENDIF
IF NOT FILE("daemon8.ddx")
	USE IN 0 ("daemon8.ddw") AGAIN ALIAS indexer
	SELECT indexer
	INDEX ON reference + STR(cardnumber, 10) TAG lookup OF ("daemon8.ddx")
	USE
ENDIF
IF NOT EMPTY(old_alias)
	SELECT (old_alias)
ENDIF
