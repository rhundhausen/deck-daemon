* KEYS.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module KEYS.FXP, compiled 1995-06-25 12:00).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE keys
PARAMETERS keyflag
ON KEY
ON KEY LABEL rightmouse DO kfilter WITH PROGRAM()
ON KEY LABEL ctrl+F DO kfilter WITH PROGRAM()
ON KEY LABEL ctrl+A DO showall
ON KEY LABEL ctrl+W *
ON KEY LABEL ctrl+G *
ON KEY LABEL ctrl+END *
ON KEY LABEL esc CLEAR READ
ON KEY LABEL F1 do HELP with wontop()
IF m.run <> 2
	ON KEY LABEL ctrl+home GO TOP IN cards
	ON KEY LABEL ctrl+END GO botton IN cards
	ON KEY LABEL alt+f12 ACTIVATE WINDOW cards
ENDIF
IF m.run = 1
	ON KEY LABEL alt+F5 DO delit WITH PROGRAM()
ENDIF
IF m.run = 3 AND NOT keyflag
	ON KEY LABEL 1 DO ADDIT WITH 1
	ON KEY LABEL 2 DO ADDIT WITH 2
	ON KEY LABEL 3 DO ADDIT WITH 3
	ON KEY LABEL 4 DO ADDIT WITH 4
	ON KEY LABEL 5 DO ADDIT WITH 5
	ON KEY LABEL 6 DO ADDIT WITH 6
	ON KEY LABEL 7 DO ADDIT WITH 7
	ON KEY LABEL 8 DO ADDIT WITH 8
	ON KEY LABEL 9 DO ADDIT WITH 9
	ON KEY LABEL - DO ADDIT WITH -1
	ON KEY LABEL + DO ADDIT WITH 1
	ON KEY LABEL 0 DO ADDIT WITH 999999
ENDIF
IF m.test
	ON KEY LABEL f12 SUSPEND
	ON KEY LABEL f11 SET SYSMENU TO DEFAULT
ENDIF
