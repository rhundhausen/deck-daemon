* EDELETE.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module EDELETE.FXP, compiled 1995-04-02 13:31).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.

WAIT WINDOW NOWAIT "Removing all references to " + m.name
DO CASE
	CASE m.what == "Series"
		SELECT cards
		DELETE ALL FOR cards.series == m.short
		SELECT list
		DELETE ALL FOR list.short == m.short
	CASE m.what == "Color"
		SELECT cards
		DELETE ALL FOR cards.color == LEFT(m.name, 5)
		SELECT list
		DELETE ALL FOR list.name == m.name
	CASE m.what == "Type"
		SELECT cards
		DELETE ALL FOR cards.type == m.name
		SELECT list
		DELETE ALL FOR list.name == m.name
	CASE m.what == "Artist"
		SELECT cards
		DELETE ALL FOR cards.artist == m.name
		SELECT list
		DELETE ALL FOR list.name == m.name
	CASE m.what == "Dealer"
		SELECT detail
		DELETE ALL FOR detail.dealer == m.name
		SELECT dealer
		DELETE ALL FOR dealer.dealer == m.name
		SELECT list
		DELETE ALL FOR list.name == m.name
ENDCASE
SELECT cards
PACK
GO TOP
SELECT list
GO TOP
WAIT CLEAR
SHOW GETS
