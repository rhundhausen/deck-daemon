* CSTAT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CSTAT.FXP, compiled 1995-03-13 00:45).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

GO IN cards TOP
DO WHILE NOT EOF()
	temp = cards.card + " "
	perc = INT((cards.count / m.cards) * 100)
	temp = temp + PADL(ALLTRIM(STR(perc)), 3) + "% "    && ? decompiler guessed a keyword on this line
	temp = temp + odds(m.cards, cards.count)
	m.cardnum = m.cardnum + 1
	DIMENSION a_cards(m.cardnum, 2)
	a_cards(m.cardnum, 1) = temp
	a_cards(m.cardnum, 2) = RECNO()
	DO addstats WITH "a_stype", cards.type
	DO addstats WITH "a_scolor", cards.color
	DO addstats WITH "a_scommon", cards.rarity
	DO addstats WITH "a_sseries", cards.series
	DO addstats WITH "a_srestrict", cards.restrictio
	SHOW GETS WINDOW (WONTOP())
	SKIP
ENDDO


PROCEDURE addstats
PARAMETERS aname, adata
IF aname == "a_sseries"
	x = ASCAN(b_series, cards.series)
	IF NOT x = 0
		adata = a_series(x)
	ENDIF
ENDIF
x=ASCAN(&aname,adata)
IF NOT x = 0
	x=ASUBSCRIPT(&aname,x,1)
	&aname(x,2)=&aname(x,2)+cards.count
ENDIF
RETURN
