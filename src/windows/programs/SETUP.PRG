* SETUP.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module SETUP.FXP, compiled 1995-03-12 15:54).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE setup
PRIVATE old_alias
old_alias = ALIAS()
USE IN 0 ("DAEMON2.DDW") AGAIN ALIAS type INDEX ("DAEMON2.DDX") ORDER '"NAME"'
SELECT type
SET FILTER TO type = "S"
COUNT TO x
DIMENSION a_series(x + 1, 1)
DIMENSION b_series(x + 1, 1)
COPY TO ARRAY a_series FIELDS type.name ALL
COPY TO ARRAY b_series FIELDS type.short ALL
a_series(x + 1, 1) = "All"
SET FILTER TO type = "C"
COUNT TO x
DIMENSION a_color(x + 1, 1)
COPY TO ARRAY a_color FIELDS type.name ALL
a_color(x + 1, 1) = "All"
SET FILTER TO type = "T"
COUNT TO x
DIMENSION a_type(x + 1, 1)
COPY TO ARRAY a_type FIELDS type.name ALL
a_type(x + 1, 1) = "All"
SET FILTER TO type = "A"
COUNT TO x
DIMENSION a_artist(x + 1, 1)
COPY TO ARRAY a_artist FIELDS type.name ALL
a_artist(x + 1, 1) = "All"
SET FILTER TO type = "D"
COUNT TO x
DIMENSION a_dealer(x + 1, 1)
COPY TO ARRAY a_dealer FIELDS type.name ALL
a_dealer(x + 1, 1) = "New"
USE
IF EMPTY(old_alias)
	SELECT cards
ELSE
	SELECT (old_alias)
ENDIF
