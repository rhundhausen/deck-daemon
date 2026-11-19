* CTRIVIA.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module CTRIVIA.FXP, compiled 1995-04-13 01:28).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE ctrivia
DIMENSION a_cdealer(1, 5)
a_cdealer = ""
cdealer = 0
collector = 0
sold = 0
soldd = 0
purchased = 0
purchasedd = 0
smint = 0
smintd = 0
svfine = 0
svfined = 0
sfine = 0
sfined = 0
sused = 0
susedd = 0
svused = 0
svusedd = 0
pmint = 0
pmintd = 0
pvfine = 0
pvfined = 0
pfine = 0
pfined = 0
pused = 0
pusedd = 0
pvused = 0
pvusedd = 0
DO sb_init WITH "Computing Collector Trivia"
SELECT daemon6
SET FILTER TO daemon6.date >= date1 AND daemon6.date <= date2
COUNT TO howmany
done = 0
IF howmany = 0
	DO errormsg WITH "Computing", "No records for dates specified!", 1
	DO sb_close
	RETURN .F.
ENDIF
USE IN 0 "daemon9.ddw" ALIAS "list"
SELECT list
ZAP
SELECT daemon6
GO TOP
DO WHILE NOT EOF("daemon6")
	IF daemon6.sale
		tty = "s"
		sold = sold + quan()
		soldd = soldd + dollars()
	ELSE
		tty = "p"
		purchased = purchased + quan()
		purchasedd = purchasedd + dollars()
	ENDIF
	DO CASE
		CASE daemon6.condition = "Mint"
			&tty.mint = &tty.mint + quan()
			&tty.mintd = &tty.mintd + dollars()
		CASE daemon6.condition = "Near Mint"
			&tty.vfine = &tty.vfine + quan()
			&tty.vfined = &tty.vfined + dollars()
		CASE daemon6.condition = "Fine"
			&tty.fine = &tty.fine + quan()
			&tty.fined = &tty.fined + dollars()
		CASE daemon6.condition = "Good"
			&tty.used = &tty.used + quan()
			&tty.usedd = &tty.usedd + dollars()
		OTHERWISE
			&tty.vused = &tty.vused + quan()
			&tty.vusedd = &tty.vusedd + dollars()
	ENDCASE
	x = ASCAN(a_cdealer, daemon6.dealer)
	IF x = 0
		cdealer = cdealer + 1
		DIMENSION a_cdealer(cdealer, 5)
		a_cdealer(cdealer, 1) = daemon6.dealer
		a_cdealer(cdealer, 2) = 0
		a_cdealer(cdealer, 3) = 0
		a_cdealer(cdealer, 4) = 0
		a_cdealer(cdealer, 5) = 0
		x = cdealer
	ENDIF
	IF daemon6.sale
		a_cdealer(x, 4) = a_cdealer(x, 4) + quan()
		a_cdealer(x, 5) = a_cdealer(x, 5) + dollars()
	ELSE
		a_cdealer(x, 2) = a_cdealer(x, 2) + quan()
		a_cdealer(x, 3) = a_cdealer(x, 3) + dollars()
	ENDIF
	done = done + 1
	DO sb_updt WITH done, howmany
	SKIP
ENDDO
DO sb_close
DO cadd WITH "Mint Cards Purchased     :" + TRANSFORM(pmint, "  99999  ") + TRANSFORM(pmintd, "$ 99999.99")
DO cadd WITH "Mint Cards Sold          :" + TRANSFORM(smint, "  99999  ") + TRANSFORM(smintd, "$ 99999.99")
DO cadd WITH ""
DO cadd WITH "Near Mint Cards Purchased:" + TRANSFORM(pvfine, "  99999  ") + TRANSFORM(pvfined, "$ 99999.99")
DO cadd WITH "Near Mint Cards Sold     :" + TRANSFORM(svfine, "  99999  ") + TRANSFORM(svfined, "$ 99999.99")
DO cadd WITH ""
DO cadd WITH "Fine Cards Purchased     :" + TRANSFORM(pfine, "  99999  ") + TRANSFORM(pfined, "$ 99999.99")
DO cadd WITH "Fine Cards Sold          :" + TRANSFORM(sfine, "  99999  ") + TRANSFORM(sfined, "$ 99999.99")
DO cadd WITH ""
DO cadd WITH "Good Cards Purchased     :" + TRANSFORM(pused, "  99999  ") + TRANSFORM(pusedd, "$ 99999.99")
DO cadd WITH "Good Cards Sold          :" + TRANSFORM(sused, "  99999  ") + TRANSFORM(susedd, "$ 99999.99")
DO cadd WITH ""
DO cadd WITH "Poor Cards Purchased     :" + TRANSFORM(pvused, "  99999  ") + TRANSFORM(pvusedd, "$ 99999.99")
DO cadd WITH "Poor Cards Sold          :" + TRANSFORM(svused, "  99999  ") + TRANSFORM(svusedd, "$ 99999.99")
DO cadd WITH REPLICATE("-", 50)
DO cadd WITH "Total Cards Purchased    :" + TRANSFORM(purchased, " 999999  ") + TRANSFORM(purchasedd, "$ 99999.99")
DO cadd WITH "Total Cards Sold         :" + TRANSFORM(sold, " 999999  ") + TRANSFORM(soldd, "$ 99999.99")
DO cadd WITH ""
DO cadd WITH REPLICATE("-", 50)
FOR x = 1 TO cdealer
	DO cadd WITH a_cdealer(x, 1)
	DO cadd WITH SPACE(20) + "Purchased : " + TRANSFORM(a_cdealer(x, 2), "999999 ") + TRANSFORM(a_cdealer(x, 3), "$ 99999.99")
	DO cadd WITH SPACE(20) + "Sold      : " + TRANSFORM(a_cdealer(x, 4), "999999 ") + TRANSFORM(a_cdealer(x, 5), "$ 99999.99")
ENDFOR
SELECT list
USE
SELECT daemon6
RETURN .T.


PROCEDURE quan
RETURN daemon6.quantity


PROCEDURE dollars
RETURN daemon6.quantity * daemon6.paid


PROCEDURE cadd
PARAMETERS text
SELECT list
APPEND BLANK
REPLACE list.text WITH m.text
SELECT daemon6
collector = collector + 1
DIMENSION a_collecto(collector)
a_collecto(collector) = text
SHOW GETS WINDOW collector
RETURN
