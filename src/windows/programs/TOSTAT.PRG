* TOSTAT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module TOSTAT.FXP, compiled 1995-03-22 23:13).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

DO sb_updt WITH done, howmany, "Counting Types"
DO othertemp WITH "type", 22
DO sb_updt WITH (done + 10), howmany, "Counting Colors"
DO othertemp WITH "color", 7
DO sb_updt WITH (done + 20), howmany, "Counting Series"
DO othertemp WITH "series", 17
DO sb_updt WITH (done + 30), howmany, "Counting Commonality"
DO othertemp WITH "common", 12
DO sb_updt WITH (done + 40), howmany, "Counting Restrictions"
DO othertemp WITH "restrict", 13
DO sb_close
RETURN


PROCEDURE othertemp
PARAMETERS a_name, size
FOR i = 1 TO ALEN(a_s&a_name,1)ù|
IF a_s&a_name(i,2) != 0ùx
temp = PADR(a_s&a_name(i,1),size)
temp = temp + transform(a_s&a_name(i,2),"999999")
perc = transform(a_s&a_name(i,2)/m.cards*100,"999.9")
temp = temp + PADL(perc, 6) + "% "
t&a_name = t&a_name + 1
DIME a_t&a_name(t&a_name)
a_t&a_name(t&a_name) = temp
SHOW GET t&a_name
ENDIF
ENDFOR
RETURN
