* PDISPLAY.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PDISPLAY.FXP, compiled 1995-02-10 00:26).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE pdisplay
PARAMETERS px
temp = "m.abut" + ALLTRIM(STR(px))    && ? decompiler guessed a keyword on this line
SHOW GET &temp,1 PROMPT a_button(px)
RETURN
