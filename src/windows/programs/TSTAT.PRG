* TSTAT.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module TSTAT.FXP, compiled 1995-03-19 00:43).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

GO IN cards TOP
DO WHILE NOT EOF()
	IF cards.total > 0
		foundit = foundit + 1
		DO addstats WITH "stype", cards.type
		DO addstats WITH "scolor", cards.color
		DO addstats WITH "scommon", cards.rarity
		DO addstats WITH "sseries", cards.series
		DO addstats WITH "srestrict", cards.restrictio
		IF rcsystem <> 0
			IF SEEK(STR(m.rcsystem, 10) + STR(cards.cardnumber, 10), "daemon8")
				DO CASE
					CASE m.rtsystem = 1
						totprice = totprice + cards.total * daemon8.hi
					CASE m.rtsystem = 2
						totprice = totprice + cards.total * daemon8.med
					CASE m.rtsystem = 3
						totprice = totprice + cards.total * daemon8.low
				ENDCASE
			ELSE
				notfound = notfound + 1
			ENDIF
		ENDIF
	ENDIF
	done = done + 1
	DO sb_updt WITH done, m.howmany
	SKIP
ENDDO


PROCEDURE addstats
PARAMETERS aname, adata
IF aname == "sseries"
	x = ASCAN(b_series, cards.series)
	IF NOT x = 0
		adata = a_series(x)
	ENDIF
ENDIF
x=ASCAN(a_&aname,adata)
IF NOT x = 0
	x=ASUBSCRIPT(a_&aname,x,1)
	a_&aname(x,2)=a_&aname(x,2)+cards.total
	SHOW GET &aname
ENDIF
RETURN
