/*

Program to asist in reading in Conjure's conversion file
Began     : January  1, 1995
New File  : January  3, 1995 - Conjure #2
New File  : February 7, 1995 - Conjure #3
New File  : April 28, 1995   - Conjure #4
Debuted   : GenghisCon 1995
Completed :
Notes     :

  1. Have not tied in Spellfire, Jyhad, etc. sets to match DDP's SETS.DD0
  2. Spellfire records will drop-off the numeric prefix (1., 2. 3.).
  3. Trek cards do not take into account the 3 x Unlimited prices (as note).
  4. Edge cards note "Beta cards singles have yellow names 1 x Alpha" ?
  5. No card numbers in Spellfire list.
  6. No card numbers in On-The-Edge list.
  7. Legendary Squadron Maintenance Officer in Star of the Guardians need [HR]
  8. All card names that legitimately end with a numeric (like Q and Q2).

To Do     :

  1. Include ARTISTS and COMMENTS and link them to the view program.

Agreed    :

   1. Alpha Unlimited
   2. Beta Unlimited
   3. Change "The Tabernacle at Pendrell Vale" -> "Tabernacle at Pendrell ..."
   4. The new feature to export Scrye on disk ...
      a) Gathers are related magic .SOD files
      b) Places these files in the MAGIC.COD format
      c) Saves as the name SCRYE.COD

*/

#Define CSTRUCT1  "GAME,C  4 0TYPE,C 12 0SERIES,C 15 0CARD,C 40 0STATUS,C 14 0COLOR,C 14 0DAEMON,C 40 0NOTES,C 10 0"
#Define CSTRUCT2  "ARTIST,C  3 0RARITY,C  3 0VALUE,N  8 2TOURNAMENT,C  1 0RAW,C 90 0FOUND,N  2 0REFERENCE,N  5 0"
#Define PSTRUCT1  "GAME,C  4 0SERIES,C 15 0RTYPE,C  1 0CARD,C 40 0COLOR,C  5 0RARITY,C  3 0ARTIST,C  3 0COMMENTS,C  9 0"
#Define PSTRUCT2  "REFERENCE,N  5 0QUANTITY,N  3 0CONJ_ART,C  3 0CONJ_RAR,C  3 0CONJ_VAL,N  8 2CONJ_ADJ,N  8 2"
#Define FSTRUCT1  "GAME,C  4 0SERIES,C 15 0TYPE,C  1 0NAME,C 40 0COLOR,C  5 0ARTIST,C  3 0RARITY,C  3 0"
#Define FSTRUCT2  "REFERENCE,N  5 0SOURCE,C 20 0DAEMON,C 30 0VALUE_LOW,N  8 2VALUE_MED,N  8 2VALUE_HI,N  8 2"
#Define ASTRUCT   "CODE,C  8 0LINE,C 60 0"
#Define NSTRUCT   "CODE,C  8 0LINE,C250 0"

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                             Main Procedure                               */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/


Function MAIN
Local nCONJURE := 4, lDONE := .F., cGAME := "", cPUB := "", cLINE := ""
Local cGAMECODE := "", nTABS := 0, cTYPE := "", aGAMES := {}, cFILE := ""
Local VAL_C2, VAL_C, VAL_U, VAL_R2, VAL_R, cSET := ""

* Check for Databases

IF ! FILE("CONJURE.ASC")
   ERROR("Missing File CONJURE.ASC")
ENDIF
IF ! FILE("DAEMON.DD")
   ERROR("Missing File DAEMON.DD")
ENDIF

* Create New Databases

@ 0,0 CLEAR
SET PRINTER TO OUTPUT.TXT
SET PRINT ON
SET EXACT ON
? "Conjure-on-Disk Conversion Utility                                 Version 1.0b"
? "Copyright 1994, Bard's Quest Software, Inc.                 All Rights Reserved"
?

**

KEYBOARD CHR(13)

**

@ 4,0 SAY "Conjure Number :" GET nCONJURE PICTURE "99" RANGE 2,9
SET CURSOR ON
READ
IF nCONJURE = 0 .OR. LASTKEY() = 27
   @ 0,0 CLEAR
   SET PRINT OFF
   SET PRINTER TO
   ERROR("Invalid Conjure Number Entered")
ENDIF

@ 5,0 SAY ""
? "Start  : " + TIME()
? "Step 1 : Preparing Databases ..... "

* Open and Prepare Databases

CREATEDBF("IMPORT.DBF","LINE,C160 0")
CREATEDBF("CONJURE.DBF",CSTRUCT1 + CSTRUCT2)
CREATEDBF("FINAL.DBF",FSTRUCT1 + FSTRUCT2)
CREATEDBF("ARTISTS.DBF",ASTRUCT)
CREATEDBF("NOTES.DBF",NSTRUCT)
USE IMPORT   NEW EXCLUSIVE ALIAS IMPORT
USE CONJURE  NEW EXCLUSIVE ALIAS CONJURE
USE FINAL    NEW EXCLUSIVE ALIAS FINAL
USE ARTISTS  NEW EXCLUSIVE ALIAS ARTISTS
USE NOTES    NEW EXCLUSIVE ALIAS NOTES
?? "Done"

* Importing ARTISTS.ASC

? "Step 2 : Importing Artists ....... "
IF FILE("ARTISTS.ASC")
   SELECT IMPORT
   ZAP
   APPEND FROM ARTISTS.ASC SDF
   GO TOP
   DO WHILE ! EOF()
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      IF nTABS = 1
         SELECT ARTISTS
         APPEND BLANK
         ARTISTS->CODE := LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         ARTISTS->LINE := cLINE
         SELECT IMPORT
      ENDIF
      SKIP
   ENDDO
ENDIF
?? "Done"

* Importing NOTES.ASC

? "Step 3 : Importing References .... "
IF FILE("NOTES.ASC")
   SELECT NOTES
   APPEND FROM NOTES.ASC SDF
ENDIF
?? "Done"

* Importing and First Pass Fixes

? "Step 4 : Importing Cards ......... "
SELECT IMPORT
ZAP
APPEND FROM CONJURE.ASC SDF
?? "Done"
?

SELECT IMPORT
GO TOP
DO WHILE ! EOF() .AND. ! lDONE
   DO CASE
   CASE EMPTY(LINE)
      * Nothing
   CASE "CARD GAME : "$UPPER(LINE)
      cGAME := FIX(SUBSTR(LINE,13,80))
      DO CASE
      CASE UPPER(cGAME) = "SIMCITY"
         cGAMECODE := "SIMC"
         AADD(aGAMES,"SIMCSimcity                       Mayfair Games, Inc. 1995      SIMCITY.COD")
      CASE UPPER(cGAME) = "BLOOD WARS"
         cGAMECODE := "WARS"
         AADD(aGAMES,"WARSBlood Wars                    TSR, Inc. 1995                BLOODWRS.COD")
      CASE UPPER(cGAME) = "DIXIE"
         cGAMECODE := "DIXI"
         AADD(aGAMES,"DIXIDixie                         Columbia Games, Inc 1994      DIXIE.COD")
      CASE UPPER(cGAME) = "DOOM TROOPER UNLIMITED"
         cGAMECODE := "DTUN"
         AADD(aGAMES,"DTUNDoom Trooper Unlimited        Heartbreaker Hobbies 1994     DOOMUNLM.COD")
      CASE UPPER(cGAME) = "DOOM TROOPER LIMITED"
         cGAMECODE := "DOOM"
         AADD(aGAMES,"DOOMDoom Trooper Limited          Heartbreaker Hobbies 1994     DOOM.COD")
      CASE UPPER(cGAME) = "PROMOTIONAL"
         cGAMECODE := "PROM"
         AADD(aGAMES,"PROMPromotional                   Heartbreaker Hobbies 1995     PROMO.COD")
      CASE UPPER(cGAME) = "INQUISITION"
         cGAMECODE := "INQU"
         AADD(aGAMES,"INQUInquisition                   Heartbreaker Hobbies 1995     INQUIS.COD")
      CASE UPPER(cGAME) = "ECHELONS OF FIRE"
         cGAMECODE := "ECHE"
         AADD(aGAMES,"ECHEEchelons of Fire              Medallion Simulations 1995    ECHEFIRE.COD")
      CASE UPPER(cGAME) = "ECHELONS OF FURY"
         cGAMECODE := "ECHF"
         AADD(aGAMES,"ECHFEchelons of Fury              Medallion Simulations 1995    ECHEFURY.COD")
      CASE UPPER(cGAME) = "FLIGHTS OF FANTASY"
         cGAMECODE := "FANT"
         AADD(aGAMES,"FANTFlights of Fantasy            Destini Productions 1994      FLIGHTS.COD")
      CASE UPPER(cGAME) = "GALACTIC EMPIRES PRIMARY EDITION"
         cTYPE     := ""
         cGAMECODE := "GALA"
         AADD(aGAMES,"GALAGalactic Empires              Companion Games, Inc. 1994    GALACTIC.COD")
      CASE UPPER(cGAME) = "NEW EMPIRES"
         cTYPE     := ""
         cGAMECODE := "NEMP"
         AADD(aGAMES,"NEMPNew Empires                   Companion Games, Inc. 1995    NEWEMP.COD")
      CASE UPPER(cGAME) = "ILLUMINATI: NWO LIMITED"
         cTYPE     := ""
         cGAMECODE := "NWOL"
         AADD(aGAMES,"NWOLIlluminati: N.W.O. Limited    Steve Jackson Games, Inc. 1994NWOLMTD.COD")
      CASE UPPER(cGAME) = "ILLUMINATI: NWO UNLIMITED"
         cTYPE     := ""
         cGAMECODE := "NWOU"
         AADD(aGAMES,"NWOUIlluminati: N.W.O. Unlimited  Steve Jackson Games, Inc. 1994NWOUNLM.COD")
      CASE UPPER(cGAME) = "JYHAD"
         cTYPE     := ""
         cGAMECODE := "JYHD"
         AADD(aGAMES,"JYHDJyhad                         Wizards of the Coast 1994     JYHAD.COD")
      CASE UPPER(cGAME) = "MAGIC:THE GATHERING"
         cTYPE     := ""
         cGAMECODE := "M:TG"
         AADD(aGAMES,"M:TGMagic:The Gathering           Wizards of the Coast 1993     MAGIC.COD")
      CASE UPPER(cGAME) = "ON THE EDGE"
         cTYPE     := ""
         cGAMECODE := "EDGE"
         AADD(aGAMES,"EDGEOn the Edge                   Atlas Games/Trident, Inc. 1994EDGE.COD")
      CASE UPPER(cGAME) = "CUT-UPS PROJECT"
         cTYPE     := ""
         cGAMECODE := "CUTS"
         AADD(aGAMES,"CUTSCut-Ups Project               Atlas Games/Trident, Inc. 1994CUTUPS.COD")
      CASE UPPER(cGAME) = "SPELLFIRE SET 1"
         cTYPE     := "Set 1"
         cGAMECODE := "SPLL"
         AADD(aGAMES,"SPLLSpellFire                     TSR, Inc. 1994                SPLLFIRE.COD")
      CASE UPPER(cGAME) = "STAR OF THE GUARDIANS"
         cTYPE     := ""
         cGAMECODE := "STAR"
         AADD(aGAMES,"STARStar of the Guardians         Mag Force 7, 1995             GUARDIAN.COD")
      CASE UPPER(cGAME) = "STAR TREK : T.N.G. LIMITED"
         cTYPE     := ""
         cGAMECODE := "STLM"
         AADD(aGAMES,"STLMStar Trek : T.N.G. Limited    Decipher, Inc. 1994           TREKLMTD.COD")
      CASE UPPER(cGAME) = "STAR TREK : T.N.G. UNLIMITED"
         cTYPE     := ""
         cGAMECODE := "STUL"
         AADD(aGAMES,"STULStar Trek : T.N.G. Unlimited  Decipher, Inc. 1994           TREKUNLM.COD")
      CASE UPPER(cGAME) = "TOWERS IN TIME"
         cTYPE     := ""
         cGAMECODE := "TIME"
         AADD(aGAMES,"TIMETowers in Time                Thunder Castle Games, Inc 1995TOWERS.COD")
      CASE UPPER(cGAME) = "ULTIMATE COMBAT"
         cTYPE     := ""
         cGAMECODE := "ULTM"
         AADD(aGAMES,"ULTMUltimate Combat               Ultimate Games 1995           ULCOMBAT.COD")
      CASE UPPER(cGAME) = "WYVERN"
         cTYPE     := ""
         cGAMECODE := "WVRN"
         AADD(aGAMES,"WVRNWyvern                        U.S. Game Systems 1994        WYVERN.COD")
      CASE UPPER(cGAME) = "WYVERN/MAGIC"
         lDONE := .T.
      OTHERWISE
         cGAMECODE := cGAME
      ENDCASE
      IF ! lDONE
         ? "   " + RTRIM(cGAME) + SPACE(40-LEN(cGAME))
      ENDIF
   CASE "PUBLISHER : "$UPPER(LINE)
      cPUB  := FIX(SUBSTR(LINE,13,80))
      ?? cPUB
   CASE "CARD SERIES : "$UPPER(LINE)
      cSET  := FIX(SUBSTR(LINE,15,80))
      ? "      " + RTRIM(cSET) + SPACE(37-LEN(cSET))
   CASE "RARITY : "$UPPER(LINE)
      cLINE := FIX(SUBSTR(LINE,10,80))
      nVAL  := EXTRACT(@cLINE)
      DO CASE
      CASE "C2"$cLINE; VAL_C2 := nVAL
      CASE "C"$cLINE;  VAL_C  := nVAL
      CASE "U"$cLINE;  VAL_U  := nVAL
      CASE "R2"$cLINE; VAL_R2 := nVAL
      CASE "R"$cLINE;  VAL_R  := nVAL
      ENDCASE
   CASE "CARD SET : "$UPPER(LINE)
      cLINE := FIX(SUBSTR(LINE,12,80))
    * ? "   SET : " + cLINE
      nVAL  := EXTRACT(@cLINE)
      SELECT CONJURE
      APPEND BLANK
      REPLACE GAME   WITH cGAMECODE
      REPLACE CARD   WITH LTRIM(RTRIM(TFIX(cLINE,.T.)))
      REPLACE TYPE   WITH "Set"
      REPLACE VALUE  WITH nVAL
      IF "POINT SYMBOLS"$UPPER(CARD)
         REPLACE RARITY WITH "C"
      ENDIF
   CASE UPPER(cGAME) = "SIMCITY"
      cLINE := FIX(LINE)
      IF ".00"$cLINE
         nVAL := EXTRACT(@cLINE)
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE CARD   WITH LTRIM(RTRIM(TFIX(cLINE,.F.)))
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH "Company Promo"
         REPLACE VALUE  WITH nVAL
      ELSE
         ? "         " + cLINE
      ENDIF
   CASE UPPER(cGAME) = "BLOOD WARS"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(cLINE) = "BATTLEFIELD"; cTYPE := "Battlefield"
      CASE UPPER(cLINE) = "FATE";        cTYPE := "Fate"
      CASE UPPER(cLINE) = "LEGION";      cTYPE := "Legion"
      CASE UPPER(cLINE) = "WARLORD";     cTYPE := "Warlord"
      OTHERWISE
         IF nTABS = 3
            SELECT CONJURE
            APPEND BLANK
            REPLACE GAME   WITH cGAMECODE
            REPLACE SERIES WITH cTYPE
            REPLACE TYPE   WITH "Card"
            REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE VALUE WITH VAL(cLINE)
         ELSE
            ? "         " + cLINE
         ENDIF
      ENDCASE
   CASE UPPER(cGAME) = "DIXIE"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "US GENERALS";     cTYPE := "US Generals"
      CASE UPPER(CLINE) = "US ARTILLERY";    cTYPE := "US Artillery"
      CASE UPPER(CLINE) = "US CAVALRY";      cTYPE := "US Cavalry"
      CASE UPPER(CLINE) = "US INFANTRY";     cTYPE := "US Infantry"
      CASE UPPER(CLINE) = "US TERRAIN";      cTYPE := "US Terrain"
      CASE UPPER(CLINE) = "US SPECIAL";      cTYPE := "US Special"
      CASE UPPER(CLINE) = "CONF. GENERALS";  cTYPE := "Conf. Generals"
      CASE UPPER(CLINE) = "CONF. ARTILLERY"; cTYPE := "Conf. Artillery"
      CASE UPPER(CLINE) = "CONF. CAVALRY";   cTYPE := "Conf. Cavalry"
      CASE UPPER(CLINE) = "CONF. INFANTRY";  cTYPE := "Conf. Infantry"
      CASE UPPER(CLINE) = "CONF. TERRAIN";   cTYPE := "Conf. Terrain"
      CASE UPPER(CLINE) = "CONF. SPECIAL";   cTYPE := "Conf. Special"
      OTHERWISE
         IF nTABS = 2
            SELECT CONJURE
            APPEND BLANK
            REPLACE GAME   WITH cGAMECODE
            REPLACE SERIES WITH cTYPE
            REPLACE TYPE   WITH "Card"
            REPLACE ARTIST WITH "EHo"
            REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE CARD   WITH RTRIM(CARD) + " " + LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE VALUE WITH VAL(cLINE)
         ELSE
            ? "         " + cLINE
         ENDIF
      ENDCASE
   CASE LEFT(UPPER(cGAME),12) = "DOOM TROOPER"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "ART";            cTYPE := "Art"
      CASE UPPER(CLINE) = "DARK SYMMETRY";  cTYPE := "Dark Symmetry"
      CASE UPPER(CLINE) = "EQUIPMENT";      cTYPE := "Equipment"
      CASE UPPER(CLINE) = "FORTIFICATIONS"; cTYPE := "Fortifications"
      CASE UPPER(CLINE) = "MISSIONS";       cTYPE := "Missions"
      CASE UPPER(CLINE) = "SPECIALS";       cTYPE := "Specials"
      CASE UPPER(CLINE) = "WARRIORS";       cTYPE := "Warriors"
      OTHERWISE
         IF nTABS = 3
            SELECT CONJURE
            APPEND BLANK
            REPLACE GAME   WITH cGAMECODE
            REPLACE SERIES WITH cTYPE
            REPLACE TYPE   WITH "Card"
            REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
            cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
            IF "UNLIMITED"$UPPER(cGAME)
               REPLACE VALUE WITH VAL(cLINE)
            ELSE
               REPLACE VALUE WITH VAL(cLINE) * 1.25
            ENDIF
         ELSE
            ? "         " + cLINE
         ENDIF
      ENDCASE
   CASE UPPER(cGAME) = "PROMOTIONAL"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      IF nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH "Promotional"
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      ELSE
         ? "         " + cLINE
      ENDIF
   CASE UPPER(cGAME) = "INQUISITION"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      SELECT CONJURE
      APPEND BLANK
      REPLACE GAME   WITH cGAMECODE
      REPLACE TYPE   WITH "Card"
      REPLACE SERIES WITH "Inquisition"
      REPLACE CARD   WITH cLINE
   CASE UPPER(cGAME) = "ECHELONS OF FIRE"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "GENERIC";        cTYPE := "Generic"
      CASE UPPER(CLINE) = "SOVIET";         cTYPE := "Soviet"
      CASE UPPER(CLINE) = "U.S.";           cTYPE := "U.S."
      OTHERWISE
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH cLINE
      ENDCASE
   CASE UPPER(cGAME) = "ECHELONS OF FURY"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "GENERIC";        cTYPE := "Generic"
      CASE UPPER(CLINE) = "GERMAN";         cTYPE := "German"
      CASE UPPER(CLINE) = "U.S.";           cTYPE := "U.S."
      OTHERWISE
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH cLINE
      ENDCASE
   CASE UPPER(cGAME) = "FLIGHTS OF FANTASY"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "GAME ENHANCEMENT CARDS"; cTYPE := "Game Enhance."
      CASE UPPER(CLINE) = "OTHER CARDS";            cTYPE := "Other Cards"
      CASE UPPER(CLINE) = "PUZZLE CARDS";           cTYPE := "Puzzle Cards"
      CASE UPPER(CLINE) = "GALLERY ART CARDS";      cTYPE := "Gallery Art"
      CASE nTABS = 1
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      ENDCASE
   CASE UPPER(cGAME) = "GALACTIC EMPIRES PRIMARY EDITION"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(cLINE) = "ARGONIAN";  cTYPE := "Argonian"
      CASE UPPER(cLINE) = "BOLAAR";    cTYPE := "Bolaar"
      CASE UPPER(cLINE) = "CORPORATE"; cTYPE := "Corporate"
      CASE UPPER(cLINE) = "INDIRIGAN"; cTYPE := "Indirigan"
      CASE UPPER(cLINE) = "KREBIZ";    cTYPE := "Krebiz"
      CASE UPPER(cLINE) = "MECHAD";    cTYPE := "Mechad"
      CASE UPPER(cLINE) = "VEKTREAN";  cTYPE := "Vektrean"
      CASE nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH cLINE

         DO CASE
         CASE RARITY = "C2"; REPLACE VALUE WITH VAL_C2
         CASE RARITY = "C";  REPLACE VALUE WITH VAL_C
         CASE RARITY = "U";  REPLACE VALUE WITH VAL_U
         CASE RARITY = "R2"; REPLACE VALUE WITH VAL_R2
         CASE RARITY = "R";  REPLACE VALUE WITH VAL_R
         ENDCASE
      CASE nTABS = 4
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE  WITH VAL(cLINE)
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "NEW EMPIRES"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "CLYDON";    cTYPE := "Clydon"
      CASE UPPER(CLINE) = "NAGIRIDNI"; cTYPE := "Nagiridni"
      CASE UPPER(CLINE) = "P. O. T.";  cTYPE := "P.O.T."
      CASE UPPER(CLINE) = "SCORPEAD";  cTYPE := "Scorpead"
      CASE UPPER(CLINE) = "TUFOR";     cTYPE := "Tufor"
      CASE UPPER(CLINE) = "SPECIAL";   cTYPE := "Special"
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH cLINE
      CASE nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH cLINE
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE LEFT(UPPER(cGAME),15) = "ILLUMINATI: NWO"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "ILLUMINATI";        cTYPE := "Illuminati"
      CASE UPPER(CLINE) = "GOALS";             cTYPE := "Goals"
      CASE UPPER(CLINE) = "GROUPS";            cTYPE := "Groups"
      CASE UPPER(CLINE) = "NEW WORLD ORDERS";  cTYPE := "New World Orders"
      CASE UPPER(CLINE) = "PLOTS";             cTYPE := "Plots"
      CASE UPPER(CLINE) = "RESOURCES";         cTYPE := "Resources"
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         IF "UNLIMITED"$UPPER(cGAME)
            REPLACE VALUE WITH VAL(cLINE)
         ELSE
            REPLACE VALUE WITH VAL(cLINE) * 1.5
         ENDIF
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "JYHAD"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "BRUJAH CLAN";             cTYPE := "Brujah Clan"
      CASE UPPER(CLINE) = "CAITIFF CLAN";            cTYPE := "Caitiff Clan"
      CASE UPPER(CLINE) = "GANGREL CLAN";            cTYPE := "Gangrel Clan"
      CASE UPPER(CLINE) = "MALKAVIAN CLAN";          cTYPE := "Malkavian Clan"
      CASE UPPER(CLINE) = "NOSFERATU CLAN";          cTYPE := "Nosferatu Clan"
      CASE UPPER(CLINE) = "TOREADOR CLAN";           cTYPE := "Toreador Clan"
      CASE UPPER(CLINE) = "TREMERE CLAN";            cTYPE := "Tremere Clan"
      CASE UPPER(CLINE) = "VENTRUE CLAN";            cTYPE := "Ventrue Clan"
      CASE UPPER(CLINE) = "ACTION";                  cTYPE := "Action"
      CASE UPPER(CLINE) = "ACTION MODIFIER";         cTYPE := "Action Modifier"
      CASE UPPER(CLINE) = "ALLY";                    cTYPE := "Ally"
      CASE UPPER(CLINE) = "COMBAT";                  cTYPE := "Combat"
      CASE UPPER(CLINE) = "EQUIPMENT";               cTYPE := "Equipment"
      CASE UPPER(CLINE) = "MASTER";                  cTYPE := "Master"
      CASE UPPER(CLINE) = "MASTER: JUSTICAR";        cTYPE := "Master:Justicar"
      CASE UPPER(CLINE) = "MASTER: OUT OF TURN";     cTYPE := "Master:Out/Turn"
      CASE UPPER(CLINE) = "MASTER: SKILL";           cTYPE := "Master:Skill"
      CASE UPPER(CLINE) = "MASTER:UNIQUE LOCATION";  cTYPE := "Master:Uniq Loc"
      CASE UPPER(CLINE) = "POLITICAL ACTION";        cTYPE := "Political Actn"
      CASE UPPER(CLINE) = "REACTION";                cTYPE := "Reaction"
      CASE UPPER(CLINE) = "RETAINER";                cTYPE := "Retainer"
      CASE UPPER(CLINE) = "UNIQUE MASTER";           cTYPE := "Unique Master"
      CASE nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "MAGIC:THE GATHERING"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "BLACK";         cTYPE := "Black"
      CASE UPPER(CLINE) = "BLUE";          cTYPE := "Blue"
      CASE UPPER(CLINE) = "COLORLESS";     cTYPE := "Beige"
      CASE UPPER(CLINE) = "GREEN";         cTYPE := "Green"
      CASE UPPER(CLINE) = "LAND";          cTYPE := "Land"
      CASE UPPER(CLINE) = "RED";           cTYPE := "Red"
      CASE UPPER(CLINE) = "WHITE";         cTYPE := "White"
      CASE UPPER(CLINE) = "MULTI";         cTYPE := "Gold"
      CASE nTABS = 2 .AND. (UPPER(cSET) = "ALPHA" .OR. UPPER(cSET) = "DISCONTINUED" .OR. UPPER(cSET) = "ARABIAN NIGHTS")
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE COLOR  WITH cTYPE
         REPLACE SERIES WITH cSET
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      CASE nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE COLOR  WITH cTYPE
         REPLACE SERIES WITH cSET
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "ON THE EDGE"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "SAMPLE CARDS"; cTYPE := "Sample Cards"
      CASE UPPER(CLINE) = "ALPHA SET";    cTYPE := "Alpha Set"
      CASE nTABS = 3 .AND. UPPER(cTYPE) = "SAMPLE CARDS"
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      CASE nTABS = 4 .AND. UPPER(cTYPE) = "ALPHA SET"
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "CUT-UPS PROJECT"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE nTABS = 1
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH "Cut-Ups Project"
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH cLINE
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH "Cut-Ups Project"
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH cLINE
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "SPELLFIRE SET 1"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "RAVENLOFT";        cTYPE := "Ravenloft"
      CASE UPPER(CLINE) = "DRAGONLANCE";      cTYPE := "Dragonlance"
      CASE UPPER(CLINE) = "FORGOTTEN REALMS"; cTYPE := "Forgottn Realms"
      CASE nTABS = 1 .AND. UPPER(cTYPE) = "DRAGONLANCE"
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH cLINE
      CASE nTABS = 3 .AND. UPPER(cTYPE) = "FORGOTTEN REALMS"
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH cLINE
      CASE nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE WITH VAL(cLINE)
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "STAR OF THE GUARDIANS"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "ARTIFACT";      cTYPE := "Artifact"
      CASE UPPER(CLINE) = "CREW";          cTYPE := "Crew"
      CASE UPPER(CLINE) = "DAMAGE";        cTYPE := "Damage"
      CASE UPPER(CLINE) = "FATE";          cTYPE := "Fate"
      CASE UPPER(CLINE) = "MODIFIER";      cTYPE := "Modifier"
      CASE UPPER(CLINE) = "PERSONALITY";   cTYPE := "Personality"
      CASE UPPER(CLINE) = "SHIP";          cTYPE := "Ship"
      CASE UPPER(CLINE) = "SQUADRON";      cTYPE := "Squadron"
      CASE UPPER(CLINE) = "SYSTEM";        cTYPE := "System"
      CASE UPPER(CLINE) = "TACTIC";        cTYPE := "Tactic"
      CASE UPPER(CLINE) = "WEAPON";        cTYPE := "Weapon"
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE ARTIST WITH cLINE
         DO CASE
         CASE RARITY = "C";  REPLACE VALUE WITH VAL_C
         CASE RARITY = "U";  REPLACE VALUE WITH VAL_U
         CASE RARITY = "R";  REPLACE VALUE WITH VAL_R
         ENDCASE
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE LEFT(UPPER(cGAME),18) = "STAR TREK : T.N.G."
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "ARTIFACT";                       cTYPE := "Artifact"
      CASE UPPER(CLINE) = "DILEMMA";                        cTYPE := "Dilemma"
      CASE UPPER(CLINE) = "EQUIPMENT";                      cTYPE := "Equipment"
      CASE UPPER(CLINE) = "EVENT";                          cTYPE := "Event"
      CASE UPPER(CLINE) = "INTERRUPT";                      cTYPE := "Interrupt"
      CASE UPPER(CLINE) = "MISSION - FEDERATION";           cTYPE := "Mission-Fed."
      CASE UPPER(CLINE) = "MISSION - KLINGON";              cTYPE := "Mission-Klingon"
      CASE UPPER(CLINE) = "MISSION - FEDERATION / KLINGON"; cTYPE := "Mission-Fed/Klg"
      CASE UPPER(CLINE) = "MISSION - ROMULAN";              cTYPE := "Mission-Romulan"
      CASE UPPER(CLINE) = "MISSION - ROMULAN / FEDERATION"; cTYPE := "Mission-Rom/Fed"
      CASE UPPER(CLINE) = "MISSION - ROMULAN / KLINGON";    cTYPE := "Mission-Rom/Klg"
      CASE UPPER(CLINE) = "MISSION - FED / ROM / KLG";      cTYPE := "Mission-F/R/K"
      CASE UPPER(CLINE) = "PERSONNEL - FEDERATION";         cTYPE := "Personnel-Fed"
      CASE UPPER(CLINE) = "PERSONNEL - KLINGON";            cTYPE := "Personnel-Klg"
      CASE UPPER(CLINE) = "PERSONNEL - ROMULAN";            cTYPE := "Personnel-Rom"
      CASE UPPER(CLINE) = "PERSONNEL - NON-ALIGNED";        cTYPE := "Personnel-Non"
      CASE UPPER(CLINE) = "PERSONNEL - FEDERATION";         cTYPE := "Personnel-Fed"
      CASE UPPER(CLINE) = "PERSONNEL - KLINGON";            cTYPE := "Personnel-Klg"
      CASE UPPER(CLINE) = "PERSONNEL - ROMULAN";            cTYPE := "Personnel-Rom"
      CASE UPPER(CLINE) = "PERSONNEL - NON-ALIGNED";        cTYPE := "Personnel-Non"
      CASE UPPER(CLINE) = "SHIP - FEDERATION";              cTYPE := "Ship-Fed"
      CASE UPPER(CLINE) = "SHIP - KLINGON";                 cTYPE := "Ship-Klg"
      CASE UPPER(CLINE) = "SHIP - ROMULAN";                 cTYPE := "Ship-Rom"
      CASE UPPER(CLINE) = "SHIP - NON-ALIGNED";             cTYPE := "Ship-Non"
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         IF "UNLIMITED"$UPPER(cGAME)
            REPLACE VALUE WITH VAL(cLINE)
         ELSE
            REPLACE VALUE WITH VAL(cLINE) * 3
         ENDIF
      ENDCASE
   CASE UPPER(cGAME) = "TOWERS IN TIME"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE nTABS = 2
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE SERIES WITH "Towers in Time"
         REPLACE ARTIST WITH "MSa"
         REPLACE RARITY WITH cLINE
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   CASE UPPER(cGAME) = "ULTIMATE COMBAT"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "ACTION";      cTYPE := "Action"
      CASE UPPER(CLINE) = "ACVANTAGE";   cTYPE := "Advantage"
      CASE UPPER(CLINE) = "ARMOR";       cTYPE := "Armor"
      CASE UPPER(CLINE) = "ENVIRONMENT"; cTYPE := "Environment"
      CASE UPPER(CLINE) = "FOUNDATION";  cTYPE := "Foundation"
      CASE UPPER(CLINE) = "TALISMAN";    cTYPE := "Talisman"
      CASE UPPER(CLINE) = "TECHNIQUE";   cTYPE := "Technique"
      CASE UPPER(CLINE) = "WEAPON";      cTYPE := "Weapon"
      OTHERWISE
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE SERIES WITH cTYPE
         IF nTABS > 0
            REPLACE CARD   WITH LEFT(cLINE,AT(CHR(9),cLINE)-1)
         ELSE
            REPLACE CARD   WITH cLINE
         ENDIF
      ENDCASE

   CASE UPPER(cGAME) = "WYVERN"
      cLINE := FIX(LINE)
      nTABS := COUNTTABS(cLINE)
      DO CASE
      CASE UPPER(CLINE) = "DRAGON";               cTYPE := "Dragon"
      CASE UPPER(CLINE) = "TERRAIN";              cTYPE := "Terrain"
      CASE UPPER(CLINE) = "TREASURE";             cTYPE := "Treasure"
      CASE UPPER(CLINE) = "BATTLE ACTION";        cTYPE := "Battle Action"
      CASE UPPER(CLINE) = "ACTION";               cTYPE := "Action"
      CASE UPPER(CLINE) = "DRAGON SLAYER ACTION"; cTYPE := "Dragon Slayer"
      CASE UPPER(CLINE) = "REACTION";             cTYPE := "Reaction"
      CASE nTABS = 3
         SELECT CONJURE
         APPEND BLANK
         REPLACE GAME   WITH cGAMECODE
         REPLACE TYPE   WITH "Card"
         REPLACE ARTIST WITH "PPr"
         REPLACE SERIES WITH cTYPE
         REPLACE COLOR  WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE CARD   WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE RARITY WITH LTRIM(LEFT(cLINE,AT(CHR(9),cLINE)-1))
         cLINE  = STUFF(cLINE,1,AT(CHR(9),cLINE),"")
         REPLACE VALUE  WITH VAL(cLINE)
      OTHERWISE
         ? "         " + cLINE
      ENDCASE
   OTHERWISE
      ? cGAME + "   ? ->" + LINE
   ENDCASE
   SELECT IMPORT
   SKIP
ENDDO

?
? "Step 5 : Generating COD Files .... "

* Generating Final Database

SELECT CONJURE
INDEX ON UPPER(GAME + IF(TYPE = "S","A","Z") + SERIES + CARD) TO ("CONJURE.NTX")
GO TOP
DO WHILE ! EOF()
   SELECT FINAL
   APPEND BLANK
   FINAL->GAME      := CONJURE->GAME
   FINAL->SERIES    := CONJURE->SERIES
   FINAL->TYPE      := CONJURE->TYPE
   FINAL->NAME      := CONJURE->CARD
   FINAL->COLOR     := CONJURE->COLOR
   FINAL->ARTIST    := CONJURE->ARTIST
   FINAL->RARITY    := CONJURE->RARITY
   FINAL->REFERENCE := CONJURE->REFERENCE
   FINAL->SOURCE    := "Conjure Magazine #"+LTRIM(STR(nCONJURE,3))
   FINAL->VALUE_LOW := CONJURE->VALUE
   FINAL->VALUE_MED := CONJURE->VALUE
   FINAL->VALUE_HI  := CONJURE->VALUE
   SELECT CONJURE
   SKIP
ENDDO

? "Step 6 : Comparing MAGIC Cards ... "

nFOREST   := 0
nISLAND   := 0
nMOUNTAIN := 0
nPLAINS   := 0
nSWAMP    := 0
USE DAEMON.DD NEW EXCLUSIVE ALIAS DAEMON
REPLACE ALL BUY_FROM WITH "", UPDATED WITH .F.
INDEX ON UPPER(SERIES + CARD) TO DAEMON.NTX
SELECT FINAL
GO TOP
DO WHILE ! EOF()
   IF FINAL->GAME = "M:TG" .AND. TYPE = "C" .AND. SERIES <> "ICE AGE"

      * Fix Series

      DO CASE
      CASE FINAL->SERIES = "Alpha"         ; cSERIES := "ALPH"
      CASE FINAL->SERIES = "Antiquities"   ; cSERIES := "ANTQ"
      CASE FINAL->SERIES = "Arabian Nights"; cSERIES := "ARAB"
      CASE FINAL->SERIES = ""              ; cSERIES := "BETA"
      CASE FINAL->SERIES = "The Dark"      ; cSERIES := "DARK"
      CASE FINAL->SERIES = ""              ; cSERIES := "FALL"
      CASE FINAL->SERIES = "Ice Age"       ; cSERIES := "ICE"
      CASE FINAL->SERIES = "Legends"       ; cSERIES := "LGND"
      CASE FINAL->SERIES = ""              ; cSERIES := "LMTD"
      CASE FINAL->SERIES = "Revised"       ; cSERIES := "RVSD"
      CASE FINAL->SERIES = "Discontinued"  ; cSERIES := "UNLT"
      ENDCASE

      * Fix Card

      DO CASE
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "BATERRING RAM"
         FINAL->DAEMON := "Battering Ram"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "CIRCLE OF PROTECTION ARTIFACTS"
         FINAL->DAEMON := "Circle of Protection:Artifacts"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "HIVORY TOWER"
         FINAL->DAEMON := "Ivory Tower"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "MISHRA'S FACTORY AUTUMN"
         FINAL->DAEMON := "Mishra's Factory (Type 3)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "MISHRA'S FACTORY SPRING"
         FINAL->DAEMON := "Mishra's Factory (Type 1)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "MISHRA'S FACTORY SUMMER"
         FINAL->DAEMON := "Mishra's Factory (Type 2)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "MISHRA'S FACTORY WINTER"
         FINAL->DAEMON := "Mishra's Factory (Type 4)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "STRIP MINE45 (NO SKY)"
         FINAL->DAEMON := "Strip Mine (Type 4)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "STRIP MINE45 (SKY EVEN)"
         FINAL->DAEMON := "Strip Mine (Type 1)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "STRIP MINE45 (SKY UNEVEN)"
         FINAL->DAEMON := "Strip Mine (Type 3)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "STRIP MINE45 (TOWER)"
         FINAL->DAEMON := "Strip Mine (Type 2)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S MINE (FACE CAVE)"
         FINAL->DAEMON := "Urza's Mine (Type 4)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S MINE (MACHINE)"
         FINAL->DAEMON := "Urza's Mine (Type 1)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S MINE (PULLEY)"
         FINAL->DAEMON := "Urza's Mine (Type 2)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S MINE (TOWER)"
         FINAL->DAEMON := "Urza's Mine (Type 3)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S POWER PLANT (BALL)"
         FINAL->DAEMON := "Urza's Power Plant (Type 3)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S POWER PLANT (BUG)"
         FINAL->DAEMON := "Urza's Power Plant (Type 2)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S POWER PLANT (COLUMNS)"
         FINAL->DAEMON := "Urza's Power Plant (Type 1)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S POWER PLANT (VAT)"
         FINAL->DAEMON := "Urza's Power Plant (Type 4)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S TOWER (FOREST)"
         FINAL->DAEMON := "Urza's Tower (Type 1)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S TOWER (ISLAND)"
         FINAL->DAEMON := "Urza's Tower (Type 4)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S TOWER (MOUNTAINS)"
         FINAL->DAEMON := "Urza's Tower (Type 2)"
      CASE cSERIES = "ANTQ" .and. UPPER(FINAL->NAME) = "URZA'S TOWER (PLAINS)"
         FINAL->DAEMON := "Urza's Tower (Type 3)"
      CASE cSERIES = "ARAB" .and. UPPER(FINAL->NAME) = "LNAFS ASP"
         FINAL->DAEMON := "Nafs Asp"
      CASE cSERIES = "ARAB" .and. UPPER(FINAL->NAME) = "MNAFS ASP"
         FINAL->DAEMON := ""
      CASE cSERIES = "ARAB" .and. UPPER(FINAL->NAME) = "MOUNTAIN"
         FINAL->DAEMON := "Mountain (Arabian Nights)"
      CASE cSERIES = "LGND" .and. UPPER(FINAL->NAME) = "ADVENTURERS' GUILDHOUSE"
         FINAL->DAEMON := "Adventurer's Guildhouse"
      CASE cSERIES = "LGND" .and. UPPER(FINAL->NAME) = "KOBOL DRILL SEARGEANT"
         FINAL->DAEMON := "Kobold Drill Sergeant"
      CASE cSERIES = "LGND" .and. UPPER(FINAL->NAME) = "THE TABERNACLE AT PENDRELL VALE"
         FINAL->DAEMON := "Tabernacle at Pendrell Vale"
      CASE cSERIES = "LGND" .and. "RATHI BERSERKER"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Aerathi Berserker"
      CASE cSERIES = "DARK" .and. UPPER(FINAL->NAME) = "HMAZE OF ITH"
         FINAL->DAEMON := "Maze of Ith"
      CASE cSERIES = "DARK" .and. UPPER(FINAL->NAME) = "WARBARGE"
         FINAL->DAEMON := "War Barge"
      CASE cSERIES = "ICE"
         FINAL->DAEMON := ""
      CASE cSERIES = "RVSD" .and. "CIRCLE PROTECTION BLACK"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Circle of Protection:Black"
      CASE cSERIES = "RVSD" .and. UPPER(FINAL->NAME) = "CIRCLE PROTECTION BLUE"
         FINAL->DAEMON := "Circle of Protection:Blue"
      CASE cSERIES = "RVSD" .and. UPPER(FINAL->NAME) = "CIRCLE PROTECTION GREEN"
         FINAL->DAEMON := "Circle of Protection:Green"
      CASE cSERIES = "RVSD" .and. "CIRCLE PROTECTION RED"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Circle of Protection:Red"
      CASE cSERIES = "RVSD" .and. "CIRCLE PROTECTION WHITE"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Circle of Protection:White"
      CASE cSERIES = "RVSD" .and. "FOREST59 X"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Forest (Type 1)"
         nFOREST   := FINAL->VALUE_MED
      CASE cSERIES = "RVSD" .and. "ISLAND59 X"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Island (Type 1)"
         nISLAND   := FINAL->VALUE_MED
      CASE cSERIES = "RVSD" .and. "MOUNTAIN59 X"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Mountain (Type 1)"
         nMOUNTAIN := FINAL->VALUE_MED
      CASE cSERIES = "RVSD" .and. "PLAINS59 X"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Plains (Type 1)"
         nPLAINS := FINAL->VALUE_MED
      CASE cSERIES = "RVSD" .and. "SWAMP59 X"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Swamp (Type 1)"
         nSWAMP := FINAL->VALUE_MED
      CASE cSERIES = "RVSD" .and. "HYPNOTIC SPECTRE"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Hypnotic Specter"
      CASE cSERIES = "RVSD" .and. UPPER(FINAL->NAME) = "ROC OF KHER RIDEGES"
         FINAL->DAEMON := "Roc of Kher Ridges"
      CASE cSERIES = "RVSD" .and. UPPER(FINAL->NAME) = "WILL-O-THE WISP"
         FINAL->DAEMON := "Will-O-The-Wisp"
      CASE cSERIES = "UNLT" .and. "BLACK LOTUS5"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Black Lotus"
      CASE cSERIES = "UNLT" .and. "CYCLOPEAN TOMB10"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Cyclopean Tomb"
      CASE cSERIES = "UNLT" .and. "FORCEFIELD17"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Forcefield"
      CASE cSERIES = "UNLT" .and. "ICY MANIPULATOR1"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Icy Manipulator"
      CASE cSERIES = "UNLT" .and. "LICH19"$UPPER(FINAL->NAME)
         FINAL->DAEMON := "Lich"
      OTHERWISE
         STRIPNOTE(FINAL->NAME,cSERIES)
      ENDCASE
      IF ! EMPTY(FINAL->DAEMON)
         SELECT DAEMON
         SEEK UPPER(cSERIES + FINAL->DAEMON)
         IF FOUND()
            DAEMON->BUY_FROM := STR(FINAL->VALUE_MED,10,2)
            DAEMON->UPDATED  := .T.
         ELSE
            ? FINAL->GAME + " : " + FINAL->SERIES + " : " + FINAL->DAEMON
         ENDIF
      ENDIF
      SELECT FINAL
   ENDIF
   SKIP
ENDDO

* Fill in other Revised Lands

SELECT DAEMON
GO TOP
DO WHILE ! EOF()
   IF ! UPDATED .AND. UPPER(SERIES) = "RVSD"
      DO CASE
      CASE "FOREST (TYPE"$UPPER(CARD)
         DAEMON->BUY_FROM := STR(nFOREST,10,2)
         DAEMON->UPDATED  := .T.
      CASE "ISLAND (TYPE"$UPPER(CARD)
         DAEMON->BUY_FROM := STR(nISLAND,10,2)
         DAEMON->UPDATED  := .T.
      CASE "MOUNTAIN (TYPE"$UPPER(CARD)
         DAEMON->BUY_FROM := STR(nMOUNTAIN,10,2)
         DAEMON->UPDATED  := .T.
      CASE "PLAINS (TYPE"$UPPER(CARD)
         DAEMON->BUY_FROM := STR(nPLAINS,10,2)
         DAEMON->UPDATED  := .T.
      CASE "SWAMP (TYPE"$UPPER(CARD)
         DAEMON->BUY_FROM := STR(nSWAMP,10,2)
         DAEMON->UPDATED  := .T.
      ENDCASE
   ENDIF
   SKIP
ENDDO

* Lookup Prices for Alpha, Beta & Unlimiteds

SELECT DAEMON
COPY ALL TO DAEMON2.DD
USE DAEMON2.DD NEW EXCLUSIVE ALIAS DAEMON2
INDEX ON UPPER(SERIES + CARD) TO DAEMON2.NTX

SELECT DAEMON
GO TOP
DO WHILE ! EOF()
   IF ! DAEMON->UPDATED .AND. (UPPER(DAEMON->SERIES)+"|")$"ALPH|BETA|UNLT|"

      * First, lookup UNLT (Discontinued)

      SELECT DAEMON2
      SEEK UPPER("UNLT" + DAEMON->CARD)
      IF FOUND() .AND. VAL(DAEMON2->BUY_FROM) <> 0
         nVAL := VAL(DAEMON2->BUY_FROM)
         DO CASE
         CASE UPPER(DAEMON->SERIES) = "ALPH"
            DAEMON->BUY_FROM := STR(nVAL * 2.5,10,2)
            DAEMON->UPDATED  := .T.
         CASE UPPER(DAEMON->SERIES) = "BETA"
            DAEMON->BUY_FROM := STR(nVAL * 2,10,2)
            DAEMON->UPDATED  := .T.
         ENDCASE
      ELSE

         * Next, lookup RVSD (Discontinued)

         SELECT DAEMON2
         SEEK UPPER("RVSD" + DAEMON->CARD)
         IF FOUND() .AND. VAL(DAEMON2->BUY_FROM) <> 0
            nVAL := VAL(DAEMON2->BUY_FROM)
            DO CASE
            CASE UPPER(DAEMON->SERIES) = "ALPH"
               DAEMON->BUY_FROM := STR(nVAL * 3.5,10,2)
               DAEMON->UPDATED  := .T.
            CASE UPPER(DAEMON->SERIES) = "BETA"
               DAEMON->BUY_FROM := STR(nVAL * 2.75,10,2)
               DAEMON->UPDATED  := .T.
            CASE UPPER(DAEMON->SERIES) = "UNLT"
               DAEMON->BUY_FROM := STR(nVAL * 1.75,10,2)
               DAEMON->UPDATED  := .T.
            ENDCASE
         ELSE
            ? "Looking up RVSD Price for : " + DAEMON->SERIES + " : " + DAEMON->CARD
            ?? " ... NOT FOUND!"
         ENDIF
      ENDIF
      SELECT DAEMON
   ENDIF
   SKIP
ENDDO

* Lookup Missing Prices for Fallen & Limited (Conjure 4 Fuck-Up)

USE CONJ4FIX.DD NEW EXCLUSIVE ALIAS CONJ4FIX
INDEX ON UPPER(SERIES + CARD) TO CONJ4FIX.NTX
SELECT DAEMON
GO TOP
DO WHILE ! EOF()
   IF UPPER(DAEMON->SERIES) = "FALL" .OR. UPPER(DAEMON->SERIES) = "LMTD"
      SELECT CONJ4FIX
      SEEK UPPER(DAEMON->SERIES + DAEMON->CARD)
      IF FOUND()
         DAEMON->BUY_FROM := STR(CONJ4FIX->BUY_PRICE,10,2)
         DAEMON->UPDATED  := .T.
      ENDIF
      SELECT DAEMON
   ENDIF
   SKIP
ENDDO

* Show Exceptions

SELECT DAEMON
GO TOP
DO WHILE ! EOF()
   IF ! UPDATED
      ? "Price Not Found : " + SERIES + " : " + CARD
   ENDIF
   SKIP
ENDDO

* Generate ARTISTS.REF

SELECT ARTISTS
COPY FIELDS CODE, LINE TO ARTISTS.REF SDF

* Generate REMARKS.REF

SELECT NOTES
COPY FIELDS CODE, LINE TO REMARKS.REF SDF

* Generate GAMES.COD and ????????.COD

SELECT FINAL
COPY TO ("MTGSETS.DBF") FOR (UPPER(GAME) = "M:TG" .AND. TYPE = "S")
SET PRINTER TO GAMES.COD
SET CONSOLE OFF
SET PRINT ON
? "Conjure on Disk #"+LTRIM(STR(nCONJURE,3))
ASORT(aGAMES)
FOR nX := 1 TO LEN(aGAMES)
   ? aGAMES[nX]
   cGAME := UPPER(LTRIM(RTRIM(LEFT(aGAMES[nX],4))))
   cFILE := UPPER(LTRIM(RTRIM(SUBSTR(aGAMES[nX],65,12)))) + ".COD"
   COUNT FOR GAME = cGAME TO nFOUND
   IF nFOUND > 0
      IF cGAME = "M:TG"
         CREATEDBF("DAEMON3.DBF",FSTRUCT1 + FSTRUCT2)
         USE DAEMON3 NEW EXCLUSIVE ALIAS DAEMON3
         APPEND FROM ("MTGSETS.DBF")
         SELECT DAEMON
         GO TOP
         DO WHILE ! EOF()
            SELECT DAEMON3
            APPEND BLANK
            DAEMON3->GAME      := "M:TG"
            DO CASE
            CASE UPPER(DAEMON->SERIES) = "ALPH"; DAEMON3->SERIES := "Alpha Unlimited"
            CASE UPPER(DAEMON->SERIES) = "ANTQ"; DAEMON3->SERIES := "Antiquities    "
            CASE UPPER(DAEMON->SERIES) = "ARAB"; DAEMON3->SERIES := "Arabian Nights "
            CASE UPPER(DAEMON->SERIES) = "BETA"; DAEMON3->SERIES := "Beta Unlimited "
            CASE UPPER(DAEMON->SERIES) = "DARK"; DAEMON3->SERIES := "The Dark       "
            CASE UPPER(DAEMON->SERIES) = "FALL"; DAEMON3->SERIES := "Fallen Empires "
            CASE UPPER(DAEMON->SERIES) = "ICE" ; DAEMON3->SERIES := "Ice Age        "
            CASE UPPER(DAEMON->SERIES) = "LGND"; DAEMON3->SERIES := "Legends        "
            CASE UPPER(DAEMON->SERIES) = "LMTD"; DAEMON3->SERIES := "Limited        "
            CASE UPPER(DAEMON->SERIES) = "RVSD"; DAEMON3->SERIES := "Revised        "
            CASE UPPER(DAEMON->SERIES) = "UNLT"; DAEMON3->SERIES := "Unlimited      "
            ENDCASE
            DAEMON3->TYPE      := "C"
            DAEMON3->NAME      := DAEMON->CARD
            DAEMON3->COLOR     := DAEMON->COLOR
          * DAEMON3->ARTIST    := DAEMON->ARTIST        && Problem
          * DAEMON3->RARITY    := DAEMON->RARITY        && Problem
            DAEMON3->REFERENCE := DAEMON->REFERENCE
            DAEMON3->SOURCE    := "Conjure Magazine #"+LTRIM(STR(nCONJURE,3))
            DAEMON3->VALUE_LOW := VAL(DAEMON->BUY_FROM)
            DAEMON3->VALUE_MED := VAL(DAEMON->BUY_FROM)
            DAEMON3->VALUE_HI  := VAL(DAEMON->BUY_FROM)
            SELECT DAEMON
            SKIP
         ENDDO
         SELECT DAEMON3
         COPY FIELDS GAME,SERIES,TYPE,NAME,COLOR,ARTIST,RARITY,REFERENCE,SOURCE,VALUE_LOW,VALUE_MED,VALUE_HI FOR GAME = cGAME TO (cFILE) SDF
         SELECT FINAL
      ELSE
         COPY FIELDS GAME,SERIES,TYPE,NAME,COLOR,ARTIST,RARITY,REFERENCE,SOURCE,VALUE_LOW,VALUE_MED,VALUE_HI FOR GAME = cGAME TO (cFILE) SDF
      ENDIF
   ENDIF
NEXT nX
SET PRINT OFF
SET CONSOLE ON
SET PRINTER TO
?? "Done"

? "Step 7 : Finishing Touches ....... "

CLOSE ALL
ERASE("APPENDS.DBF")
ERASE("ARTISTS.DBF")
ERASE("CONJ4FIX.NTX")
ERASE("CONJURE.BAK")
ERASE("CONJURE.DBF")
ERASE("CONJURE.NTX")
ERASE("CONJURE.REP")
ERASE("CONJ_ART.DBF")
ERASE("CONJ_ART.NTX")
ERASE("CONJ_REF.DBF")
ERASE("DAEMON.NTX")
ERASE("DAEMON2.DBF")
ERASE("DAEMON2.NTX")
* ERASE("DAEMON3.DBF")
* ERASE("FINAL.DBF")
ERASE("FINAL.NTX")
ERASE("GARBAGE.DBF")
ERASE("IMPORT.DBF")
ERASE("MTGSETS.DBF")
ERASE("NOTES.DBF")
ERASE("OUTPUT.TXT")
ERASE("PRICES.DBF")
ERASE("PRICES.DD")
ERASE("PRICES.NTX")
ERASE("WORK.DBF")
ERASE("WORK.NDX")
?? "Done"
? "Stop   : " + TIME()
?
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                         Various String functions                         */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function FIX (cTEMP)
Local nX, cNEW := ""

cTEMP := LTRIM(RTRIM(cTEMP))
FOR nX := 1 TO LEN(cTEMP)
   DO CASE
   CASE SUBSTR(cTEMP,nX,1)$"ЄЁ$ВҐТБдгў"
      * Nothing
   CASE SUBSTR(cTEMP,nX,1)$"Ћ"
      cNEW := cNEW + "‚"
   CASE SUBSTR(cTEMP,nX,1)$"®"
      cNEW := cNEW + "’"
   OTHERWISE
      cNEW := cNEW + SUBSTR(cTEMP,nX,1)
   ENDCASE
NEXT nX
Return (cNEW)


Function TFIX (cTEMP,lUPPER)
Local nX, cNEW := ""

IF lUPPER
   cTEMP := LTRIM(RTRIM(UPPER(cTEMP)))
ELSE
   cTEMP := LTRIM(RTRIM(cTEMP))
ENDIF
FOR nX := 1 TO LEN(cTEMP)
   DO CASE
   CASE SUBSTR(cTEMP,nX,1)$"ЄЁ$ВҐТБдгў"+CHR(9)
      * Nothing
   CASE SUBSTR(cTEMP,nX,1)$"Ћ"
      cNEW := cNEW + "‚"
   CASE SUBSTR(cTEMP,nX,1)$"®"
      cNEW := cNEW + "’"
   OTHERWISE
      cNEW := cNEW + SUBSTR(cTEMP,nX,1)
   ENDCASE
NEXT nX
Return (cNEW)


Function EXTRACT (cTEMP)
Local nX, nPOS := 0

cTEMP := LTRIM(RTRIM(cTEMP))
FOR nX := LEN(cTEMP) TO 1 STEP -1
   nPOS := IF(SUBSTR(cTEMP,nX,1)$" "+CHR(9) .AND. nPOS = 0,nX,nPOS)
NEXT nX
IF nPOS <> 0
   nVAL  := VAL(SUBSTR(cTEMP,nPOS+1,10))
   cTEMP := LEFT(cTEMP,nPOS)
ENDIF
Return (nVAL)


Function COUNTTABS (cTEMP)
Local nX, nTABS := 0

FOR nX := 1 TO LEN(RTRIM(cTEMP))
   IF SUBSTR(cTEMP,nX,1) = CHR(9)
      nTABS++
   ENDIF
NEXT nX
Return (nTABS)


Function STRIPNOTE (cTEMP,cSERIES)
Local nX, nBEGIN := 0

* Check for (#,### Cards)

cTEMP := LTRIM(RTRIM(cTEMP))
IF "("$cTEMP .AND. (cSERIES = "UNLT" .or. cSERIES = "ALPH")
   IF "CARDS"$UPPER(cTEMP)
      cTEMP := LEFT(cTEMP,AT("(",cTEMP)-1)
   ELSE
      IF ","$UPPER(cTEMP)
         cTEMP := LEFT(cTEMP,AT("(",cTEMP)-1)
      ENDIF
   ENDIF
ENDIF

* Check for Footnotes

cTEMP := LTRIM(RTRIM(cTEMP))
IF SUBSTR(cTEMP,LEN(cTEMP),1)$"0123456789"
   FOR nX = LEN(cTEMP) TO 1 STEP -1
      IF ! SUBSTR(cTEMP,nX,1)$"0123456789" .AND. nBEGIN = 0
         nBEGIN := (nX + 1)
      ENDIF
   NEXT nX
 * REPLACE NOTES WITH SUBSTR(CTEMP,NBEGIN,LEN(CTEMP)-NBEGIN+1)
 * REPLACE CARD  WITH LEFT(CARD,NBEGIN-1)
   cTEMP := LEFT(cTEMP,nBEGIN - 1)
ENDIF

FINAL->DAEMON := cTEMP
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                  Function to Translate Dollar Amounts                    */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function VALFIX (cTEMP)

* Check for Dollar Sign

cTEMP := LTRIM(RTRIM(cTEMP))
IF LEFT(cTEMP,1) = "$"
   cTEMP := RIGHT(cTEMP,LEN(cTEMP)-1)
ENDIF

* Check for commas (twice to be safe)

IF ","$cTEMP
   cTEMP := STUFF(cTEMP,AT(",",cTEMP),1,"")
ENDIF
IF ","$cTEMP
   cTEMP := STUFF(cTEMP,AT(",",cTEMP),1,"")
ENDIF
IF ".."$cTEMP
   cTEMP := STUFF(cTEMP,AT(".",cTEMP),1,"")
ENDIF
IF ". ."$cTEMP
   cTEMP := STUFF(cTEMP,AT(".",cTEMP),2,"")
ENDIF
Return VAL(cTEMP)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*               Function to Build a .DBF from Schema-String                */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CREATEDBF (cDBFNAME,cSTRUCTURE)
Local aSCHEMA[30][4], nFIELD := 0
DO WHILE LEN(cSTRUCTURE) > 0
   nFIELD++
   aSCHEMA[nFIELD,1] := LTRIM(RTRIM(LEFT(cSTRUCTURE,AT(",",cSTRUCTURE)-1)))
   aSCHEMA[nFIELD,2] := LTRIM(RTRIM(SUBSTR(cSTRUCTURE,AT(",",cSTRUCTURE)+1,1)))
   aSCHEMA[nFIELD,3] := VAL(SUBSTR(cSTRUCTURE,AT(",",cSTRUCTURE)+2,3))
   aSCHEMA[nFIELD,4] := VAL(SUBSTR(cSTRUCTURE,AT(",",cSTRUCTURE)+5,2))
   cSTRUCTURE := SUBSTR(cSTRUCTURE,AT(",",cSTRUCTURE)+7,LEN(cSTRUCTURE)-(AT(",",cSTRUCTURE)+6))
ENDDO
ASIZE(aSCHEMA,nFIELD)
DBCREATE(cDBFNAME,aSCHEMA)
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                  Generic Error Message & Shutdown Code                   */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ERROR
PARAMETER MSG
TONE(900,2)
? "Conjure-on-Disk Conversion Utility                                 Version 1.0b"
? "Copyright 1994, Bard's Quest Software, Inc.                 All Rights Reserved"
?
? MSG
?
?
SET CURSOR ON
CLOSE ALL
CLEAR ALL
QUIT
Return (Nil)
