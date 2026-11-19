* VIEWB.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module VIEWB.FXP, compiled 1995-03-23 16:37).
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
PRIVATE m.artist, m.series
x = RAT(",", cards.artist)    && ? decompiler guessed a keyword on this line
IF x <> 0
	y = LEN(cards.artist)
	m.artist = ALLTRIM(RIGHT(cards.artist, y - x - 1)) + " " + ALLTRIM(LEFT(cards.artist, x - 1))    && ? decompiler guessed a keyword on this line
ELSE
	m.artist = cards.artist
ENDIF
x = ASCAN(b_series, cards.series)
IF x <> 0
	m.series = a_series(x)
ELSE
	m.series = ""
ENDIF
SET NEAR OFF    && ? decompiler guessed a keyword on this line
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
@ 0.222, 20.333 COLOR RGB(255,0,0,128,0,0) SAY IIF(NOT cards.restrictio = "Open", cards.restrictio, "") FONT "Times New Roman", 14 STYLE m.isystem SIZE 0.955, 14.250 PICTURE "@I"
@ 7.722, 2.333 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 11 STYLE m.isystem SIZE 5.667, 53.333
@ 7.500, 1.167 TO 13.667, 57.667 PEN 2, 8
@ 14.167, 15.333 COLOR RGB(255,255,0,128,0,0) SAY m.artist FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 29.000 PICTURE "@I"
@ 15.944, 1.167 TO 20.833, 58.334 PEN 2, 8
@ 17.389, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(lsystem OR cards.quantity <> cards.total, IIF(cards.quantity < 1, "", "You have " + ALLTRIM(STR(cards.quantity)) + " available for Decks"), "") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 18.500, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.wanted = 0, "You do not want this card", "You want " + ALLTRIM(STR(cards.wanted)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 0.333, 2.333 COLOR RGB(0,0,128,128,0,0) SAY IIF(cards.cardnumber > 900000, "User: " + TRANSFORM(cards.cardnumber - 900000, "999,999"), TRANSFORM(cards.cardnumber, "999,999")) FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 13.833 PICTURE "@B"
@ 16.278, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.total = 0, "You do not have this card", "You have " + ALLTRIM(STR(cards.total)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 19.611, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(cards.count), "Card not in this Deck", ALLTRIM(STR(cards.count)) + " of this card in Deck") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.333 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 21.278, 27.333 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 5.000, 0.667 PICTURE "@*HT \<OK"
IF NOT WVISIBLE("view")
	ACTIVATE WINDOW view
ENDIF
READ CYCLE SHOW _qyn0zyvaa() DEACTIVATE _qyn0zyva8()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW view
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE _qyn0zyva8
CLEAR READ


PROCEDURE _qyn0zyvaa
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF SYS(2016) = "VIEW" OR SYS(2016) = "*"
	ACTIVATE WINDOW view SAME
	@ 17.389, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(lsystem OR cards.quantity <> cards.total, IIF(cards.quantity < 1, "", "You have " + ALLTRIM(STR(cards.quantity)) + " available for Decks"), "") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	@ 18.500, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.wanted = 0, "You do not want this card", "You want " + ALLTRIM(STR(cards.wanted)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	@ 16.278, 3.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.total = 0, "You do not have this card", "You have " + ALLTRIM(STR(cards.total)) + " of this card") FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 53.167, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
