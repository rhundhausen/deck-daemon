* TOOLS.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from TOOLS.EXE (module TOOLS.FXP, compiled 1995-02-03 02:35).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

CLEAR ALL
CLOSE ALL
CLEAR
MODIFY WINDOW screen AT 0, 0 SIZE 25, 90 FONT "Times New Roman", 8 STYLE "I" NONE FLOAT CLOSE MINIMIZE TITLE "Daemon Tools" CENTER ICON FILE "daemon.ico"    && ? decompiler guessed a keyword on this line
MOVE WINDOW screen CENTER
SET STATUS BAR OFF
SET SYSMENU OFF
SET TALK OFF
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
DO "tools.spr"
