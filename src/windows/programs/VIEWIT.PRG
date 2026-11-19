* VIEWIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module VIEWIT.FXP, compiled 1995-04-02 13:54).
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
IF NOT WEXIST("view") OR UPPER(WTITLE("VIEW")) == "VIEW.PJX" OR UPPER(WTITLE("VIEW")) == "VIEW.SCX" OR UPPER(WTITLE("VIEW")) == "VIEW.MNX" OR UPPER(WTITLE("VIEW")) == "VIEW.PRG" OR UPPER(WTITLE("VIEW")) == "VIEW.FRX" OR UPPER(WTITLE("VIEW")) == "VIEW.QPR"
	DEFINE WINDOW view AT 0.000, 0.000 SIZE 22.778, 59.833 FONT "Times New Roman", 11 STYLE "I" COLOR RGB(,,,128,0,0) FLOAT CLOSE TITLE "Card View" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW view CENTER
ENDIF
IF WVISIBLE("view")
	ACTIVATE WINDOW view SAME
ELSE
	ACTIVATE WINDOW view NOSHOW
ENDIF
@ 1.778, 2.333 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 40.833
@ 0.333, 42.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT zsystem, cards.cost + " ", castcost(0.5, 55, 3)) FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 15.833 PICTURE "@J"
@ 3.111, 2.333 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 26.833
@ 3.111, 47.000 COLOR RGB(255,255,0,128,0,0) SAY cards.color + " " FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 11.333 PICTURE "@J"
@ 4.444, 2.333 COLOR RGB(255,255,0,128,0,0) SAY m.series FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 20.833
@ 4.444, 39.500 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity + " " FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 18.833 PICTURE "@J"
@ 0.222, 20.333 COLOR RGB(255,0,0,128,0,0) SAY IIF(NOT cards.restrictio = "Open", ALLTRIM(cards.restrictio), "") FONT "Times New Roman", 14 STYLE m.isystem SIZE 0.955, 14.250 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 7.333, 2.333 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 11 STYLE m.isystem SIZE 5.667, 53.333
@ 7.111, 1.167 TO 13.278, 57.667 PEN 2, 8
@ 13.500, 15.333 COLOR RGB(255,255,0,128,0,0) SAY m.artist FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 29.000 PICTURE "@I"
@ 15.944, 1.167 TO 20.833, 58.334 PEN 2, 8
@ 18.500, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.wanted = 0, "You do not want this card", "You want " + ALLTRIM(STR(cards.wanted)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 21.111, 5.333 GET m.have DEFAULT 1 FONT "Times New Roman", 11 STYLE m.isystem SIZE 1.444, 4.333, 0.667 PICTURE "@*BHN " + (LOCFILE("hplus.bmp", "BMP|ICO|PCT|ICN", "Where is hplus?")) + ";" + (LOCFILE("hminus.bmp", "BMP|ICO|PCT|ICN", "Where is hminus?")) VALID _qz00r12ib()
@ 21.111, 45.333 GET m.want DEFAULT 1 FONT "Times New Roman", 11 STYLE m.isystem SIZE 1.444, 4.333, 0.667 PICTURE "@*BHN " + (LOCFILE("wplus.bmp", "BMP|ICO|PCT|ICN", "Where is wplus?")) + ";" + (LOCFILE("wminus.bmp", "BMP|ICO|PCT|ICN", "Where is wminus?")) VALID _qz00r12ju()
@ 21.056, 25.833 GET m.but DEFAULT 1 FONT "Times New Roman", 11 STYLE m.isystem SIZE 1.611, 8.833, 0.667 PICTURE "@*HT OK"
@ 0.333, 2.333 COLOR RGB(0,0,128,128,0,0) SAY IIF(cards.cardnumber > 100000, "User: " + TRANSFORM(cards.cardnumber - 1000000, "999,999"), TRANSFORM(cards.cardnumber, "999,999")) FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 13.833 PICTURE "@B"
@ 19.611, 3.167 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.deck < 1, "", "You need " + ALLTRIM(STR(cards.deck)) + " More For Decks") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 16.278, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.total = 0, "You do not have this card", "You have " + ALLTRIM(STR(cards.total)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 14.722, 2.000 COLOR RGB(255,255,0,128,0,0) SAY m.value FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 55.667 PICTURE "@I"
IF NOT WVISIBLE("view")
	ACTIVATE WINDOW view
ENDIF
READ CYCLE SHOW _qz00r12q4() ACTIVATE _qz00r12n2() DEACTIVATE _qz00r12q2()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW view
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE _qz00r12ib
DO haveadd WITH m.have, .T.


PROCEDURE _qz00r12ju
DO CASE
	CASE m.want == 1
		REPLACE cards.wanted WITH cards.wanted + 1
		SHOW GET m.want, 2 ENABLE
	CASE m.want == 2
		REPLACE cards.wanted WITH cards.wanted - 1
		IF cards.wanted = 0
			SHOW GET m.want, 2 DISABLE
		ENDIF
ENDCASE
SHOW GETS OFF WINDOW view


PROCEDURE _qz00r12n2
IF cards.total = 0
	SHOW GET m.have, 2 DISABLE
ENDIF
IF cards.wanted = 0
	SHOW GET m.want, 2 DISABLE
ENDIF


PROCEDURE _qz00r12q2
CLEAR READ


PROCEDURE _qz00r12q4
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF SYS(2016) = "VIEW" OR SYS(2016) = "*"
	ACTIVATE WINDOW view SAME
	@ 18.500, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.wanted = 0, "You do not want this card", "You want " + ALLTRIM(STR(cards.wanted)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	@ 19.611, 3.167 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.deck < 1, "", "You need " + ALLTRIM(STR(cards.deck)) + " More For Decks") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	@ 16.278, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.total = 0, "You do not have this card", "You have " + ALLTRIM(STR(cards.total)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
