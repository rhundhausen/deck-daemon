* OSTAT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module OSTAT.FXP, compiled 1995-01-04 07:00).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

DO othertemp WITH "a_stype"
DO othertemp WITH "a_scolor"
DO othertemp WITH "a_sseries"
DO othertemp WITH "a_scommon"
DO othertemp WITH "a_srestrict"
RETURN


PROCEDURE othertemp
PARAMETERS a_name
FOR i = 1 TO ALEN(&a_name,1)ù 
IF &a_name(i,2) != 0ù
temp = PADR(&a_name(i,1),31)
perc = INT(&a_name(i,2)/m.cards*100)
temp = temp + PADL(ALLTRIM(STR(perc)), 3) + "% "    && ? decompiler guessed a keyword on this line
temp = temp + odds(m.cards,&a_name(i,2))
m.othernum = m.othernum + 1
DIMENSION a_other(m.othernum)
a_other(m.othernum) = temp
SHOW GET othernum
ENDIF
ENDFOR
m.othernum = m.othernum + 1
DIMENSION a_other(m.othernum)
a_other(m.othernum) = REPLICATE("-", 40)
RETURN
