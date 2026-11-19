* LIST.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module LIST.FXP, compiled 1995-04-26 00:40).
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
IF NOT WEXIST("list") OR UPPER(WTITLE("LIST")) == "LIST.PJX" OR UPPER(WTITLE("LIST")) == "LIST.SCX" OR UPPER(WTITLE("LIST")) == "LIST.MNX" OR UPPER(WTITLE("LIST")) == "LIST.PRG" OR UPPER(WTITLE("LIST")) == "LIST.FRX" OR UPPER(WTITLE("LIST")) == "LIST.QPR"
	DEFINE WINDOW list AT 3.786, 0.500 SIZE 27.500, 158.250 FONT "Times New Roman", 8 STYLE "I" POPUP OF NOGROW    && ? decompiler guessed a keyword on this line
ENDIF
IF NOT WEXIST("tool1") OR UPPER(WTITLE("TOOL1")) == "TOOL1.PJX" OR UPPER(WTITLE("TOOL1")) == "TOOL1.SCX" OR UPPER(WTITLE("TOOL1")) == "TOOL1.MNX" OR UPPER(WTITLE("TOOL1")) == "TOOL1.PRG" OR UPPER(WTITLE("TOOL1")) == "TOOL1.FRX" OR UPPER(WTITLE("TOOL1")) == "TOOL1.QPR"
	DEFINE WINDOW tool1 AT 0.000, 0.250 SIZE 3.714, 161.500 FONT "Times New Roman", 8 STYLE "I" POPUP OF NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
ENDIF
m.value = ""
m.series = ""
m.artist = ""
m.size = 1
IF WVISIBLE("list")
	ACTIVATE WINDOW list SAME
ELSE
	ACTIVATE WINDOW list NOSHOW
ENDIF
@ 0.429, 101.000 COLOR RGB(,,,0,0,0) TO 23.929, 157.250 STYLE "16" PATTERN 1 PEN 1, 8
@ 0.071, 99.750 COLOR RGB(,,,128,0,0) TO 23.714, 156.500 STYLE "16" PATTERN 1 PEN 2, 8
@ 8.786, 101.750 TO 16.429, 154.500 PEN 2, 8
@ 19.071, 102.000 TO 23.214, 154.250 PEN 1, 8
@ 2.643, 102.500 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 43.000
@ 0.929, 134.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT m.zsystem, cards.cost + " ", castcost(1, 150, 4)) FONT "Times New Roman", 9 STYLE m.isystem SIZE 1.000, 15.750 PICTURE "@J"
@ 4.357, 102.500 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.750
@ 4.357, 141.250 COLOR RGB(255,255,0,128,0,0) SAY cards.color + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 13.500 PICTURE "@J"
@ 6.357, 102.500 COLOR RGB(255,255,0,128,0,0) SAY m.series FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 29.750
@ 6.357, 136.750 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 18.000 PICTURE "@J"
@ 0.643, 102.500 COLOR RGB(255,0,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 13.833
@ 9.214, 103.500 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 49.000
@ 16.714, 115.000 COLOR RGB(255,255,0,128,0,0) SAY m.artist FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 29.500 PICTURE "@I"
@ 19.357, 104.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(cards.total), "You do not have this card", "You have " + ALLTRIM(STR(cards.total)) + " of this card") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 47.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 20.643, 104.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(cards.wanted), "", "You need " + ALLTRIM(STR(cards.wanted)) + " of this card") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 47.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 21.857, 104.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.deck < 1, "", "You need " + ALLTRIM(STR(cards.deck)) + " For Decks") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 47.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
@ 25.000, 149.250 SAY IIF(m.fseries = "All", "", "Series") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 25.000, 141.250 SAY IIF(m.ftype = "All", "", "Type") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 25.000, 133.250 SAY IIF(m.fcolor = "All", "", "Color") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 25.000, 125.250 SAY IIF(m.fartist = "All", "", "Artist") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 25.000, 117.250 SAY IIF(m.frarity = "All", "", "Rarity") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 26.143, 129.250 SAY IIF(m.frestrict = "All", "", "Restrict") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 10.750
@ 26.143, 117.500 SAY IIF(m.fwant = 1, "", "Wanted") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 10.750
@ 25.000, 101.250 SAY IIF(m.fhave = 1, "", "Have") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 25.000, 109.250 SAY IIF(m.fcost = "All", "", "Ccost") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000
@ 17.857, 100.500 COLOR RGB(255,255,0,128,0,0) SAY m.value FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 55.000 PICTURE "@I"
IF WVISIBLE("tool1")
	ACTIVATE WINDOW tool1 SAME
ELSE
	ACTIVATE WINDOW tool1 NOSHOW
ENDIF
@ 0.286, 0.000 GET m.but DEFAULT 1 FONT "Times New Roman", 8 STYLE m.isystem SIZE 2.714, 9.500, 2.500 PICTURE "@*BHN " + (LOCFILE("exit.bmp", "BMP|ICO|PCT|ICN", "Where is exit?")) + ";" + (LOCFILE("build.bmp", "BMP|ICO|PCT|ICN", "Where is build?")) + ";" + (LOCFILE("filter.bmp", "BMP|ICO|PCT|ICN", "Where is filter?")) + ";" + (LOCFILE("eye.bmp", "BMP|ICO|PCT|ICN", "Where is eye?")) + ";" + (LOCFILE("order.bmp", "BMP|ICO|PCT|ICN", "Where is order?")) + ";" + (LOCFILE("point09.bmp", "BMP|ICO|PCT|ICN", "Where is point09?")) + ";" + (LOCFILE("memo.bmp", "BMP|ICO|PCT|ICN", "Where is memo?")) + ";" + (LOCFILE("binoculr.bmp", "BMP|ICO|PCT|ICN", "Where is binoculr?")) + ";" + (LOCFILE("zoom.bmp", "BMP|ICO|PCT|ICN", "Where is zoom?")) + ";" + (LOCFILE("print.bmp", "BMP|ICO|PCT|ICN", "Where is print?")) + ";" + (LOCFILE("pc04.bmp", "BMP|ICO|PCT|ICN", "Where is pc04?")) + ";" + (LOCFILE("help.bmp", "BMP|ICO|PCT|ICN", "Where is help?")) VALID _qyg18cfh9()
@ 0.500, 142.750 GET m.util DEFAULT 1 FONT "Times New Roman", 8 STYLE m.isystem SIZE 2.214, 7.750, 1.000 PICTURE "@*BHN " + (LOCFILE("plus.bmp", "BMP|ICO|PCT|ICN", "Where is plus?")) + ";" + (LOCFILE("minus.bmp", "BMP|ICO|PCT|ICN", "Where is minus?")) VALID _qyg18cfiv()
IF NOT WVISIBLE("tool1")
	ACTIVATE WINDOW tool1
ENDIF
IF NOT WVISIBLE("list")
	ACTIVATE WINDOW list
ENDIF
READ CYCLE SHOW _qyg18cfe1() ACTIVATE _qyg18cfdy() DEACTIVATE _qyg18cfk5() WHEN _qyg18cfdx()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW list
RELEASE WINDOW tool1
SET readborder &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE showget
IF size = 1
	SHOW GETS OFF WINDOW list
ENDIF
RETURN


PROCEDURE display
DEFINE WINDOW feature FROM -1.030, -2.350 TO 30.000, IIF(m.size = 1, 45.6, 75.5) GROW POPUP MINIMIZE IN "list" NOSHADOW SKIP    && ? decompiler guessed a keyword on this line
IF m.size <> 1
	MODIFY WINDOW feature NONE    && ? decompiler guessed a keyword on this line
ENDIF
BROWSE FIELDS &esystem NOAPPEND NOEDIT NORGRID NOWAIT NOMENU REST FONT "Times New Roman",9 STYLE m.isystem TITLE "Cards" WINDOW feature IN WINDOW LIST WHEN showget()
RELEASE WINDOW feature


PROCEDURE _qyg18cfh9
DO select1 WITH m.but


PROCEDURE _qyg18cfiv
DO haveadd WITH m.util
SHOW GETS OFF


PROCEDURE _qyg18cfdx
DO display


PROCEDURE _qyg18cfdy
IF rdsystem
	IF NOT USED("daemon8")
		USE IN 0 "daemon8.ddw" INDEX "daemon8.ddx" ORDER '"lookup"'
	ENDIF
ELSE
	IF USED("daemon8")
		SELECT "daemon8"
		USE
		SELECT cards
	ENDIF
ENDIF
IF WOUTPUT() <> "CARDS"
	ACTIVATE WINDOW cards
	KEYBOARD "{ALT+F12}"
ENDIF


PROCEDURE _qyg18cfk5
RETURN NOT (m.run = 1)


PROCEDURE _qyg18cfe1
PRIVATE currwind
STORE WOUTPUT() TO currwind
x = ASCAN(b_series, cards.series)
IF NOT x = 0
	m.series = a_series(x)
ELSE
	m.series = ""
ENDIF
IF cards.total < 1
	SHOW GET m.util, 2 DISABLE
ELSE
	SHOW GET m.util, 2 ENABLE
ENDIF
x = RAT(",", cards.artist)    && ? decompiler guessed a keyword on this line
IF x <> 0
	y = LEN(cards.artist)
	m.artist = ALLTRIM(RIGHT(cards.artist, y - x - 1)) + " " + ALLTRIM(LEFT(cards.artist, x - 1))    && ? decompiler guessed a keyword on this line
ELSE
	m.artist = cards.artist
ENDIF
IF m.rdsystem
	SELECT daemon8
	IF SEEK(STR(m.rcsystem, 10) + STR(cards.cardnumber, 10))
		m.value = ALLTRIM(m.pnsystem) + " "    && ? decompiler guessed a keyword on this line
		DO CASE
			CASE m.rtsystem == 1
				m.value = m.value + "Hi Price is : $" + ALLTRIM(STR(daemon8.hi, 8, 2))    && ? decompiler guessed a keyword on this line
			CASE m.rtsystem == 2
				m.value = m.value + "Med. Price is : $" + ALLTRIM(STR(daemon8.med, 8, 2))    && ? decompiler guessed a keyword on this line
			CASE m.rtsystem == 3
				m.value = m.value + "Low Price is : $" + ALLTRIM(STR(daemon8.low, 8, 2))    && ? decompiler guessed a keyword on this line
		ENDCASE
	ELSE
		m.value = "Price Not Listed for this card."
	ENDIF
	SELECT cards
ELSE
	m.value = ""
ENDIF
IF SYS(2016) = "LIST" OR SYS(2016) = "*"
	ACTIVATE WINDOW list SAME
	@ 2.643, 102.500 COLOR RGB(255,255,0,128,0,0) SAY cards.card FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 43.000, 0.000
	@ 0.929, 134.000 COLOR RGB(255,255,0,128,0,0) SAY IIF(NOT m.zsystem, cards.cost + " ", castcost(1, 150, 4)) FONT "Times New Roman", 9 STYLE m.isystem SIZE 1.000, 15.750, 0.000 PICTURE "@J"
	@ 4.357, 102.500 COLOR RGB(255,255,0,128,0,0) SAY cards.type FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.750, 0.000
	@ 4.357, 141.250 COLOR RGB(255,255,0,128,0,0) SAY cards.color + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 13.500, 0.000 PICTURE "@J"
	@ 6.357, 102.500 COLOR RGB(255,255,0,128,0,0) SAY m.series FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 29.750, 0.000
	@ 6.357, 136.750 COLOR RGB(255,255,0,128,0,0) SAY cards.rarity + " " FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 18.000, 0.000 PICTURE "@J"
	@ 0.643, 102.500 COLOR RGB(255,0,0,128,0,0) SAY IIF(cards.restrictio = "Open", "", cards.restrictio) FONT "Times New Roman", 11 STYLE m.isystem SIZE 0.944, 13.833, 0.000
	@ 9.214, 103.500 COLOR RGB(255,255,0,128,0,0) SAY cards.descriptio FONT "Times New Roman", 8 STYLE m.isystem SIZE 7.000, 49.000, 0.000
	@ 16.714, 115.000 COLOR RGB(255,255,0,128,0,0) SAY m.artist FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 29.500, 0.000 PICTURE "@I"
	@ 19.357, 104.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(cards.total), "You do not have this card", "You have " + ALLTRIM(STR(cards.total)) + " of this card") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 47.000, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	@ 20.643, 104.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(EMPTY(cards.wanted), "", "You need " + ALLTRIM(STR(cards.wanted)) + " of this card") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 47.000, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	@ 21.857, 104.500 COLOR RGB(255,255,0,128,0,0) SAY IIF(cards.deck < 1, "", "You need " + ALLTRIM(STR(cards.deck)) + " For Decks") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 47.000, 0.000 PICTURE "@I"    && ? decompiler guessed a keyword on this line
	IF m.fchanged
		m.fchanged = .F.
		@ 25.000, 149.250 CLEAR TO 26.000, 156.250
		@ 25.000, 149.250 SAY IIF(m.fseries = "All", "", "Series") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
		@ 25.000, 141.250 CLEAR TO 26.000, 148.250
		@ 25.000, 141.250 SAY IIF(m.ftype = "All", "", "Type") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
		@ 25.000, 133.250 CLEAR TO 26.000, 140.250
		@ 25.000, 133.250 SAY IIF(m.fcolor = "All", "", "Color") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
		@ 25.000, 125.250 CLEAR TO 26.000, 132.250
		@ 25.000, 125.250 SAY IIF(m.fartist = "All", "", "Artist") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
		@ 25.000, 117.250 CLEAR TO 26.000, 124.250
		@ 25.000, 117.250 SAY IIF(m.frarity = "All", "", "Rarity") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
		@ 26.143, 129.250 CLEAR TO 27.143, 140.000
		@ 26.143, 129.250 SAY IIF(m.frestrict = "All", "", "Restrict") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 10.750, 0.000
		@ 26.143, 117.500 CLEAR TO 27.143, 128.250
		@ 26.143, 117.500 SAY IIF(m.fwant = 1, "", "Wanted") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 10.750, 0.000
		@ 25.000, 101.250 CLEAR TO 26.000, 108.250
		@ 25.000, 101.250 SAY IIF(m.fhave = 1, "", "Have") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
		@ 25.000, 109.250 CLEAR TO 26.000, 116.250
		@ 25.000, 109.250 SAY IIF(m.fcost = "All", "", "Ccost") FONT "Times New Roman", 8 STYLE m.isystem + "T" SIZE 1.000, 7.000, 0.000
	ENDIF
	@ 17.857, 100.500 COLOR RGB(255,255,0,128,0,0) SAY m.value FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 55.000, 0.000 PICTURE "@I"
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
