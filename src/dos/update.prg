/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                                                          */
/*   Program           : UPDATE.EXE                                         */
/*   Title             : DECK DAEMON UPDATE UTILITY                         */
/*   Version           : 1.2                                                */
/*   Purpose           : Update Customer's Current List of Cards            */
/*   Author(s)         : Richard Hundhausen                                 */
/*   Copyright         : 1994, Richard Hundhausen                           */
/*   Distributor       : Bard's Quest Software, Inc.                        */
/*   Started           : August 19, 1994                                    */
/*   Completed         : August 19, 1994                                    */
/*   Clipper Libraries : Clipper, Extend, Terminal, DBFNTX                  */
/*   Complier Version  : Clipper 5.2c                                       */
/*                                                                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                                                          */
/*  Database         Index(s)         Expression(s)                         */
/*  ДДДДДДДДДДДД     ДДДДДДДДДДДД     ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД  */
/*  DAEMON0.DD                                                              */
/*  DAEMON1.DD ..... DAEMON1A.DD .... UPPER(SERIES + CARD)                  */
/*                   DAEMON1B.DD .... UPPER(CARD + SERIES)                  */
/*                   DAEMON1C.DD .... UPPER(COLOR + SERIES + CARD)          */
/*                   DAEMON1D.DD .... UPPER(TYPE + SERIES + CARD)           */
/*                   DAEMON1E.DD .... UPPER(SERIES + COLOR + CARD) - Tom's  */
/*  DAEMON2.DD ..... DAEMON2A.DD .... UPPER(TYPE + NAME)                    */
/*  DAEMON3.DD ..... DAEMON3A.DD .... UPPER(DECK)                           */
/*  DAEMON4.DD ..... DAEMON4A.DD .... STR(DECK,3) + STR(CARD,5)             */
/*                   DAEMON4B.DD .... CARD                                  */
/*                                                                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

#include "inkey.ch"
#define PROG_NAME   "UPDATE.EXE"
#define VERSION     "1.1a"
#define BOX_COLOR   "B+/N"
#define OK_COLOR    "W+/N"
#define OPEN_COLOR  "W+/B"
#define READ_COLOR  "W+/B,W+/N,,,GR+/B"
#define SHAD_COLOR  "W/N"
#define SHOW_COLOR  "GR+/B"
#define WARN_COLOR  "W+/R"
#define B_SINGLE    "ЪДїіЩДАі"
#define B_DOUBLE    "ЙН»єјНИє"
#define CSCHEMA     "SERIES,C  4 0SERIESNM,C 20 0CARD,C 30 0COLOR,C  5 0TYPE,C 20 0RARITY,C  1 0TOURNAMENT,C  1 0COST,C 10 0ARTIST,C 20 0DESC,C240 0"
#define DSCHEMA     "VOLUME,N  4 1DNAME,C 20 0DTYPE,C 12 0DCOUNT,N  4 0DQTY,N  4 0SERIES,C  4 0SERIESNM,C 20 0CARD,C 30 0COLOR,C  5 0TYPE,C 20 0RARITY,C  1 0TOURNAMENT,C  1 0COST,C 10 0ARTIST,C 20 0DESC,C240 0"
#define NEWSCHEMA   "NUMBER,N  3 0DECK,C 20 0TYPE,C 12 0COUNT,N  4 0CARDS,N  4 0WINS,N  3 0LOSSES,N  3 0"

Static GETLIST := {}

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                              Main Routine                                */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function MAIN_BLOCK (pPARM)
Local cPARMS

SET SCOREBOARD OFF
SET DELETED ON
SET CURSOR OFF
SETCANCEL(.F.)
SET EXACT ON
SET BELL OFF
SET WRAP ON

cPARMS := IF(pPARM = Nil,"",UPPER(pPARM))
DO CASE
CASE "CARDS"$cPARMS
   MAKE_EXP()
CASE "DECKS"$cPARMS
   MAKE_DECKS()
CASE FILE("CARDS.LST") .AND. FILE("DECKS.LST")
   DECISION("CD")
CASE FILE("CARDS.LST")
   DECISION("C")
CASE FILE("DECKS.LST")
   DECISION("D")
OTHERWISE
   ERROR("Warning : One or more update file(s) are missing")
ENDCASE
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                     Export Expansion Set(s) to File                      */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function MAKE_EXP
Local cSCREEN, cPATH := "C:\DAEMON", cSET := "    ", lBADPATH := .T.
Local nCARDS := 0, lPROBLEMS := .F., lAPPEND := .T., nTOTAL := 0

* Opening Screen

@ 0,0 CLEAR
RESTORE SCREEN FROM REPLICATE(CHR(219)+CHR(9),2000)
SETCOLOR(OPEN_COLOR)
@  0,0  SAY SPACE(80)
@ 24,0  SAY SPACE(80)
@  0,69 SAY "і " + DTOC(DATE())
@ 24,53 SAY "і Expansion Set Generation"
ZBOX(6,17,18,62)
@ 7,18 SAY "         Welcome to the Deck Daemon         "
@ 8,18 SAY "ДДДДД Expansion Set Generation Utility ДДДДД"

* Step 1 : Find Path

DO WHILE lBADPATH
   cPATH := cPATH + SPACE(40)
   SETCOLOR(READ_COLOR)
   @ 10,19 SAY "Deck Daemon Directory :" GET cPATH PICTURE "@S18"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF EMPTY(cPATH) .OR. LASTKEY() = 27
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
   cPATH := LTRIM(RTRIM(UPPER(cPATH)))
   IF ! FILE(cPATH + "DAEMON1.DD")
      IF ! FILE(cPATH + "\DAEMON1.DD") .OR. ! FILE(cPATH + "\DAEMON2.DD")
         TONE(900,2)
         SAVE SCREEN TO cSCREEN
         ZWARN(0,"Sorry : Required file(s) are missing from that directory",1)
         RESTORE SCREEN FROM cSCREEN
      ELSE
         cPATH    := cPATH + "\"
         lBADPATH := .F.
      ENDIF
   ELSE
      lBADPATH := .F.
   ENDIF
ENDDO

* Step 2 : Ask for Expansion Set Name

SETCOLOR(READ_COLOR)
@ 11,19 SAY "Expansion Set Name    :" GET cSET PICTURE "@!"
SET CURSOR ON
READ
SET CURSOR OFF
IF EMPTY(cSET) .OR. LASTKEY() = 27
   SETCOLOR("W/N")
   @ 0,0 CLEAR
   SET CURSOR ON
   CLOSE ALL
   CLEAR ALL
   QUIT
ENDIF

* Step 3 : Overwrite / Append

IF FILE("CARDS.LST")
   @ 12,19 SAY "Append to CARDS.LST?  :" GET lAPPEND PICTURE "Y"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
ELSE
   lAPPEND := .F.
ENDIF

* Step 4 : Create Temporary Database and Rebuild Indexes

@ 13,19 SAY "Reading "+cSET+" Cards    :"
@ 13,42 SAY STR(nCARDS,4) COLOR SHOW_COLOR
CREATEDBF("CARDS.DBF",CSCHEMA)
USE ("CARDS.DBF") ALIAS UPDATE NEW EXCLUSIVE
ZAP
USE (cPATH+"DAEMON1.DD") NEW EXCLUSIVE ALIAS CARDS
USE (cPATH+"DAEMON2.DD") NEW EXCLUSIVE ALIAS SUPPORT
INDEX ON UPPER(SHORT) TO ("DAEMON2.NTX")

* Step 5 : Generate CARDS.DBF

SELECT CARDS
GO TOP
DO WHILE ! EOF()
   IF UPPER(SERIES) = cSET
      nCARDS++
      @ 13,42 SAY STR(nCARDS,4) COLOR SHOW_COLOR
      SELECT UPDATE
      APPEND BLANK
      UPDATE->SERIES     := CARDS->SERIES
      UPDATE->CARD       := CARDS->CARD
      UPDATE->COLOR      := CARDS->COLOR
      UPDATE->TYPE       := CARDS->TYPE
      UPDATE->RARITY     := LEFT(CARDS->FLAGS,1)
      UPDATE->TOURNAMENT := SUBSTR(CARDS->FLAGS,3,1)
      UPDATE->COST       := CARDS->COST
      UPDATE->ARTIST     := CARDS->ARTIST
      UPDATE->DESC       := CARDS->DESC
      SELECT SUPPORT
      SEEK UPPER(CARDS->SERIES)
      IF FOUND()
         UPDATE->SERIESNM := SUPPORT->NAME
      ELSE
         UPDATE->SERIESNM := "!!! Series Not Found"
         lPROBLEMS := .T.
      ENDIF
      SELECT CARDS
   ENDIF
   SKIP
ENDDO

* Step 6 : Index and Generate SDF File

IF lAPPEND
   @ 14,19 SAY "Updating ASCII File   : "
   @ 14,43 SAY "CARDS.LST" COLOR SHOW_COLOR
   SELECT UPDATE
   INDEX ON UPPER(SERIES + CARD) TO ("CARDS.NTX")
   COPY ALL TO ("CARDS2")
   ZAP
   APPEND FROM CARDS.LST SDF
   APPEND FROM CARDS2
   INDEX ON UPPER(SERIES + CARD) TO ("CARDS.NTX")
   nTOTAL := LASTREC()
   COPY ALL TO ("CARDS.LST") SDF
   CLOSE ALL
   @ 14,53 SAY "(" + LTRIM(STR(nTOTAL,5)) + ")" COLOR SHOW_COLOR
ELSE
   @ 14,19 SAY "Generating ASCII File : "
   @ 14,43 SAY "CARDS.LST" COLOR SHOW_COLOR
   SELECT UPDATE
   INDEX ON UPPER(SERIES + CARD) TO ("CARDS.NTX")
   COPY ALL TO ("CARDS.LST") SDF
   CLOSE ALL
ENDIF

* Step 7 : Clean up

ERASE ("CARDS.DBF")
ERASE ("CARDS.NTX")
ERASE ("CARDS2.DBF")
ERASE ("DAEMON2.NTX")
DO CASE
CASE lPROBLEMS
   @ 15,19 SAY "Problems Encountered  :"
   @ 15,43 SAY "View ASCII File!" COLOR WARN_COLOR
CASE nCARDS = 0
   @ 15,19 SAY "Problems Encountered  :"
   @ 15,43 SAY "No Cards Found!" COLOR WARN_COLOR
OTHERWISE
   @ 15,19 SAY "Operation Successful  :"
   @ 15,43 SAY "All Done!" COLOR SHOW_COLOR
ENDCASE
@ 17,38 SAY " Ok " COLOR OK_COLOR
SET CURSOR OFF
CLEAR TYPEAHEAD
INKEY(0)

* All Done, Exit

SETCOLOR("W/N")
@ 0,0 CLEAR
SET CURSOR ON
CLEAR ALL
QUIT
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Export Decks to File                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function MAKE_DECKS
Local cSCREEN, cPATH := "C:\DAEMON", lBADPATH := .T., nDECKS := 0
Local lPROBLEMS := .F., nVOL := 0, lAPPEND := .T.

* Opening Screen

@ 0,0 CLEAR
RESTORE SCREEN FROM REPLICATE(CHR(219)+CHR(9),2000)
SETCOLOR(OPEN_COLOR)
@  0,0  SAY SPACE(80)
@ 24,0  SAY SPACE(80)
@  0,69 SAY "і " + DTOC(DATE())
@ 24,55 SAY "і Daemon Deck Generation"
ZBOX(6,17,18,62)
@ 7,18 SAY "         Welcome to the Deck Daemon         "
@ 8,18 SAY "ДДДДДД Daemon Deck Generation Utility ДДДДДД"

* Step 1 : Find Path

DO WHILE lBADPATH
   cPATH := cPATH + SPACE(40)
   SETCOLOR(READ_COLOR)
   @ 10,19 SAY "Deck Daemon Volume    :" GET nVOL  PICTURE "99.9" VALID nVOL > 0
   @ 11,19 SAY "Deck Daemon Directory :" GET cPATH PICTURE "@S18"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF EMPTY(cPATH) .OR. LASTKEY() = 27 .OR. nVOL = 0
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
   cPATH := LTRIM(RTRIM(UPPER(cPATH)))
   IF ! FILE(cPATH + "DAEMON1.DD")
      IF ! FILE(cPATH + "\DAEMON1.DD") .OR. ! FILE(cPATH + "\DAEMON2.DD") .OR. ! FILE(cPATH + "\DAEMON3.DD") .OR. ! FILE(cPATH + "\DAEMON4.DD")
         TONE(900,2)
         SAVE SCREEN TO cSCREEN
         ZWARN(0,"Sorry : Required file(s) are missing from that directory",1)
         RESTORE SCREEN FROM cSCREEN
      ELSE
         cPATH    := cPATH + "\"
         lBADPATH := .F.
      ENDIF
   ELSE
      lBADPATH := .F.
   ENDIF
ENDDO

* Step 2 : Overwrite / Append

IF FILE("DECKS.LST")
   @ 12,19 SAY "Append to DECKS.LST?  :" GET lAPPEND PICTURE "Y"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
ELSE
   lAPPEND := .F.
ENDIF

* Step 3 : Create Temporary Database and Rebuild Indexes

@ 13,19 SAY "Reading All Decks     :"
CREATEDBF("DECKS.DBF",DSCHEMA)
USE ("DECKS.DBF") ALIAS UPDATE NEW EXCLUSIVE
ZAP
USE (cPATH+"DAEMON1.DD") NEW EXCLUSIVE ALIAS CARDS
INDEX ON REFERENCE TO ("DAEMON1.NTX")
USE (cPATH+"DAEMON2.DD") NEW EXCLUSIVE ALIAS SUPPORT
INDEX ON UPPER(SHORT) TO ("DAEMON2.NTX")
USE (cPATH+"DAEMON4.DD") NEW EXCLUSIVE ALIAS DECKLINK
INDEX ON DECK TO ("DAEMON4.NTX")
USE (cPATH+"DAEMON3.DD") NEW EXCLUSIVE ALIAS DECKS

* Step 4 : Generate DECKS.DBF

GO TOP
DO WHILE ! EOF()
   nDECKS++
   @ 13,42 SAY STR(nDECKS,4) COLOR SHOW_COLOR

   SELECT DECKLINK
   SEEK DECKS->NUMBER
   IF FOUND()
      DO WHILE (DECKLINK->DECK = DECKS->NUMBER .AND. ! EOF())
         IF DECKLINK->QUANTITY > 0
            SELECT CARDS
            SEEK DECKLINK->CARD
            IF FOUND()
               SELECT UPDATE
               APPEND BLANK
               UPDATE->VOLUME     := nVOL
               UPDATE->DNAME      := DECKS->DECK
               UPDATE->DTYPE      := DECKS->TYPE
               UPDATE->DCOUNT     := DECKS->COUNT
               UPDATE->DQTY       := DECKLINK->QUANTITY
               UPDATE->SERIES     := CARDS->SERIES
               UPDATE->CARD       := CARDS->CARD
               UPDATE->COLOR      := CARDS->COLOR
               UPDATE->TYPE       := CARDS->TYPE
               UPDATE->RARITY     := LEFT(CARDS->FLAGS,1)
               UPDATE->TOURNAMENT := SUBSTR(CARDS->FLAGS,3,1)
               UPDATE->COST       := CARDS->COST
               UPDATE->ARTIST     := CARDS->ARTIST
               UPDATE->DESC       := CARDS->DESC

               SELECT SUPPORT
               SEEK UPPER(CARDS->SERIES)
               IF FOUND()
                  UPDATE->SERIESNM := SUPPORT->NAME
               ELSE
                  UPDATE->SERIESNM := "!!! Series Not Found"
                  lPROBLEMS         := .T.
               ENDIF
            ELSE
               SELECT UPDATE
               APPEND BLANK
               UPDATE->DNAME  := DECKS->DECK
               UPDATE->DTYPE  := DECKS->TYPE
               UPDATE->DCOUNT := DECKS->COUNT
               UPDATE->DQTY   := DECKLINK->QUANTITY
               UPDATE->CARD   := "!!! Couldn't Find Card "+STR(DECKLINK->CARD,5)
               lPROBLEMS      := .T.
            ENDIF
            SELECT DECKLINK
         ENDIF
         SKIP
      ENDDO
   ENDIF
   SELECT DECKS
   SKIP
ENDDO

* Step 5 : Index and Generate SDF File

IF lAPPEND
   @ 14,19 SAY "Updating ASCII File   : "
   @ 14,43 SAY "DECKS.LST" COLOR SHOW_COLOR
   SELECT UPDATE
   INDEX ON UPPER(DNAME + DTYPE + SERIES + CARD) TO ("DECKS.NTX")
   COPY ALL TO ("DECKS2")
   ZAP
   APPEND FROM DECKS.LST SDF
   APPEND FROM DECKS2
   INDEX ON UPPER(DNAME + DTYPE + SERIES + CARD) TO ("DECKS.NTX")
   COPY ALL TO ("DECKS.LST") SDF
   CLOSE ALL
ELSE
   @ 14,19 SAY "Generating ASCII File : "
   @ 14,43 SAY "DECKS.LST" COLOR SHOW_COLOR
   SELECT UPDATE
   INDEX ON UPPER(DNAME + DTYPE + SERIES + CARD) TO ("DECKS.NTX")
   GO TOP
   COPY ALL TO ("DECKS.LST") SDF
   CLOSE ALL
ENDIF

* Step 6 : Clean up

ERASE ("DECKS.DBF")
ERASE ("DECKS.NTX")
ERASE ("DECKS2.DBF")
ERASE ("DAEMON1.NTX")
ERASE ("DAEMON2.NTX")
ERASE ("DAEMON4.NTX")
IF lPROBLEMS
   @ 15,19 SAY "Problems Encountered  :"
   @ 15,43 SAY "View ASCII File!" COLOR WARN_COLOR
ELSE
   @ 15,19 SAY "Operation Successful  :"
   @ 15,43 SAY "All Done!" COLOR SHOW_COLOR
ENDIF
@ 17,38 SAY " Ok " COLOR OK_COLOR
SET CURSOR OFF
CLEAR TYPEAHEAD
INKEY(0)

* All Done, Exit

SETCOLOR("W/N")
@ 0,0 CLEAR
SET CURSOR ON
CLEAR ALL
QUIT
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                          Decide Which to Update                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function DECISION (cCHOICE)
Local lCARDS := .T., lDECKS := .T., aIMPORTS := {}, cSETS := "", nSETS := 0
Local cVOLUMES := "", nVOLUMES := 0, nOPTION := 1, lUPDATING := .T., cSCREEN

@ 0,0 CLEAR
RESTORE SCREEN FROM REPLICATE(CHR(219)+CHR(9),2000)
SETCOLOR(OPEN_COLOR)
@  0,0  SAY SPACE(80)
@ 24,0  SAY SPACE(80)
@  0,69 SAY "і " + DTOC(DATE())
@ 24,58 SAY "і Deck Daemon Updates"
ZBOX(6,16,18,63)
@  7,17 SAY "          Welcome to the Deck Daemon          "
@  9,17 SAY "ДДДДДДДДДДДДДДД Update Utility ДДДДДДДДДДДДДДД"
@ 13,25 SAY "Please Wait : Reading Files ..."
SET CURSOR ON

* Load in all series names

IF "C"$cCHOICE
   CREATEDBF("CARDS.DD",CSCHEMA)
   USE ("CARDS.DD") ALIAS UPDATE NEW EXCLUSIVE
   APPEND FROM ("CARDS.LST") SDF
   GO TOP
   DO WHILE ! EOF()
      IF ! UPDATE->SERIESNM$cSETS
         AADD(aIMPORTS," Expansion    : " + UPDATE->SERIESNM + "          ")
         cSETS := cSETS + UPDATE->SERIESNM
         nSETS++
      ENDIF
      SKIP
   ENDDO
   CLOSE UPDATE
   ERASE ("CARDS.DD")
ENDIF

* Load in all daemon deck volumes

IF "D"$cCHOICE
   CREATEDBF("DECKS.DD",DSCHEMA)
   USE ("DECKS.DD") ALIAS UPDATE NEW EXCLUSIVE
   APPEND FROM ("DECKS.LST") SDF
   GO TOP
   DO WHILE ! EOF()
      IF ! STR(UPDATE->VOLUME,4,1)$cVOLUMES
         AADD(aIMPORTS," Daemon Decks : Volume " + STR(UPDATE->VOLUME,4,1) + "                   ")
         cVOLUMES := cVOLUMES + STR(UPDATE->VOLUME,4,1)
         nVOLUMES++
      ENDIF
      SKIP
   ENDDO
   CLOSE UPDATE
   ERASE ("DECKS.DD")
ENDIF

* Begin the selection routine

ASORT(aIMPORTS)
SET CURSOR OFF
IF LEN(aIMPORTS) > 0
   @ 13,25 SAY "                               "
   @ 24,1  SAY " Use [] / [] to select; [Enter] Selects; [Esc] Quits" COLOR OPEN_COLOR
   DO WHILE lUPDATING
      nOPTION := ACHOICE(11,17,17,62,aIMPORTS,,,nOPTION)
      DO CASE
      CASE LASTKEY() = 27
         lUPDATING := .F.
      CASE nOPTION = 0
         TONE(900,2)
      CASE "EXPANSION"$UPPER(LEFT(aIMPORTS[nOPTION],15)) .AND. ! "UPDATED"$aIMPORTS[nOPTION]
         SAVE SCREEN TO cSCREEN
         IF CARDS(SUBSTR(aIMPORTS[nOPTION],17,20))
            aIMPORTS[nOPTION] := LEFT(aIMPORTS[nOPTION],36) + "[Updated] "
         ELSE
            aIMPORTS[nOPTION] := LEFT(aIMPORTS[nOPTION],36) + "[Failed!] "
         ENDIF
         KEYBOARD CHR(K_DOWN)
         RESTORE SCREEN FROM cSCREEN
      CASE "DAEMON DECKS"$UPPER(LEFT(aIMPORTS[nOPTION],15)) .AND. ! "UPDATED"$aIMPORTS[nOPTION]
         SAVE SCREEN TO cSCREEN
         IF DECKS(LTRIM(RTRIM(SUBSTR(aIMPORTS[nOPTION],17,20))))
            aIMPORTS[nOPTION] := LEFT(aIMPORTS[nOPTION],36) + "[Updated] "
         ELSE
            aIMPORTS[nOPTION] := LEFT(aIMPORTS[nOPTION],36) + "[Failed!] "
         ENDIF
         KEYBOARD CHR(K_DOWN)
         RESTORE SCREEN FROM cSCREEN
      OTHERWISE
         TONE(900,2)
      ENDCASE
   ENDDO
ENDIF
SETCOLOR("W/N")
@ 0,0 CLEAR
SET CURSOR ON
CLOSE ALL
CLEAR ALL
QUIT
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                          Import Expansion Set(s)                         */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CARDS (cSET)
Local cSCREEN, cPATH := "C:\DAEMON", lBADPATH := .T., cSETCODE, lDUPS := .F.
Local nHIGHEST := 0, nUPDATE, nCURRENT := 0, cARTISTS := "", cCOLORS := ""
Local cSERIES := "", cTYPES := "", nARTISTS := 0, nCOLORS := 0, nSERIES := 0
Local nTYPES := 0, cTITLE := ""

* Step 1 : Prompt the User

@ 11,17 CLEAR TO 17,62
@ 11,18 SAY "Expansion Set         :"
@ 11,42 SAY cSET COLOR SHOW_COLOR
DO WHILE lBADPATH
   cPATH := cPATH + SPACE(40)
   SETCOLOR(READ_COLOR)
   @ 12,18 SAY "Deck Daemon Directory :" GET cPATH PICTURE "@S18"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF EMPTY(cPATH) .OR. LASTKEY() = 27
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
   cPATH := LTRIM(RTRIM(UPPER(cPATH)))
   IF ! FILE(cPATH + "DAEMON1.DD")
      IF ! FILE(cPATH + "\DAEMON1.DD") .OR. ! FILE(cPATH + "\DAEMON2.DD")
         TONE(900,2)
         SAVE SCREEN TO cSCREEN
         ZWARN(0,"Sorry : Invalid Directory or Deck Daemon File(s) Missing",1)
         RESTORE SCREEN FROM cSCREEN
      ELSE
         cPATH := cPATH + "\"
         lBADPATH := .F.
      ENDIF
   ELSE
      lBADPATH := .F.
   ENDIF
ENDDO

* Step 2 : Reading Import List

SET CURSOR ON
@ 13,18 SAY "Reading Expansion Set :"
CREATEDBF("CARDS.DBF",CSCHEMA)
USE ("CARDS.DBF") ALIAS UPDATE NEW EXCLUSIVE
APPEND FROM ("CARDS.LST") SDF
DELETE FOR UPPER(SERIESNM) <> UPPER(cSET)
PACK
GO TOP
cSETCODE := UPPER(UPDATE->SERIES)
nUPDATE  := LASTREC()
@ 13,42 SAY LTRIM(STR(nUPDATE,5)) + " Cards" COLOR SHOW_COLOR

* Step 3 : Reading Current Database

@ 14,18 SAY "Reading Your Database :"
USE (cPATH+"DAEMON1.DD") NEW EXCLUSIVE ALIAS CURRENT
COPY ALL TO (cPATH+"DAEMON1.UPD")
GO TOP
DO WHILE ! EOF()
   lDUPS := IF(UPPER(SERIES)$cSETCODE,.T.,lDUPS)
   IF CURRENT->REFERENCE > nHIGHEST
      nHIGHEST := CURRENT->REFERENCE
   ENDIF
   nCURRENT++
   SKIP
ENDDO
@ 14,42 SAY LTRIM(STR(nCURRENT,5)) + " Cards" COLOR SHOW_COLOR

* Step 4 : Notify of Duplicates

IF lDUPS
   TONE(900,2)
   SAVE SCREEN TO cSCREEN
   CLEAR TYPEAHEAD
   ZWARN(0,"NOTE : "+RTRIM(cSETCODE)+" cards have been found in your database.  Continue anyway? [Y/N] ",1)
   IF LASTKEY() <> 89 .AND. LASTKEY() <> 121
      CLOSE ALL
      ERASE ("CARDS.DBF")
      ERASE (cPATH+"DAEMON1A.DD")
      ERASE (cPATH+"DAEMON1B.DD")
      ERASE (cPATH+"DAEMON1C.DD")
      ERASE (cPATH+"DAEMON1D.DD")
      ERASE (cPATH+"DAEMON1E.DD")
      ERASE (cPATH+"DAEMON1F.DD")
      ERASE (cPATH+"DAEMON1G.DD")
      ERASE (cPATH+"DAEMON1H.DD")
      ERASE (cPATH+"DAEMON2A.DD")
      ERASE (cPATH+"DAEMON2B.DD")
      ERASE (cPATH+"DAEMON3A.DD")
      ERASE (cPATH+"DAEMON3B.DD")
      ERASE (cPATH+"DAEMON4A.DD")
      ERASE (cPATH+"DAEMON4B.DD")
      ERASE (cPATH+"DAEMON4C.DD")
      Return (.F.)
   ENDIF
   RESTORE SCREEN FROM cSCREEN
ENDIF

* Step 5 : Reading Support Information

@ 15,18 SAY "Updating Cards        : Card      of"
@ 15,55 SAY LTRIM(STR(nUPDATE,5)) COLOR SHOW_COLOR
USE (cPATH+"DAEMON2.DD") NEW EXCLUSIVE ALIAS SUPPORT
COPY ALL TO (cPATH+"DAEMON2.UPD")
GO TOP
DO WHILE ! EOF()
   DO CASE
   CASE TYPE = "A"; cARTISTS := cARTISTS + UPPER(NAME)  + "|"
   CASE TYPE = "C"; cCOLORS  := cCOLORS  + UPPER(NAME)  + "|"
   CASE TYPE = "S"; cSERIES  := cSERIES  + UPPER(SHORT) + "|"
   CASE TYPE = "T"; cTYPES   := cTYPES   + UPPER(NAME)  + "|"
   ENDCASE
   SKIP
ENDDO

* Step 5 : Copying Over New Cards

SELECT UPDATE
GO TOP
DO WHILE ! EOF()
   nHIGHEST++
   @ 15,46 SAY STR(RECNO(),5) COLOR SHOW_COLOR

   SELECT CURRENT
   APPEND BLANK
   CURRENT->SERIES    := UPDATE->SERIES
   CURRENT->CARD      := UPDATE->CARD
   CURRENT->COLOR     := UPDATE->COLOR
   CURRENT->TYPE      := UPDATE->TYPE
   CURRENT->FLAGS     := (UPDATE->RARITY + " " + UPDATE->TOURNAMENT)
   CURRENT->COST      := UPDATE->COST
   CURRENT->ARTIST    := UPDATE->ARTIST
   CURRENT->DESC      := UPDATE->DESC
   CURRENT->REFERENCE := nHIGHEST

   * Check Support Strings, Adding if Necessary

   SELECT UPDATE
   IF ! (UPPER(UPDATE->ARTIST)+"|")$cARTISTS
      SELECT SUPPORT
      APPEND BLANK
      SUPPORT->TYPE := "A"
      SUPPORT->NAME := UPDATE->ARTIST
      cARTISTS := cARTISTS + UPPER(UPDATE->ARTIST) + "|"
      nARTISTS++
   ENDIF
   IF ! (UPPER(UPDATE->COLOR)+SPACE(15)+"|")$cCOLORS
      SELECT SUPPORT
      APPEND BLANK
      SUPPORT->TYPE := "C"
      SUPPORT->NAME := UPDATE->COLOR
      cCOLORS := cCOLORS + UPPER(UPDATE->COLOR) + SPACE(15) + "|"
      nCOLORS++
   ENDIF
   IF ! (UPPER(UPDATE->SERIES)+"|")$cSERIES
      SELECT SUPPORT
      APPEND BLANK
      SUPPORT->TYPE  := "S"
      SUPPORT->SHORT := UPDATE->SERIES

    * Need to check this ZZZ

      SUPPORT->NAME  := UPDATE->SERIESNM
      cSERIES := cSERIES + UPPER(UPDATE->SERIES) + "|"
      nSERIES++
   ENDIF
   IF ! (UPPER(UPDATE->TYPE)+"|")$cTYPES
      SELECT SUPPORT
      APPEND BLANK
      SUPPORT->TYPE := "T"
      SUPPORT->NAME := UPDATE->TYPE
      cTYPES := cTYPES + UPPER(UPDATE->TYPE) + "|"
      nTYPES++
   ENDIF
   SELECT UPDATE
   SKIP
ENDDO

* Step 6 : Erase Indexes

CLOSE ALL
ERASE ("CARDS.DBF")
ERASE (cPATH+"DAEMON1A.DD")
ERASE (cPATH+"DAEMON1B.DD")
ERASE (cPATH+"DAEMON1C.DD")
ERASE (cPATH+"DAEMON1D.DD")
ERASE (cPATH+"DAEMON1E.DD")
ERASE (cPATH+"DAEMON1F.DD")
ERASE (cPATH+"DAEMON1G.DD")
ERASE (cPATH+"DAEMON1H.DD")
ERASE (cPATH+"DAEMON2A.DD")
ERASE (cPATH+"DAEMON2B.DD")
ERASE (cPATH+"DAEMON3A.DD")
ERASE (cPATH+"DAEMON3B.DD")
ERASE (cPATH+"DAEMON4A.DD")
ERASE (cPATH+"DAEMON4B.DD")
ERASE (cPATH+"DAEMON4C.DD")
TONE(900,2)
@ 17,38 SAY " Ok " COLOR OK_COLOR
SET CURSOR OFF
CLEAR TYPEAHEAD
INKEY(0)

* Display Notes

ZBOX(2,16,22,63)
cTITLE := LTRIM(RTRIM(cSET)) + " Update Results"
@  3,40-LEN(cTITLE)/2 SAY cTITLE
@  4,17 SAY REPLICATE("Д",46)
@  5,18 SAY STR(nCURRENT,5) COLOR SHOW_COLOR
@  5,24 SAY "Cards in your database previously"
IF lDUPS
   @ 6,24 SAY "Cards from series "+cSETCODE+" already exist!" COLOR WARN_COLOR
ENDIF
@  7,18 SAY STR(nUPDATE,5) COLOR SHOW_COLOR
@  7,24 SAY "Additional cards have been added"
@  8,18 SAY "ДДДДДД"
@  9,18 SAY STR(nUPDATE + nCURRENT,5) COLOR SHOW_COLOR
@  9,24 SAY "cards in your database now"
@ 11,18 SAY STR(nSERIES,5) COLOR SHOW_COLOR
@ 11,24 SAY "Series  added to support tables"
@ 12,18 SAY STR(nCOLORS,5) COLOR SHOW_COLOR
@ 12,24 SAY "Colors  added to support tables"
@ 13,18 SAY STR(nTYPES,5) COLOR SHOW_COLOR
@ 13,24 SAY "Types   added to support tables"
@ 14,18 SAY STR(nARTISTS,5) COLOR SHOW_COLOR
@ 14,24 SAY "Artists added to support tables"
@ 15,18 SAY "ДДДДДД"
@ 16,18 SAY STR(nSERIES + nCOLORS + nTYPES + nARTISTS,5) COLOR SHOW_COLOR
@ 16,24 SAY "new items added to support tables"
@ 18,18 SAY "Note : Previous databases were saved"
@ 19,18 SAY "       under DAEMON1.UPD & DAEMON2.UPD"
TONE(900,2)
@ 21,38 SAY " Ok " COLOR OK_COLOR
SET CURSOR OFF
CLEAR TYPEAHEAD
INKEY(0)
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                          Import Daemon Deck(s)                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function DECKS (cSET)
Local cSCREEN, cPATH := "C:\DAEMON", lBADPATH := .T., cDECKS := "", nVOLUME
Local nUPDATE := 0, lDUPS := .F., nHIGHEST := 0, nCURRENT := 0, cARTISTS := ""
Local cCOLORS := "", cSERIES := "", cTYPES := "", nNEXTCARD := 0, nNEWCARDS := 0
Local nARTISTS := 0, nCOLORS := 0, nSERIES := 0, nTYPES := 0, cTITLE := ""

* Step 1 : Prompt the User

@ 11,17 CLEAR TO 17,62
@ 11,18 SAY "Daemon Deck Set       :"
@ 11,42 SAY cSET COLOR SHOW_COLOR
DO WHILE lBADPATH
   cPATH := cPATH + SPACE(40)
   SETCOLOR(READ_COLOR)
   @ 12,18 SAY "Deck Daemon Directory :" GET cPATH PICTURE "@S18"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF EMPTY(cPATH) .OR. LASTKEY() = 27
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
   cPATH := LTRIM(RTRIM(UPPER(cPATH)))
   IF ! FILE(cPATH + "DAEMON1.DD")
      IF ! FILE(cPATH + "\DAEMON1.DD") .OR. ! FILE(cPATH + "\DAEMON2.DD")
         TONE(900,2)
         SAVE SCREEN TO cSCREEN
         ZWARN(0,"Sorry : Invalid Directory or Deck Daemon File(s) Missing",1)
         RESTORE SCREEN FROM cSCREEN
      ELSE
         cPATH := cPATH + "\"
         lBADPATH := .F.
      ENDIF
   ELSE
      lBADPATH := .F.
   ENDIF
ENDDO

* Step 2 : Reading Import List

SET CURSOR ON
@ 13,18 SAY "Reading Daemon Decks  :"
CREATEDBF("DECKS.DBF",DSCHEMA)
USE ("DECKS.DBF") ALIAS UPDATE NEW EXCLUSIVE
APPEND FROM ("DECKS.LST") SDF
nVOLUME := VAL(RIGHT(cSET,4))
DELETE FOR VOLUME <> nVOLUME
PACK

* Step 2.5 : Counting Decks

GO TOP
DO WHILE ! EOF()
   IF ! (UPPER(UPDATE->DNAME)+"|")$cDECKS
      nUPDATE++
      cDECKS := cDECKS + UPPER(UPDATE->DNAME) + "|"
   ENDIF
   SKIP
ENDDO
GO TOP
@ 13,42 SAY LTRIM(STR(nUPDATE,5)) + " Decks & Sideboards" COLOR SHOW_COLOR

* Step 3   : Fixing Current Database (Widening the Number Field)

CREATEDBF("FIX.DBF",NEWSCHEMA)
USE ("FIX.DBF") ALIAS FIX NEW EXCLUSIVE
ZAP
APPEND FROM (cPATH+"DAEMON3.DD")
PACK
COPY ALL TO (cPATH+"DAEMON3.DD")
CLOSE

* Step 3.5 : Reading Current Database

@ 14,18 SAY "Reading Your Database :"
USE (cPATH+"DAEMON3.DD") NEW EXCLUSIVE ALIAS CURRENT
COPY ALL TO (cPATH+"DAEMON3.DCK")
GO TOP
DO WHILE ! EOF()
   IF UPPER(CURRENT->DECK + "|")$cDECKS
      lDUPS := .T.
   ENDIF
   IF CURRENT->NUMBER > nHIGHEST
      nHIGHEST := CURRENT->NUMBER
   ENDIF
   nCURRENT++
   SKIP
ENDDO
@ 14,42 SAY LTRIM(STR(nCURRENT,5)) + " Decks" COLOR SHOW_COLOR

* Step 4 : Notify of Duplicates

IF lDUPS
   TONE(900,2)
   SAVE SCREEN TO cSCREEN
   CLEAR TYPEAHEAD
   ZWARN(0,"NOTE : Deck(s) with same name have been found.  Continue anyway? [Y/N] ",1)
   IF LASTKEY() <> 89 .AND. LASTKEY() <> 121
      CLOSE ALL
      ERASE ("DECKS.DBF")
      ERASE ("FIX.DBF")
      ERASE ("DAEMON1.NTX")
      ERASE (cPATH+"DAEMON1A.DD")
      ERASE (cPATH+"DAEMON1B.DD")
      ERASE (cPATH+"DAEMON1C.DD")
      ERASE (cPATH+"DAEMON1D.DD")
      ERASE (cPATH+"DAEMON1E.DD")
      ERASE (cPATH+"DAEMON1F.DD")
      ERASE (cPATH+"DAEMON1G.DD")
      ERASE (cPATH+"DAEMON1H.DD")
      ERASE (cPATH+"DAEMON2A.DD")
      ERASE (cPATH+"DAEMON2B.DD")
      ERASE (cPATH+"DAEMON3A.DD")
      ERASE (cPATH+"DAEMON3B.DD")
      ERASE (cPATH+"DAEMON4A.DD")
      ERASE (cPATH+"DAEMON4B.DD")
      ERASE (cPATH+"DAEMON4C.DD")
      Return (.F.)
   ENDIF
   RESTORE SCREEN FROM cSCREEN
ENDIF

* Step 5 : Reading Support Information

@ 15,18 SAY "Updating Decks        : Deck      of"
@ 15,55 SAY LTRIM(STR(nUPDATE,5)) COLOR SHOW_COLOR
USE (cPATH+"DAEMON4.DD") NEW EXCLUSIVE ALIAS DECKLINK
COPY ALL TO (cPATH+"DAEMON4.DCK")
USE (cPATH+"DAEMON2.DD") NEW EXCLUSIVE ALIAS SUPPORT
COPY ALL TO (cPATH+"DAEMON2.DCK")
GO TOP
DO WHILE ! EOF()
   DO CASE
   CASE TYPE = "A"; cARTISTS := cARTISTS + UPPER(NAME)  + "|"
   CASE TYPE = "C"; cCOLORS  := cCOLORS  + UPPER(NAME)  + "|"
   CASE TYPE = "S"; cSERIES  := cSERIES  + UPPER(SHORT) + "|"
   CASE TYPE = "T"; cTYPES   := cTYPES   + UPPER(NAME)  + "|"
   ENDCASE
   SKIP
ENDDO

* Step 5.5 : Preparing DAEMON1.DD for Comparison

USE (cPATH+"DAEMON1.DD") NEW EXCLUSIVE ALIAS CARDS
PACK
COPY ALL TO (cPATH+"DAEMON1.DCK")
GO TOP
nNEXTCARD := 0
DO WHILE ! EOF()
   IF CARDS->REFERENCE > nNEXTCARD
      nNEXTCARD := CARDS->REFERENCE
   ENDIF
   SKIP
ENDDO
INDEX ON UPPER(CARD) TO ("DAEMON1.NTX")

* Step 6 : Copying Over New Cards

cDECKS  := ""
nUPDATE := 0
SELECT UPDATE
GO TOP
DO WHILE ! EOF()

   * First, Add the Deck

   IF ! (UPPER(UPDATE->DNAME)+"|")$cDECKS
      nUPDATE++
      nHIGHEST++
      SELECT CURRENT
      APPEND BLANK
      CURRENT->NUMBER := nHIGHEST
      CURRENT->DECK   := UPDATE->DNAME
      CURRENT->TYPE   := UPDATE->DTYPE
      CURRENT->COUNT  := UPDATE->DCOUNT
      CURRENT->CARDS  := UPDATE->DCOUNT
      CURRENT->WINS   := 0
      CURRENT->LOSSES := 0
      @ 15,46 SAY STR(nUPDATE,5) COLOR SHOW_COLOR
      cDECKS := cDECKS + UPPER(UPDATE->DNAME) + "|"
   ENDIF

   * Lookup Card

   SELECT CARDS
   SEEK UPPER(UPDATE->CARD)
   IF ! FOUND()
      nNEWCARDS++
      nNEXTCARD++
      APPEND BLANK
      CARDS->SERIES    := UPDATE->SERIES
      CARDS->CARD      := UPDATE->CARD
      CARDS->COLOR     := UPDATE->COLOR
      CARDS->TYPE      := UPDATE->TYPE
      CARDS->FLAGS     := (UPDATE->RARITY + " " + UPDATE->TOURNAMENT)
      CARDS->COST      := UPDATE->COST
      CARDS->ARTIST    := UPDATE->ARTIST
      CARDS->DESC      := UPDATE->DESC
      CARDS->REFERENCE := nNEXTCARD
      CARDS->UPDATED   := .T.

      * Now update the support tables

      SELECT UPDATE
      IF ! (UPPER(UPDATE->ARTIST)+"|")$cARTISTS
         SELECT SUPPORT
         APPEND BLANK
         SUPPORT->TYPE := "A"
         SUPPORT->NAME := UPDATE->ARTIST
         cARTISTS := cARTISTS + UPPER(UPDATE->ARTIST) + "|"
         nARTISTS++
      ENDIF
      IF ! (UPPER(UPDATE->COLOR)+SPACE(15)+"|")$cCOLORS
         SELECT SUPPORT
         APPEND BLANK
         SUPPORT->TYPE := "C"
         SUPPORT->NAME := UPDATE->COLOR
         cCOLORS := cCOLORS + UPPER(UPDATE->COLOR) + SPACE(15) + "|"
         nCOLORS++
      ENDIF
      IF ! (UPPER(UPDATE->SERIES)+"|")$cSERIES
         SELECT SUPPORT
         APPEND BLANK
         SUPPORT->TYPE  := "S"
         SUPPORT->SHORT := UPDATE->SERIES
         SUPPORT->NAME  := UPDATE->SERIES
         cSERIES := cSERIES + UPPER(UPDATE->SERIES) + "|"
         nSERIES++
      ENDIF
      IF ! (UPPER(UPDATE->TYPE)+"|")$cTYPES
         SELECT SUPPORT
         APPEND BLANK
         SUPPORT->TYPE := "T"
         SUPPORT->NAME := UPDATE->TYPE
         cTYPES := cTYPES + UPPER(UPDATE->TYPE) + "|"
         nTYPES++
      ENDIF
   ENDIF

   * Add Card(s) to DeckLink

   SELECT DECKLINK
   APPEND BLANK
   DECKLINK->DECK     := CURRENT->NUMBER
   DECKLINK->CARD     := CARDS->REFERENCE
   DECKLINK->QUANTITY := UPDATE->DQTY

   * Check Color

   DO CASE
   CASE "BLACK"$UPPER(CARDS->COLOR)
      DECKLINK->COLOR := 1
   CASE "BLUE"$UPPER(CARDS->COLOR)
      DECKLINK->COLOR := 2
   CASE "GREEN"$UPPER(CARDS->COLOR)
      DECKLINK->COLOR := 3
   CASE "RED"$UPPER(CARDS->COLOR)
      DECKLINK->COLOR := 4
   CASE "WHITE"$UPPER(CARDS->COLOR)
      DECKLINK->COLOR := 5
   CASE "GOLD"$UPPER(CARDS->COLOR)
      DECKLINK->COLOR := 6
   ENDCASE

   * Check Type

   DO CASE
   CASE LEFT(UPPER(CARDS->TYPE),8) = "ARTIFACT"
      DECKLINK->TYPE := 7
   CASE LEFT(UPPER(CARDS->TYPE),7) = "ENCHANT"
      DECKLINK->TYPE := 8
   CASE LEFT(UPPER(CARDS->TYPE),7) = "INSTANT"
      DECKLINK->TYPE := 9
   CASE LEFT(UPPER(CARDS->TYPE),9) = "INTERRUPT"
      DECKLINK->TYPE = 10
   CASE LEFT(UPPER(CARDS->TYPE),4) = "LAND"
      DECKLINK->TYPE = 11
   CASE LEFT(UPPER(CARDS->TYPE),7) = "SORCERY"
      DECKLINK->TYPE = 12
   CASE LEFT(UPPER(CARDS->TYPE),6) = "SUMMON"
      DECKLINK->TYPE = 13
   ENDCASE

   * Check Tournament Status

   DO CASE
   CASE SUBSTR(CARDS->FLAGS,3,1) = "R"
      DECKLINK->STATUS := 14
   CASE SUBSTR(CARDS->FLAGS,3,1) = "B"
      DECKLINK->STATUS := 15
   ENDCASE
   SELECT UPDATE
   SKIP
ENDDO

* Step 9 : Erase Indexes

CLOSE ALL
ERASE ("DECKS.DBF")
ERASE ("FIX.DBF")
ERASE ("DAEMON1.NTX")
ERASE (cPATH+"DAEMON1A.DD")
ERASE (cPATH+"DAEMON1B.DD")
ERASE (cPATH+"DAEMON1C.DD")
ERASE (cPATH+"DAEMON1D.DD")
ERASE (cPATH+"DAEMON1E.DD")
ERASE (cPATH+"DAEMON1F.DD")
ERASE (cPATH+"DAEMON1G.DD")
ERASE (cPATH+"DAEMON1H.DD")
ERASE (cPATH+"DAEMON2A.DD")
ERASE (cPATH+"DAEMON2B.DD")
ERASE (cPATH+"DAEMON3A.DD")
ERASE (cPATH+"DAEMON3B.DD")
ERASE (cPATH+"DAEMON4A.DD")
ERASE (cPATH+"DAEMON4B.DD")
ERASE (cPATH+"DAEMON4C.DD")
TONE(900,2)
@ 17,38 SAY " Ok " COLOR OK_COLOR
SET CURSOR OFF
CLEAR TYPEAHEAD
INKEY(0)

* Display Notes

ZBOX(2,16,22,63)
cTITLE := LTRIM(RTRIM(cSET)) + " Update Results"
@  3,40-LEN(cTITLE)/2 SAY cTITLE
@  4,17 SAY REPLICATE("Д",46)
@  5,18 SAY STR(nCURRENT,5) COLOR SHOW_COLOR
@  5,24 SAY "Decks in your database previously"
IF lDUPS
   @ 6,24 SAY "Similar deck name(s) already exist!" COLOR WARN_COLOR
ENDIF
@  7,18 SAY STR(nUPDATE,5) COLOR SHOW_COLOR
@  7,24 SAY "Additional decks have been added"
@  8,18 SAY "ДДДДДД"
@  9,18 SAY STR(nUPDATE + nCURRENT,5) COLOR SHOW_COLOR
@  9,24 SAY "decks in your database now"
IF nNEWCARDS > 0
   @ 10,18 SAY STR(nNEWCARDS,5) COLOR SHOW_COLOR
   @ 10,24 SAY "NEW/ALTERED CARDS ADDED TO LIST"
ENDIF
@ 11,18 SAY STR(nSERIES,5) COLOR SHOW_COLOR
@ 11,24 SAY "Series  added to support tables"
@ 12,18 SAY STR(nCOLORS,5) COLOR SHOW_COLOR
@ 12,24 SAY "Colors  added to support tables"
@ 13,18 SAY STR(nTYPES,5) COLOR SHOW_COLOR
@ 13,24 SAY "Types   added to support tables"
@ 14,18 SAY STR(nARTISTS,5) COLOR SHOW_COLOR
@ 14,24 SAY "Artists added to support tables"
@ 15,18 SAY "ДДДДДД"
@ 16,18 SAY STR(nSERIES + nCOLORS + nTYPES + nARTISTS,5) COLOR SHOW_COLOR
@ 16,24 SAY "new items added to support tables"
@ 18,18 SAY "Note : Previous databases were saved"
@ 19,18 SAY "       under *.DCK file extension.  "
TONE(900,2)
@ 21,38 SAY " Ok " COLOR OK_COLOR
SET CURSOR OFF
CLEAR TYPEAHEAD
INKEY(0)
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                 3d Box                                   */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ZBOX (Y1,X1,Y2,X2)
Local Y
@ Y1,X1 CLEAR TO Y2,X2
@ Y1,X2+1 SAY "Я" COLOR BOX_COLOR
FOR Y := Y1+1 TO Y2+1
   @ Y,X2+1 SAY " " COLOR SHAD_COLOR
NEXT
@ Y2+1,X1 SAY "Ы"+REPLICATE("Ь",X2-X1+1) COLOR BOX_COLOR
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                      3d Warning Message Box Routine                      */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ZWARN (nYPOS,cMSG,nMODE)
Local nCURSOR := SETCURSOR(), nCOLOR := SETCOLOR()
DO CASE
CASE nMODE == 1
   SETCOLOR(WARN_COLOR)
   @ 24,0 CLEAR TO 24,79
   @ 24,40-LEN(cMSG)/2 SAY cMSG
   CLEAR TYPEAHEAD
   INKEY(0)
ENDCASE
SETCURSOR(nCURSOR)
SETCOLOR(nCOLOR)
Return (Nil)

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
/*                      Program Abort Warning Message                       */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ERROR (cMSG)
TONE(900,2)
? "Expansion Set/Daemon Decks UPDATE Program                          Version " + VERSION
? "Copyright 1994, Bard's Quest Software, Inc.                 All Rights Reserved"
?
? cMSG
?
?
SET CURSOR ON
CLOSE ALL
CLEAR ALL
QUIT
Return (Nil)
