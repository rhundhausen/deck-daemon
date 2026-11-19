* PRINTIT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PRINTIT.FXP, compiled 1995-07-05 20:49).
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
IF NOT WEXIST("printit") OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.PJX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.SCX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.MNX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.PRG" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.FRX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.QPR"
	DEFINE WINDOW printit AT 0.000, 0.000 SIZE 12.188, 121.000 FONT "Times New Roman", 9 STYLE "I" FLOAT OF TITLE "Print Setup" NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
	MOVE WINDOW printit CENTER
ENDIF
RELEASE a_print
RELEASE a_button
RELEASE a_def
PUBLIC a_print(1)
PUBLIC a_button(8)
PUBLIC a_def(14)
FOR x = 1 TO 8
	a_button(x) = "-----"
ENDFOR
DO pconfig
m.pfilterold = FILTER("cards")
m.porderold = ORDER("cards")
m.precnoold = RECNO("cards")
SET ORDER TO
totprint = 98
pavail = 98
oldbutton = ""
m.butnumber = 1
header1 = ""
header2 = ""
body = ""
pfilter = FILTER("Cards")
DEFINE POPUP printlist SHADOW NOSHOW
DEFINE BAR 1 OF printlist PROMPT "Series Abrv." SKIP FOR a_print(1, 1) OR pavail < a_print(1, 3)
DEFINE BAR 2 OF printlist PROMPT "Series" SKIP FOR a_print(2, 1) OR pavail < a_print(2, 3)
DEFINE BAR 3 OF printlist PROMPT "Card Name" SKIP FOR a_print(3, 1) OR pavail < a_print(3, 3)
DEFINE BAR 4 OF printlist PROMPT "Color" SKIP FOR a_print(4, 1) OR pavail < a_print(4, 3)
DEFINE BAR 5 OF printlist PROMPT "Type" SKIP FOR a_print(5, 1) OR pavail < a_print(5, 3)
DEFINE BAR 6 OF printlist PROMPT "Rarity" SKIP FOR a_print(6, 1) OR pavail < a_print(6, 3)
DEFINE BAR 7 OF printlist PROMPT "Restriction" SKIP FOR a_print(7, 1) OR pavail < a_print(7, 3)
DEFINE BAR 8 OF printlist PROMPT "Casting C." SKIP FOR a_print(8, 1) OR pavail < a_print(8, 3)
DEFINE BAR 9 OF printlist PROMPT "Artist" SKIP FOR a_print(9, 1) OR pavail < a_print(9, 3)
DEFINE BAR 10 OF printlist PROMPT "Quantity" SKIP FOR a_print(10, 1) OR pavail < ABS(a_print(10, 3))    && ? decompiler guessed a keyword on this line
DEFINE BAR 11 OF printlist PROMPT "Wanted" SKIP FOR a_print(11, 1) OR pavail < ABS(a_print(11, 3))    && ? decompiler guessed a keyword on this line
DEFINE BAR 12 OF printlist PROMPT "Deck" SKIP FOR a_print(12, 1) OR pavail < ABS(a_print(12, 3))    && ? decompiler guessed a keyword on this line
DEFINE BAR 13 OF printlist PROMPT "Price" SKIP FOR a_print(13, 1) OR pavail < ABS(a_print(13, 3)) OR m.rcsystem = 0    && ? decompiler guessed a keyword on this line
DEFINE BAR 14 OF printlist PROMPT "Nothing" SKIP FOR a_button(m.butnumber + 1) <> "-----"
IF WVISIBLE("printit")
	ACTIVATE WINDOW printit SAME
ELSE
	ACTIVATE WINDOW printit NOSHOW
ENDIF
@ 3.938, 1.400 TO 6.438, 119.200 PEN 1, 8
@ 3.000, 1.800 SAY "Print Line :" FONT "Times New Roman", 9 STYLE "IT"
@ 9.188, 38.000 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 18.833, 0.667 PICTURE "@*HN Display to Screen;Print to Printer" VALID _qyg19jpt0()
@ 9.188, 5.200 GET m.bfilter DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 24.333, 0.667 PICTURE "@*HN Not Using Current Filter" VALID _qyg19jpwb()
@ 9.188, 86.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 24.167, 0.667 PICTURE "@*HT \<Cancel"
@ 4.500, 2.400 GET m.abut1 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jq2m()
@ 4.500, 19.200 GET m.abut2 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jq6c() WHEN a_button(1) <> "-----"
@ 4.500, 36.000 GET m.abut3 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jq9x() WHEN a_button(2) <> "-----"
@ 4.500, 52.800 GET m.abut4 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jqdk() WHEN a_button(3) <> "-----"
@ 4.500, 69.600 GET m.abut5 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jqh5() WHEN a_button(4) <> "-----"
@ 4.500, 86.400 GET m.abut6 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jqkq() WHEN a_button(5) <> "-----"
@ 4.500, 103.200 GET m.abut7 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qyg19jqoc() WHEN a_button(6) <> "-----"
@ 0.500, 80.000 GET m.save_btn DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "N" SIZE 1.769, 19.200, 0.667 PICTURE "@*HN Save Default;Load Default" VALID save_defau()
IF NOT WVISIBLE("printit")
	ACTIVATE WINDOW printit
ENDIF
READ CYCLE WHEN _qyg19jqrv() MODAL
RELEASE WINDOW printit
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SET ORDER TO (m.porderold)
IF NOT EMPTY(m.pfilterold)
	SET FILTER TO &pfilterold
ENDIF
GO (m.precnoold)
RELEASE a_print
RELEASE a_button
RELEASE a_def


PROCEDURE predone
PARAMETERS px
FOR j = 1 TO px
	DO pcheck WITH a_button(j)
	DO pdisplay WITH j
ENDFOR
RETURN


PROCEDURE _qyg19jpt0
DO printer WITH m.but


PROCEDURE _qyg19jpwb
IF EMPTY(pfilter)
	pfilter = FILTER("cards")
	SHOW GET m.bfilter, 1 PROMPT "Using Current Filter"
ELSE
	pfilter = ""
	SHOW GET m.bfilter, 1 PROMPT "Not Using Current Filter"
ENDIF


PROCEDURE _qyg19jq2m
DO pcheck WITH a_button(1)
DO button WITH 1


PROCEDURE _qyg19jq6c
DO pcheck WITH a_button(2)
DO button WITH 2


PROCEDURE _qyg19jq9x
DO pcheck WITH a_button(3)
DO button WITH 3


PROCEDURE _qyg19jqdk
DO pcheck WITH a_button(4)
DO button WITH 4


PROCEDURE _qyg19jqh5
DO pcheck WITH a_button(5)
DO button WITH 5


PROCEDURE _qyg19jqkq
DO pcheck WITH a_button(6)
DO button WITH 6


PROCEDURE _qyg19jqoc
DO pcheck WITH a_button(7)
DO button WITH 7


PROCEDURE _qyg19jqrv
IF EMPTY(FILTER("cards"))
	SHOW GET m.bfilter DISABLE
ELSE
	SHOW GET m.bfilter, 1 PROMPT "Using Current Filter"
ENDIF
first = 0
FOR i = 1 TO 4
	second = AT(",", m.eksystem, i)
	a_button(i) = SUBSTR(m.eksystem, first + 1, second - first - 1)
	first = second
ENDFOR
DO predone WITH 4


PROCEDURE save_defau
IF m.save_btn == 1
	SAVE TO ("daemonp.ddw") ALL LIKE "a_button"
ELSE
	IF FILE("daemonp.ddw")
		RESTORE FROM ("daemonp.ddw") ADDITIVE
		DO predone WITH 7
	ELSE
		?? CHR(7)
		WAIT WINDOW TIMEOUT 3 "No Default Saved!"
	ENDIF
ENDIF
RETURN
