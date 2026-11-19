* BUILDER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module BUILDER.FXP, compiled 1995-04-11 09:30).
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
IF NOT WEXIST("tool2") OR UPPER(WTITLE("TOOL2")) == "TOOL2.PJX" OR UPPER(WTITLE("TOOL2")) == "TOOL2.SCX" OR UPPER(WTITLE("TOOL2")) == "TOOL2.MNX" OR UPPER(WTITLE("TOOL2")) == "TOOL2.PRG" OR UPPER(WTITLE("TOOL2")) == "TOOL2.FRX" OR UPPER(WTITLE("TOOL2")) == "TOOL2.QPR"
	DEFINE WINDOW tool2 AT 0.000, 0.500 SIZE 3.929, 159.000 FONT "Times New Roman", 8 STYLE "I" POPUP OF NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
ENDIF
IF NOT WEXIST("builder") OR UPPER(WTITLE("BUILDER")) == "BUILDER.PJX" OR UPPER(WTITLE("BUILDER")) == "BUILDER.SCX" OR UPPER(WTITLE("BUILDER")) == "BUILDER.MNX" OR UPPER(WTITLE("BUILDER")) == "BUILDER.PRG" OR UPPER(WTITLE("BUILDER")) == "BUILDER.FRX" OR UPPER(WTITLE("BUILDER")) == "BUILDER.QPR"
	DEFINE WINDOW builder AT 4.000, 0.750 SIZE 27.857, 157.250 FONT "Times New Roman", 8 STYLE "I" POPUP OF NOGROW    && ? decompiler guessed a keyword on this line
ENDIF
IF NOT WEXIST("control") OR UPPER(WTITLE("CONTROL")) == "CONTROL.PJX" OR UPPER(WTITLE("CONTROL")) == "CONTROL.SCX" OR UPPER(WTITLE("CONTROL")) == "CONTROL.MNX" OR UPPER(WTITLE("CONTROL")) == "CONTROL.PRG" OR UPPER(WTITLE("CONTROL")) == "CONTROL.FRX" OR UPPER(WTITLE("CONTROL")) == "CONTROL.QPR"
	DEFINE WINDOW control AT 0.286, 99.750 SIZE 29.000, 21.800 FONT "MS Sans Serif", 8 POPUP OF IN builder NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
ENDIF
size = 1
changed = .F.
m.alpha = ""
IF WVISIBLE("tool2")
	ACTIVATE WINDOW tool2 SAME
ELSE
	ACTIVATE WINDOW tool2 NOSHOW
ENDIF
@ 0.571, 79.000 COLOR RGB(0,0,128,0,0,128) TO 3.785, 156.250 PATTERN 1 PEN 1, 8
@ 0.000, 0.000 GET m.but DEFAULT 1 FONT "Times New Roman", 8 STYLE m.isystem SIZE 2.714, 9.500, 2.500 PICTURE "@*BHN " + (LOCFILE("exit.bmp", "BMP|ICO|PCT|ICN", "Where is exit?")) + ";" + (LOCFILE("filter.bmp", "BMP|ICO|PCT|ICN", "Where is filter?")) + ";" + (LOCFILE("eye.bmp", "BMP|ICO|PCT|ICN", "Where is eye?")) + ";" + (LOCFILE("zoom.bmp", "BMP|ICO|PCT|ICN", "Where is zoom?")) + ";" + (LOCFILE("binoculr.bmp", "BMP|ICO|PCT|ICN", "Where is binoculr?")) + ";" + (LOCFILE("help.bmp", "BMP|ICO|PCT|ICN", "Where is help?")) VALID _qyh00fz0j()
@ 0.286, 78.000 COLOR RGB(,,,0,255,255) TO 3.500, 155.250 PATTERN 1 PEN 1, 8
@ 0.571, 79.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.card, "Deck Not Chosen") FONT "Times New Roman", 10 STYLE "BI" SIZE 0.941, 28.800
@ 0.643, 117.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.cost, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.500
@ 2.071, 79.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.type, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.750
@ 2.071, 108.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.color, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 8.000 PICTURE "@J"
@ 2.000, 118.250 COLOR RGB(255,0,0,0,255,255) SAY IIF((cards.restrictio = "Open" OR NOT m.run = 3), "", cards.restrictio) FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 10.800 PICTURE "@J"
@ 0.643, 134.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, m.series, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 19.000
@ 2.071, 133.500 COLOR RGB(0,0,128,0,255,255) SAY IIF((cards.count = 0 OR NOT m.run = 3), "", "In Deck: " + ALLTRIM(STR(cards.count))) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 20.000    && ? decompiler guessed a keyword on this line
IF WVISIBLE("builder")
	ACTIVATE WINDOW builder SAME
ELSE
	ACTIVATE WINDOW builder NOSHOW
ENDIF
@ 0.571, 128.000 COLOR RGB(,,,0,0,128) TO 26.071, 157.000 PATTERN 1 PEN 1, 8
@ 0.286, 127.000 COLOR RGB(,,,0,255,255) TO 25.786, 156.000 PATTERN 1 PEN 1, 8
@ 3.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.black FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 4.857, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.blue FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 5.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.green FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 7.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.red FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 8.071, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.white FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 9.143, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.gold FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 11.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.artifact FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 11.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.enchant FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 12.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.instant FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 13.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.interrupt FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 14.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.land FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 15.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.sorcery FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 18.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.restricted FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 20.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.banned FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 21.857, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.cards FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 23.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.deck FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
@ 0.643, 129.500 COLOR RGB(0,0,128,0,255,255) SAY m.deckname FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 25.000
@ 2.214, 134.500 COLOR RGB(0,0,128,0,255,255) SAY m.decktype FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.750
@ 3.929, 127.750 SAY "Black" + CHR(13) + "Blue " + CHR(13) + "Green" + CHR(13) + "Red" + CHR(13) + "White" + CHR(13) + "Gold" + CHR(13) + "" + CHR(13) + "Artifact" + CHR(13) + "Enchant" + CHR(13) + "Instant" + CHR(13) + "Interrupt" + CHR(13) + "Land" + CHR(13) + "Sorcery" + CHR(13) + "Summon" + CHR(13) + "" + CHR(13) + "Restricted" + CHR(13) + "Banned" + CHR(13) + "" + CHR(13) + "Cards" + CHR(13) + "Deck" FONT "Times New Roman", 8 STYLE "IT" SIZE 20.000, 13.500, 0.000
@ 16.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.summon FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000 PICTURE "@TJ"
IF WVISIBLE("control")
	ACTIVATE WINDOW control SAME
ELSE
	ACTIVATE WINDOW control NOSHOW
ENDIF
@ 0.308, 0.800 COLOR RGB(,,,0,0,128) TO 29.000, 21.800 PATTERN 1 PEN 1, 8
@ 0.000, 0.000 COLOR RGB(,,,0,255,255) TO 28.692, 21.000 PATTERN 1 PEN 1, 8
@ 1.231, 0.800 COLOR,,,,,,,, RGB(0,0,128,0,255,255),RGB(0,0,128,0,255,255) GET m.fseries DEFAULT 1 FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.500, 24.250 FROM a_series PICTURE "@^" VALID _qyh00fzce()
@ 4.308, 0.800 COLOR,,,,,,,, RGB(0,0,128,0,255,255),RGB(0,0,128,0,255,255) GET m.ftype DEFAULT 1 FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.500, 24.250 FROM a_type PICTURE "@^" VALID _qyh00fzis()
@ 7.385, 0.800 COLOR,,,,,,,, RGB(0,0,128,0,255,255),RGB(0,0,128,0,255,255) GET m.fcolor DEFAULT 1 FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.500, 24.250 FROM a_color PICTURE "@^" VALID _qyh00fzkb()
@ 0.077, 6.400 SAY "Series" FONT "Times New Roman", 8 STYLE "IT"
@ 3.154, 7.200 SAY "Type" FONT "Times New Roman", 8 STYLE "IT"
@ 6.231, 6.400 SAY "Color" FONT "Times New Roman", 8 STYLE "IT"
@ 14.154, 1.600 GET m.alpha DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 3.000, 0.000 PICTURE "@*HN A;B;C;D;E" VALID _qyh00fzmp()
@ 16.000, 1.600 GET m.alpha DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 3.000, 0.000 PICTURE "@*HN F;G;H;I;J" VALID _qyh00fzo0()
@ 17.846, 1.600 GET m.alpha DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 3.000, 0.000 PICTURE "@*HN K;L;M;N;O" VALID _qyh00fzpb()
@ 19.692, 1.600 GET m.alpha DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 3.000, 0.000 PICTURE "@*HN P;Q;R;S;T" VALID _qyh00fzqo()
@ 21.538, 1.600 GET m.alpha DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 7.500, 0.667 PICTURE "@*HN U to Z" VALID _qyh00fzs5()
@ 23.692, 1.600 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 15.000, 0.667 PICTURE "@*HN \<Show All" VALID _qyh00fzth()
@ 25.846, 4.000 GET m.build DEFAULT 1 FONT "MS Sans Serif", 8 SIZE 2.385, 6.200, 0.800 PICTURE "@*BHN " + (LOCFILE("plus.bmp", "BMP|ICO|PCT|ICN", "Where is plus?")) + ";" + (LOCFILE("minus.bmp", "BMP|ICO|PCT|ICN", "Where is minus?")) VALID _qyh00fzv5()
@ 21.538, 11.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 7.167, 0.667 PICTURE "@*HN Deck" VALID _qyh00fzwp()
@ 11.385, 1.600 GET m.add DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 2.500, 0.000 PICTURE "@*HN 1;2;3;4;5;6" VALID _qyh00fzy4()
IF NOT WVISIBLE("control")
	ACTIVATE WINDOW control
ENDIF
IF NOT WVISIBLE("builder")
	ACTIVATE WINDOW builder
ENDIF
IF NOT WVISIBLE("tool2")
	ACTIVATE WINDOW tool2
ENDIF
READ CYCLE SHOW _qyh00fzzn() ACTIVATE _qyh00fzb5()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW builder
RELEASE WINDOW control
RELEASE WINDOW tool2
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SET FILTER TO
GO TOP
DO keys
RETURN .T.


PROCEDURE showget
SHOW GETS OFF WINDOW tool2
RETURN


PROCEDURE findit
PARAMETERS m.alpha
SELECT cards
SET CLOCK ON    && ? decompiler guessed a keyword on this line
SEEK (m.alpha)
SET CLOCK OFF    && ? decompiler guessed a keyword on this line
SHOW WINDOW SAY cards
RETURN .T.


PROCEDURE display
DEFINE WINDOW feature FROM -0.850, -2.150 TO 30.300, IIF(size == 1, 47.2, 62.2) NONE POPUP MINIMIZE IN "builder" NOSHADOW SKIP    && ? decompiler guessed a keyword on this line
BROWSE NOAPPEND FIELDS cards.card, cards.series, cards.color, cards.type, cards.cost, cards.count, cards.restrictio, cards.rarity FONT "Times New Roman", 9 STYLE m.isystem REST NOEDIT NOMENU NORGRID WINDOW feature NOWAIT TITLE "Cards" IN builder NODELETE WHEN showget()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW feature
MODIFY WINDOW control AT 0.292, IIF(size == 1, 99.750, 129.5) SIZE 29.385, 21.800


PROCEDURE checkbuild
IF m.run = 2
	m.black = 0
	m.blue = 0
	m.green = 0
	m.red = 0
	m.white = 0
	m.gold = 0
	m.artifact = 0
	m.enchant = 0
	m.instant = 0
	m.interrupt = 0
	m.land = 0
	m.sorcery = 0
	m.summon = 0
	m.restricted = 0
	m.banned = 0
	m.decktype = ""
	m.deckname = "Deck Daemon"
	m.deck = 0
	m.cards = 0
	size = 1
	changed = .F.
	m.alpha = ""
	SHOW GETS DISABLE
	DO "prebuild.prg"
	IF m.run = 1
		MOVE WINDOW builder TO -1000, -1000
		MOVE WINDOW tool2 TO -1000, -1000
		CLEAR READ
	ELSE
		DO showall
		IF m.cards > 0
			SET FILTER TO
		ELSE
			WAIT WINDOW NOWAIT "No cards in Deck " + m.deckname
			SET FILTER TO
		ENDIF
		SET ORDER TO '"BUILDER"'
		GO TOP
		SHOW GETS ENABLE
		DO display
		DO keys
	ENDIF
ENDIF


PROCEDURE _qyh00fz0j
DO select2 WITH m.but


PROCEDURE _qyh00fzce
DO setfilter IN "filter.prg"
GO TOP
SHOW GETS
SHOW WINDOW TOP SAY cards
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzis
DO setfilter IN "filter.prg"
GO TOP
SHOW GETS
SHOW WINDOW TOP SAY cards
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzkb
DO setfilter IN "filter.prg"
GO TOP
SHOW GETS
SHOW WINDOW SAY cards
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzmp
DO findit WITH m.alpha
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzo0
DO findit WITH m.alpha
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzpb
DO findit WITH m.alpha
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzqo
DO findit WITH m.alpha
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzs5
DO findit WITH "U"
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzth
DO showall IN "filter.prg"
SHOW WINDOW SAY cards
SHOW GETS
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzv5
IF m.build == 1
	DO addit WITH 1
ELSE
	IF cards.count > 0
		DO addit WITH -1
	ENDIF
ENDIF


PROCEDURE _qyh00fzwp
IF m.cards > 0
	DO "deck.prg"
	SHOW GETS
	SHOW WINDOW SAY ("cards")
	ACTIVATE WINDOW cards
	KEYBOARD "{ALT+F12}"
ENDIF


PROCEDURE _qyh00fzy4
DO addit WITH m.add
ACTIVATE WINDOW cards
KEYBOARD "{ALT+F12}"


PROCEDURE _qyh00fzb5
DO checkbuild


PROCEDURE _qyh00fzzn
PRIVATE currwind
STORE WOUTPUT() TO currwind
x = ASCAN(b_series, cards.series)
IF x <> 0
	m.series = a_series(x)
ELSE
	m.series = ""
ENDIF
IF SYS(2016) = "TOOL2" OR SYS(2016) = "*"
	ACTIVATE WINDOW tool2 SAME
	@ 0.571, 79.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.card, "Deck Not Chosen") FONT "Times New Roman", 10 STYLE "BI" SIZE 0.941, 28.800, 0.000
	@ 0.643, 117.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.cost, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.500, 0.000
	@ 2.071, 79.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.type, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 26.750, 0.000
	@ 2.071, 108.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, cards.color, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 8.000, 0.000 PICTURE "@J"
	@ 2.000, 118.250 COLOR RGB(255,0,0,0,255,255) SAY IIF((cards.restrictio = "Open" OR NOT m.run = 3), "", cards.restrictio) FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 10.800, 0.000 PICTURE "@J"
	@ 0.643, 134.500 COLOR RGB(0,0,128,0,255,255) SAY IIF(m.run = 3, m.series, "") FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 19.000, 0.000
	@ 2.071, 133.500 COLOR RGB(0,0,128,0,255,255) SAY IIF((cards.count = 0 OR NOT m.run = 3), "", "In Deck: " + ALLTRIM(STR(cards.count))) FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 20.000, 0.000    && ? decompiler guessed a keyword on this line
ENDIF
IF SYS(2016) = "BUILDER" OR SYS(2016) = "*"
	ACTIVATE WINDOW builder SAME
	@ 3.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.black FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 4.857, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.blue FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 5.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.green FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 7.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.red FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 8.071, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.white FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 9.143, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.gold FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 11.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.artifact FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 11.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.enchant FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 12.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.instant FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 13.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.interrupt FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 14.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.land FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 15.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.sorcery FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 18.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.restricted FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 20.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.banned FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 21.857, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.cards FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 23.000, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.deck FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
	@ 0.643, 129.500 COLOR RGB(0,0,128,0,255,255) SAY m.deckname FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 25.000, 0.000
	@ 2.214, 134.500 COLOR RGB(0,0,128,0,255,255) SAY m.decktype FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 14.750, 0.000
	@ 16.929, 140.500 COLOR RGB(0,0,128,0,255,255) SAY m.summon FONT "Times New Roman", 8 STYLE m.isystem SIZE 1.000, 6.000, 0.000 PICTURE "@TJ"
ENDIF
IF m.run = 3
	IF cards.count = 0
		SHOW GET m.build, 2 DISABLE
	ELSE
		SHOW GET m.build, 2 ENABLE
	ENDIF
	DO CASE
		CASE NOT (m.cards < m.deck)
			SHOW GET m.build, 1 DISABLE
		CASE (cards.restrictio = "Open")
			DO CASE
				CASE NOT (cards.type = "Land") AND (cards.count < m.r_nonland)
					SHOW GET m.build, 1 ENABLE
				CASE NOT (cards.type = "Land") AND NOT (cards.count < m.r_nonland)
					SHOW GET m.build, 1 DISABLE
				OTHERWISE
					SHOW GET m.build, 1 ENABLE
			ENDCASE
		CASE (cards.restrictio = "Restricted")
			IF cards.count < m.r_restrict
				SHOW GET m.build, 1 ENABLE
			ELSE
				SHOW GET m.build, 1 DISABLE
			ENDIF
		CASE (cards.restrictio = "Banned")
			IF cards.count < m.r_banned
				SHOW GET m.build, 1 ENABLE
			ELSE
				SHOW GET m.build, 1 DISABLE
			ENDIF
	ENDCASE
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
