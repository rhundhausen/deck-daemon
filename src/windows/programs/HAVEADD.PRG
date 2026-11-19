* HAVEADD.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module HAVEADD.FXP, compiled 1995-04-11 09:48).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE haveadd
PARAMETERS m.have, m.htest
IF EOF("cards")
	RETURN
ENDIF
IF NOT lsystem
	m.hqty = IIF(m.htest, 1, quick())
ENDIF
DO CASE
	CASE m.have == 1
		IF lsystem
			DO "buy.prg"
		ELSE
			IF cards.quantity + m.hqty > 9000
				?? CHR(7) + CHR(7)
				= errors("Adding Card", 9008, 1)
				RETURN
			ENDIF
			REPLACE cards.quantity WITH cards.quantity + m.hqty
			REPLACE cards.total WITH cards.total + m.hqty
			REPLACE cards.deck WITH cards.deck - m.hqty
			IF cards.wanted > m.hqty
				REPLACE cards.wanted WITH cards.wanted - m.hqty
			ELSE
				REPLACE cards.wanted WITH 0
			ENDIF
		ENDIF
	CASE m.have == 2
		IF lsystem
			DO "sell.prg"
		ELSE
			IF cards.quantity > m.hqty
				REPLACE cards.quantity WITH cards.quantity - m.hqty
			ELSE
				REPLACE cards.quantity WITH 0
			ENDIF
			REPLACE cards.deck WITH cards.deck + m.hqty
			REPLACE cards.total WITH cards.total - m.hqty
		ENDIF
ENDCASE
FLUSH
SHOW GETS OFF
IF m.have == 1
	IF m.htest
		SHOW GET m.have, 2 ENABLE
	ELSE
		SHOW GET m.util, 2 ENABLE
	ENDIF
	IF m.htest AND cards.wanted < 1
		SHOW GET m.want, 2 DISABLE
	ENDIF
ENDIF
IF m.have == 2
	IF cards.total = 0 AND m.htest
		SHOW GET m.have, 2 DISABLE
	ELSE
		SHOW GET m.util, 2 DISABLE
	ENDIF
ENDIF
