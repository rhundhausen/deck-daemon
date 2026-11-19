* FILTER.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module FILTER.FXP, compiled 1995-03-23 16:33).
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
IF NOT WEXIST("filter") OR UPPER(WTITLE("FILTER")) == "FILTER.PJX" OR UPPER(WTITLE("FILTER")) == "FILTER.SCX" OR UPPER(WTITLE("FILTER")) == "FILTER.MNX" OR UPPER(WTITLE("FILTER")) == "FILTER.PRG" OR UPPER(WTITLE("FILTER")) == "FILTER.FRX" OR UPPER(WTITLE("FILTER")) == "FILTER.QPR"
	DEFINE WINDOW filter AT 0.000, 0.000 SIZE 21.063, 87.000 FONT "Times New Roman", 10 STYLE "I" FLOAT CLOSE TITLE "Filters" NOGROW ZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW filter CENTER
ENDIF
DO CASE
	CASE m.fcost == "All"
		m.ctype = 1
		m.ctemp = 0
	CASE LEFT(m.fcost, 2) == "<="
		m.ctype = 2
		m.ctemp = VAL(RIGHT(m.fcost, LEN(m.fcost) - 2))
	CASE LEFT(m.fcost, 2) == ">="
		m.ctype = 3
		m.ctemp = VAL(RIGHT(m.fcost, LEN(m.fcost) - 2))
	CASE LEFT(m.fcost, 1) == "="
		m.ctype = 4
		m.ctemp = VAL(RIGHT(m.fcost, LEN(m.fcost) - 2))
ENDCASE
IF WVISIBLE("filter")
	ACTIVATE WINDOW filter SAME
ELSE
	ACTIVATE WINDOW filter NOSHOW
ENDIF
@ 2.250, 7.200 GET m.fseries DEFAULT 1 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.500, 22.600 FROM a_series PICTURE "@^"
@ 2.250, 31.200 GET m.ftype DEFAULT 1 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.500, 24.200 FROM a_type PICTURE "@^"
@ 5.250, 7.200 GET m.fcolor DEFAULT 1 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.500, 14.600 FROM a_color PICTURE "@^"
@ 5.250, 31.200 GET m.fartist DEFAULT 1 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.500, 19.400 FROM a_artist PICTURE "@^"
@ 8.438, 7.200 GET m.fhave DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.063, 29.400, 0.250 PICTURE "@*RVN All;Cards You Have;Cards You Don't Have"
@ 12.813, 41.400 GET m.frestrict DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.063, 16.200, 0.250 PICTURE "@*RVN All;Open;Banned;Restricted"
@ 14.188, 7.200 GET m.fwant DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.063, 29.400, 0.250 PICTURE "@*RVN All;Cards You Want;Cards You Don't Want"
@ 19.000, 47.200 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.769, 30.000, 0.667 PICTURE "@*HN Cle\<ar Filters" VALID _qyr0zexny()
@ 19.000, 8.800 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.769, 14.667, 0.667 PICTURE "@*HT \<Ok;\?\<Cancel" VALID _qyr0zexpa()
@ 1.000, 12.000 SAY "Series" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 1.000, 37.600 SAY "Type" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 4.000, 10.400 SAY "Color" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 4.000, 36.800 SAY "Artist" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 2.938, 67.800 COLOR, RGB(,,,255,255,255) GET m.ctemp DEFAULT 0.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 2.800 RANGE 0, 20 PICTURE "@K 99" ENABLE 1.000, 0, 20 MESSAGE "Casting Cost Out of Range!"    && ? decompiler guessed a keyword on this line
@ 2.250, 56.800 TO 9.563, 85.000 PEN 1, 8
@ 1.000, 63.200 SAY "Casting Cost" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 4.313, 60.000 GET m.ctype DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.063, 23.800, 0.125 PICTURE "@*RVN All;Less or Equal;Greater or Equal;Equal  to" VALID _qyr0zextj() WHEN _qyr0zexsd()
@ 12.875, 65.200 GET m.frarity DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.063, 18.000, 0.250 PICTURE "@*RVN All;Rare;Common;UnCommon"
@ 8.438, 41.400 GET m.fdeck DEFAULT 1 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 1.063, 36.000, 0.250 PICTURE "@*RVN All;Cards Need for Decks;Cards Not Needed for Decks"
IF NOT WVISIBLE("filter")
	ACTIVATE WINDOW filter
ENDIF
READ CYCLE SHOW _qyr0zexvy() ACTIVATE _qyr0zexvu() DEACTIVATE _qyr0zexvw()    && ? decompiler guessed a keyword on this line
RELEASE WINDOW filter
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF


PROCEDURE showall
m.fseries = "All"
m.fcolor = "All"
m.ftype = "All"
m.fartist = "All"
m.fwant = 1
m.fhave = 1
m.frestrict = "All"
m.frarity = "All"
m.fcost = "All"
m.fdeck = 1
SET FILTER TO
GO TOP
fchanged = .T.
SHOW GETS


PROCEDURE setfilter
m.filter = ""
IF NOT m.fseries == "All"
	x = ASCAN(a_series, m.fseries)
	temp = 'series="' + b_series(x) + '"'
	m.filter = setit(m.filter, temp)
ENDIF
IF NOT m.fcolor == "All"
	m.filter = setit(m.filter, 'color="' + m.fcolor + '"')
ENDIF
IF NOT m.fartist == "All"
	m.filter = setit(m.filter, 'artist="' + m.fartist + '"')
ENDIF
IF NOT m.ftype == "All"
	m.filter = setit(m.filter, 'type="' + m.ftype + '"')
ENDIF
IF NOT m.frarity == "All"
	m.filter = setit(m.filter, 'rarity="' + m.frarity + '"')
ENDIF
IF NOT m.frestrict == "All"
	m.filter = setit(m.filter, 'restriction="' + m.frestrict + '"')
ENDIF
IF NOT m.fwant == 1
	IF m.fwant == 2
		m.filter = setit(m.filter, "wanted>0")
	ELSE
		m.filter = setit(m.filter, "wanted=0")
	ENDIF
ENDIF
IF NOT m.fhave == 1
	IF m.fhave == 2
		m.filter = setit(m.filter, "total>0")
	ELSE
		m.filter = setit(m.filter, "total=0")
	ENDIF
ENDIF
IF m.fcost <> "All"
	DO CASE
		CASE m.ctype == 2
			m.fcost = "<=" + TRANSFORM(m.ctemp, "99")
		CASE m.ctype == 3
			m.fcost = ">=" + TRANSFORM(m.ctemp, "99")
		CASE m.ctype == 4
			m.fcost = "=" + TRANSFORM(m.ctemp, "99")
	ENDCASE
	m.filter = setit(m.filter, "costtotal" + m.fcost)
ENDIF
IF m.fdeck <> 1
	IF m.fdeck == 2
		m.filter = setit(m.filter, "deck>0")
	ELSE
		m.filter = setit(m.filter, "deck=0")
	ENDIF
ENDIF
SET FILTER TO &filter
GO TOP
fchanged = .T.
RETURN


PROCEDURE setit
PARAMETERS m.filter, temp
IF EMPTY(filter)
	filter = temp
ELSE
	filter = filter + " and " + temp
ENDIF
RETURN filter


PROCEDURE _qyr0zexny
DO showall


PROCEDURE _qyr0zexpa
IF m.but == 1
	DO setfilter
ENDIF


PROCEDURE _qyr0zexsd
IF m.ctype <> 1
	SHOW GET m.ctemp ENABLE
ELSE
	SHOW GET m.ctemp DISABLE
ENDIF


PROCEDURE _qyr0zextj
IF m.ctype <> 1
	SHOW GET m.ctemp ENABLE
	m.fcost = "Davis Jr."
ELSE
	SHOW GET m.ctemp DISABLE
	m.fcost = "All"
ENDIF


PROCEDURE _qyr0zexvu
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyr0zexvw
CLEAR READ
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyr0zexvy
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF m.fcost = "All"
	SHOW GET m.ctemp, 1 DISABLE
	m.ctype = 1
ELSE
	SHOW GET m.ctemp, 1 ENABLE
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
