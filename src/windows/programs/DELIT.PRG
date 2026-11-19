* DELIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module DELIT.FXP, compiled 1995-03-18 15:17).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE delit
PARAMETERS delit
IF delit <> "LIST" OR ALIAS() <> "CARDS"
	RETURN
ENDIF
IF alertit("Delete {" + cards.series + "} " + ALLTRIM(cards.card))    && ? decompiler guessed a keyword on this line
	DELETE
	SHOW GETS
ENDIF
