* SYSTEM.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SYSTEM.FXP, compiled 1995-07-05 19:41).
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
IF NOT WEXIST("system") OR UPPER(WTITLE("SYSTEM")) == "SYSTEM.PJX" OR UPPER(WTITLE("SYSTEM")) == "SYSTEM.SCX" OR UPPER(WTITLE("SYSTEM")) == "SYSTEM.MNX" OR UPPER(WTITLE("SYSTEM")) == "SYSTEM.PRG" OR UPPER(WTITLE("SYSTEM")) == "SYSTEM.FRX" OR UPPER(WTITLE("SYSTEM")) == "SYSTEM.QPR"
	DEFINE WINDOW system AT 0.000, 0.000 SIZE 13.063, 89.800 FONT "Times New Roman", 10 STYLE "I" POPUP OF NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW system CENTER
ENDIF
IF NOT WEXIST("_qyg19v03m")
	DEFINE WINDOW _qyg19v03m AT 0.000, 0.000 SIZE 13.063, 89.800 FONT "Times New Roman", 10 STYLE "I" POPUP OF NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qyg19v03m CENTER
ENDIF
IF NOT WEXIST("_qyg19v059")
	DEFINE WINDOW _qyg19v059 AT 0.000, 0.000 SIZE 13.063, 89.800 FONT "Times New Roman", 10 STYLE "I" POPUP OF NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qyg19v059 CENTER
ENDIF
IF NOT WEXIST("_qyg19v08m")
	DEFINE WINDOW _qyg19v08m AT 0.000, 0.000 SIZE 13.063, 89.800 FONT "Times New Roman", 10 STYLE "I" POPUP OF NOGROW NOZOOM    && ? decompiler guessed a keyword on this line
	MOVE WINDOW _qyg19v08m CENTER
ENDIF
m.italic = (m.isystem == "I")
USE IN 0 "daemon7.ddw" ALIAS price INDEX "daemon7.ddx" ORDER '"name"'
DEFINE POPUP _qyg19v0du PROMPT PROMPT FIELD price.name NOSHOW
IF WVISIBLE("system")
	ACTIVATE WINDOW system SAME
ELSE
	ACTIVATE WINDOW system NOSHOW
ENDIF
@ 0.000, 67.200 COLOR RGB(0,0,0,192,192,192) TO 1.313, 89.800 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 1.313, 22.600 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 22.400 COLOR RGB(0,0,0,192,192,192) TO 1.313, 45.000 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 44.800 COLOR RGB(0,0,0,192,192,192) TO 1.313, 67.400 STYLE "12" PATTERN 1 PEN 1, 8
@ 1.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 13.063, 89.800 PATTERN 1 PEN 0, 8
@ 1.000, 0.000 COLOR RGB(192,192,192,192,192,192) TO 1.000, 22.600 STYLE "1" PEN 1, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 2.188, 65.800 STYLE "1" PEN 2, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 12.063, 3.000 PEN 2, 8
@ 11.938, 3.000 COLOR RGB(0,0,0,0,0,0) TO 11.938, 65.800 STYLE "1" PEN 2, 8
@ 2.250, 65.400 COLOR RGB(0,0,0,0,0,0) TO 12.063, 65.400 PEN 2, 8
@ 1.063, 22.400 COLOR RGB(255,255,255,255,255,255) TO 1.063, 89.400 STYLE "1" PEN 1, 8
@ 0.250, 0.200 COLOR RGB(255,255,255,255,255,255) TO 13.063, 0.200 PEN 1, 8
@ 0.063, 1.200 COLOR RGB(0,0,0,,,) SAY "User Information" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 23.600 COLOR RGB(0,0,0,,,) SAY "User Settings" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 46.000 COLOR RGB(0,0,0,,,) SAY "Price Guide" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 69.200 COLOR RGB(0,0,0,,,) SAY "System" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 2.000, 84.800 GET screen1 DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 3.200, 0.800 PICTURE "@*IHN " WHEN .F.
@ 3.375, 6.200 SAY "User name" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 5.188, 6.200 SAY "User address" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 7.188, 6.200 SAY "City/ST/Zip" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 3.438, 25.000 COLOR, RGB(,,,192,192,192) GET m.usystem DEFAULT " " FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 36.800 PICTURE "@KT" VALID _qyg19v18m() WHEN _qyg19v169()
@ 5.438, 25.000 GET m.asystem DEFAULT " " FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 36.800 PICTURE "@KT" VALID _qyg19v1ea() WHEN _qyg19v1c4()
@ 7.438, 25.000 GET m.csystem DEFAULT " " FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 36.800 PICTURE "@KT" VALID _qyg19v1jv() WHEN _qyg19v1hp()
@ 9.500, 24.600 COLOR,,,,,,,, RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192) GET m.psystem DEFAULT 0 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.063, 31.000 PICTURE "@*C Print User info. on Reports"
@ 10.500, 72.400 GET m.ok DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.333, 0.667 PICTURE "@*HT \<OK"
@ 0.000, 45.600 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v1pp()
@ 0.000, 23.200 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v1sm()
@ 0.000, 68.000 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v1vp()
IF WVISIBLE("_qyg19v03m")
	ACTIVATE WINDOW _qyg19v03m SAME
ELSE
	ACTIVATE WINDOW _qyg19v03m NOSHOW
ENDIF
@ 0.000, 67.200 COLOR RGB(0,0,0,192,192,192) TO 1.313, 89.800 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 1.313, 22.600 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 22.400 COLOR RGB(0,0,0,192,192,192) TO 1.313, 45.000 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 44.800 COLOR RGB(0,0,0,192,192,192) TO 1.313, 67.400 STYLE "12" PATTERN 1 PEN 1, 8
@ 1.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 13.063, 89.800 PATTERN 1 PEN 0, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 2.188, 65.800 STYLE "1" PEN 2, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 12.063, 3.000 PEN 2, 8
@ 11.938, 3.000 COLOR RGB(0,0,0,0,0,0) TO 11.938, 65.800 STYLE "1" PEN 2, 8
@ 2.250, 65.400 COLOR RGB(0,0,0,0,0,0) TO 12.063, 65.400 PEN 2, 8
@ 1.063, 22.400 COLOR RGB(255,255,255,255,255,255) TO 1.063, 89.400 STYLE "1" PEN 1, 8
@ 0.250, 0.200 COLOR RGB(255,255,255,255,255,255) TO 13.063, 0.200 PEN 1, 8
@ 0.063, 1.200 COLOR RGB(0,0,0,,,) SAY "User Information" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 23.600 COLOR RGB(0,0,0,,,) SAY "User Settings" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 46.000 COLOR RGB(0,0,0,,,) SAY "Price Guide" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 69.200 COLOR RGB(0,0,0,,,) SAY "System" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 1.000, 22.600 COLOR RGB(192,192,192,192,192,192) TO 1.000, 44.800 STYLE "1" PEN 4, 8
@ 1.063, 0.400 COLOR RGB(255,255,255,255,255,255) TO 1.063, 22.600 STYLE "1" PEN 1, 8
@ 2.000, 84.800 GET screen2 DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 3.200, 0.800 PICTURE "@*IHN " WHEN .F.
@ 5.938, 7.800 SAY "Default Price" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 5.375, 6.600 TO 7.750, 40.400 PEN 1, 8
@ 3.750, 8.200 COLOR,,,,,,,, RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192) GET m.lsystem DEFAULT 0 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.063, 19.800 PICTURE "@*C Collector Mode" VALID _qyg19v2kd()
@ 5.938, 27.600 COLOR, RGB(0,0,0,192,192,192) GET m.dsystem DEFAULT 0.050 FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.875, 7.600 RANGE 0, PICTURE "@K$ 99.99" ENABLE 0.05, 0.05, 50.00 VALID _qyg19v2pr() WHEN _qyg19v2nt() MESSAGE "Can't Have Negative Values!"    && ? decompiler guessed a keyword on this line
@ 10.250, 8.000 COLOR,,,,,,,, RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192) GET m.italic DEFAULT 0 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.063, 15.200 PICTURE "@*C Italic Print" VALID _qyg19v2vg()
@ 8.250, 8.000 COLOR,,,,,,,, RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192) GET m.zsystem DEFAULT 0 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.063, 26.000 PICTURE "@*C Graphic Cost Display" VALID _qyg19v2zt()
@ 10.500, 72.400 GET m.ok DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.333, 0.667 PICTURE "@*HT \<OK"
@ 0.000, 45.600 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v349()
@ 0.000, 0.800 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v376()
@ 0.000, 68.000 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v3a9()
@ 9.313, 8.000 COLOR,,,,,,,, RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192) GET m.susystem DEFAULT 0 FONT "Times New Roman", 9 STYLE m.isystem + "T" SIZE 1.063, 28.800 PICTURE "@*C Pause on Start up screen"
IF WVISIBLE("_qyg19v059")
	ACTIVATE WINDOW _qyg19v059 SAME
ELSE
	ACTIVATE WINDOW _qyg19v059 NOSHOW
ENDIF
@ 0.000, 67.200 COLOR RGB(0,0,0,192,192,192) TO 1.313, 89.800 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 1.313, 22.600 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 22.400 COLOR RGB(0,0,0,192,192,192) TO 1.313, 45.000 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 44.800 COLOR RGB(0,0,0,192,192,192) TO 1.313, 67.400 STYLE "12" PATTERN 1 PEN 1, 8
@ 1.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 13.063, 89.800 PATTERN 1 PEN 0, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 2.188, 76.800 STYLE "1" PEN 2, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 12.063, 3.000 PEN 2, 8
@ 11.938, 3.000 COLOR RGB(0,0,0,0,0,0) TO 11.938, 77.000 STYLE "1" PEN 2, 8
@ 2.188, 76.600 COLOR RGB(0,0,0,0,0,0) TO 12.001, 76.600 PEN 2, 8
@ 1.063, 22.000 COLOR RGB(255,255,255,255,255,255) TO 1.063, 89.400 STYLE "1" PEN 1, 8
@ 0.250, 0.200 COLOR RGB(255,255,255,255,255,255) TO 13.063, 0.200 PEN 1, 8
@ 0.063, 1.200 COLOR RGB(0,0,0,,,) SAY "User Information" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 23.600 COLOR RGB(0,0,0,,,) SAY "User Settings" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 46.000 COLOR RGB(0,0,0,,,) SAY "Price Guide" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 69.200 COLOR RGB(0,0,0,,,) SAY "System" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 1.000, 45.000 COLOR RGB(192,192,192,192,192,192) TO 1.000, 67.200 STYLE "1" PEN 2, 8
@ 1.063, 0.600 COLOR RGB(255,255,255,255,255,255) TO 1.063, 23.200 STYLE "1" PEN 1, 8
@ 3.875, 55.400 SAY "Mint" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 5.375, 50.000 SAY "Near Mint" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 6.875, 55.600 SAY "Fine" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 8.438, 55.200 SAY "Good" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 9.813, 55.200 SAY "Poor" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 3.500, 49.000 TO 11.313, 75.600 PEN 1, 8
@ 2.563, 52.000 SAY "Value Calculations" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 4.000, 63.600 SAY "%" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 5.250, 63.600 SAY "%" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 6.750, 63.600 SAY "%" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 8.250, 63.600 SAY "%" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 9.750, 63.600 SAY "%" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 2.000, 84.800 GET screen3 DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 3.200, 0.800 PICTURE "@*IHN " WHEN .F.
@ 2.750,8.800 GET m.rchoose  PICTURE "@&N"  POPUP _qyg19v0du  SIZE 4.500,32.600  DEFAULT " "  FONT "Times New Roman", 10  STYLE m.isystem +"T"  VALID _qyg19v48t()  COLOR RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192)
@ 10.250, 4.800 GET m.rbut DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 11.167, 0.667 PICTURE "@*HN \<Select;\<Delete;Hi Price" VALID _qyg19v4cd()
@ 9.063, 8.800 COLOR,,,,,,,, RGB(0,0,0,192,192,192),RGB(0,0,0,192,192,192) GET m.rdsystem DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "BT" SIZE 1.308, 28.000 PICTURE "@*C Display Price Information" VALID _qyg19v4mb() WHEN NOT EOF("price")
@ 3.938, 62.400 COLOR, RGB(0,0,0,192,192,192) GET m.r1system DEFAULT 5.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 4.400 RANGE 5, 250 PICTURE "@K 999" ENABLE 1.000, 5, 250 VALID _qyg19v4rj() WHEN _qyg19v4pk() MESSAGE "Value is out of range!"    && ? decompiler guessed a keyword on this line
@ 5.438, 62.400 COLOR, RGB(0,0,0,192,192,192) GET m.r2system DEFAULT 5.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 4.400 RANGE 5, 250 PICTURE "@K 999" ENABLE 1.000, 5, 250 VALID _qyg19v4xw() WHEN _qyg19v4vx() MESSAGE "Value is out of range!"    && ? decompiler guessed a keyword on this line
@ 6.938, 62.400 COLOR, RGB(0,0,0,192,192,192) GET m.r3system DEFAULT 5.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 4.400 RANGE 5, 250 PICTURE "@K 999" ENABLE 1.000, 5, 250 VALID _qyg19v53c() WHEN _qyg19v51d() MESSAGE "Value is out of range!"    && ? decompiler guessed a keyword on this line
@ 8.438, 62.400 COLOR, RGB(0,0,0,192,192,192) GET m.r4system DEFAULT 5.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 4.400 RANGE 5, 250 PICTURE "@K 999" ENABLE 1.000, 5, 250 VALID _qyg19v58r() WHEN _qyg19v56u() MESSAGE "Value is out of range!"    && ? decompiler guessed a keyword on this line
@ 9.938, 62.400 COLOR, RGB(0,0,0,192,192,192) GET m.r5system DEFAULT 5.000 FONT "Times New Roman", 10 STYLE m.isystem + "T" SIZE 0.875, 4.400 RANGE 5, 250 PICTURE "@K 999" ENABLE 1.000, 5, 250 VALID _qyg19v5e8() WHEN _qyg19v5c9() MESSAGE "Value is out of range!"    && ? decompiler guessed a keyword on this line
@ 7.750, 9.200 COLOR RGB(0,0,0,192,192,192) SAY m.pnsystem FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 32.000
@ 10.500, 77.600 GET m.ok DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.333, 0.667 PICTURE "@*HT \<OK"
@ 0.000, 0.800 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v5ju()
@ 0.000, 23.200 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v5ms()
@ 0.000, 68.000 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v5pu()
IF WVISIBLE("_qyg19v08m")
	ACTIVATE WINDOW _qyg19v08m SAME
ELSE
	ACTIVATE WINDOW _qyg19v08m NOSHOW
ENDIF
@ 0.000, 67.200 COLOR RGB(0,0,0,192,192,192) TO 1.313, 89.800 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 1.313, 22.600 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 22.400 COLOR RGB(0,0,0,192,192,192) TO 1.313, 45.000 STYLE "12" PATTERN 1 PEN 1, 8
@ 0.000, 44.800 COLOR RGB(,,,192,192,192) TO 1.313, 67.400 STYLE "12" PATTERN 1 PEN 1, 8
@ 1.000, 0.000 COLOR RGB(0,0,0,192,192,192) TO 13.063, 89.800 PATTERN 1 PEN 0, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 2.188, 65.800 STYLE "1" PEN 2, 8
@ 2.188, 3.000 COLOR RGB(255,255,255,255,255,255) TO 12.063, 3.000 PEN 2, 8
@ 11.938, 3.000 COLOR RGB(0,0,0,0,0,0) TO 11.938, 65.800 STYLE "1" PEN 2, 8
@ 2.250, 65.400 COLOR RGB(0,0,0,0,0,0) TO 12.063, 65.400 PEN 2, 8
@ 1.063, 22.000 COLOR RGB(255,255,255,255,255,255) TO 1.063, 89.400 STYLE "1" PEN 1, 8
@ 0.250, 0.200 COLOR RGB(255,255,255,255,255,255) TO 13.063, 0.200 PEN 1, 8
@ 0.063, 1.200 COLOR RGB(0,0,0,,,) SAY "User Information" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 23.600 COLOR RGB(0,0,0,,,) SAY "User Settings" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 46.000 COLOR RGB(0,0,0,,,) SAY "Price Guide" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 0.063, 69.200 COLOR RGB(0,0,0,,,) SAY "System" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 1.000, 67.400 COLOR RGB(192,192,192,192,192,192) TO 1.000, 89.600 STYLE "1" PEN 2, 8
@ 1.063, 0.600 COLOR RGB(255,255,255,255,255,255) TO 1.063, 22.400 STYLE "1" PEN 1, 8
@ 3.125, 6.000 TO 11.688, 19.000 PEN 1, 8
@ 2.313, 5.600 SAY "Maintenance" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 3.125, 25.200 TO 7.438, 42.200 PEN 1, 8
@ 2.313, 29.400 COLOR RGB(0,0,0,,,) SAY "Trivia" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 3.125, 45.000 TO 9.313, 62.800 PEN 1, 8
@ 2.313, 49.400 SAY "Updates" FONT "Times New Roman", 10 STYLE m.isystem + "T"
@ 2.000, 84.800 GET screen4 DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 3.200, 0.800 PICTURE "@*IHN " WHEN .F.
@ 3.625, 26.800 GET m.btrivia DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 10.500, 0.308 PICTURE "@*VN \<Cards;C\<ollector" VALID _qyg19v6ht()
@ 9.875, 40.400 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 19.500, 0.667 PICTURE "@*HN \<Rebuild Data Files" VALID _qyg19v6lt()
@ 3.313, 7.400 GET m.maint DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 8.333, 0.308 PICTURE "@*VN Ser\<ies;\<Type;Co\<lor;\<Artist;\<Dealer" VALID _qyg19v6pk()
@ 3.750, 49.000 GET m.but DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 8.167, 0.308 PICTURE "@*VN Card\<s;D\<ecks;\<Prices" VALID _qyg19v6wx()
@ 10.500, 72.400 GET m.ok DEFAULT 1 FONT "MS Sans Serif", 8 STYLE "B" SIZE 1.769, 9.333, 0.667 PICTURE "@*HT \<OK"
@ 0.000, 23.200 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v71t()
@ 0.000, 0.800 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v74u()
@ 0.000, 45.600 GET m.but DEFAULT 0 FONT "Times New Roman", 10 STYLE m.isystem SIZE 1.000, 21.000, 0.800 PICTURE "@*IHN " WHEN _qyg19v78e()
IF NOT WVISIBLE("_qyg19v08m")
	ACTIVATE WINDOW _qyg19v08m
ENDIF
IF NOT WVISIBLE("_qyg19v059")
	ACTIVATE WINDOW _qyg19v059
ENDIF
IF NOT WVISIBLE("_qyg19v03m")
	ACTIVATE WINDOW _qyg19v03m
ENDIF
IF NOT WVISIBLE("system")
	ACTIVATE WINDOW system
ENDIF
READ CYCLE SHOW _qyg19v7c9() WHEN _qyg19v7c5() MODAL WITH user, settings, price, system    && ? decompiler guessed a keyword on this line
RELEASE WINDOW _qyg19v03m
RELEASE WINDOW _qyg19v059
RELEASE WINDOW _qyg19v08m
RELEASE WINDOW system
RELEASE POPUP _qyg19v0du
SET READBORDER &rborder
IF m.talkstat = "ON"
	SET TALK ON
ENDIF
IF m.compstat = "ON"
	SET COMPATIBLE ON
ENDIF
SAVE TO "daemonq.ddw" ALL LIKE "?system"
SAVE TO "daemonr.ddw" ALL LIKE "??system"
SELECT price
USE
SELECT cards


PROCEDURE _qyg19v169
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v18m
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v1c4
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v1ea
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v1hp
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v1jv
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v1pp
_CUROBJ = OBJNUM(screen3)


PROCEDURE _qyg19v1sm
_CUROBJ = OBJNUM(screen2)


PROCEDURE _qyg19v1vp
_CUROBJ = OBJNUM(screen4)


PROCEDURE _qyg19v2kd
SHOW GETS WINDOW (WONTOP())


PROCEDURE _qyg19v2nt
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v2pr
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v2vg
IF m.italic
	m.isystem = "I"
ELSE
	m.isystem = "N"
ENDIF
m.changed = .T.


PROCEDURE _qyg19v2zt
m.changed = .T.


PROCEDURE _qyg19v349
_CUROBJ = OBJNUM(screen3)


PROCEDURE _qyg19v376
_CUROBJ = OBJNUM(screen1)


PROCEDURE _qyg19v3a9
_CUROBJ = OBJNUM(screen4)


PROCEDURE _qyg19v48t
rcsystem = price.reference
SHOW GETS WINDOW (WONTOP())


PROCEDURE _qyg19v4cd
DO CASE
	CASE m.rbut == 1
		m.pnsystem = price.name
		rcsystem = price.reference
		SHOW GETS WINDOW (WONTOP())
	CASE m.rbut == 2
		IF alertit("Delete " + ALLTRIM(price.name) + "?")    && ? decompiler guessed a keyword on this line
			WAIT WINDOW NOWAIT "Working..."
			IF NOT USED("daemon8")
				USE IN 0 "daemon8.ddw" INDEX "daemon8.ddx"
			ENDIF
			SELECT daemon8
			DELETE ALL FOR daemon8.reference == STR(price.reference, 10)
			PACK
			USE
			SELECT price
			DELETE
			PACK
			WAIT CLEAR
			GO TOP
			SHOW GETS WINDOW (WONTOP())
		ENDIF
	CASE m.rbut == 3
		m.rtsystem = m.rtsystem + 1
		IF m.rtsystem > 3
			m.rtsystem = 1
		ENDIF
		SHOW GETS WINDOW (WONTOP())
ENDCASE


PROCEDURE _qyg19v4mb
SHOW GETS WINDOW (WONTOP())


PROCEDURE _qyg19v4pk
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v4rj
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v4vx
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v4xw
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v51d
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v53c
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v56u
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v58r
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v5c9
SET NEAR ON    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v5e8
SET NEAR OFF    && ? decompiler guessed a keyword on this line


PROCEDURE _qyg19v5ju
_CUROBJ = OBJNUM(screen1)


PROCEDURE _qyg19v5ms
_CUROBJ = OBJNUM(screen2)


PROCEDURE _qyg19v5pu
_CUROBJ = OBJNUM(screen4)


PROCEDURE _qyg19v6ht
IF m.btrivia == 1
	DO "trivia.spr"
ELSE
	DO "collect.spr"
ENDIF


PROCEDURE _qyg19v6lt
DO rebuild
SELECT cards
GO TOP


PROCEDURE _qyg19v6pk
DO CASE
	CASE m.maint == 1
		m.what = "Series"
	CASE m.maint == 2
		m.what = "Type"
	CASE m.maint == 3
		m.what = "Color"
	CASE m.maint == 4
		m.what = "Artist"
	CASE m.maint == 5
		m.what = "Dealer"
		USE IN 0 "daemon5.ddw" ALIAS "dealer" INDEX "daemon5.ddx" ORDER '"dealer"'
		USE IN 0 "daemon6.ddw" ALIAS detail INDEX "daemon6.ddx"
ENDCASE
DO "nedit.prg"
IF m.maint == 5
	SELECT dealer
	USE
	SELECT detail
	USE
	SELECT cards
ENDIF


PROCEDURE _qyg19v6wx
DO import WITH m.but
SELECT cards
GO TOP
SHOW GETS


PROCEDURE _qyg19v71t
_CUROBJ = OBJNUM(screen2)


PROCEDURE _qyg19v74u
_CUROBJ = OBJNUM(screen1)


PROCEDURE _qyg19v78e
_CUROBJ = OBJNUM(screen3)


PROCEDURE _qyg19v7c5
_CUROBJ = OBJNUM(screen1)


PROCEDURE _qyg19v7c9
PRIVATE currwind
STORE WOUTPUT() TO currwind
IF m.lsystem
	SHOW GET m.dsystem ENABLE
	SHOW GET m.ssystem ENABLE
ELSE
	SHOW GET m.dsystem DISABLE
	SHOW GET m.ssystem DISABLE
ENDIF
IF BOF("price") AND EOF("price")
	m.rchoose = 0
	SHOW GET m.r1system DISABLE
	SHOW GET m.r2system DISABLE
	SHOW GET m.r3system DISABLE
	SHOW GET m.r4system DISABLE
	SHOW GET m.r5system DISABLE
	SHOW GET m.rdsystem DISABLE
	SHOW GET m.rchoose DISABLE
	SHOW GET m.rbut DISABLE
ELSE
	IF lsystem
		SHOW GET m.r1system ENABLE
		SHOW GET m.r2system ENABLE
		SHOW GET m.r3system ENABLE
		SHOW GET m.r4system ENABLE
		SHOW GET m.r5system ENABLE
	ELSE
		SHOW GET m.r1system DISABLE
		SHOW GET m.r2system DISABLE
		SHOW GET m.r3system DISABLE
		SHOW GET m.r4system DISABLE
		SHOW GET m.r5system DISABLE
	ENDIF
	SHOW GET m.rdsystem ENABLE
	SHOW GET m.rchoose ENABLE
	SHOW GET m.rbut ENABLE
	DO CASE
		CASE m.rtsystem == 1
			SHOW GET m.rbut, 3 PROMPT "Hi Price"
		CASE m.rtsystem == 2
			SHOW GET m.rbut, 3 PROMPT "Med price"
		CASE m.rtsystem == 3
			SHOW GET m.rbut, 3 PROMPT "Low price"
	ENDCASE
ENDIF
SELECT price
LOCATE FOR price.reference == m.rcsystem
IF FOUND()
	m.pnsystem = price.name
ELSE
	m.pnsystem = "None Selected"
	m.rdsystem = .F.
ENDIF
SELECT cards
rchoose = IIF(EMPTY(m.rcsystem), 0, rcsystem)
IF SYS(2016) = "_QYG19V059" OR SYS(2016) = "*"
	ACTIVATE WINDOW _qyg19v059 SAME
	@ 7.750, 9.200 COLOR RGB(0,0,0,192,192,192) SAY m.pnsystem FONT "Times New Roman", 10 STYLE m.isystem SIZE 0.938, 32.000, 0.000
ENDIF
IF m.lsystem
	SHOW GET m.btrivia, 2 ENABLE
ELSE
	SHOW GET m.btrivia, 2 DISABLE
ENDIF
IF NOT EMPTY(currwind)
	ACTIVATE WINDOW (currwind) SAME
ENDIF
