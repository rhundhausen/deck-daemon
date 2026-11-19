* PCONFIG.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module PCONFIG.FXP, compiled 1995-06-26 22:17).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

DIMENSION a_print(14, 7)
a_print(1, 1) = .F.
a_print(1, 2) = "query.SERIES"
a_print(1, 3) = 7
a_print(1, 4) = ""
a_print(1, 5) = "Series"
a_print(1, 6) = "cards.series"
a_print(1, 7) = "series"
a_print(2, 1) = .F.
a_print(2, 2) = "a_series(ascan(b_series, query.series))"
a_print(2, 3) = 21
a_print(2, 4) = ""
a_print(2, 5) = "Series"
a_print(2, 6) = "cards.series"
a_print(2, 7) = "series"
a_print(3, 1) = .F.
a_print(3, 2) = "query.card"
a_print(3, 3) = 31
a_print(3, 4) = ""
a_print(3, 5) = "Card Name"
a_print(3, 6) = "cards.card"
a_print(3, 7) = "card"
a_print(4, 1) = .F.
a_print(4, 2) = "query.color"
a_print(4, 3) = 6
a_print(4, 4) = ""
a_print(4, 5) = "Color"
a_print(4, 6) = "cards.color"
a_print(4, 7) = "color"
a_print(5, 1) = .F.
a_print(5, 2) = "query.type"
a_print(5, 3) = 21
a_print(5, 4) = ""
a_print(5, 5) = "Type"
a_print(5, 6) = "cards.type"
a_print(5, 7) = "type"
a_print(6, 1) = .F.
a_print(6, 2) = "query.rarity"
a_print(6, 3) = 11
a_print(6, 4) = ""
a_print(6, 5) = "Rarity"
a_print(6, 6) = "cards.rarity"
a_print(6, 7) = "rarity"
a_print(7, 1) = .F.
a_print(7, 2) = "query.restrictio"
a_print(7, 3) = 12
a_print(7, 4) = ""
a_print(7, 5) = "Restriction"
a_print(7, 6) = "cards.restrictio"
a_print(7, 7) = "restrictio"
a_print(8, 1) = .F.
a_print(8, 2) = "query.cost"
a_print(8, 3) = 11
a_print(8, 4) = "Casting"
a_print(8, 5) = "Cost"
a_print(8, 6) = "cards.cost, cards.costtotal"
a_print(8, 7) = "costtotal, cost"
a_print(9, 1) = .F.
a_print(9, 2) = "query.artist"
a_print(9, 3) = 20
a_print(9, 4) = ""
a_print(9, 5) = "Artist"
a_print(9, 6) = "cards.artist"
a_print(9, 7) = "artist"
a_print(10, 1) = .F.
a_print(10, 2) = 'transform(iif(query.total>0,query.total,""),"9,999")'
a_print(10, 3) = -6
a_print(10, 4) = "Cards"
a_print(10, 5) = "Qty"
a_print(10, 6) = "cards.total"
a_print(10, 7) = "total"
a_print(11, 1) = .F.
a_print(11, 2) = 'transform(iif(query.wanted>0,query.wanted,""),"9,999")'
a_print(11, 3) = -6
a_print(11, 4) = "Cards"
a_print(11, 5) = "Wantd"
a_print(11, 6) = "cards.wanted"
a_print(11, 7) = "wanted"
a_print(12, 1) = .F.
a_print(12, 2) = 'transform(iif(query.deck>0,query.deck,""),"9,999")'
a_print(12, 3) = -6
a_print(12, 4) = "Need"
a_print(12, 5) = "Deck"
a_print(12, 6) = "cards.deck"
a_print(12, 7) = "deck"
a_print(13, 1) = .F.
a_print(13, 2) = 'transform(query.price,"$9,999.99")'
a_print(13, 3) = -10
a_print(13, 4) = "Card"
a_print(13, 5) = "Value"
DO CASE
	CASE rtsystem == 1
		a_print(13, 6) = "price.hi as price"
	CASE rtsystem == 2
		a_print(13, 6) = "price.med as price"
	CASE rtsystem == 3
		a_print(13, 6) = "price.low as price"
ENDCASE
a_print(13, 7) = "price"
a_def(1) = "Series Abrv."
a_def(2) = "Series"
a_def(3) = "Card Name"
a_def(4) = "Color"
a_def(5) = "Type"
a_def(6) = "Rarity"
a_def(7) = "Restriction"
a_def(8) = "Casting C."
a_def(9) = "Artist"
a_def(10) = "Quantity"
a_def(11) = "Wanted"
a_def(12) = "Deck"
a_def(13) = "Price"
