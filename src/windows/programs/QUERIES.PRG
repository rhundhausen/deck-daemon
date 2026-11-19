* QUERIES.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module QUERIES.FXP, compiled 1995-03-06 00:13).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE queries
SELECT c.card, c.cardnumber, a.quantity, a.trade, a.paid, a.worth, a.date, a.dealer, a.guide, a.condition, a.reference FROM cards c, daemon6 a WHERE c.cardnumber = a.cardnumber AND a.sale INTO CURSOR sales
SELECT c.card, c.cardnumber, a.quantity, a.trade, a.paid, a.worth, a.date, a.dealer, a.guide, a.condition, a.reference FROM cards c, daemon6 a WHERE c.cardnumber = a.cardnumber AND NOT a.sale INTO CURSOR purchases
USE IN 0 "daemon9.ddw" ALIAS list
