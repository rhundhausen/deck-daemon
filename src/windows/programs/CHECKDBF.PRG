* CHECKDBF.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CHECKDBF.FXP, compiled 1995-03-19 23:03).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE checkdbf
flag = .T.
flag = FILE("DAEMON1.DDW") AND flag
flag = FILE("DAEMON2.DDW") AND flag
flag = FILE("DAEMON3.DDW") AND flag
flag = FILE("DAEMON4.DDW") AND flag
flag = FILE("DAEMON5.DDW") AND flag
flag = FILE("DAEMON6.DDW") AND flag
flag = FILE("DAEMON7.DDW") AND flag
flag = FILE("DAEMON8.DDW") AND flag
flag = FILE("DAEMON9.DDW") AND flag
IF flag = .F.
	= errors("STARTUP", 9003, 1)
	DO exiter WITH .T.
ENDIF
temperr = ON("ERROR")
ON ERROR DO inuse
USE "daemon1.ddw" ALIAS "testing"
on error &temperr
SELECT ("testing")
USE
RETURN


PROCEDURE inuse
= errors("Startup", 9007, 1)
DO exiter WITH .T.
