* ERRORS.PRG
* Deck Daemon for Windows, written by Dave Armga for Bard's Quest Software, 1995
* MIT License, see LICENSE at the repository root.
* Decompiled from DAEMON.EXE (module ERRORS.FXP, compiled 1995-04-26 23:52).
* Comments and original layout are not stored in compiled FoxPro code
* and could not be recovered. Lines marked '&& ?' use a keyword the
* decompiler inferred from context; see ../README.md.



PROCEDURE errors
PARAMETERS what, terror, how
IF EMPTY(how)
	how = 1
ENDIF
DO CASE
	CASE terror == 802
		etext = "File Not Found!"
	CASE terror == 804
		etext = "Too Many Files Open"
	CASE terror == 805
		etext = "Access Denied {file locked}"
	CASE terror == 806
		etext = "Invalid File Handle {internal error}"
	CASE terror == 808
		etext = "Out of Memory"
	CASE terror == 825
		etext = "Seek error {internal error}"
	CASE terror == 829
		etext = "Disk Full Error"
	CASE terror == 831
		etext = "Error opening File {internal}"
	CASE terror == 9001
		etext = "Internal Loop Failure"
	CASE terror == 9002
		etext = "Unknown Rebuild Failure"
	CASE terror == 9003
		etext = "Data File(s) Missing, Re-Install"
	CASE terror == 9004
		etext = "No Cards in Database!"
	CASE terror == 9005
		etext = "Undefined Deck Rule!"
	CASE terror == 9006
		etext = "Database Corrupt! Run Rebuild"
	CASE terror == 9007
		etext = "Deck Daemon is already running!"
	CASE terror == 9008
		etext = "This Card Qty Beyond System Capacity!"
	OTHERWISE
		= errormsg(what, "Daemon Panic! {Internal}", 1)
		DO exiter WITH .T.
ENDCASE
RETURN errormsg(what, etext, how)
