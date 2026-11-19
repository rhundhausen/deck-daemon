* DECKINFO.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module DECKINFO.FXP, compiled 1994-12-23 05:18).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE deckinfo
PARAMETERS x
DO CASE
	CASE cards.color = "Black"
		m.black = m.black + x
	CASE cards.color = "Blue"
		m.blue = m.blue + x
	CASE cards.color = "Green"
		m.green = m.green + x
	CASE cards.color = "Red"
		m.red = m.red + x
	CASE cards.color = "White"
		m.white = m.white + x
	CASE cards.color = "Gold"
		m.gold = m.gold + x
ENDCASE
temp = LEFT(cards.type, 4)
DO CASE
	CASE temp = "Arti"
		m.artifact = m.artifact + x
	CASE temp = "Ench"
		m.enchant = m.enchant + x
	CASE temp = "Inst"
		m.instant = m.instant + x
	CASE temp = "Inte"
		m.interrupt = m.interrupt + x
	CASE temp = "Land"
		m.land = m.land + x
	CASE temp = "Sorc"
		m.sorcery = m.sorcery + x
	CASE temp = "Summ"
		m.summon = m.summon + x
ENDCASE
DO CASE
	CASE cards.restrictio = "Restricted"
		m.restricted = m.restricted + x
	CASE cards.restrictio = "Banned"
		m.banned = m.banned + x
ENDCASE
m.cards = m.cards + x
