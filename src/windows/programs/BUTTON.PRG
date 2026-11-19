* BUTTON.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module BUTTON.FXP, compiled 1995-02-10 00:33).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE button
PARAMETERS butnumber
m.item = ""
DO popup WITH 2, 2 + (16.8 * (butnumber - 1))
DO CASE
	CASE m.item = "" OR m.item = "Cancel"
		DO pcheck WITH a_button(butnumber)
	CASE m.item = "Nothing"
		a_button(butnumber) = "-----"
	OTHERWISE
		a_button(butnumber) = m.item
		DO pcheck WITH a_button(butnumber)
ENDCASE
DO pdisplay WITH butnumber
