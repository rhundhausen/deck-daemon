* SORT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SORT.FXP, compiled 1995-07-05 19:43).
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
IF NOT WEXIST("PRINTIT") OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.PJX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.SCX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.MNX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.PRG" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.FRX" OR UPPER(WTITLE("PRINTIT")) == "PRINTIT.QPR"
	DEFINE WINDOW printit AT 0.000, 0.000 SIZE 12.125, 72.200 FONT "Times New Roman", 9 STYLE "I" FLOAT OF TITLE "" NOGROW DOUBLE    && ? decompiler guessed a keyword on this line
	MOVE WINDOW printit CENTER
ENDIF
RELEASE a_print
RELEASE a_button
RELEASE a_def
PUBLIC a_print(1)
PUBLIC a_button(4)
PUBLIC a_def(9)
FOR x = 1 TO 4
	a_button(x) = "-----"
ENDFOR
DO sconfig
m.pfilterold = FILTER("cards")
m.porderold = ORDER("cards")
m.precnoold = RECNO("cards")
SET ORDER TO
totprint = 100
pavail = 100
oldbutton = ""
m.butnumber = 1
header1 = ""
header2 = ""
body = ""
pfilter = FILTER("Cards")
DEFINE POPUP printlist SHADOW NOSHOW
DEFINE BAR 1 OF printlist PROMPT a_def(1) SKIP FOR a_print(1, 1)
DEFINE BAR 2 OF printlist PROMPT a_def(2) SKIP FOR a_print(2, 1)
DEFINE BAR 3 OF printlist PROMPT a_def(3) SKIP FOR a_print(3, 1)
DEFINE BAR 4 OF printlist PROMPT a_def(4) SKIP FOR a_print(4, 1)
DEFINE BAR 5 OF printlist PROMPT a_def(5) SKIP FOR a_print(5, 1)
DEFINE BAR 6 OF printlist PROMPT a_def(6) SKIP FOR a_print(6, 1)
DEFINE BAR 7 OF printlist PROMPT a_def(7) SKIP FOR a_print(7, 1)
DEFINE BAR 8 OF printlist PROMPT a_def(8) SKIP FOR a_print(8, 1)
DEFINE BAR 9 OF printlist PROMPT a_def(9) SKIP FOR a_print(9, 1)
IF WVISIBLE("PRINTIT")
	ACTIVATE WINDOW printit SAME
ELSE
	ACTIVATE WINDOW printit NOSHOW
ENDIF
@ 3.938, 1.400 TO 6.438, 69.800 PEN 1, 8
@ 4.500, 2.400 GET m.abut1 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qym0upv3t()
@ 4.500, 19.200 GET m.abut2 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qym0upv5g() WHEN a_button(1) <> "-----"
@ 4.500, 36.000 GET m.abut3 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qym0upv6u() WHEN a_button(2) <> "-----"
@ 4.500, 52.800 GET m.abut4 DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 12.500, 0.667 PICTURE "@*HN -----" VALID _qym0upv85() WHEN a_button(3) <> "-----"
@ 9.750, 15.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 11.167, 0.667 PICTURE "@*HN \<Set Order;\<Defaults;\<Cancel" VALID _qym0upv9h()
@ 0.688, 23.800 SAY "Sort Order" FONT "Times New Roman", 20 STYLE "BIT"
IF NOT WVISIBLE("PRINTIT")
	ACTIVATE WINDOW printit
ENDIF
READ CYCLE WHEN _qym0upve9() MODAL
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


PROCEDURE _qym0upv3t
DO pcheck WITH a_button(1)
DO button WITH 1


PROCEDURE _qym0upv5g
DO pcheck WITH a_button(2)
DO button WITH 2


PROCEDURE _qym0upv6u
DO pcheck WITH a_button(3)
DO button WITH 3


PROCEDURE _qym0upv85
DO pcheck WITH a_button(4)
DO button WITH 4


PROCEDURE _qym0upv9h
DO CASE
	CASE m.but == 1
		WAIT WINDOW NOWAIT "Running Sort..."
		m.eksystem = ""
		m.ussystem = ""
		m.esystem = ""
		FOR i = 1 TO 4
			x = ASCAN(a_def, a_button(i))
			IF x = 0
				= errors("Building Sort", 9001, 1)
				RESTORE FROM ("daemonq.ddw") ADDITIVE
				RESTORE FROM ("daemonr.ddw") ADDITIVE
				RETURN
			ENDIF
			m.eksystem = m.eksystem + a_def(x) + ","
			m.ussystem = m.ussystem + a_print(x, 7) + "+"
			m.esystem = m.esystem + a_print(x, 6) + ","
		ENDFOR
		m.ussystem = LEFT(m.ussystem, LEN(ussystem) - 1)
		FOR i = 1 TO 9
			IF a_print(i, 1) <> .T.
				m.esystem = m.esystem + a_print(i, 6) + ","
			ENDIF
		ENDFOR
		m.esystem = LEFT(m.esystem, LEN(m.esystem) - 1)
		SAVE TO ("daemonq.ddw") ALL LIKE "?SYSTEM"
		SAVE TO ("daemonr.ddw") ALL LIKE "??system"
		DELETE TAG ("USER")
		INDEX ON &ussystem			   TAG USER       OF ("daemon1.ddx") ADDITIVE
		m.fchanged = .T.
		CLEAR READ
	CASE m.but == 2
		DO sortby
		SHOW GET abut1, 1 PROMPT a_button(1)
		SHOW GET abut2, 1 PROMPT a_button(2)
		SHOW GET abut3, 1 PROMPT a_button(3)
		SHOW GET abut4, 1 PROMPT a_button(4)
	CASE m.but == 3
		CLEAR READ
ENDCASE


PROCEDURE _qym0upve9
first = 0
FOR i = 1 TO 4
	second = AT(",", m.eksystem, i)
	a_button(i) = SUBSTR(m.eksystem, first + 1, second - first - 1)
	first = second
ENDFOR
DO predone WITH 4
