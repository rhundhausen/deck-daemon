* SORTBY.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SORTBY.FXP, compiled 1995-03-18 14:20).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

PRIVATE m.currarea, m.talkstat, m.compstat
IF SET("TALK") = "ON"
	SET TALK OFF
	m.talkstat = "ON"
ELSE
	m.talkstat = "OFF"
ENDIF
m.compstat = SET("COMPATIBLE")
SET COMPATIBLE OFF
m.rborder = SET("READBORDER")
SET READBORDER ON
IF NOT WEXIST("sortby") OR UPPER(WTITLE("SORTBY")) == "SORTBY.PJX" OR UPPER(WTITLE("SORTBY")) == "SORTBY.SCX" OR UPPER(WTITLE("SORTBY")) == "SORTBY.MNX" OR UPPER(WTITLE("SORTBY")) == "SORTBY.PRG" OR UPPER(WTITLE("SORTBY")) == "SORTBY.FRX" OR UPPER(WTITLE("SORTBY")) == "SORTBY.QPR"
	DEFINE WINDOW sortby AT 0.000, 0.000 SIZE 13.923, 38.800 FONT "MS Sans Serif", 8 FLOAT OF TITLE "Sort Defaults" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW sortby CENTER
ENDIF
m.sortby = 1
IF WVISIBLE("sortby")
	ACTIVATE WINDOW sortby SAME
ELSE
	ACTIVATE WINDOW sortby NOSHOW
ENDIF
@ 11.154, 16.400 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.615, 5.000, 0.667 PICTURE "@*HN OK" VALID _qym0uqav4()
@ 0.769, 13.200 GET m.sortby DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.308, 10.333, 0.308 PICTURE "@*RVN \<Series;\<Card;C\<olor;\<Type;\Artist;C\<ost"
IF NOT WVISIBLE("sortby")
	ACTIVATE WINDOW sortby
ENDIF
READ CYCLE DEACTIVATE _qym0uqayi()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW sortby
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE _qym0uqav4
DO CASE
	CASE m.sortby == 1
		a_button(1) = "Series"
		a_button(2) = "Color"
		a_button(3) = "Type"
		a_button(4) = "Card Name"
	CASE m.sortby == 2
		a_button(1) = "Card Name"
		a_button(2) = "Series"
		a_button(3) = "Color"
		a_button(4) = "Type"
	CASE m.sortby == 3
		a_button(1) = "Color"
		a_button(2) = "Series"
		a_button(3) = "Type"
		a_button(4) = "Card Name"
	CASE m.sortby == 4
		a_button(1) = "Type"
		a_button(2) = "Series"
		a_button(3) = "Color"
		a_button(4) = "Card Name"
	CASE m.sortby == 5
		a_button(1) = "Artist"
		a_button(2) = "Series"
		a_button(3) = "Color"
		a_button(4) = "Card Name"
	CASE m.sortby == 6
		a_button(1) = "Casting C."
		a_button(2) = "Series"
		a_button(3) = "Color"
		a_button(4) = "Card Name"
ENDCASE
CLEAR READ


PROCEDURE _qym0uqayi
CLEAR READ
