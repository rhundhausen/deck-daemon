#include "inkey.ch"

* Main Constants

#define PROG_NAME   "DAEMON.EXE"
#define BEEP_SHORT  TONE(1500,1)
#define BEEP_LONG   TONE(900,2)
#define DOLLAR_INC  0.5

* Mouse Contants

#define K_MOUSE1    715   /* Main Edits                     */
#define K_MOUSE2    716   /* Price, Increase                */
#define K_MOUSE3    717   /* Price, Decrease                */
#define K_MOUSE4    718   /* Trade, Toggle                  */
#define K_MOUSE5    719   /* Condition, Mint                */
#define K_MOUSE6    720   /* Condition, Near Mint           */
#define K_MOUSE7    721   /* Condition, Light Use           */
#define K_MOUSE8    722   /* Condition, Heavy Use           */
#define K_MOUSE9    723   /* Tournament, Open               */
#define K_MOUSE10   724   /* Tournament, Restricted         */
#define K_MOUSE11   725   /* Tournament, Banned             */
#define K_MOUSE12   726   /* Rarity, Common                 */
#define K_MOUSE13   727   /* Rarity, Uncommon               */
#define K_MOUSE14   728   /* Rarity, Rare                   */
#define K_MOUSE15   729   /* Quantity, Increase             */
#define K_MOUSE16   730   /* Quantity, Decrease             */
#define K_MOUSE17   731   /* All Done, OK                   */
#define K_MOUSE20   734   /* SUPPORT(), Row Select          */
#define K_MOUSE25   739   /* Printing, Deck Pick            */
#define K_MOUSE30   744   /* CARD_EDIT(), Row Select        */
#define K_MOUSE35   749   /* Decks Main TBROWSE, Row Select */
#define K_MOUSE40   754   /* DeckBuilder, Select/Add        */
#define K_MOUSE41   755   /* DeckBuilder, Select/Subtract   */
#define K_MOUSE45   759   /* Deck Statistics, Row Select    */
#define K_MOUSE50   764   /* Deck Random Draw, Row Select   */
#define K_MOUSE60   774   /* Main TBROWSE, Select/Add       */
#define K_MOUSE61   775   /* Main TBROWSE, Select/Subtract  */

* Filename Constants

#define TITLEPCX    "DAEMON.PCX"
#define PREVFILE    "PREVIEW.$$$"

* Box Drawing Constants

#define B_SINGLE    "ÚÄ¿³ÙÄÀ³"
#define B_DOUBLE    "ÉÍ»º¼ÍÈº"

* Color Variables

Static ALT_COLOR,  BK1_COLOR,  BK2_COLOR,  BK3_COLOR,  BUTT_COLOR, CLR_COLOR
Static CRD1_COLOR, CRD2_COLOR, CRD3_COLOR, CRD4_COLOR, CRD5_COLOR, MAIN_COLOR
Static NULL_COLOR, SHAD_COLOR, SHOW_COLOR, TALK_COLOR, TRIV_COLOR, WARN_COLOR
Static lCOLOR

* Main Variables

Static cMAINMENU, cPULLMENU, lNOFONT, cOUTPUT, nITEM, GETLIST := {}

* Mouse Variables

Static lINVENTORY := .F., lMOUSED, lPRESSED, nSELECTED, lFASTMOUSE := .F.

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                           Main Menu Functions                            */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function MAIN_BLOCK (cPARM1, cPARM2, cPARM3, cPARM4, cPARM5, cPARM6, cPARM7, cPARM8, cPARM9, cPARM10)
Local cSCREEN, cPARMS, lNOMOUSE := .F.
SET SCOREBOARD OFF
SET DELETED ON
SET CURSOR OFF
SETCANCEL(.F.)
SET EXACT ON
SET BELL OFF
SET WRAP ON

* Check Parameters

cPARMS     := IF(cPARM1 = Nil,"",UPPER(cPARM1))
cPARMS     := cPARMS + IF(cPARM2 = Nil,"",UPPER(cPARM2))
cPARMS     := cPARMS + IF(cPARM3 = Nil,"",UPPER(cPARM3))
cPARMS     := cPARMS + IF(cPARM4 = Nil,"",UPPER(cPARM4))
cPARMS     := cPARMS + IF(cPARM5 = Nil,"",UPPER(cPARM5))
cPARMS     := cPARMS + IF(cPARM6 = Nil,"",UPPER(cPARM6))
cPARMS     := cPARMS + IF(cPARM7 = Nil,"",UPPER(cPARM7))
cPARMS     := cPARMS + IF(cPARM8 = Nil,"",UPPER(cPARM8))
cPARMS     := cPARMS + IF(cPARM9 = Nil,"",UPPER(cPARM9))
cPARMS     := cPARMS + IF(cPARM10 = Nil,"",UPPER(cPARM10))
lCGA       := "CGA"$cPARMS
lCOLOR     := ! ("BW"$cPARMS)
lNOFONT    := ("NOFONT"$cPARMS .OR. ! FILE("FONT.EXE") .OR. lCGA)
lNOTITLE   := ("NOTITLE"$cPARMS .OR. ! FILE(TITLEPCX) .OR. lCGA)
lNOMOUSE   := "NOMOUSE"$cPARMS
lINVENTORY := "INVENTORY"$cPARMS
lLOWMEM    := "LOWMEMORY"$cPARMS
lNOBUTTONS := "NOBUTTONS"$cPARMS
lFASTMOUSE := "FASTMOUSE"$cPARMS
ALT_COLOR  := IF(lCOLOR,IF(lCGA,"W+/B,W+/N,,,GR+/B","W+/B,W+/N,,,GR+/B"),"W/N,N/W,,,W/N")
BK1_COLOR  := IF(lCOLOR,IF(lCGA,"B+/N"             ,"B+/N"             ),"W/N")
BK2_COLOR  := IF(lCOLOR,IF(lCGA,"W/N"              ,"W+/N"             ),"W/N")
BK3_COLOR  := IF(lCOLOR,IF(lCGA,"B/N"              ,"B/N"              ),"N/W")
BUTT_COLOR := IF(lCOLOR,IF(lCGA,"W+/N"             ,"N/W"              ),"W/N")
CRD1_COLOR := IF(lCOLOR,IF(lCGA,"N/GR"             ,"N/N*"             ),"W/N")
CRD2_COLOR := IF(lCOLOR,IF(lCGA,"GR+/GR"           ,"GR+/N*"           ),"W/N")
CRD3_COLOR := IF(lCOLOR,IF(lCGA,"W+/GR"            ,"W+/N*"            ),"W/N")
CRD4_COLOR := IF(lCOLOR,IF(lCGA,"W+/R"             ,"W+/R"             ),"W/N")
CRD5_COLOR := IF(lCOLOR,IF(lCGA,"BG/GR"            ,"BG/N*"            ),"W/N")
CLR_COLOR  := IF(lCOLOR,IF(lCGA,"W+/B"             ,"W+/B*"            ),"W/N")
MAIN_COLOR := IF(lCOLOR,IF(lCGA,"N/W,W+/N,,,B+/W"  ,"N/W*,W+/N,,,B+/W*"),"N/W,W/N,,,N/W")
NULL_COLOR := IF(lCOLOR,IF(lCGA,"N/N"              ,"N/N"              ),"N/N")
SHAD_COLOR := IF(lCOLOR,IF(lCGA,"W/N"              ,"W/N"              ),"W/N")
SHOW_COLOR := IF(lCOLOR,IF(lCGA,"B+/W"             ,"B+/W*"            ),"N/W,W/N")
TALK_COLOR := IF(lCOLOR,IF(lCGA,"W/B"              ,"W/B"              ),"W/N")
TRIV_COLOR := IF(lCOLOR,IF(lCGA,"GR+/B"            ,"GR+/B"            ),"W/N,N/W")
WARN_COLOR := IF(lCOLOR,IF(lCGA,"W+/R"             ,"W+/R"             ),"N/W,W/N")

* Check to see if disk(ette) is writeable

IF ! GOODPATH("DAEMON.$$$")
   TONE(900,2)
   ? "   Error : Disk is write protected or out of space."
   ?
   SET CURSOR ON
   Return (Nil)
ENDIF

* Check to see if databases exist

IF ! FILE("DAEMON0.DD") .OR. ! FILE("DAEMON1.DD") .OR. ! FILE("DAEMON2.DD") .OR. ! FILE("DAEMON3.DD") .OR. ! FILE("DAEMON4.DD")
   TONE(900,2)
   ? "   Error : Data File(s) missing.  Please re-install Deck Daemon."
   ?
   SET CURSOR ON
   Return (Nil)
ENDIF

* Check for Mouse

lMOUSED := ! lNOMOUSE .AND. DC_MOUPRESENT()
IF lMOUSED
   DC_MOUINITIALIZE()
ENDIF

* Title Screen

IF ! lNOTITLE
   SETCOLOR(NULL_COLOR)
   @ 0,0 CLEAR
   DC_PAUSE(.4)
   FINDVIDEOMODE(640,480,16)
   SHOWPCX(TITLEPCX)
   INKEY(5)
   CLEARWIN(0,0,8,0,0,60,80)
   TEXTMODE()
   IF ! lNOFONT
      IF lLOWMEM
         SWPRUNCMD("FONT.EXE",0)
      ELSE
         RUN("FONT.EXE")
      ENDIF
   ENDIF
   SETCOLOR(NULL_COLOR)
   @ 0,0 CLEAR
   SET CURSOR ON
   SET CURSOR OFF
   DC_PAUSE(.4)
ELSE
   IF ! lNOFONT
      IF lLOWMEM
         SWPRUNCMD("FONT.EXE",0)
      ELSE
         RUN("FONT.EXE")
      ENDIF
   ENDIF
   SET CURSOR ON
   SET CURSOR OFF
ENDIF

* Bring up Main Screen

IF lCOLOR
   RESTORE SCREEN FROM REPLICATE(CHR(219)+CHR(9),2000)
ELSE
   RESTORE SCREEN FROM REPLICATE(CHR(219)+CHR(0),2000)
ENDIF
SETCOLOR(MAIN_COLOR)
SETBLINK(lCGA)
@  0,0  SAY SPACE(80)
@ 24,0  SAY SPACE(80)
@  0,71 SAY DATE()
@ 24,64 SAY "DECK DAEMON 1.2"
@  0,69 SAY "³"
@ 24,62 SAY "³"
SAVE SCREEN TO cSCREEN
IF PREP_INDEX(.T.)
   RESTORE SCREEN FROM cSCREEN
   CARDS()
ENDIF
TEXTMODE()
SETBLINK(.T.)
SET CURSOR ON
SETCOLOR("W/N")
CLEAR SCREEN
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                            Maintain Inventory                            */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function CARDS
Local oTBROWSE, oTBROWSE2, nKEY, cSCREEN, cSCREEN2, cSCREEN3, nROW, nSUBOPT
Local nX, nAMT, cNEWSTR, cSEARCH, cTEMP, lTEMP, lHAPPY, lHAPPY2, cSCREEN2A
Local aBOUGHT := {}, aSOLD := {}, nREF, aCARDS[14][2], nCOLOR, nCOLUMN := 1
Local nSUBOPT2, nPAGE, nLINES, nPRINTED, cLSERIES, cLARTIST, nDECK, cDECK
Local nHAVECARDS, nTOTLCARDS, nNEEDCARDS, nSERIESHV, nSERIESTTL, cSERIESHV
Local cSERIESTTL, nTRADEABLE, nTOTLPURCH, nTOTLSALES, nMOSTPURCH, nMOSTSALES
Local cMOSTPURCH, cMOSTSALES, cDDESC, nSUBOPT2A, cFILL, nAMOUNT1, nAMOUNT2
Local lNECESSARY, nTEMP, nTOT2PURCH, nTOT2SALES
Local aCOLORS := { "N/B","G/B","BG/B","R/B","RB/B","GR/B","W/B","N+/B", ;
                   "B+/B","G+/B","BG+/B","R+/B","RB+/B","GR+/B","W+/B"  }

* Draw Screen

SETCOLOR(MAIN_COLOR)
ZBOX(2,1,22,77,BK1_COLOR,.T.)
@  0,2 SAY "View  Edit  Add  Copy  Order  Print  Support  Decks  Misc  Quit"
@  3,3 SAY "Series     Card Name/Description      Color      Type / Rarity      Cards"
@  4,3 SAY "ÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ"
IF lMOUSED
   SETCOLOR(SHOW_COLOR)
   @  4,77 SAY "T"
   @  5,77 SAY ""
   @  6,77 SAY ""
   @ 20,77 SAY ""
   @ 21,77 SAY ""
   @ 22,77 SAY "B"
   IF ! lNOBUTTONS
      SETCOLOR(BUTT_COLOR)
      @ 22,4  SAY " TOP "
      @ 22,12 SAY " PAGE  "
      @ 22,23 SAY " LINE  "
      @ 22,45 SAY " LINE  "
      @ 22,56 SAY " PAGE  "
      @ 22,67 SAY " BOTTOM "
   ENDIF
   SETCOLOR(MAIN_COLOR)
ENDIF
HELPIT("Press the first letter of the command on the top line.")

* Enable Mouse

IF lMOUSED
   DC_MOUSETPOS(0,0)
   lMOUSED := DC_MOUENABLE()
ENDIF

* Use databases

USE ("DAEMON0.DD") ALIAS INFO    NEW EXCLUSIVE
USE ("DAEMON1.DD") ALIAS CARDS   NEW EXCLUSIVE
SET INDEX TO ("DAEMON1A.DD"), ("DAEMON1B.DD"), ("DAEMON1C.DD"), ("DAEMON1D.DD"), ("DAEMON1E.DD")
USE ("DAEMON2.DD") ALIAS SUPPORT NEW EXCLUSIVE
SET INDEX TO ("DAEMON2A.DD")

* Begin TBrowse

SELECT CARDS
oTBROWSE := TBROWSEDB(5,2,21,76)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||IF(CARDS->UPDATED," ","  ")+CARDS->SERIES+"  "+CARD+" "+CARDS->COLOR+" "+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(CARDS->FLAGS,1)+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
DO WHILE .T.
   SETCOLOR(MAIN_COLOR)
   DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
   nSELECTED := oTBROWSE:ROWPOS
   nKEY      := IF(lMOUSED,MOUSEKEY(1),ASC(UPPER(CHR(INKEY(0)))))
   DO CASE
   CASE nKEY == K_DOWN
      oTBROWSE:DOWN()
   CASE nKEY == K_UP
      oTBROWSE:UP()
   CASE nKEY == K_PGDN
      oTBROWSE:PAGEDOWN()
   CASE nKEY == K_PGUP
      oTBROWSE:PAGEUP()
   CASE nKEY == K_HOME
      oTBROWSE:GOTOP()
   CASE nKEY == K_END
      oTBROWSE:GOBOTTOM()
   CASE ((nKEY == K_MOUSE60 .OR. nKEY == K_MOUSE61) .AND. oTBROWSE:ROWPOS <> nSELECTED)  && Mouse-Select
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()
   CASE ((nKEY == K_MOUSE60 .OR. nKEY == K_MOUSE61) .AND. oTBROWSE:ROWPOS = nSELECTED .AND. ! lINVENTORY)  && Mouse-View
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:STABILIZE()
      @ 0,1 SAY " View " COLOR BK2_COLOR
      CARD_VIEW(1)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == K_MOUSE60 .AND. oTBROWSE:ROWPOS = nSELECTED .AND. lINVENTORY)   && Mouse-Add
      IF CARDS->QUANTITY < 999 .AND. lINVENTORY
         BEEP_SHORT
         CARDS->QUANTITY++
         CARDS->UPDATED := .T.
         oTBROWSE:REFRESHCURRENT()
      ENDIF
   CASE (nKEY == K_MOUSE61 .AND. oTBROWSE:ROWPOS = nSELECTED .AND. lINVENTORY)   && Mouse-Minus
      IF CARDS->QUANTITY > 0 .AND. lINVENTORY
         BEEP_SHORT
         CARDS->QUANTITY--
         CARDS->UPDATED := .T.
         oTBROWSE:REFRESHCURRENT()
      ENDIF
   CASE (nKEY == K_ENTER .or. nKEY == 86)                       && View Card
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:STABILIZE()
      @ 0,1 SAY " View " COLOR BK2_COLOR
      CARD_VIEW(1)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 69                                             && Edit Card
      SAVE SCREEN TO cSCREEN
      IF lCOLOR
         RESTSCREEN(6,0,23,79,REPLICATE(CHR(219)+CHR(9),1440))
         @ 6,2 SAY REPLICATE("Ü",77) COLOR BK1_COLOR
      ELSE
         RESTSCREEN(6,0,23,79,REPLICATE(CHR(219)+CHR(0),1440))
      ENDIF
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM := 5
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      @ 0,7 SAY " Edit " COLOR BK2_COLOR
      CARDS->UPDATED := .T.
      CARD_EDIT(1)
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 65 .or. nKEY == K_INS)                            && Add Card
      SAVE SCREEN TO cSCREEN
      @ 0,13 SAY " Add " COLOR BK2_COLOR
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()

      * Create new, empty record

      SELECT CARDS
      SET ORDER TO
      nREF := 0
      GO BOTTOM
      DO WHILE (! BOF() .AND. nREF = 0)
         nREF := IF(DELETED(),nREF,REFERENCE)
         SKIP - 1
      ENDDO
      SET ORDER TO nCOLUMN
      APPEND BLANK
      CARDS->REFERENCE := (nREF + 1)
      CARDS->UPDATED   := .T.

      * Change screen

      @ 5,2 CLEAR TO 5,76
      IF lCOLOR
         RESTSCREEN(6,0,23,79,REPLICATE(CHR(219)+CHR(9),1440))
         @ 6,2 SAY REPLICATE("Ü",77) COLOR BK1_COLOR
      ELSE
         RESTSCREEN(6,0,23,79,REPLICATE(CHR(219)+CHR(0),1440))
      ENDIF
      CARD_EDIT(2)
      IF LASTKEY() == K_ESC
         SAVE SCREEN TO cSCREEN2
         ZWARN(24,"[Esc] Pressed : Do you want me to save this card? [Y/N]",3,"")
         IF (LASTKEY() = 78 .OR. LASTKEY() = 110)
            DELETE
         ENDIF
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:GOTOP()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 67                                        && Copy Card
      SAVE SCREEN TO cSCREEN
      IF lCOLOR
         RESTSCREEN(6,0,23,79,REPLICATE(CHR(219)+CHR(9),1440))
         @ 6,2 SAY REPLICATE("Ü",77) COLOR BK1_COLOR
      ELSE
         RESTSCREEN(6,0,23,79,REPLICATE(CHR(219)+CHR(0),1440))
      ENDIF
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM := 5
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      @ 0,18 SAY " Copy " COLOR BK2_COLOR
      COPY NEXT 1 TO ("DAEMON1A.DBF")

      * Find next reference number

      SELECT CARDS
      SET ORDER TO
      nREF := 0
      GO BOTTOM
      DO WHILE (! BOF() .AND. nREF = 0)
         nREF := IF(DELETED(),nREF,REFERENCE)
         SKIP - 1
      ENDDO
      SET ORDER TO nCOLUMN
      APPEND FROM ("DAEMON1A.DBF")
      ERASE ("DAEMON1A.DBF")
      CARDS->REFERENCE := (nREF + 1)
      CARDS->UPDATED   := .T.

      * Change screen

      CARD_EDIT(3)
      IF LASTKEY() == K_ESC
         SAVE SCREEN TO cSCREEN2
         ZWARN(24,"[Esc] Pressed : Do you want me to save this card? [Y/N]",3,"")
         IF (LASTKEY() = 78 .OR. LASTKEY() = 110)
            DELETE
         ENDIF
      ENDIF
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:GOTOP()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 80)                                            && Print
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      @ 0,31 SAY " Print " COLOR BK2_COLOR
      SETCOLOR(ALT_COLOR)
      ZBOX(2,27,10,42,BK2_COLOR,.F.)
      @ 3,28 SAY " My Card List "
      @ 4,28 SAY " Cards I Need "
      @ 5,28 SAY " All Cards    "
      @ 6,28 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      @ 7,28 SAY " Deck List    "
      @ 8,28 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      @ 9,28 SAY " Others ...   "
      nSUBOPT := 1
      lHAPPY  := .T.
      SAVE SCREEN TO cSCREEN2
      DO WHILE lHAPPY
         SETCOLOR(ALT_COLOR)
         RESTORE SCREEN FROM cSCREEN2
         @ 6,28 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
         @ 8,28 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
         IF lMOUSED
            DC_AT_PROMPT(3,28," My Card List ","")
            DC_AT_PROMPT(4,28," Cards I Need ","")
            DC_AT_PROMPT(5,28," All Cards    ","")
            DC_AT_PROMPT(7,28," Deck List    ","")
            DC_AT_PROMPT(9,28," Others ...   ","")
            nSUBOPT := DC_MENU_TO(nSUBOPT)
            IF nSUBOPT > 0
               SETCOLOR(MAIN_COLOR)
               @ 4,77  CLEAR TO 6,77
               @ 20,77 CLEAR TO 22,77
               @ 22,4  CLEAR TO 22,74
               SETCOLOR(ALT_COLOR)
            ENDIF
         ELSE
            @ 3,28 PROMPT " My Card List "
            @ 4,28 PROMPT " Cards I Need "
            @ 5,28 PROMPT " All Cards    "
            @ 7,28 PROMPT " Deck List    "
            @ 9,28 PROMPT " Others ...   "
            MENU TO nSUBOPT
         ENDIF
         DO CASE
         CASE nSUBOPT == 0
            lHAPPY := .F.
         CASE nSUBOPT == 1 .OR. nSUBOPT == 2 .OR. nSUBOPT == 3
            IF ADJUST(.T.)
               SELECT CARDS
               SET ORDER TO 1
               GO TOP
               nPAGE      := 0
               nLINES     := 0
               nPRINTED   := 0
               nTOTLCARDS := 0
               cLSERIES   := ""
               DO WHILE ! EOF()
                  IF nLINES = 0
                     DO CASE
                     CASE nSUBOPT == 1
                        HEADING(@nPAGE,"Cards You Own","")
                     CASE nSUBOPT == 2
                        HEADING(@nPAGE,"Cards You Do Not Own","")
                     CASE nSUBOPT == 3
                        HEADING(@nPAGE,"Complete Card Listing by Series","")
                     ENDCASE
                     nLINES := 11
                  ENDIF
                  IF (QUANTITY > 0 .AND. nSUBOPT = 1) .OR. (QUANTITY = 0 .AND. nSUBOPT = 2) .OR. nSUBOPT = 3
                     IF cLSERIES <> SERIES .OR. nLINES = 11
                        IF nLINES <> 11
                           ?
                           nLINES++
                        ENDIF
                        SELECT SUPPORT
                        SEEK "S"
                        IF FOUND()
                           DO WHILE (SUPPORT->TYPE = "S" .AND. ! EOF())
                              IF SUPPORT->SHORT = CARDS->SERIES
                                 ? IF(cOUTPUT = PREVFILE,"","  ") + NAME
                              ENDIF
                              SKIP
                           ENDDO
                        ENDIF
                        SELECT CARDS
                        ?
                        nLINES := nLINES + 2
                     ENDIF
                     IF nSUBOPT = 1
                        ? IF(cOUTPUT = PREVFILE,"","  ")
                        ?? CARD + "   " + COLOR + "   " + TYPE
                        ?? "(" + LEFT(FLAGS,1) + ")" + STR(QUANTITY,5) + " cards"
                     ELSE
                        ? IF(cOUTPUT = PREVFILE,"","  ")
                        ?? "   " + CARD + "   " + COLOR + "   " + TYPE + "   "
                        ?? IF(LEFT(FLAGS,1) = "R","Rare",IF(LEFT(FLAGS,1) = "U","Uncommon","Common"))
                     ENDIF
                     cLSERIES := SERIES
                     nLINES++
                     nPRINTED++
                     nTOTLCARDS := nTOTLCARDS + QUANTITY
                     IF nLINES > 50
                        ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                        nLINES := 0
                     ENDIF
                  ENDIF
                  SKIP
               ENDDO
               DO CASE
               CASE nPRINTED = 0 .AND. nSUBOPT = 1
                  ?
                  ? SPACE(IF(cOUTPUT = PREVFILE,26,28)) + "You Don't Own Any Cards"
               CASE nPRINTED = 0 .AND. nSUBOPT = 2
                  ?
                  ? SPACE(IF(cOUTPUT = PREVFILE,29,31)) + "You Own Each Card"
               CASE nPRINTED = 0 .AND. nSUBOPT = 3
                  ?
                  ? SPACE(IF(cOUTPUT = PREVFILE,30,32)) + "No Cards on File"
               CASE nPRINTED > 0 .AND. cOUTPUT = PREVFILE .AND. nSUBOPT = 1
                  ? "------------------------------" + SPACE(35) + "----------"
                  ? STR(nPRINTED,4) + " cards" + STR(nTOTLCARDS,59) + " cards"
               CASE nPRINTED > 0 .AND. cOUTPUT <> PREVFILE .AND. nSUBOPT = 1
                  ? "  ------------------------------" + SPACE(35) + "----------"
                  ? STR(nPRINTED,6) + " cards" + STR(nTOTLCARDS,59) + " cards"
               CASE nPRINTED > 0 .AND. cOUTPUT = PREVFILE .AND. nSUBOPT <> 1
                  ? "------------------------------"
                  ? STR(nPRINTED,4) + " cards"
               CASE nPRINTED > 0 .AND. cOUTPUT <> PREVFILE .AND. nSUBOPT <> 1
                  ? "  ------------------------------"
                  ? STR(nPRINTED,6) + " cards"
               ENDCASE
               END_DOC()
               SELECT CARDS
               SET ORDER TO nCOLUMN
            ENDIF
         CASE nSUBOPT == 4
            lHAPPY2 := .T.
            IF lMOUSED
               ZBOX(2,47,15,76,BK2_COLOR,.F.)
               @  3,75 SAY ""
               @ 12,75 SAY ""
               @ 13,48 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
               @ 14,48 SAY "    [Enter]   ù   [Esc]     "
               oTBROWSE2 := TBROWSEDB(3,48,12,73)
            ELSE
               ZBOX(2,47,15,74,BK2_COLOR,.F.)
               oTBROWSE2 := TBROWSEDB(3,48,14,73)
            ENDIF
            USE ("DAEMON3.DD") ALIAS DECKS    NEW EXCLUSIVE
            SET INDEX TO ("DAEMON3A.DD")
            USE ("DAEMON4.DD") ALIAS DECKLINK NEW EXCLUSIVE
            SET INDEX TO ("DAEMON4A.DD"), ("DAEMON4B.DD")
            SELECT DECKS
            oTBROWSE2:ADDCOLUMN(TBCOLUMNNEW("",{||" "+DECK+" "+IF(UPPER(TYPE) = "SIDEBOARD","(S) ",IF(UPPER(TYPE) = "TOURNAMENT","(T) ",IF(UPPER(TYPE) = "GRAND MELEE","(G) ","(O) ")))}))
            DO WHILE lHAPPY2
               DO WHILE ! oTBROWSE2:STABILIZE(); ENDDO
               nSELECTED := oTBROWSE2:ROWPOS
               nKEY      := IF(lMOUSED,MOUSEKEY(8),ASC(UPPER(CHR(INKEY(0)))))
               DO CASE
               CASE (nKEY == K_MOUSE25 .AND. oTBROWSE2:ROWPOS <> nSELECTED)  && Mouse-Select
                  lPRESSED := .T.
                  oTBROWSE2:ROWPOS := nSELECTED
                  oTBROWSE2:REFRESHALL()
               CASE nKEY == K_ENTER .or. (nKEY == K_MOUSE25 .AND. oTBROWSE2:ROWPOS = nSELECTED)
                  cDECK  := LTRIM(RTRIM(DECKS->DECK))
                  IF DECKS->TYPE = "Sideboard" .OR. DECKS->TYPE = "Open Deck"
                     cDDESC := LTRIM(RTRIM(DECKS->TYPE)) + " with "
                  ELSE
                     cDDESC := LTRIM(RTRIM(DECKS->TYPE)) + " Deck with "
                  ENDIF
                  cDDESC := cDDESC + LTRIM(STR(DECKS->WINS,3)) + " Wins and "
                  cDDESC := cDDESC + LTRIM(STR(DECKS->LOSSES,3)) + " Losses"
                  nDECK  := DECKS->NUMBER
                  IF ADJUST(.T.)

                     * First, gather cards

                     SELECT CARDS
                     SET ORDER TO 2
                     SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
                     COPY TO DAEMON1.TMP FOR DECKLINK->QUANTITY > 0
                     USE ("DAEMON1.TMP") ALIAS CARDTEMP NEW EXCLUSIVE
                     SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK

                     * Next, print list

                     GO TOP
                     nPAGE    := 0
                     nAMT     := 0
                     nLINES   := 0
                     nPRINTED := 0
                     DO WHILE ! EOF()
                        IF nLINES = 0
                           HEADING(nPAGE,"Deck Listing : "+cDECK,cDDESC)
                           nLINES := 13
                        ENDIF
                        IF cOUTPUT = PREVFILE
                           ? CARD + " " + SERIES + " " + COLOR + " " + TYPE
                           ?? "(" + LEFT(FLAGS,1) + ")" + STR(DECKLINK->QUANTITY,4) + " cards"
                        ELSE
                           ? "  " + CARD + " " + SERIES + " " + COLOR + " " + TYPE
                           ?? "(" + LEFT(FLAGS,1) + ")" + STR(DECKLINK->QUANTITY,5) + " cards"
                        ENDIF
                        nAMT := nAMT + DECKLINK->QUANTITY
                        nLINES++
                        nPRINTED++
                        IF nLINES > 50
                           ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                           nLINES := 0
                        ENDIF
                        SKIP
                     ENDDO
                     DO CASE
                     CASE nPRINTED = 0
                        ?
                        ? SPACE(IF(cOUTPUT = PREVFILE,30,32)) + "No Cards in Deck"
                     CASE nPRINTED > 0 .AND. cOUTPUT = PREVFILE
                        ? "------------------------------" + SPACE(35) + "----------"
                        ? STR(nPRINTED,4) + " Different Cards" + STR(nAMT,49) + " Total"
                     CASE nPRINTED > 0 .AND. cOUTPUT <> PREVFILE
                        ? "  ------------------------------" + SPACE(36) + "----------"
                        ? STR(nPRINTED,6) + " Different Cards" + STR(nAMT,50) + " Total"
                     ENDCASE
                     END_DOC()
                     CLOSE CARDTEMP
                     ERASE ("DAEMON1.TMP")
                  ENDIF
                  lHAPPY2 := .F.
               CASE nKEY == K_ESC
                  lHAPPY2 := .F.
               CASE nKEY == K_DOWN
                  oTBROWSE2:DOWN()
               CASE nKEY == K_UP
                  oTBROWSE2:UP()
               CASE nKEY == K_PGDN
                  oTBROWSE2:PAGEDOWN()
               CASE nKEY == K_PGUP
                  oTBROWSE2:PAGEUP()
               CASE nKEY == K_HOME
                  oTBROWSE2:GOTOP()
               CASE nKEY == K_END
                  oTBROWSE2:GOBOTTOM()
               ENDCASE
            ENDDO
            CLOSE DECKS
            CLOSE DECKLINK
            SELECT CARDS
            SET ORDER TO nCOLUMN
         CASE nSUBOPT == 5
            SAVE SCREEN TO cSCREEN2A
            ZBOX(2,47,15,69,BK2_COLOR,.F.)
            @  3,48 SAY " A. Cards for Trade  "
            @  4,48 SAY " B. Multiple Cards   "
            @  5,48 SAY " C. Expensive Cards  "
            @  6,48 SAY " D. Valuable  Cards  "
            @  7,48 SAY " E. Cards by Artist  "
            @  8,48 SAY " F. RESTRICTED Cards "
            @  9,48 SAY " G. BANNED Cards     "
            @ 10,48 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
            @ 11,48 SAY " H. Series Listing   "
            @ 12,48 SAY " I. Types Listing    "
            @ 13,48 SAY " J. Artists Listing  "
            @ 14,48 SAY " K. Dealers Listing  "
            SAVE SCREEN TO cSCREEN3
            nSUBOPT2 := 1
            lHAPPY2  := .T.
            DO WHILE lHAPPY2
               SETCOLOR(ALT_COLOR)
               RESTORE SCREEN FROM cSCREEN3
               @ 10,48 SAY    "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
               IF lMOUSED
                  DC_AT_PROMPT( 3,48," A. Cards for Trade  ","")
                  DC_AT_PROMPT( 4,48," B. Multiple Cards   ","")
                  DC_AT_PROMPT( 5,48," C. Expensive Cards  ","")
                  DC_AT_PROMPT( 6,48," D. Valuable  Cards  ","")
                  DC_AT_PROMPT( 7,48," E. Cards by Artist  ","")
                  DC_AT_PROMPT( 8,48," F. RESTRICTED Cards ","")
                  DC_AT_PROMPT( 9,48," G. BANNED Cards     ","")
                  DC_AT_PROMPT(11,48," H. Series Listing   ","")
                  DC_AT_PROMPT(12,48," I. Types Listing    ","")
                  DC_AT_PROMPT(13,48," J. Artists Listing  ","")
                  DC_AT_PROMPT(14,48," K. Dealers Listing  ","")
                  nSUBOPT2 := DC_MENU_TO(nSUBOPT2)
               ELSE
                  @  3,48 PROMPT " A. Cards for Trade  "
                  @  4,48 PROMPT " B. Multiple Cards   "
                  @  5,48 PROMPT " C. Expensive Cards  "
                  @  6,48 PROMPT " D. Valuable  Cards  "
                  @  7,48 PROMPT " E. Cards by Artist  "
                  @  8,48 PROMPT " F. RESTRICTED Cards "
                  @  9,48 PROMPT " G. BANNED Cards     "
                  @ 11,48 PROMPT " H. Series Listing   "
                  @ 12,48 PROMPT " I. Types Listing    "
                  @ 13,48 PROMPT " J. Artists Listing  "
                  @ 14,48 PROMPT " K. Dealers Listing  "
                  MENU TO nSUBOPT2
               ENDIF
               IF nSUBOPT2 = 0
                  lHAPPY2 := .F.
               ELSE
                  IF nSUBOPT2 = 3 .OR. nSUBOPT2 = 4
                     SETCOLOR(MAIN_COLOR)
                     ZBOX(7,49,14,67,BK3_COLOR,.F.)
                     @ 12,50 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
                     nSUBOPT2A := 1
                     nAMOUNT1  := 0
                     nAMOUNT2  := 0
                     IF lMOUSED
                        DC_AT_PROMPT( 8,50," A. Top 10 Cards ","")
                        DC_AT_PROMPT( 9,50," B. Top 25 Cards ","")
                        DC_AT_PROMPT(10,50," C. Top 50 Cards ","")
                        DC_AT_PROMPT(11,50," D. By $ Amount  ","")
                        DC_AT_PROMPT(13,50," E. All Non-Zero ","")
                        nSUBOPT2A := DC_MENU_TO(nSUBOPT2A)
                     ELSE
                        @  8,50 PROMPT " A. Top 10 Cards "
                        @  9,50 PROMPT " B. Top 25 Cards "
                        @ 10,50 PROMPT " C. Top 50 Cards "
                        @ 11,50 PROMPT " D. By $ Amount  "
                        @ 13,50 PROMPT " E. All Non-Zero "
                        MENU TO nSUBOPT2A
                     ENDIF
                     IF nSUBOPT2A = 4
                        SETCOLOR(MAIN_COLOR)
                        @  8,50 CLEAR TO 13,66
                        @  8,50 SAY "  Enter $ Range  "
                        @ 10,51 SAY "from $" GET nAMOUNT1 PICTURE "9999.99"
                        @ 12,51 SAY "to   $" GET nAMOUNT2 PICTURE "9999.99"
                        SET CURSOR ON
                        IF lMOUSED
                           DC_READMODAL(GETLIST); GETLIST := {}
                        ELSE
                           READ
                        ENDIF
                        SET CURSOR OFF
                        IF nAMOUNT2 < nAMOUNT1
                           nTEMP    := nAMOUNT1
                           nAMOUNT1 := nAMOUNT2
                           nAMOUNT2 := nTEMP
                        ENDIF
                     ENDIF
                     RESTORE SCREEN FROM cSCREEN2A
                  ENDIF
                  IF ADJUST(nSUBOPT2 < 8)
                     nPAGE    := 0
                     nPRINTED := 0
                     DO CASE
                     CASE nSUBOPT2 = 1
                        SELECT CARDS
                        SET ORDER TO 1
                        GO TOP
                        nLINES := 0
                        cLSERIES := ""
                        DO WHILE ! EOF()
                           IF nLINES = 0
                              HEADING(@nPAGE,"Cards Open for Trade","")
                              nLINES := 11
                           ENDIF
                           IF SUBSTR(FLAGS,4,1) = "T"

                              IF cLSERIES <> SERIES .OR. nLINES = 11
                                 IF nLINES <> 11
                                    ?
                                    nLINES++
                                 ENDIF
                                 SELECT SUPPORT
                                 SEEK "S"
                                 IF FOUND()
                                    DO WHILE (SUPPORT->TYPE = "S" .AND. ! EOF())
                                       IF SUPPORT->SHORT = CARDS->SERIES
                                          ? IF(cOUTPUT = PREVFILE,"","  ") + NAME
                                       ENDIF
                                       SKIP
                                    ENDDO
                                 ENDIF
                                 SELECT CARDS
                                 ?
                                 nLINES := nLINES + 2
                              ENDIF
                              IF cOUTPUT = PREVFILE
                                 ? "   " + CARD + "   " + COLOR + "   " + TYPE + "   "
                                 ?? IF(LEFT(FLAGS,1) = "R","Rare",IF(LEFT(FLAGS,1) = "U","Uncommon","Common"))
                              ELSE
                                 ? "     " + CARD + "   " + COLOR + "   " + TYPE + "   "
                                 ?? IF(LEFT(FLAGS,1) = "R","Rare",IF(LEFT(FLAGS,1) = "U","Uncommon","Common"))
                              ENDIF
                              nLINES++
                              nPRINTED++
                              cLSERIES := SERIES
                              IF nLINES > 50
                                 ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                                 nLINES := 0
                              ENDIF
                           ENDIF
                           SKIP
                        ENDDO
                        IF nPRINTED = 0
                           ?
                           ? SPACE(IF(cOUTPUT = PREVFILE,26,28)) + "No Cards Open for Trade"
                        ENDIF
                     CASE nSUBOPT2 = 2
                        SELECT CARDS
                        INDEX ON STR(999 - QUANTITY,6,2) + UPPER(SERIES + CARD) TO ("DAEMON1Z.DD")
                        GO TOP
                        nLINES   := 0
                        nPRINTED := 0
                        HEADING(nPAGE,"Multiple Card Listing","")
                        DO WHILE ! EOF() .AND. QUANTITY > 1 .AND. nLINES < 40
                           IF cOUTPUT = PREVFILE
                              ? SERIES + " " + CARD + " " + COLOR + " " + TYPE
                              ?? "(" + LEFT(FLAGS,1) + ")" + STR(QUANTITY,4) + " cards"
                           ELSE
                              ? "  " + SERIES + " " + CARD + " " + COLOR + " " + TYPE
                              ?? "(" + LEFT(FLAGS,1) + ")" + STR(QUANTITY,5) + " cards"
                           ENDIF
                           nLINES++
                           nPRINTED++
                           SKIP
                        ENDDO
                        IF nPRINTED = 0
                           ?
                           ? SPACE(IF(cOUTPUT = PREVFILE,29,31)) + "No Multiple Cards"
                        ENDIF
                        SELECT CARDS
                        SET INDEX TO ("DAEMON1A.DD"), ("DAEMON1B.DD"), ("DAEMON1C.DD"), ("DAEMON1D.DD"), ("DAEMON1E.DD")
                        ERASE ("DAEMON1Z.DD")
                     CASE (nSUBOPT2 = 3 .OR. nSUBOPT2 = 4)
                        SELECT CARDS
                        IF nSUBOPT2 = 3
                           INDEX ON STR(999.99 - BUY_PRICE,6,2) + UPPER(SERIES + CARD) TO ("DAEMON1Z.DD")
                           cFILL := "Most Expensive Cards Bought"
                        ELSE
                           INDEX ON STR(999.99 - SOLD_PRICE,6,2) + UPPER(SERIES + CARD) TO ("DAEMON1Z.DD")
                           cFILL := "Most Valuable Cards Sold"
                        ENDIF

                        * Custom Heading for Submenu Items

                        DO CASE
                        CASE nSUBOPT2A = 1
                           cFILL := "Top 10 " + cFILL
                        CASE nSUBOPT2A = 2
                           cFILL := "Top 25 " + cFILL
                        CASE nSUBOPT2A = 3
                           cFILL := "Top 50 " + cFILL
                        CASE nSUBOPT2A = 4 .AND. nSUBOPT2 = 3
                           cFILL := " Cards Bought Between $ " + LTRIM(STR(nAMOUNT1,7,2)) + " and $ " + LTRIM(STR(nAMOUNT2,7,2))
                        CASE nSUBOPT2A = 4 .AND. nSUBOPT2 = 4
                           cFILL := " Cards Sold Between $ " + LTRIM(STR(nAMOUNT1,7,2)) + " and $ " + LTRIM(STR(nAMOUNT2,7,2))
                        ENDCASE
                        HEADING(nPAGE,cFILL,"")
                        GO TOP
                        nLINES     := 0
                        nPRINTED   := 0
                        lNECESSARY := .T.
                        DO WHILE ! EOF() .AND. IF(nSUBOPT2 = 3,BUY_PRICE,SOLD_PRICE) > 0 .AND. lNECESSARY
                           IF (IF(nSUBOPT2 = 3,BUY_PRICE,SOLD_PRICE) >= nAMOUNT1 .AND. IF(nSUBOPT2 = 3,BUY_PRICE,SOLD_PRICE) <= nAMOUNT2) .OR. nSUBOPT2A <> 4
                              IF cOUTPUT = PREVFILE
                                 ?  SERIES + " " + CARD + " " + COLOR + " " + TYPE + " ("
                                 ?? LEFT(FLAGS,1) + ") $"
                                 ?? STR(IF(nSUBOPT2 = 3,BUY_PRICE,SOLD_PRICE),7,2)
                              ELSE
                                 ? "  " + SERIES + " " + CARD + " " + COLOR + " " + TYPE + " ("
                                 ?? LEFT(FLAGS,1) + ")  $"
                                 ?? STR(IF(nSUBOPT2 = 3,BUY_PRICE,SOLD_PRICE),7,2)
                              ENDIF

                            * Check for page break

                              nLINES++
                              nPRINTED++
                              IF nLINES > 50
                                 ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                                 HEADING(nPAGE,cFILL,"")
                                 nLINES := 0
                              ENDIF

                            * Check for Number Met

                              DO CASE
                              CASE nSUBOPT2A = 1
                                 lNECESSARY := nPRINTED < 10
                              CASE nSUBOPT2A = 2
                                 lNECESSARY := nPRINTED < 25
                              CASE nSUBOPT2A = 3
                                 lNECESSARY := nPRINTED < 50
                              ENDCASE

                           ENDIF
                           SKIP
                        ENDDO
                        IF nPRINTED = 0 .AND. nSUBOPT2 = 3
                           ?
                           IF nSUBOPT2A = 4
                              ? SPACE(IF(cOUTPUT = PREVFILE,13,15)) + "No Cards Have Been Purchased in that Price Range"
                           ELSE
                              ? SPACE(IF(cOUTPUT = PREVFILE,23,25)) + "No Cards Have Been Purchased"
                           ENDIF
                        ENDIF
                        IF nPRINTED = 0 .AND. nSUBOPT2 = 4
                           ?
                           IF nSUBOPT2A = 4
                              ? SPACE(IF(cOUTPUT = PREVFILE,15,17)) + "No Cards Have Been Sold in that Price Range"
                           ELSE
                              ? SPACE(IF(cOUTPUT = PREVFILE,26,28)) + "No Cards Have Been Sold"
                           ENDIF
                        ENDIF
                        SELECT CARDS
                        SET INDEX TO ("DAEMON1A.DD"), ("DAEMON1B.DD"), ("DAEMON1C.DD"), ("DAEMON1D.DD"), ("DAEMON1E.DD")
                        ERASE ("DAEMON1Z.DD")
                     CASE nSUBOPT2 = 5
                        SELECT CARDS
                        INDEX ON UPPER(ARTIST) + UPPER(SERIES + CARD) TO ("DAEMON1Z.DD")
                        GO TOP
                        nLINES   := 0
                        cLARTIST := ""
                        DO WHILE ! EOF()
                           IF ! EMPTY(ARTIST)
                              IF nLINES = 0
                                 HEADING(@nPAGE,"Cards by Artist","")
                                 nLINES := 11
                              ENDIF
                              IF cLARTIST <> NOCOMMA(ARTIST) .OR. nLINES = 11
                                 IF nLINES <> 11
                                    ?
                                    nLINES++
                                 ENDIF
                                 ? IF(cOUTPUT = PREVFILE,"","  ") + NOCOMMA(ARTIST)
                                 ?
                                 nLINES := nLINES + 2
                              ENDIF
                              IF cOUTPUT = PREVFILE
                                 ? SERIES + " " + CARD + " " + COLOR + " " + TYPE
                                 ?? "(" + LEFT(FLAGS,1) + ")" + STR(QUANTITY,4) + " cards"
                              ELSE
                                 ? "  " + SERIES + " " + CARD + " " + COLOR + " " + TYPE
                                 ?? "(" + LEFT(FLAGS,1) + ")" + STR(QUANTITY,5) + " cards"
                              ENDIF
                              cLARTIST := NOCOMMA(ARTIST)
                              nLINES++
                              IF nLINES > 50
                                 ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                                 nLINES := 0
                              ENDIF
                           ENDIF
                           SKIP
                        ENDDO
                        SELECT CARDS
                        SET INDEX TO ("DAEMON1A.DD"), ("DAEMON1B.DD"), ("DAEMON1C.DD"), ("DAEMON1D.DD"), ("DAEMON1E.DD")
                        ERASE ("DAEMON1Z.DD")
                     CASE (nSUBOPT2 = 6 .OR. nSUBOPT2 = 7)
                        SELECT CARDS
                        SET ORDER TO 1
                        GO TOP
                        nLINES   := 0
                        cLSERIES := ""
                        DO WHILE ! EOF()
                           IF SUBSTR(FLAGS,3,1) = IF(nSUBOPT2 = 6,"R","B")
                              IF nLINES = 0
                                 IF nSUBOPT2 = 6
                                    HEADING(@nPAGE,"RESTRICTED Cards","")
                                 ELSE
                                    HEADING(@nPAGE,"BANNED Cards","")
                                 ENDIF
                                 nLINES := 11
                              ENDIF
                              IF cLSERIES <> SERIES .OR. nLINES = 11
                                 IF nLINES <> 11
                                    ?
                                    nLINES++
                                 ENDIF
                                 SELECT SUPPORT
                                 SEEK "S"
                                 IF FOUND()
                                    DO WHILE (SUPPORT->TYPE = "S" .AND. ! EOF())
                                       IF SUPPORT->SHORT = CARDS->SERIES
                                          ? IF(cOUTPUT = PREVFILE,"","  ") + NAME
                                       ENDIF
                                       SKIP
                                    ENDDO
                                 ENDIF
                                 SELECT CARDS
                                 ?
                                 nLINES := nLINES + 2
                              ENDIF
                              ? IF(cOUTPUT = PREVFILE,"","  ")
                              ?? "   " + CARD + "   " + COLOR + "   " + TYPE + "   "
                              ?? IF(LEFT(FLAGS,1) = "R","Rare",IF(LEFT(FLAGS,1) = "U","Uncommon","Common"))
                              cLSERIES := SERIES
                              nLINES++
                              IF nLINES > 50
                                 ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                                 nLINES := 0
                              ENDIF
                           ENDIF
                           SKIP
                        ENDDO
                     CASE nSUBOPT2 = 8
                        HEADING(nPAGE,"Card Series Listing","")
                        SELECT SUPPORT
                        GO TOP
                        DO WHILE ! EOF()
                           IF TYPE == "S" .AND. ! EMPTY(NAME)
                              ? SPACE(31) + NAME
                           ENDIF
                           SKIP
                        ENDDO
                     CASE nSUBOPT2 = 9
                        HEADING(nPAGE,"Card Type Listing","")
                        SELECT SUPPORT
                        GO TOP
                        DO WHILE ! EOF()
                           IF TYPE == "T" .AND. ! EMPTY(NAME)
                              ? SPACE(IF(cOUTPUT = PREVFILE,29,31)) + NAME
                           ENDIF
                           SKIP
                        ENDDO
                     CASE nSUBOPT2 = 10
                        SELECT SUPPORT
                        GO TOP
                        nLINES := 0
                        DO WHILE ! EOF()
                           IF TYPE == "A" .AND. ! EMPTY(NAME)
                              IF nLINES = 0
                                 HEADING(@nPAGE,"Artist Listing","")
                                 nLINES := 11
                              ENDIF
                              ? SPACE(IF(cOUTPUT = PREVFILE,29,31)) + NAME
                              nLINES++
                              IF nLINES > 50
                                 ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                                 nLINES := 0
                              ENDIF
                           ENDIF
                           SKIP
                        ENDDO
                     CASE nSUBOPT2 = 11
                        SELECT SUPPORT
                        GO TOP
                        nLINES := 0
                        DO WHILE ! EOF()
                           IF TYPE == "D" .AND. ! EMPTY(NAME)
                              IF nLINES = 0
                                 HEADING(@nPAGE,"Card Dealer Listing","")
                                 nLINES := 11
                              ENDIF
                              ? SPACE(31) + NAME
                              nLINES++
                              IF nLINES > 50
                                 ? IF(cOUTPUT <> PREVFILE,CHR(12),"")
                                 nLINES := 0
                              ENDIF
                           ENDIF
                           SKIP
                        ENDDO
                     ENDCASE
                     END_DOC()
                     SELECT CARDS
                  ENDIF
               ENDIF
            ENDDO
         ENDCASE
      ENDDO
      oTBROWSE:AUTOLITE := .T.
      SET ORDER TO nCOLUMN
      oTBROWSE:GOTOP()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 79 .or. nKEY == K_TAB)                    && Change Order
      @ 0,24 SAY " Order " COLOR BK2_COLOR
      nCOLUMN := IF(nCOLUMN = 5,1,nCOLUMN + 1)
      DO CASE
      CASE nCOLUMN == 1
         @ 3,3  SAY "Series     Card Name/Description      Color      Type / Rarity      Cards"
         @ 4,3  SAY "ÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||IF(CARDS->UPDATED," ","  ")+CARDS->SERIES+"  "+CARDS->CARD+" "+CARDS->COLOR+" "+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(CARDS->FLAGS,1)+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
      CASE nCOLUMN == 2
         @ 3,3  SAY "    Card Name/Description      Series Color      Type / Rarity      Cards"
         @ 4,3  SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||IF(CARDS->UPDATED,""," ")+CARDS->CARD+"  "+CARDS->SERIES+"  "+CARDS->COLOR+" "+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(FLAGS,1)+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
      CASE nCOLUMN == 3
         @ 3,3  SAY "Color Series     Card Name/Description           Type / Rarity      Cards"
         @ 4,3  SAY "ÄÄÄÄÄ ÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||IF(CARDS->UPDATED,""," ")+CARDS->COLOR+"  "+CARDS->SERIES+"  "+CARDS->CARD+" "+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(FLAGS,1)+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
      CASE nCOLUMN == 4
         @ 3,3  SAY "     Type / Rarity      Series     Card Name/Description      Color Cards"
         @ 4,3  SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||IF(CARDS->UPDATED,""," ")+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(CARDS->FLAGS,1)+"  "+CARDS->SERIES+"  "+CARD+" "+COLOR+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
      CASE nCOLUMN == 5
         @ 3,3  SAY "Series Color     Card Name/Description           Type / Rarity      Cards"
         @ 4,3  SAY "ÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||IF(CARDS->UPDATED," ","  ")+CARDS->SERIES+"  "+CARDS->COLOR+" "+CARDS->CARD+" "+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(CARDS->FLAGS,1)+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
      ENDCASE
      SET ORDER TO nCOLUMN
      oTBROWSE:GOTOP()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      @ 0,24 SAY " Order " COLOR MAIN_COLOR
   CASE (nKEY == 83)                                       && Support Tables
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      @ 0,38 SAY " Support " COLOR BK2_COLOR
      SETCOLOR(ALT_COLOR)
      ZBOX(2,37,8,47,BK2_COLOR,.F.)
      nSUBOPT := 1
      lHAPPY := .T.
      SAVE SCREEN TO cSCREEN2
      DO WHILE lHAPPY
         SETCOLOR(ALT_COLOR)
         RESTORE SCREEN FROM cSCREEN2
         IF lMOUSED
            DC_AT_PROMPT(3,38," Colors  ","")
            DC_AT_PROMPT(4,38," Series  ","")
            DC_AT_PROMPT(5,38," Types   ","")
            DC_AT_PROMPT(6,38," Artists ","")
            DC_AT_PROMPT(7,38," Dealers ","")
            nSUBOPT := DC_MENU_TO(nSUBOPT)
            IF nSUBOPT > 0
               SETCOLOR(MAIN_COLOR)
               @ 4,77  CLEAR TO 6,77
               @ 20,77 CLEAR TO 22,77
               @ 22,4  CLEAR TO 22,74
               SETCOLOR(ALT_COLOR)
            ENDIF
         ELSE
            @ 3,38 PROMPT " Colors  "
            @ 4,38 PROMPT " Series  "
            @ 5,38 PROMPT " Types   "
            @ 6,38 PROMPT " Artists "
            @ 7,38 PROMPT " Dealers "
            MENU TO nSUBOPT
         ENDIF
         DO CASE
         CASE nSUBOPT == 0
            lHAPPY := .F.
         CASE nSUBOPT == 1
            SUPPORT("C",0)
         CASE nSUBOPT == 2
            SUPPORT("S",0)
         CASE nSUBOPT == 3
            SUPPORT("T",0)
         CASE nSUBOPT == 4
            SUPPORT("A",0)
         CASE nSUBOPT == 5
            SUPPORT("D",0)
         ENDCASE
      ENDDO
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 68)                                       && Deck Maintenance
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      @ 0,47 SAY " Decks " COLOR BK2_COLOR
      DECKS()
      SELECT CARDS
      SET ORDER TO nCOLUMN
      oTBROWSE:GOTOP()
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 77)                                       && Misc. Functions
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      @ 0,54 SAY " Misc " COLOR BK2_COLOR
      SAVE SCREEN TO cSCREEN2
      SETCOLOR(ALT_COLOR)
      ZBOX(2,49,13,64,BK2_COLOR,.F.)
      IF lMOUSED
         DC_AT_PROMPT( 3,50," Locate Card  ","")
         DC_AT_PROMPT( 4,50," View Graphic ","")
         DC_AT_PROMPT( 5,50," Erase Card   ","")
         DC_AT_PROMPT( 6,50," Pack Cards   ","")
         DC_AT_PROMPT( 7,50," Increase [+] ","")
         DC_AT_PROMPT( 8,50," Decrease [-] ","")
         DC_AT_PROMPT( 9,50," Reset Cards  ","")
         DC_AT_PROMPT(10,50," User Info    ","")
         DC_AT_PROMPT(11,50," Trivia       ","")
         DC_AT_PROMPT(12,50," About        ","")
         nSUBOPT := 1
         nSUBOPT := DC_MENU_TO(nSUBOPT)
      ELSE
         @  3,50 PROMPT " Locate Card  "
         @  4,50 PROMPT " View Graphic "
         @  5,50 PROMPT " Erase Card   "
         @  6,50 PROMPT " Pack Cards   "
         @  7,50 PROMPT " Increase [+] "
         @  8,50 PROMPT " Decrease [-] "
         @  9,50 PROMPT " Reset Cards  "
         @ 10,50 PROMPT " User Info    "
         @ 11,50 PROMPT " Trivia       "
         @ 12,50 PROMPT " About        "
         nSUBOPT := 1
         MENU TO nSUBOPT
      ENDIF
      RESTORE SCREEN FROM cSCREEN2
      DO CASE
      CASE nSUBOPT == 1
         cSEARCH := SPACE(20)
         SETCOLOR(ALT_COLOR)
         ZBOX(11,13,13,66,BK2_COLOR,.F.)
         @ 12,15 SAY "What card are you looking for" GET cSEARCH
         SET CURSOR ON
         IF lMOUSED
            DC_READMODAL(GETLIST); GETLIST := {}
         ELSE
            READ
         ENDIF
         SET CURSOR OFF
         RESTORE SCREEN FROM cSCREEN
         IF LASTKEY() <> 27 .AND. ! EMPTY(cSEARCH)
            nCOLUMN := 2
            SETCOLOR(MAIN_COLOR)
            @ 3,3  SAY "    Card Name/Description      Series Color      Type / Rarity      Cards"
            @ 4,3  SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ"
            oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||IF(CARDS->UPDATED,""," ")+CARDS->CARD+"  "+CARDS->SERIES+"  "+CARDS->COLOR+" "+CARDS->TYPE+" "+IF(EMPTY(LEFT(CARDS->FLAGS,1))," ","ù")+LEFT(CARDS->FLAGS,1)+TRANSFORM(CARDS->QUANTITY,"@Z 99999")+"  "}))
            SET ORDER TO nCOLUMN
            SET SOFTSEEK ON
            SEEK UPPER(LTRIM(RTRIM(cSEARCH)))
         ENDIF
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
      CASE nSUBOPT == 2                                    && View Graphic
         IF FILE("CARD" + ZPAD(CARDS->REFERENCE,4) + ".PCX")
            SETCOLOR(NULL_COLOR)
            @ 0,0 CLEAR
            DC_PAUSE(.4)
            FINDVIDEOMODE(640,480,16)
            SHOWPCX("CARD" + ZPAD(CARDS->REFERENCE,4) + ".PCX")
            INKEY(0)
            TEXTMODE()
            IF ! lNOFONT
               IF lLOWMEM
                  SWPRUNCMD("FONT.EXE",0)
               ELSE
                  RUN("FONT.EXE")
               ENDIF
            ENDIF
            SET CURSOR ON
            SET CURSOR OFF
            DC_PAUSE(.4)
            SETBLINK(lCGA)
         ELSE
            SETCOLOR(ALT_COLOR)
            ZBOX(10,13,15,66,BK2_COLOR,.F.)
            @ 12,15 SAY "Sorry : Graphics image not found or not supported."
            PAUSE(14,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         ENDIF
         SETCOLOR(MAIN_COLOR)
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
         RESTORE SCREEN FROM cSCREEN
      CASE nSUBOPT == 3                                    && Erase a card
         RESTORE SCREEN FROM cSCREEN
         SETCOLOR(MAIN_COLOR)
         @ 4,2  CLEAR TO 6,77
         @ 22,4 CLEAR TO 22,74
         IF lCOLOR
            RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
            @ 7,2 SAY REPLICATE("Ü",77) COLOR BK1_COLOR
         ELSE
            RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(0),1360))
         ENDIF
         nROW := oTBROWSE:ROWPOS
         oTBROWSE:NBOTTOM := 5
         oTBROWSE:REFRESHALL()
         oTBROWSE:STABILIZE()
         SETCOLOR(MAIN_COLOR)
         ZBOX(13,20,15,57,BK1_COLOR,.T.)
         IF lMOUSED
            @ 14,22 SAY "Shall I ERASE this card?     /    "
            @ 14,47 SAY " Y " COLOR BUTT_COLOR
            @ 14,53 SAY " N " COLOR BUTT_COLOR
         ELSE
            @ 14,22 SAY "Shall I ERASE this card? [Y] / [N]"
         ENDIF
         nKEY2 := IF(lMOUSED,MOUSEKEY(2),INKEY(0))
         RESTORE SCREEN FROM cSCREEN
         IF nKEY2 == 89 .or. nKEY2 == 121
            nREF := REFERENCE

            * Erase from decks

            USE ("DAEMON4.DD") ALIAS DECKLINK NEW EXCLUSIVE
            SET INDEX TO ("DAEMON4A.DD"), ("DAEMON4B.DD")
            SET ORDER TO
            DELETE FOR (CARD = nREF)
            CLOSE DECKLINK

            * Erase main card

            SELECT CARDS
            DELETE
            IF oTBROWSE:ROWPOS = 1
               SKIP 1
               IF EOF()
                  SKIP -1
               ENDIF
            ENDIF
            oTBROWSE:NBOTTOM  := 21
            oTBROWSE:AUTOLITE := .T.
            oTBROWSE:REFRESHALL()
            oTBROWSE:REFRESHCURRENT()
         ELSE
            oTBROWSE:NBOTTOM  := 21
            oTBROWSE:AUTOLITE := .T.
            oTBROWSE:ROWPOS   := nROW
            oTBROWSE:CONFIGURE()
            oTBROWSE:REFRESHALL()
            oTBROWSE:REFRESHCURRENT()
         ENDIF
      CASE nSUBOPT == 4                                    && Pack Card List
         HELPIT("Press [ESC] to abort or any other key to continue")
         SETCOLOR(ALT_COLOR)
         ZBOX(4,10,16,69,BK2_COLOR,.F.)
         @  5,30 SAY "Packing the Card List"
         @  7,12 SAY "This command packs your card list by physically removing"
         @  8,12 SAY "all cards that you've told it to ERASE.  This command   "
         @  9,12 SAY "also attempts to correct any corruption that you may be "
         @ 10,12 SAY "experiencing.  It is usually not necessary to run this  "
         @ 11,12 SAY "command unless you need to reclaim your hard drive space"
         @ 12,12 SAY "or if you have experienced an abnormal system shutdown  "
         @ 13,12 SAY "and have found corrupted information.                   "
         PAUSE(15,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         IF LASTKEY() <> K_ESC
            CLOSE ALL
            ZWARN(19,"Please Wait : Packing the Card List",2,BK2_COLOR)
            SET CURSOR ON
            USE ("DAEMON1.DD") NEW EXCLUSIVE
            PACK
            CLOSE
            ERASE ("DAEMON1A.DD")
            ERASE ("DAEMON1B.DD")
            ERASE ("DAEMON1C.DD")
            ERASE ("DAEMON1D.DD")
            ERASE ("DAEMON1E.DD")
            USE ("DAEMON2.DD") NEW EXCLUSIVE
            PACK
            CLOSE
            ERASE ("DAEMON2A.DD")
            USE ("DAEMON3.DD") NEW EXCLUSIVE
            PACK
            CLOSE
            ERASE ("DAEMON3A.DD")
            USE ("DAEMON4.DD") NEW EXCLUSIVE
            PACK
            CLOSE
            ERASE ("DAEMON4A.DD")
            ERASE ("DAEMON4B.DD")
            PREP_INDEX(.F.)
            oTBROWSE:AUTOLITE := .T.

            * Reopen databases

            USE ("DAEMON0.DD") ALIAS INFO    NEW EXCLUSIVE
            USE ("DAEMON1.DD") ALIAS CARDS   NEW EXCLUSIVE
            SET INDEX TO ("DAEMON1A.DD"), ("DAEMON1B.DD"), ("DAEMON1C.DD"), ("DAEMON1D.DD"), ("DAEMON1E.DD")
            USE ("DAEMON2.DD") ALIAS SUPPORT NEW EXCLUSIVE
            SET INDEX TO ("DAEMON2A.DD")
            SELECT CARDS
            SET ORDER TO nCOLUMN
            oTBROWSE:GOTOP()
            SET CURSOR OFF
         ENDIF
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
         RESTORE SCREEN FROM cSCREEN
      CASE (nSUBOPT == 5 .AND. CARDS->QUANTITY < 999)       && Increase Quantity
         CARDS->QUANTITY++
         CARDS->UPDATED := .T.
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHCURRENT()
         RESTORE SCREEN FROM cSCREEN
      CASE (nSUBOPT == 6 .AND. CARDS->QUANTITY > 0)         && Decrease Quantity
         CARDS->QUANTITY--
         CARDS->UPDATED := .T.
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHCURRENT()
         RESTORE SCREEN FROM cSCREEN
      CASE nSUBOPT == 7                                    && Resetting Cards
         HELPIT("Press [ESC] to abort or any other key to continue")
         SETCOLOR(ALT_COLOR)
         ZBOX(5,10,14,69,BK2_COLOR,.F.)
         @  6,33 SAY "Resetting Cards"
         @  8,12 SAY "This command removes all of the update flags from your  "
         @  9,12 SAY "card list.  The flags appear as you make changes to your"
         @ 10,12 SAY "inventory, such as editing, increasing or decreasing the"
         @ 11,12 SAY "amount of cards."
         PAUSE(13,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         IF LASTKEY() <> K_ESC
            ZWARN(18,"Please Wait : Resetting the Card List",2,BK2_COLOR)
            SET CURSOR ON
            REPLACE ALL UPDATED WITH .F.
            oTBROWSE:GOTOP()
            SET CURSOR OFF
         ENDIF
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
         RESTORE SCREEN FROM cSCREEN
      CASE nSUBOPT == 8                                    && Personal Info.
         HELPIT("Press [PGDN] to save or [ESC] to abort")
         SELECT INFO
         SETCOLOR(ALT_COLOR)
         ZBOX(5,12,19,68,BK2_COLOR,.F.)
         @  6,32 SAY "User Information"
         @  8,14 SAY "Name ................." GET INFO->NAME
         @  9,14 SAY "Address .............." GET INFO->ADDRESS
         @ 10,14 SAY "City ................." GET INFO->CITY
         @ 11,14 SAY "State ................" GET INFO->STATE
         @ 12,14 SAY "Zip Code ............." GET INFO->ZIPCODE
         @ 13,14 SAY "Telephone ............" GET INFO->TELEPHONE PICTURE "@R (###) ###-####"
         @ 14,13 SAY REPLICATE("Ä",55)
         @ 15,14 SAY "Collection Expense ..." GET INFO->EST_SPENT
         @ 16,14 SAY "Collection Worth ....." GET INFO->EST_WORTH
         @ 17,13 SAY REPLICATE("Ä",55)
         @ 18,14 SAY "Report Heading ......." GET INFO->LP_HEADING
         SET CURSOR ON
         IF lMOUSED
            DC_READMODAL(GETLIST); GETLIST := {}
         ELSE
            READ
         ENDIF
         SET CURSOR OFF
         COMMIT
         SELECT CARDS
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
         RESTORE SCREEN FROM cSCREEN
      CASE nSUBOPT == 9                                    && Trivia
         SETCOLOR(MAIN_COLOR)
         @ 4,77  CLEAR TO 6,77
         @ 20,77 CLEAR TO 22,77
         @ 22,4  CLEAR TO 22,74
         SETCOLOR(ALT_COLOR)
         ZBOX(3,7,21,71,BK2_COLOR,.F.)
         @  4,9 SAY "Page 1              Ä Deck Daemon Trivia Ä"
         SETCOLOR(TALK_COLOR)
         @  5,8 SAY REPLICATE("Ä",63)
         @  7,9 SAY "      Number of cards (have) :      of      different"
         @  8,9 SAY "      Number of cards (need) :"
         @  9,9 SAY "     Number of series (have) :      of"
         @ 10,9 SAY "   Number of tradeable cards :      different"
         @ 11,9 SAY "      Total purchase dollars :         (x Quantity =        )"
         @ 12,9 SAY "         Total sales dollars :         (x Quantity =        )"
         @ 13,9 SAY "  Most expensive card bought :"
         @ 14,9 SAY "                             :"
         @ 15,9 SAY "    Most expensive card sold :"
         @ 16,9 SAY "                             :"
         @ 17,9 SAY "        Most purchase $ from :"
         @ 18,9 SAY "             Most sales $ to :"
         SAVE SCREEN TO cSCREEN2
         SETCOLOR(MAIN_COLOR)
         ZBOX(11,20,13,59,BK3_COLOR,.F.)
         @ 12,22 SAY "Please Wait : Gathering information."
         SET CURSOR ON

         * Initialize variables

         nHAVECARDS := 0
         nTOTLCARDS := 0
         nNEEDCARDS := 0
         nSERIESHV  := 0
         nSERIESTTL := 0
         cSERIESHV  := ""
         cSERIESTTL := ""
         nTRADEABLE := 0
         nTOTLPURCH := 0
         nTOTLSALES := 0
         nTOT2PURCH := 0
         nTOT2SALES := 0
         nMOSTPURCH := 0
         nMOSTSALES := 0
         cMOSTPURCH := ""
         cMOSTSALES := ""
         aBOUGHT    := {}
         aSOLD      := {}
         FOR nX := 1 TO 14; aCARDS[nX,1] := 0; aCARDS[nX,2] := 0; NEXT nX

         * Begin calculations

         SET ORDER TO 0
         GO TOP
         DO WHILE ! EOF()
            nHAVECARDS := nHAVECARDS + IF(QUANTITY > 0,1,0)
            nTOTLCARDS := nTOTLCARDS + QUANTITY
            nNEEDCARDS := nNEEDCARDS + IF(QUANTITY = 0,1,0)
            cSERIESHV  := cSERIESHV  + IF(QUANTITY > 0,IF((SERIES+"|")$cSERIESHV,"",(SERIES+"|")),"")
            cSERIESTTL := cSERIESTTL + IF((SERIES+"|")$cSERIESTTL,"",(SERIES+"|"))
            nTRADEABLE := nTRADEABLE  + IF(SUBSTR(FLAGS,4,1) = "T" .AND. QUANTITY > 0,1,0)
            nTOTLPURCH := nTOTLPURCH + BUY_PRICE
            nTOT2PURCH := nTOT2PURCH + (BUY_PRICE * QUANTITY)
            nTOTLSALES := nTOTLSALES + SOLD_PRICE
            nTOT2SALES := nTOT2SALES + (SOLD_PRICE * QUANTITY)
            cMOSTPURCH := IF(BUY_PRICE > nMOSTPURCH,CARD,cMOSTPURCH)
            nMOSTPURCH := IF(BUY_PRICE > nMOSTPURCH,BUY_PRICE,nMOSTPURCH)
            cMOSTSALES := IF(SOLD_PRICE > nMOSTSALES,CARD,cMOSTSALES)
            nMOSTSALES := IF(SOLD_PRICE > nMOSTSALES,SOLD_PRICE,nMOSTSALES)

            * Most prolific dealers

            SET EXACT OFF
            IF ! EMPTY(BUY_FROM)
               nREF := aSCAN(aBOUGHT,BUY_FROM)
               IF nREF = 0
                  aADD(aBOUGHT,BUY_FROM + STR(BUY_PRICE,10,2))
               ELSE
                  aBOUGHT[nREF] := LEFT(aBOUGHT[nREF],15) + STR(VAL(RIGHT(aBOUGHT[nREF],10)) + BUY_PRICE,10,2)
               ENDIF
            ENDIF
            IF ! EMPTY(SOLD_TO)
               nREF := aSCAN(aSOLD,SOLD_TO)
               IF nREF = 0
                  aADD(aSOLD,SOLD_TO + STR(SOLD_PRICE,10,2))
               ELSE
                  aSOLD[nREF] := LEFT(aSOLD[nREF],15) + STR(VAL(RIGHT(aSOLD[nREF],10)) + SOLD_PRICE,10,2)
               ENDIF
            ENDIF

            * Page 2 trivia

            IF LEFT(UPPER(TYPE),8) = "ARTIFACT"
               aCARDS[1,1] := aCARDS[1,1] + QUANTITY
               aCARDS[1,2]++
            ENDIF
            IF LEFT(UPPER(TYPE),4) = "LAND"
               aCARDS[2,1] := aCARDS[2,1] + QUANTITY
               aCARDS[2,2]++
            ENDIF
            IF LEFT(UPPER(TYPE),12) = "LAND-SPECIAL" .OR. LEFT(UPPER(TYPE),14) = "LAND-LEGENDARY"
               aCARDS[3,1] := aCARDS[3,1] + QUANTITY
               aCARDS[3,2]++
            ENDIF
            DO CASE
            CASE UPPER(COLOR) = "BLACK"
               aCARDS[4,1] := aCARDS[4,1] + QUANTITY
               aCARDS[4,2]++
            CASE UPPER(COLOR) = "BLUE"
               aCARDS[5,1] := aCARDS[5,1] + QUANTITY
               aCARDS[5,2]++
            CASE UPPER(COLOR) = "GREEN"
               aCARDS[6,1] := aCARDS[6,1] + QUANTITY
               aCARDS[6,2]++
            CASE UPPER(COLOR) = "RED"
               aCARDS[7,1] := aCARDS[7,1] + QUANTITY
               aCARDS[7,2]++
            CASE UPPER(COLOR) = "WHITE"
               aCARDS[8,1] := aCARDS[8,1] + QUANTITY
               aCARDS[8,2]++
            CASE UPPER(COLOR) = "GOLD"
               aCARDS[9,1] := aCARDS[9,1] + QUANTITY
               aCARDS[9,2]++
            ENDCASE
            DO CASE
            CASE LEFT(FLAGS,1) = "C"
               aCARDS[10,1] := aCARDS[10,1] + QUANTITY
               aCARDS[10,2]++
            CASE LEFT(FLAGS,1) = "U"
               aCARDS[11,1] := aCARDS[11,1] + QUANTITY
               aCARDS[11,2]++
            CASE LEFT(FLAGS,1) = "R"
               aCARDS[12,1] := aCARDS[12,1] + QUANTITY
               aCARDS[12,2]++
            ENDCASE
            DO CASE
            CASE SUBSTR(FLAGS,3,1) = "R"
               aCARDS[13,1] := aCARDS[13,1] + QUANTITY
               aCARDS[13,2]++
            CASE SUBSTR(FLAGS,3,1) = "B"
               aCARDS[14,1] := aCARDS[14,1] + QUANTITY
               aCARDS[14,2]++
            ENDCASE

            SET EXACT ON
            SKIP
         ENDDO

         * Final touches

         FOR nX := 1 TO LEN(cSERIESHV)
            nSERIESHV := nSERIESHV + IF(SUBSTR(cSERIESHV,nX,1) = "|",1,0)
         NEXT
         FOR nX := 1 TO LEN(cSERIESTTL)
            nSERIESTTL := nSERIESTTL + IF(SUBSTR(cSERIESTTL,nX,1) = "|",1,0)
         NEXT
         cSTRPURCH := ""
         cSTRSALES := ""
         ASORT(aBOUGHT,,,{|X,Y| VAL(RIGHT(X,10)) > VAL(RIGHT(Y,10)) } )
         ASORT(aSOLD,,,{|X,Y| VAL(RIGHT(X,10)) > VAL(RIGHT(Y,10)) } )

         * Page 1 results

         RESTORE SCREEN FROM cSCREEN2
         SET CURSOR OFF
         SETCOLOR(TRIV_COLOR)
         @  7,39 SAY STR(nTOTLCARDS,5)
         @  7,47 SAY STR(nHAVECARDS,5)
         @  8,39 SAY STR(nNEEDCARDS,5)
         @  9,39 SAY STR(nSERIESHV,5)
         @  9,47 SAY STR(nSERIESTTL,5)
         @ 10,39 SAY STR(nTRADEABLE,5)
         @ 11,39 SAY STR(nTOTLPURCH,8,2)
         @ 11,61 SAY STR(nTOT2PURCH,8,2)
         @ 12,39 SAY STR(nTOTLSALES,8,2)
         @ 12,61 SAY STR(nTOT2SALES,8,2)
         @ 13,39 SAY STR(nMOSTPURCH,8,2)
         @ 14,40 SAY cMOSTPURCH
         @ 15,39 SAY STR(nMOSTSALES,8,2)
         @ 16,40 SAY cMOSTSALES
         IF LEN(aBOUGHT) > 0
            IF VAL(RIGHT(aBOUGHT[1],10)) > 0
               @ 17,40 SAY NOCOMMA(LEFT(aBOUGHT[1],15))
               @ 17,56 SAY "($" + STR(VAL(RIGHT(aBOUGHT[1],10)),8,2) + ")"
            ENDIF
         ENDIF
         IF LEN(aSOLD) > 0
            IF VAL(RIGHT(aSOLD[1],10)) > 0
               @ 18,40 SAY NOCOMMA(LEFT(aSOLD[1],15))
               @ 18,56 SAY "($" + STR(VAL(RIGHT(aSOLD[1],10)),8,2) + ")"
            ENDIF
         ENDIF
         HELPIT("Press any key to continue")
         PAUSE(20,37,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         @ 7,9 CLEAR TO 20,69

         * Page 2

         SETCOLOR(ALT_COLOR)
         @  4,9  SAY "Page 2              Ä Deck Daemon Trivia Ä"
         SETCOLOR(TALK_COLOR)
         @  6,13 SAY "    Number of ARTIFACT cards :      of      different"
         @  7,13 SAY "        Number of LAND cards :      of      different"
         @  8,13 SAY "Number of SPECIAL LAND cards :      of      different"
         @  9,13 SAY "       Number of BLACK cards :      of      different"
         @ 10,13 SAY "        Number of BLUE cards :      of      different"
         @ 11,13 SAY "       Number of GREEN cards :      of      different"
         @ 12,13 SAY "         Number of RED cards :      of      different"
         @ 13,13 SAY "       Number of WHITE cards :      of      different"
         @ 14,13 SAY "        Number of GOLD cards :      of      different"
         @ 15,13 SAY "      Number of COMMON cards :      of      different"
         @ 16,13 SAY "    Number of UNCOMMON cards :      of      different"
         @ 17,13 SAY "        Number of RARE cards :      of      different"
         @ 18,13 SAY "  Number of RESTRICTED cards :      of      different"
         @ 19,13 SAY "      Number of BANNED cards :      of      different"
         IF lCOLOR
            @  7,31 SAY "LAND"    COLOR "GR/B"
            @  8,23 SAY "SPECIAL" COLOR "BG+/B"
            @  8,31 SAY "LAND"    COLOR "GR/B"
            @  9,30 SAY "BLACK"   COLOR "N/B"
            @ 10,31 SAY "BLUE"    COLOR "B+/B"
            @ 11,30 SAY "GREEN"   COLOR "G+/B"
            @ 12,32 SAY "RED"     COLOR "R/B"
            @ 13,30 SAY "WHITE"   COLOR "W+/B"
            @ 14,31 SAY "GOLD"    COLOR "GR+/B"
         ENDIF
         SETCOLOR(TRIV_COLOR)
         FOR nX := 1 TO 14
            @ nX+5,43 SAY STR(aCARDS[nX,1],5)
            @ nX+5,51 SAY STR(aCARDS[nX,2],5)
         NEXT nX

         * Finished

         PAUSE(20,37,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         SET ORDER TO nCOLUMN
         oTBROWSE:GOTOP()
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
         RESTORE SCREEN FROM cSCREEN
      CASE nSUBOPT == 10                                   && Program Credits
         HELPIT("Press any key to continue")
         SETCOLOR(ALT_COLOR)
         ZBOX(2,15,22,64,BK1_COLOR,.T.)
         @  3,21 SAY "          DECK DAEMON           "
         @  5,21 SAY "             Version 1.2              "
         @  7,21 SAY "      Developer : Richard Hundhausen  "
         @  8,21 SAY "      Technical : Aaron Detmar        "
         @  9,21 SAY "                : Dave Jordan         "
         @ 10,21 SAY "                : Joel Lytle          "
         @ 11,21 SAY "                : Jon Beck            "
         @ 12,21 SAY "                : Tom Gilmore         "
         @ 13,21 SAY "                : Ed Willis           "
         @ 14,21 SAY "                : Jake Miller         "
         @ 15,21 SAY "        Artwork : Brian Jackson       "
         @ 16,21 SAY "       Security : S. Mike Pavelec     "
         @ 17,21 SAY "  Serial Number : "
         @ 19,21 SAY " (C) 1994, Bard's Quest Software, Inc."
         @ 17,39 SAY LEFT(BLISERNUM(),10) COLOR TRIV_COLOR
         IF lCOLOR
            nCOLOR := 1
            @ 21,38 SAY " Ok " COLOR IF(lMOUSED,BUTT_COLOR,MAIN_COLOR)
            IF lMOUSED; DC_MOUSHOW(); ENDIF
            DO WHILE nCOLOR <> 0
               @ 3,28 SAY "   DECK DAEMON   " COLOR aCOLORS[nCOLOR]
               nCOLOR := IF(nCOLOR = 15,1,nCOLOR + 1)
               IF INKEY() <> 0
                  nCOLOR := 0
               ELSE
                  IF DC_MOUBUTTON() = 1 .AND. DC_MOUROW() = 21 .AND. DC_MOUCOL() >= 38 .AND. DC_MOUCOL() <= 41 .AND. lMOUSED
                     nCOLOR := 0
                  ENDIF
               ENDIF
            ENDDO
            IF lMOUSED; DC_MOUHIDE(); ENDIF
         ELSE
            PAUSE(21,38,MAIN_COLOR)
         ENDIF
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
         RESTORE SCREEN FROM cSCREEN
      OTHERWISE
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHCURRENT()
         RESTORE SCREEN FROM cSCREEN
      ENDCASE
      SET CURSOR OFF
   CASE (nKEY == 81 .OR. nKEY == K_ESC)                    && Quit/Exit
      SAVE SCREEN TO cSCREEN
      @ 0,60 SAY " Quit " COLOR BK2_COLOR
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      SETCOLOR(ALT_COLOR)
      ZBOX(11,16,13,63,BK2_COLOR,.F.)
      IF lMOUSED
         @ 12,18 SAY "Shall I QUIT and exit the program?     /    "
         @ 12,53 SAY " Y " COLOR IF(lCOLOR,BUTT_COLOR,MAIN_COLOR)
         @ 12,59 SAY " N " COLOR IF(lCOLOR,BUTT_COLOR,MAIN_COLOR)
      ELSE
         @ 12,18 SAY "Shall I QUIT and exit the program? [Y] / [N]"
      ENDIF
      nKEY2 := IF(lMOUSED,MOUSEKEY(3),INKEY(0))
      RESTORE SCREEN FROM cSCREEN
      IF nKEY2 == 89 .or. nKEY2 == 121
         CLOSE ALL
         CLEAR ALL
         Return (Nil)
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == K_PLUS .AND. CARDS->QUANTITY < 999)       && Increase Quantity
      CARDS->QUANTITY++
      CARDS->UPDATED := .T.
      oTBROWSE:REFRESHCURRENT()
   CASE (nKEY == K_MINUS .AND. CARDS->QUANTITY > 0)        && Decrease Quantity
      CARDS->QUANTITY--
      CARDS->UPDATED := .T.
      oTBROWSE:REFRESHCURRENT()
   CASE (nKEY == 48 .AND. CARDS->QUANTITY > 0)             && Set Quantity -> 0
      CARDS->QUANTITY := 0
      CARDS->UPDATED := .T.
      oTBROWSE:REFRESHCURRENT()
   CASE nKEY >= 49 .AND. nKEY <= 57                        && Set 1 Digit Quan.
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      KEYBOARD CHR(nKEY)
      @ oTBROWSE:ROWPOS+4,72 GET CARDS->QUANTITY PICTURE "@Z"
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      CARDS->UPDATED  := .T.
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
   CASE LASTKEY() == K_ALT_F12
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      SETCOLOR(ALT_COLOR)
      ZBOX(6,23,19,56,BK2_COLOR,.F.)
      @  7,24 SAY " Program"
      @  8,24 SAY REPLICATE("Ä",32)
      @  9,25 SAY "Memory (0) .... " + TRANSFORM((MEMORY(0)*1024),"999,999") + " Bytes"
      @ 10,25 SAY "Memory (1) .... " + TRANSFORM((MEMORY(1)*1024),"999,999") + " Bytes"
      @ 11,25 SAY "Memory (2) .... " + TRANSFORM((MEMORY(2)*1024),"999,999") + " Bytes"
      @ 13,24 SAY " Blinker"
      @ 14,24 SAY REPLICATE("Ä",32)
      @ 15,25 SAY "Blimemavl() ... " + TRANSFORM(BLIMEMAVL(),"999,999") + " Bytes"
      @ 16,25 SAY "Blimemmax() ... " + TRANSFORM(BLIMEMMAX(),"999,999") + " Bytes"
      PAUSE(18,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   ENDCASE
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                               View a Card                                */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function CARD_VIEW (nMODE)
Local cCOLORSTR, cCOSTSTR, cRARESTR, cSERIESNM, cDESC, cFILL, nYPOS

* Draw the box

SETCOLOR(CRD1_COLOR)
@ 2,14 CLEAR TO 22,64
IF lCOLOR
   @ 2,65 SAY "ß" COLOR BK2_COLOR
   SETCOLOR(SHAD_COLOR)
   @ 3,65 CLEAR TO 22,65
   @ 23,4 SAY REPLICATE("Ü",51) COLOR BK1_COLOR
ENDIF
SETCOLOR(CRD1_COLOR)
@  2,15,22,63 BOX B_DOUBLE
SETCOLOR(CRD2_COLOR)
@  6,17,14,61 BOX B_SINGLE
@ 16,17,21,61 BOX B_SINGLE
@  6,33 SAY " Description "
@ 16,27 SAY " Collector's Information "

* Do some lookup work

cCOLORSTR := LTRIM(RTRIM(COLOR))
cCOSTSTR  := LTRIM(RTRIM(COST))
cRARESTR  := IF(LEFT(FLAGS,1) = "R","Rare",IF(LEFT(FLAGS,1) = "U","Uncommon",IF(LEFT(FLAGS,1) = "C","Common","")))
cSERIESNM := SERIES
SELECT SUPPORT
SEEK "S"
IF FOUND()
   DO WHILE (SUPPORT->TYPE = "S" .AND. ! EOF())
      cSERIESNM := IF(SUPPORT->SHORT = IF(nMODE=1,CARDS->SERIES,CARDTEMP->SERIES),NAME,cSERIESNM)
      SKIP
   ENDDO
ENDIF
cSERIESNM := LTRIM(RTRIM(cSERIESNM))

* Display top of card

IF nMODE = 1
   SELECT CARDS
ELSE
   SELECT CARDTEMP
ENDIF

DO CASE
CASE SUBSTR(FLAGS,3,1) = "B"
   @ 2,36 SAY " Banned "     COLOR CRD4_COLOR
CASE SUBSTR(FLAGS,3,1) = "R"
   @ 2,34 SAY " Restricted " COLOR CRD4_COLOR
ENDCASE

SETCOLOR(CRD3_COLOR)
IF ! EMPTY(cRARESTR)
   @ 2,61-LEN(cRARESTR)  SAY " " + cRARESTR + " "
ENDIF
@ 3,17 SAY CARD
@ 3,62-LEN(cCOLORSTR) SAY cCOLORSTR
@ 4,17 SAY TYPE
@ 4,62-LEN(cCOSTSTR)  SAY cCOSTSTR
@ 5,17 SAY cSERIESNM
DO CASE
CASE SUBSTR(FLAGS,2,1) = "M"
   @ 5,48 SAY "Mint Condition"
CASE SUBSTR(FLAGS,2,1) = "N"
   @ 5,43 SAY "Near-Mint Condition"
CASE SUBSTR(FLAGS,2,1) = "L"
   @ 5,43 SAY "Light Use Condition"
CASE SUBSTR(FLAGS,2,1) = "H"
   @ 5,43 SAY "Heavy Use Condition"
ENDCASE

* Display description

cDESC := LTRIM(RTRIM(DESC))
cFILL := ""
nYPOS := 7
FOR nX := 1 TO LEN(cDESC)
   IF SUBSTR(cDESC,nX,1) = " " .AND. LEN(cFILL) > 32
      @ nYPOS,19 SAY cFILL
      cFILL := ""
      nYPOS++
   ELSE
      cFILL := cFILL + IF(cFILL = "" .AND. SUBSTR(cDESC,nX,1) = " ","",SUBSTR(cDESC,nX,1))
   ENDIF
NEXT nX
IF ! EMPTY(cFILL)
   @ nYPOS,19 SAY cFILL
ENDIF

* Display collector's information

IF ! EMPTY(ARTIST)
   @ 15,35-LEN(RTRIM(ARTIST))/2 SAY "Artist : " + NOCOMMA(ARTIST) COLOR CRD5_COLOR
ENDIF
DO CASE
CASE QUANTITY < 1
   @ 17,19 SAY "You do not have this card"
CASE QUANTITY = 1
   @ 17,19 SAY "You have this card"
OTHERWISE
   @ 17,19 SAY "You have "+LTRIM(STR(QUANTITY,4))+" of this card"
ENDCASE
IF SUBSTR(FLAGS,4,1) = "T"
   @ 18,19 SAY "Card is Available for trade"
ENDIF
cFILL := ""
IF ! EMPTY(BUY_FROM)
   IF BUY_PRICE = 0
      cFILL := "Traded from "+NOCOMMA(BUY_FROM)
   ELSE
      cFILL := "Bought from "+NOCOMMA(BUY_FROM)
   ENDIF
ENDIF
IF BUY_PRICE <> 0
   IF EMPTY(cFILL)
      cFILL := "You paid $ "+LTRIM(STR(BUY_PRICE,8,2))+" for this card."
   ELSE
      cFILL := cFILL + " for $ "+LTRIM(STR(BUY_PRICE,8,2))
   ENDIF
ENDIF
IF ! EMPTY(cFILL)
   @ 19,19 SAY cFILL
ENDIF
cFILL := ""
IF ! EMPTY(SOLD_TO)
   IF SOLD_PRICE = 0
      cFILL := "Traded to "+NOCOMMA(SOLD_TO)
   ELSE
      cFILL := "Sold to "+NOCOMMA(SOLD_TO)
   ENDIF
ENDIF
IF SOLD_PRICE <> 0
   IF EMPTY(cFILL)
      cFILL := "You paid $ "+LTRIM(STR(SOLD_PRICE,8,2))+" for this card."
   ELSE
      cFILL := cFILL + " for $ "+LTRIM(STR(SOLD_PRICE,8,2))
   ENDIF
ENDIF
IF ! EMPTY(cFILL)
   @ 20,19 SAY cFILL
ENDIF

* Display bottom of card

@ 22,17 SAY " " + LTRIM(STR(REFERENCE,5)) + " " COLOR CRD1_COLOR
PAUSE(22,37,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
IF nMODE = 1
   SELECT CARDS
ELSE
   SELECT CARDTEMP
ENDIF
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                                Card Form                                 */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function CARD_EDIT (nMODE)
Local cSCREEN, nKEY, nUKEY, lNEEDED := .T., aPROMPT[16], nX, nOLDITEM
Local nOLDCOLOR := 0, nOLDTYPE := 0, nOLDSTATUS := 0
Local nNEWCOLOR := 0, nNEWTYPE := 0, nNEWSTATUS := 0

* Initialize Array

aPROMPT[1]  := " 817" + CARDS->SERIES
aPROMPT[2]  := " 917" + CARDS->CARD
aPROMPT[3]  := "1017" + CARDS->COLOR
aPROMPT[4]  := "1117" + CARDS->TYPE
aPROMPT[5]  := "1217" + CARDS->COST
aPROMPT[6]  := "1317" + CARDS->ARTIST
aPROMPT[7]  := "1417" + LEFT(CARDS->DESC,38)
aPROMPT[8]  := "1518" + LEFT(CARDS->FLAGS,1)
aPROMPT[9]  := "1618" + SUBSTR(CARDS->FLAGS,3,1)
aPROMPT[10] := "1718" + SUBSTR(CARDS->FLAGS,2,1)
aPROMPT[11] := "1818" + TRANSFORM(CARDS->QUANTITY,"@Z")
aPROMPT[12] := "1918" + IF(SUBSTR(CARDS->FLAGS,4,1) = "T","Y","N")
aPROMPT[13] := "2017" + CARDS->BUY_FROM
aPROMPT[14] := "2046" + TRANSFORM(CARDS->BUY_PRICE,"@Z")
aPROMPT[15] := "2117" + CARDS->SOLD_TO
aPROMPT[16] := "2146" + TRANSFORM(CARDS->SOLD_PRICE,"@Z")

* Initialize Decklink Variables

DO CASE
CASE "BLACK"$UPPER(CARDS->COLOR)
   nOLDCOLOR := 1
CASE "BLUE"$UPPER(CARDS->COLOR)
   nOLDCOLOR := 2
CASE "GREEN"$UPPER(CARDS->COLOR)
   nOLDCOLOR := 3
CASE "RED"$UPPER(CARDS->COLOR)
   nOLDCOLOR := 4
CASE "WHITE"$UPPER(CARDS->COLOR)
   nOLDCOLOR := 5
CASE "GOLD"$UPPER(CARDS->COLOR)
   nOLDCOLOR := 6
OTHERWISE
   nOLDCOLOR := 0
ENDCASE
DO CASE
CASE LEFT(UPPER(CARDS->TYPE),8) = "ARTIFACT"
   nOLDTYPE  := 7
CASE LEFT(UPPER(CARDS->TYPE),7) = "ENCHANT"
   nOLDTYPE  := 8
CASE LEFT(UPPER(CARDS->TYPE),7) = "INSTANT"
   nOLDTYPE  := 9
CASE LEFT(UPPER(CARDS->TYPE),9) = "INTERRUPT"
   nOLDTYPE  := 10
CASE LEFT(UPPER(CARDS->TYPE),4) = "LAND"
   nOLDTYPE  := 11
CASE LEFT(UPPER(CARDS->TYPE),7) = "SORCERY"
   nOLDTYPE  := 12
CASE LEFT(UPPER(CARDS->TYPE),6) = "SUMMON"
   nOLDTYPE  := 13
OTHERWISE
   nOLDTYPE := 0
ENDCASE
DO CASE
CASE SUBSTR(CARDS->FLAGS,3,1) = "R"
   nOLDSTATUS := 14
CASE SUBSTR(CARDS->FLAGS,3,1) = "B"
   nOLDSTATUS := 15
OTHERWISE
   nOLDSTATUS := 0
ENDCASE

* Draw Screen

SETCOLOR(MAIN_COLOR)
zBOX(7,1,22,56,BK1_COLOR,.T.)
@  8,3  SAY "Series ......"
@  9,3  SAY "Card ........"
@ 10,3  SAY "Color ......."
@ 11,3  SAY "Type ........"
@ 12,3  SAY "Casting Cost."
@ 13,3  SAY "Artist ......"
@ 14,3  SAY "Description ." + SPACE(39) + CHR(26)
@ 15,3  SAY "Rarity ...... [ ] ..... Cùommon, Uùncommon or Rùare"
@ 16,3  SAY "Tournament .. [ ] ..... Oùpen, Rùestricted or Bùanned"
@ 17,3  SAY "Condition ... [ ] ..... Mùint, Nùear, Lùight, Hùeavy"
@ 18,3  SAY "Quantity .... [   ] "+IF(lMOUSED," ","...")+" Blank if you NEED the card"
@ 19,3  SAY "Trade? ...... [ ] ..... Is the card open for trade?"
@ 20,3  SAY "From ........                 .... Price $        "+IF(lMOUSED," ","")
@ 21,3  SAY "Traded To ...                 .... Price $        "+IF(lMOUSED," ","")
FOR nX := 1 TO 16
   @ VAL(SUBSTR(aPROMPT[nX],1,2)), VAL(SUBSTR(aPROMPT[nX],3,2)) SAY RIGHT(aPROMPT[nX],LEN(aPROMPT[nX])-4) COLOR SHOW_COLOR
NEXT nX
IF nMODE = 2
   HELPIT("")
ELSE
   HELPIT("Commands : [], [], [+], [-], [ENTER] or [ESC]")
ENDIF
IF lMOUSED
   @ 22,27 SAY " Ok " COLOR IF(lMOUSED,BUTT_COLOR,BK2_COLOR)
ENDIF
SAVE SCREEN TO cSCREEN

* Begin Editing Routine

nITEM := 1
DO WHILE lNEEDED
   IF nMODE = 2
      nKEY := K_ENTER
   ELSE
      @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2)) SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4) COLOR BK2_COLOR
      nOLDITEM := nITEM
      nKEY     := IF(lMOUSED,MOUSEKEY(4),ASC(UPPER(CHR(INKEY(0)))))
      nUKEY    := ASC(UPPER(CHR(nKEY)))
   ENDIF
   IF lMOUSED .AND. nKEY >= K_MOUSE1
      @ VAL(SUBSTR(aPROMPT[nOLDITEM],1,2)), VAL(SUBSTR(aPROMPT[nOLDITEM],3,2)) SAY RIGHT(aPROMPT[nOLDITEM],LEN(aPROMPT[nOLDITEM])-4) COLOR SHOW_COLOR
      @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2))       SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4)       COLOR BK2_COLOR
      DO CASE
       CASE nKEY == K_MOUSE1;  nKEY := K_ENTER
       CASE nKEY == K_MOUSE2;  nKEY := 43
       CASE nKEY == K_MOUSE3;  nKEY := 45
       CASE nKEY == K_MOUSE4;  nKEY := nUKEY := IF(SUBSTR(CARDS->FLAGS,4,1)="T",78,89)
       CASE nKEY == K_MOUSE5;  nKEY := nUKEY := 77
       CASE nKEY == K_MOUSE6;  nKEY := nUKEY := 78
       CASE nKEY == K_MOUSE7;  nKEY := nUKEY := 76
       CASE nKEY == K_MOUSE8;  nKEY := nUKEY := 72
       CASE nKEY == K_MOUSE9;  nKEY := nUKEY := 79
       CASE nKEY == K_MOUSE10; nKEY := nUKEY := 82
       CASE nKEY == K_MOUSE11; nKEY := nUKEY := 66
       CASE nKEY == K_MOUSE12; nKEY := nUKEY := 67
       CASE nKEY == K_MOUSE13; nKEY := nUKEY := 85
       CASE nKEY == K_MOUSE14; nKEY := nUKEY := 82
       CASE nKEY == K_MOUSE15; nKEY := 43
       CASE nKEY == K_MOUSE16; nKEY := 45
       CASE nKEY == K_MOUSE17; nKEY := K_ESC
      ENDCASE
   ENDIF
   DO CASE

   * Movement keys

   CASE nKEY = K_UP
      @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2)) SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4) COLOR SHOW_COLOR
      nITEM := IF(nITEM = 1,16,nITEM - 1)
   CASE nKEY = K_DOWN
      @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2)) SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4) COLOR SHOW_COLOR
      nITEM := IF(nITEM = 16,1,nITEM + 1)
   CASE nKEY = K_HOME .AND. nITEM > 1
      @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2)) SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4) COLOR SHOW_COLOR
      nITEM := 1
   CASE nKEY = K_END .AND. nITEM < 16
      @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2)) SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4) COLOR SHOW_COLOR
      nITEM := 16
   CASE nKEY = K_ESC
      lNEEDED := .F.

   * Special function keys

   CASE (nUKEY = 67 .OR. nUKEY = 82 .OR. nUKEY = 85) .AND. nITEM = 8
      CARDS->FLAGS := CHR(nUKEY) + RIGHT(CARDS->FLAGS,3)
      aPROMPT[8]  := "1518" + LEFT(CARDS->FLAGS,1)
   CASE (nUKEY = 66 .OR. nUKEY = 79 .OR. nUKEY = 82) .AND. nITEM = 9
      CARDS->FLAGS := LEFT(CARDS->FLAGS,2) + CHR(nUKEY) + RIGHT(CARDS->FLAGS,1)
      aPROMPT[9]  := "1618" + SUBSTR(CARDS->FLAGS,3,1)
   CASE (nUKEY = 72 .OR. nUKEY = 76 .OR. nUKEY = 77 .OR. nUKEY = 78) .AND. nITEM = 10
      CARDS->FLAGS := LEFT(CARDS->FLAGS,1) + CHR(nUKEY) + RIGHT(CARDS->FLAGS,2)
      aPROMPT[10] := "1718" + SUBSTR(CARDS->FLAGS,2,1)
   CASE nKEY = 43 .AND. nITEM = 11
      CARDS->QUANTITY++
      aPROMPT[11] := "1818" + TRANSFORM(CARDS->QUANTITY,"@Z")
   CASE (nUKEY = 78 .OR. nUKEY = 89) .AND. nITEM = 12
      CARDS->FLAGS := LEFT(CARDS->FLAGS,3) + IF(nUKEY = 89,"T"," ")
      aPROMPT[12] := "1918" + IF(SUBSTR(CARDS->FLAGS,4,1) = "T","Y","N")
   CASE nKEY = 43 .AND. nITEM = 14 .AND. CARDS->BUY_PRICE  <= (999.99 - DOLLAR_INC)
      CARDS->BUY_PRICE := CARDS->BUY_PRICE + DOLLAR_INC
      aPROMPT[14] := "2046" + TRANSFORM(CARDS->BUY_PRICE,"@Z")
   CASE nKEY = 43 .AND. nITEM = 16 .AND. CARDS->SOLD_PRICE <= (999.99 - DOLLAR_INC)
      CARDS->SOLD_PRICE := CARDS->SOLD_PRICE + DOLLAR_INC
      aPROMPT[16] := "2146" + TRANSFORM(CARDS->SOLD_PRICE,"@Z")
   CASE nKEY = 45 .AND. nITEM = 11 .AND. CARDS->QUANTITY > 0
      CARDS->QUANTITY--
      aPROMPT[11] := "1818" + TRANSFORM(CARDS->QUANTITY,"@Z")
   CASE nKEY = 45 .AND. nITEM = 14 .AND. CARDS->BUY_PRICE >= DOLLAR_INC
      CARDS->BUY_PRICE := CARDS->BUY_PRICE - DOLLAR_INC
      aPROMPT[14] := "2046" + TRANSFORM(CARDS->BUY_PRICE,"@Z")
   CASE nKEY = 45 .AND. nITEM = 16 .AND. CARDS->SOLD_PRICE >= DOLLAR_INC
      CARDS->SOLD_PRICE := CARDS->SOLD_PRICE - DOLLAR_INC
      aPROMPT[16] := "2146" + TRANSFORM(CARDS->SOLD_PRICE,"@Z")
   CASE nKEY = K_ENTER

      * Allow editing of each field

      DO CASE
      CASE nITEM == 1
         @  8,17 GET CARDS->SERIES                   WHEN SUPPORT("S",1)
      CASE nITEM == 2
         HELPIT("Enter the card's NAME/DESCRIPTION")
         @  9,17 GET CARDS->CARD
      CASE nITEM == 3
         @ 10,17 GET CARDS->COLOR                    WHEN SUPPORT("C",1)
      CASE nITEM == 4
         @ 11,17 GET CARDS->TYPE                     WHEN SUPPORT("T",1)
      CASE nITEM == 5
         HELPIT("Enter the card's CASTING COST")
         @ 12,17 GET CARDS->COST                     PICTURE "@!"
      CASE nITEM == 6
         @ 13,17 GET CARDS->ARTIST                   WHEN SUPPORT("A",1)
      CASE nITEM == 7
         HELPIT("Enter the DESCRIPTION/FUNCTION/EXPLANATION")
         @ 14,17 GET CARDS->DESC                     PICTURE "@S38"
      CASE nITEM == 8
         cTEMP := LEFT(CARDS->FLAGS,1)
         @ 15,18 GET cTEMP              PICTURE "!"  WHEN SUPPORT("R",1)
      CASE nITEM == 9
         cTEMP := SUBSTR(CARDS->FLAGS,3,1)
         @ 16,18 GET cTEMP              PICTURE "!"  WHEN SUPPORT("U",1)
      CASE nITEM == 10
         cTEMP := SUBSTR(CARDS->FLAGS,2,1)
         @ 17,18 GET cTEMP              PICTURE "!"  WHEN SUPPORT("N",1)
      CASE nITEM == 11
         HELPIT("Enter the NUMBER of cards you possess")
         @ 18,18 GET CARDS->QUANTITY    PICTURE "@Z"
      CASE nITEM == 12
         lTEMP := (SUBSTR(CARDS->FLAGS,4,1) = "T")
         @ 19,18 GET lTEMP              PICTURE "Y"  WHEN SUPPORT("O",1)
      CASE nITEM == 13
         @ 20,17 GET CARDS->BUY_FROM                 WHEN SUPPORT("D",1)
      CASE nITEM == 14
         HELPIT("Enter the PRICE you paid for the card (Zero if traded)")
         @ 20,46 GET CARDS->BUY_PRICE   PICTURE "@Z"
      CASE nITEM == 15
         @ 21,17 GET CARDS->SOLD_TO                  WHEN SUPPORT("D",2)
      CASE nITEM == 16
         HELPIT("Enter the PRICE you sold the card (Zero if traded)")
         @ 21,46 GET CARDS->SOLD_PRICE  PICTURE "@Z"
      ENDCASE
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF

      * Reset Array

      aPROMPT[1]  := " 817" + CARDS->SERIES
      aPROMPT[2]  := " 917" + CARDS->CARD
      aPROMPT[3]  := "1017" + CARDS->COLOR
      aPROMPT[4]  := "1117" + CARDS->TYPE
      aPROMPT[5]  := "1217" + CARDS->COST
      aPROMPT[6]  := "1317" + CARDS->ARTIST
      aPROMPT[7]  := "1417" + LEFT(CARDS->DESC,38)
      aPROMPT[8]  := "1518" + LEFT(CARDS->FLAGS,1)
      aPROMPT[9]  := "1618" + SUBSTR(CARDS->FLAGS,3,1)
      aPROMPT[10] := "1718" + SUBSTR(CARDS->FLAGS,2,1)
      aPROMPT[11] := "1818" + TRANSFORM(CARDS->QUANTITY,"@Z")
      aPROMPT[12] := "1918" + IF(SUBSTR(CARDS->FLAGS,4,1) = "T","Y","N")
      aPROMPT[13] := "2017" + CARDS->BUY_FROM
      aPROMPT[14] := "2046" + TRANSFORM(CARDS->BUY_PRICE,"@Z")
      aPROMPT[15] := "2117" + CARDS->SOLD_TO
      aPROMPT[16] := "2146" + TRANSFORM(CARDS->SOLD_PRICE,"@Z")
      IF nMODE = 2
         HELPIT("")
         IF LASTKEY() = K_ESC
            lNEEDED := .F.
         ELSE
            @ VAL(SUBSTR(aPROMPT[nITEM],1,2)), VAL(SUBSTR(aPROMPT[nITEM],3,2)) SAY RIGHT(aPROMPT[nITEM],LEN(aPROMPT[nITEM])-4) COLOR SHOW_COLOR
            IF nITEM = 16
               lNEEDED := .F.
            ELSE
               nITEM++
            ENDIF
         ENDIF
      ELSE
         HELPIT("Commands : [], [], [+], [-], [ENTER] or [ESC]")
      ENDIF
   ENDCASE

   * Check Decklink Variables

   DO CASE
   CASE "BLACK"$UPPER(CARDS->COLOR)
      nNEWCOLOR := 1
   CASE "BLUE"$UPPER(CARDS->COLOR)
      nNEWCOLOR := 2
   CASE "GREEN"$UPPER(CARDS->COLOR)
      nNEWCOLOR := 3
   CASE "RED"$UPPER(CARDS->COLOR)
      nNEWCOLOR := 4
   CASE "WHITE"$UPPER(CARDS->COLOR)
      nNEWCOLOR := 5
   CASE "GOLD"$UPPER(CARDS->COLOR)
      nNEWCOLOR := 6
   OTHERWISE
      nNEWCOLOR := 0
   ENDCASE
   DO CASE
   CASE LEFT(UPPER(CARDS->TYPE),8) = "ARTIFACT"
      nNEWTYPE  := 7
   CASE LEFT(UPPER(CARDS->TYPE),7) = "ENCHANT"
      nNEWTYPE  := 8
   CASE LEFT(UPPER(CARDS->TYPE),7) = "INSTANT"
      nNEWTYPE  := 9
   CASE LEFT(UPPER(CARDS->TYPE),9) = "INTERRUPT"
      nNEWTYPE  := 10
   CASE LEFT(UPPER(CARDS->TYPE),4) = "LAND"
      nNEWTYPE  := 11
   CASE LEFT(UPPER(CARDS->TYPE),7) = "SORCERY"
      nNEWTYPE  := 12
   CASE LEFT(UPPER(CARDS->TYPE),6) = "SUMMON"
      nNEWTYPE  := 13
   OTHERWISE
      nNEWTYPE := 0
   ENDCASE
   DO CASE
   CASE SUBSTR(CARDS->FLAGS,3,1) = "R"
      nNEWSTATUS := 14
   CASE SUBSTR(CARDS->FLAGS,3,1) = "B"
      nNEWSTATUS := 15
   OTHERWISE
      nNEWSTATUS := 0
   ENDCASE

   * Update Decklink if necessary

   IF nMODE = 1 .AND. ((nNEWCOLOR <> nOLDCOLOR) .OR. (nNEWTYPE <> nOLDTYPE) .OR. (nNEWSTATUS <> nOLDSTATUS))
      USE ("DAEMON4.DD") ALIAS DECKLINK NEW EXCLUSIVE
      SET INDEX TO ("DAEMON4B.DD"), ("DAEMON4A.DD")
      SEEK CARDS->REFERENCE
      IF FOUND()
         DO WHILE (DECKLINK->CARD = CARDS->REFERENCE .AND. ! EOF())
            DECKLINK->COLOR  := nNEWCOLOR
            DECKLINK->TYPE   := nNEWTYPE
            DECKLINK->STATUS := nNEWSTATUS
            SKIP
         ENDDO
      ENDIF
      CLOSE DECKLINK
      SELECT CARDS
   ENDIF

   * Reset Decklink variables

   nOLDCOLOR  := nNEWCOLOR
   nOLDTYPE   := nNEWTYPE
   nOLDSTATUS := nNEWSTATUS
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                       Maintain/Select Card Dealers                       */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function SUPPORT (cTYPE,nMODE)
Local oTBROWSE, nKEY, cSCREEN, GETLIST := {}, nCURSOR := SETCURSOR()
Local cSEEK := "", nLASTKEY := LASTKEY(), aCHOICES[5], nOPTION := 1
Local cNAME := "", nROW := ROW(), cLASTNAME, nRECNO, nORDER
SAVE SCREEN TO cSCREEN
SET CURSOR OFF

* Draw Screen, Called from SUPPORT()

DO CASE
CASE nMODE == 0 .AND. cTYPE = "S"
   SETCOLOR(ALT_COLOR)
   ZBOX(2,51,21,76,BK2_COLOR,.F.)
   @ 19,52 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   IF lMOUSED
      @ 20,52 SAY " ù  ùAdd ù Edit ù Quit"
   ELSE
      @ 20,52 SAY "    [A]dd or [E]dit     "
   ENDIF
   HELPIT("Commands : [A]dd, [E]dit, [ESC] Returns")
   oTBROWSE := TBROWSEDB(3,52,18,75)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+LEFT(NAME,15)+" ù "+SHORT+" "}))
CASE nMODE == 0 .AND. cTYPE$"AT"
   SETCOLOR(ALT_COLOR)
   ZBOX(2,51,21,74,BK2_COLOR,.F.)
   @ 19,52 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   IF lMOUSED
      @ 20,52 SAY "  ù  ùAddùEditùQuit "
   ELSE
      @ 20,52 SAY "   [A]dd or [E]dit    "
   ENDIF
   HELPIT("Commands : [A]dd, [E]dit, [ESC] Returns")
   oTBROWSE := TBROWSEDB(3,52,18,73)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+NAME+" "}))
CASE nMODE == 0
   SETCOLOR(ALT_COLOR)
   ZBOX(2,51,21,69,BK2_COLOR,.F.)
   @ 19,52 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   IF lMOUSED
      @ 20,52 SAY "ùùAddùEditùQuit"
   ELSE
      @ 20,52 SAY " [A]dd or [E]dit "
   ENDIF
   HELPIT("Commands : [A]dd, [E]dit, [ESC] Returns")
   oTBROWSE := TBROWSEDB(3,52,18,68)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+NAME+" "}))

* Draw Screen, ACHOICE()'s, Called from CARD_EDIT()

CASE cTYPE$"NORU*"
   DO CASE
   CASE cTYPE == "N"
      SETCOLOR(MAIN_COLOR)
      ZBOX(8,59,16,77,BK1_COLOR,.T.)
      @  9,60 SAY " Select CONDITION"
      @ 10,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      HELPIT("Select the CONDITION of this card")
      aCHOICES[1] := " [ ] None        "
      aCHOICES[2] := " [M] Mint        "
      aCHOICES[3] := " [N] Near Mint   "
      aCHOICES[4] := " [L] Light Use   "
      aCHOICES[5] := " [H] Heavy Use   "
      nOPTION := IF(lMOUSED,DC_ACHOICE(11,60,15,76,aCHOICES),ACHOICE(11,60,15,76,aCHOICES))
      DO CASE
      CASE nOPTION = 1
         CARDS->FLAGS := LEFT(CARDS->FLAGS,1) + " " + RIGHT(CARDS->FLAGS,2)
      CASE nOPTION > 1
         CARDS->FLAGS := LEFT(CARDS->FLAGS,1) + SUBSTR(aCHOICES[nOPTION],3,1) + RIGHT(CARDS->FLAGS,2)
      ENDCASE
   CASE cTYPE == "O"
      SETCOLOR(MAIN_COLOR)
      ZBOX(8,59,13,77,BK1_COLOR,.T.)
      @  9,60 SAY " Open for Trade? "
      @ 10,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      HELPIT("Select YES or NO")
      aCHOICES[1] := " [N]ot for Trade "
      aCHOICES[2] := " [Y]es, Trade It "
      ASIZE(aCHOICES,2)
      nOPTION := IF(lMOUSED,DC_ACHOICE(11,60,12,76,aCHOICES),ACHOICE(11,60,12,76,aCHOICES))
      DO CASE
      CASE nOPTION = 1
         CARDS->FLAGS := LEFT(CARDS->FLAGS,3) + " "
      CASE nOPTION = 2
         CARDS->FLAGS := LEFT(CARDS->FLAGS,3) + "T"
      ENDCASE
   CASE cTYPE == "R"
      SETCOLOR(MAIN_COLOR)
      ZBOX(8,59,15,77,BK1_COLOR,.T.)
      @  9,60 SAY "  Select RARITY  "
      @ 10,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      HELPIT("Select the card's RARITY/COMMONALITY")
      aCHOICES[1] := " [ ] None        "
      aCHOICES[2] := " [C] Common      "
      aCHOICES[3] := " [U] Uncommon    "
      aCHOICES[4] := " [R] Rare        "
      ASIZE(aCHOICES,4)
      nOPTION := IF(lMOUSED,DC_ACHOICE(11,60,14,76,aCHOICES),ACHOICE(11,60,14,76,aCHOICES))
      DO CASE
      CASE nOPTION = 1
         CARDS->FLAGS := " " + RIGHT(CARDS->FLAGS,3)
      CASE nOPTION > 1
         CARDS->FLAGS := SUBSTR(aCHOICES[nOPTION],3,1) + RIGHT(CARDS->FLAGS,3)
      ENDCASE
   CASE cTYPE == "U"
      SETCOLOR(MAIN_COLOR)
      ZBOX(8,59,14,76,BK1_COLOR,.T.)
      @  9,60 SAY "Tournament Class"
      @ 10,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      HELPIT("Select the card's TOURNAMENT PLAYABILITY CLASS")
      aCHOICES[1] := " [O] Open       "
      aCHOICES[2] := " [R] Restricted "
      aCHOICES[3] := " [B] Banned     "
      ASIZE(aCHOICES,3)
      nOPTION := IF(lMOUSED,DC_ACHOICE(11,60,13,75,aCHOICES),ACHOICE(11,60,13,75,aCHOICES))
      IF nOPTION > 0
         CARDS->FLAGS := LEFT(CARDS->FLAGS,2) + SUBSTR(aCHOICES[nOPTION],3,1) + RIGHT(CARDS->FLAGS,1)
      ENDIF
   CASE cTYPE == "*"
      @ nROW,30 SAY DECKS->TYPE COLOR BK2_COLOR
      SETCOLOR(ALT_COLOR)
      ZBOX(9,47,16,66,BK2_COLOR,.F.)
      @ 10,48 SAY " Select DECK TYPE "
      @ 11,48 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      HELPIT("Select the TYPE of this DECK")
      aCHOICES[1] := "   Open Deck     "
      aCHOICES[2] := "   Tournament    "
      aCHOICES[3] := "   Sideboard     "
      aCHOICES[4] := "   Grand Melee   "
      ASIZE(aCHOICES,4)
      DO CASE
      CASE UPPER(DECKS->TYPE) = "OPEN DECK"
         nOPTION := IF(lMOUSED,DC_ACHOICE(12,48,15,65,aCHOICES,,,1),ACHOICE(12,48,15,65,aCHOICES,,,1))
      CASE UPPER(DECKS->TYPE) = "TOURNAMENT"
         nOPTION := IF(lMOUSED,DC_ACHOICE(12,48,15,65,aCHOICES,,,2),ACHOICE(12,48,15,65,aCHOICES,,,2))
      CASE UPPER(DECKS->TYPE) = "SIDEBOARD"
         nOPTION := IF(lMOUSED,DC_ACHOICE(12,48,15,65,aCHOICES,,,3),ACHOICE(12,48,15,65,aCHOICES,,,3))
      CASE UPPER(DECKS->TYPE) = "GRAND MELEE"
         nOPTION := IF(lMOUSED,DC_ACHOICE(12,48,15,65,aCHOICES,,,4),ACHOICE(12,48,15,65,aCHOICES,,,4))
      ENDCASE
      IF nOPTION > 0
         DECKS->TYPE := SUBSTR(aCHOICES[nOPTION],4,12)
      ENDIF
   ENDCASE
   SELECT SUPPORT
   SET ORDER TO 1
   SET FILTER TO
   IF cTYPE = "*"
      SELECT DECKS
      SETCOLOR(MAIN_COLOR)
      KEYBOARD CHR(IF(nOPTION = 0,K_ESC,IF(nLASTKEY = K_UP,K_UP,K_ENTER)))
   ELSE
      SELECT CARDS
      SETCOLOR(BK2_COLOR)
      KEYBOARD CHR(IF(nOPTION = 0,K_ESC,K_ENTER))
   ENDIF
   SETCURSOR(nCURSOR)
   RESTORE SCREEN FROM cSCREEN
   Return (.T.)

* Draw Screen, TBROWSE()'s, Called from CARD_EDIT()

OTHERWISE
   IF cTYPE$"AT" .AND. nMODE == 1
      IF lCOLOR
         RESTSCREEN(7,52,23,57,REPLICATE(CHR(219)+CHR(9),102))
      ELSE
         RESTSCREEN(7,52,23,57,REPLICATE(CHR(219)+CHR(0),102))
      ENDIF
      SETCOLOR(MAIN_COLOR)
      @  8,50 CLEAR TO 22,51              && Clear margin
      IF lCOLOR
         @ 7,52 SAY "ß" COLOR BK1_COLOR   && Put top piece
         SETCOLOR(SHAD_COLOR)
         @ 8,52 CLEAR TO 22,52            && Put side piece
         @ 23,52 SAY "Ü" COLOR BK1_COLOR  && Put bottom piece
      ENDIF
      SETCOLOR(MAIN_COLOR)
      ZBOX(8,54,21,77,BK1_COLOR,.T.)
      @ 10,55 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   ELSE
      SETCOLOR(MAIN_COLOR)
      ZBOX(8,59,21,77,BK1_COLOR,.T.)
      @ 10,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   ENDIF
   DO CASE
   CASE cTYPE == "A" .AND. nMODE == 1
      @  9,55 SAY "  Select the ARTIST  "
      IF lMOUSED
         @ 11,77 SAY ""
         @ 18,77 SAY ""
      ENDIF
      @ 19,55 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      @ 20,55 SAY "   [A]dd or [E]dit   "
      HELPIT("Select the card's ARTIST")
      cSEEK := IF(EMPTY(CARDS->ARTIST),"",CARDS->ARTIST)
      oTBROWSE := TBROWSEDB(11,55,18,76)
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+IF(EMPTY(NAME),"**** No Artist *****",NAME)+" "}))
   CASE cTYPE == "S" .AND. nMODE == 1
      @ 9,60 SAY "Select the SERIES"
      IF lMOUSED
         @ 11,77 SAY ""
         @ 20,77 SAY ""
      ENDIF
      HELPIT("Select the SERIES of this card")
      oTBROWSE := TBROWSEDB(11,60,20,76)
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+NAME+" "}))
   CASE cTYPE == "C" .AND. nMODE == 1
      @  9,60 SAY " Select the COLOR "
      IF lMOUSED
         @ 11,77 SAY ""
         @ 20,77 SAY ""
      ENDIF
      HELPIT("Select the COLOR of this card")
      cSEEK := IF(EMPTY(CARDS->COLOR),"",CARDS->COLOR)
      oTBROWSE := TBROWSEDB(11,60,20,76)
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+NAME+" "}))
   CASE cTYPE == "T" .AND. nMODE == 1
      @  9,57 SAY " Select the TYPE "
      IF lMOUSED
         @ 11,77 SAY ""
         @ 20,77 SAY ""
      ENDIF
      HELPIT("Select the TYPE of this card")
      cSEEK := IF(EMPTY(CARDS->TYPE),"",CARDS->TYPE)
      oTBROWSE := TBROWSEDB(11,55,20,76)
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+NAME+" "}))
   CASE cTYPE == "D" .AND. nMODE == 1
      @  9,60 SAY "  Select DEALER  "
      IF lMOUSED
         @ 11,77 SAY ""
         @ 18,77 SAY ""
      ENDIF
      @ 19,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      @ 20,60 SAY " [A]dd or [E]dit "
      HELPIT("Select the DEALER you bought or traded this card from")
      cSEEK := IF(EMPTY(CARDS->BUY_FROM),"",CARDS->BUY_FROM)
      oTBROWSE := TBROWSEDB(11,60,18,76)
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+IF(EMPTY(NAME),"** No Dealer **",NAME)+" "}))
   CASE cTYPE == "D" .AND. nMODE == 2
      @  9,60 SAY "  Select DEALER  "
      IF lMOUSED
         @ 11,77 SAY ""
         @ 18,77 SAY ""
      ENDIF
      @ 19,60 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
      @ 20,60 SAY " [A]dd or [E]dit "
      HELPIT("Select the DEALER you sold or traded this card to")
      cSEEK := IF(EMPTY(CARDS->SOLD_TO),"",CARDS->SOLD_TO)
      oTBROWSE := TBROWSEDB(11,60,18,76)
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+IF(EMPTY(NAME),"** No Dealer **",NAME)+" "}))
   ENDCASE
ENDCASE

* Adjust Database

SELECT SUPPORT
IF cTYPE$"AD" .AND. nMODE == 0
   SET FILTER TO TYPE == cTYPE .AND. ! EMPTY(NAME)
ELSE
   SET FILTER TO TYPE == cTYPE
ENDIF
GO TOP
IF nMODE > 0 .AND. ! EMPTY(cSEEK)
   SEEK cTYPE + UPPER(cSEEK)
   IF ! FOUND()
      GO TOP
   ENDIF
ENDIF

* Begin TBROWSE, for both CARD_EDIT() and SUPPORT()

DO WHILE .T.
   DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
   nSELECTED := oTBROWSE:ROWPOS
   DO CASE
   CASE lMOUSED .AND. cTYPE$"S"  .AND. nMODE = 0
      nKEY := MOUSEKEY(5)
   CASE lMOUSED .AND. cTYPE$"AT" .AND. nMODE = 0
      nKEY := MOUSEKEY(6)
   CASE lMOUSED .AND. cTYPE$"CD" .AND. nMODE = 0
      nKEY := MOUSEKEY(7)
   CASE lMOUSED .AND. cTYPE$"CS" .AND. nMODE > 0
      nKEY := MOUSEKEY(10)
   CASE lMOUSED .AND. cTYPE$"T"  .AND. nMODE > 0
      nKEY := MOUSEKEY(11)
   CASE lMOUSED .AND. cTYPE$"A"  .AND. nMODE > 0
      nKEY := MOUSEKEY(12)
   CASE lMOUSED .AND. cTYPE$"D"  .AND. nMODE > 0
      nKEY := MOUSEKEY(13)
   CASE ! lMOUSED
      nKEY := ASC(UPPER(CHR(INKEY(0))))
   ENDCASE

   * Begin Key/Mouse Processing

   DO CASE

   * Mouse, Pick New Row for SUPPORT()

   CASE (nKEY == K_MOUSE20 .AND. oTBROWSE:ROWPOS <> nSELECTED) .AND. nMODE = 0
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()

   * Mouse, Pick New Row for CARD_EDIT()

   CASE (nKEY == K_MOUSE30 .AND. oTBROWSE:ROWPOS <> nSELECTED) .AND. nMODE > 0
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()

   * Mouse or Key, Select Current Row for SUPPORT()

   CASE (nKEY == 69 .or. nKEY == K_ENTER .or. (nKEY == K_MOUSE20 .AND. oTBROWSE:ROWPOS = nSELECTED)) .AND. nMODE == 0
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      cNAME := LEFT(SUPPORT->NAME,15)
      DO CASE
      CASE cTYPE$"CD"
         @ oTBROWSE:ROWPOS+2,53 GET cNAME
         cLASTNAME := cNAME
      CASE cTYPE = "S"
         @ oTBROWSE:ROWPOS+2,53 GET cNAME
         @ oTBROWSE:ROWPOS+2,71 GET SUPPORT->SHORT
         cLASTNAME := SUPPORT->SHORT
      OTHERWISE
         @ oTBROWSE:ROWPOS+2,53 GET SUPPORT->NAME
         cLASTNAME := SUPPORT->NAME
      ENDCASE
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() <> 27
         IF cTYPE$"CDS"
            SUPPORT->NAME := cNAME
         ENDIF

       * Update Items in the card list

         SELECT CARDS
         nRECNO := RECNO()
         nORDER := INDEXORD()
         SET ORDER TO 0
         GO TOP
         DO CASE
         CASE cTYPE = "A" .AND. (SUPPORT->NAME <> cLASTNAME)
            REPLACE ALL ARTIST WITH SUPPORT->NAME FOR ARTIST = cLASTNAME
         CASE cTYPE = "C" .AND. (cNAME <> cLASTNAME)
            REPLACE ALL COLOR  WITH cNAME FOR COLOR = cLASTNAME
         CASE cTYPE = "D" .AND. (cNAME <> cLASTNAME)
            REPLACE ALL BUY_FROM WITH cNAME FOR BUY_FROM = cLASTNAME
            REPLACE ALL SOLD_TO  WITH cNAME FOR SOLD_TO  = cLASTNAME
         CASE cTYPE = "S" .AND. (SUPPORT->SHORT <> cLASTNAME)
            REPLACE ALL SERIES   WITH SUPPORT->SHORT FOR SERIES = cLASTNAME
         CASE cTYPE = "T" .AND. (SUPPORT->NAME <> cLASTNAME)
            REPLACE ALL TYPE WITH SUPPORT->NAME FOR TYPE = cLASTNAME
         ENDCASE
         SET ORDER TO nORDER
         GO nRECNO
         SELECT SUPPORT
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()

   * Mouse or Key, Select Current Row for CARD_EDIT()

   CASE (nKEY == K_ENTER .or. nKEY == K_ESC .or. (nKEY == K_MOUSE30 .AND. oTBROWSE:ROWPOS = nSELECTED)) .AND. nMODE <> 0
      IF nKEY <> K_ESC
         DO CASE
         CASE cTYPE == "A"
            CARDS->ARTIST   := SUPPORT->NAME
         CASE cTYPE == "S"
            CARDS->SERIES   := SUPPORT->SHORT
         CASE cTYPE == "C"
            CARDS->COLOR    := SUPPORT->NAME
         CASE cTYPE == "T"
            CARDS->TYPE     := SUPPORT->NAME
         CASE cTYPE == "D" .AND. nMODE == 1
            CARDS->BUY_FROM := SUPPORT->NAME
         CASE cTYPE == "D" .AND. nMODE == 2
            CARDS->SOLD_TO  := SUPPORT->NAME
         ENDCASE
      ENDIF
      SELECT SUPPORT
      SET FILTER TO
      SELECT CARDS
      SETCURSOR(nCURSOR)
      SETCOLOR(BK2_COLOR)
      RESTORE SCREEN FROM cSCREEN
      KEYBOARD CHR(IF(nKEY = K_ESC,K_ESC,K_ENTER))
      Return (.T.)

   CASE (nKEY == 69 .AND. nMODE == 1 .AND. cTYPE = "A")         && Edit on Fly
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      cLASTNAME := SUPPORT->NAME
      @ oTBROWSE:ROWPOS+10,56 GET SUPPORT->NAME
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF SUPPORT->NAME <> cLASTNAME .AND. LASTKEY() <> 27

       * Update Artists in the card list

         SELECT CARDS
         nRECNO := RECNO()
         nORDER := INDEXORD()
         SET ORDER TO 0
         GO TOP
         REPLACE ALL ARTIST WITH SUPPORT->NAME FOR ARTIST = cLASTNAME
         SET ORDER TO nORDER
         GO nRECNO
         SELECT SUPPORT
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()

   CASE (nKEY == 69 .AND. nMODE > 0 .AND. cTYPE = "D")    && Edit Dealer on fly
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      cNAME := LEFT(SUPPORT->NAME,15)
      cLASTNAME := cNAME
      @ oTBROWSE:ROWPOS+10,61 GET cNAME
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() <> 27
         SUPPORT->NAME := cNAME
         IF cNAME <> cLASTNAME

          * Update Artists in the card list

            SELECT CARDS
            nRECNO := RECNO()
            nORDER := INDEXORD()
            SET ORDER TO 0
            GO TOP
            REPLACE ALL BUY_FROM WITH cNAME FOR BUY_FROM = cLASTNAME
            REPLACE ALL SOLD_TO  WITH cNAME FOR SOLD_TO  = cLASTNAME
            SET ORDER TO nORDER
            GO nRECNO
            SELECT SUPPORT
         ENDIF
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
   CASE (nKEY == 65 .or. nKEY == K_INS) .AND. nMODE == 0
      oTBROWSE:NBOTTOM := 17
      oTBROWSE:GOBOTTOM()
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      APPEND BLANK
      SUPPORT->TYPE := cTYPE
      cNAME := LEFT(SUPPORT->NAME,15)
      DO CASE
      CASE cTYPE$"CD"
         @ oTBROWSE:ROWPOS+3,53 GET cNAME
      CASE cTYPE = "S"
         @ oTBROWSE:ROWPOS+3,53         GET cNAME
         @ oTBROWSE:ROWPOS+3,69 SAY "ù" GET SUPPORT->SHORT
      OTHERWISE
         @ oTBROWSE:ROWPOS+3,53 GET SUPPORT->NAME
      ENDCASE
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() == K_ESC .or. EMPTY(IF(cTYPE$"CDS",cNAME,SUPPORT->NAME))
         DELETE
      ELSE
         IF cTYPE$"CDS"
            SUPPORT->NAME := cNAME
         ENDIF
      ENDIF
      oTBROWSE:NBOTTOM  := 18
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:GOTOP()
   CASE ((nKEY == 65 .OR. nKEY == K_INS) .AND. nMODE == 1 .AND. cTYPE = "A")

      * ADD ARTIST on the fly

      oTBROWSE:NBOTTOM := 17
      oTBROWSE:GOBOTTOM()
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      APPEND BLANK
      SUPPORT->TYPE := cTYPE
      @ oTBROWSE:ROWPOS+11,56 GET NAME
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() == K_ESC .or. EMPTY(SUPPORT->NAME)
         DELETE
      ENDIF
      oTBROWSE:NBOTTOM  := 18
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
   CASE ((nKEY == 65 .OR. nKEY == K_INS) .AND. nMODE > 0 .AND. cTYPE = "D")

      * ADD DEALER on the fly

      oTBROWSE:NBOTTOM := 17
      oTBROWSE:GOBOTTOM()
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      APPEND BLANK
      SUPPORT->TYPE := cTYPE
      cNAME := LEFT(SUPPORT->NAME,15)
      @ oTBROWSE:ROWPOS+11,61 GET cNAME
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() == K_ESC .or. EMPTY(cNAME)
         DELETE
      ELSE
         SUPPORT->NAME := cNAME
      ENDIF
      oTBROWSE:NBOTTOM  := 18
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
   CASE (nKEY == K_ESC .or. (nKEY == 81 .AND. lMOUSED)) .AND. nMODE == 0
      SELECT SUPPORT
      SET FILTER TO
      SELECT CARDS
      SETCURSOR(nCURSOR)
      SETCOLOR(BK2_COLOR)
      Return (Nil)
   CASE nKEY == K_DOWN
      oTBROWSE:DOWN()
   CASE nKEY == K_UP
      oTBROWSE:UP()
   CASE nKEY == K_PGDN
      oTBROWSE:PAGEDOWN()
   CASE nKEY == K_PGUP
      oTBROWSE:PAGEUP()
   CASE nKEY == K_HOME
      oTBROWSE:GOTOP()
   CASE nKEY == K_END
      oTBROWSE:GOBOTTOM()
   ENDCASE
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                           Maintain/Select Decks                          */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function DECKS
Local oTBROWSE, nKEY, cSCREEN, GETLIST := {}, nHIGH := 0, nDECK, nCARDS, nKEY2
IF lCOLOR
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(9),1840))
ELSE
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(0),1840))
ENDIF
SETCOLOR(MAIN_COLOR)
ZBOX(2,6,22,71,BK1_COLOR,.T.)
@  3,7  SAY "     Name of Deck      Type of Deck  Cards   Max   Wins  Losses "
@  4,7  SAY " ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄ  ÄÄÄÄÄ  ÄÄÄÄ  ÄÄÄÄÄÄ "
IF lMOUSED
   @  5,71 SAY ""
   @ 19,71 SAY ""
ENDIF
@ 20,7  SAY "ÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄ"
@ 21,7  SAY " View ³ Add ³ Edit ³ Kill ³ Statistics ³ Random Drawing ³ Quit  "
HELPIT("Press the first letter of the command on the bottom line.")
oTBROWSE := TBROWSEDB(5,7,19,70)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+DECK+"  "+TYPE+STR(COUNT,6)+" of"+STR(CARDS,5)+STR(WINS,5)+STR(LOSSES,7)+"   "}))

* Set databases

USE ("DAEMON3.DD") ALIAS DECKS    NEW EXCLUSIVE
SET INDEX TO ("DAEMON3A.DD")
USE ("DAEMON4.DD") ALIAS DECKLINK NEW EXCLUSIVE
SET INDEX TO ("DAEMON4A.DD"), ("DAEMON4B.DD")
SELECT DECKS
GO TOP
DO WHILE .T.
   DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
   nSELECTED := oTBROWSE:ROWPOS
   nKEY      := IF(lMOUSED,MOUSEKEY(14),ASC(UPPER(CHR(INKEY(0)))))
   DO CASE
   CASE (nKEY == K_MOUSE35 .AND. oTBROWSE:ROWPOS <> nSELECTED)  && Mouse-Select
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()
   CASE (nKEY == 86 .or. nKEY == K_ENTER .or. (nKEY == K_MOUSE35 .AND. oTBROWSE:ROWPOS = nSELECTED))
      SAVE SCREEN TO cSCREEN
      @ 21,7 SAY " View " COLOR BK2_COLOR
      DC_PAUSE(.4)
      DECK_WARN(1)
      DECKBUILD(DECKS->NUMBER,1)
      SELECT DECKS
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 65 .or. nKEY == K_INS)
      @ 21,14 SAY " Add " COLOR BK2_COLOR
      oTBROWSE:NBOTTOM := 18
      oTBROWSE:GOBOTTOM()
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO

      * Get the highest number

      nHIGH := 0
      GO TOP
      DO WHILE ! EOF(); nHIGH := IF(NUMBER > nHIGH .AND. ! DELETED(),NUMBER,nHIGH); SKIP; ENDDO
      APPEND BLANK
      DECKS->NUMBER := nHIGH + 1
      DECKS->TYPE   := "Open Deck"

      * Begin GET

      @ oTBROWSE:ROWPOS+5,7 CLEAR TO oTBROWSE:ROWPOS+5,70
      @ oTBROWSE:ROWPOS+5,8  GET DECKS->DECK
      @ oTBROWSE:ROWPOS+5,30 GET DECKS->TYPE    WHEN SUPPORT("*",1)  VALID CHCK_CARDS()
      @ oTBROWSE:ROWPOS+5,52 GET DECKS->CARDS   VALID DECK_WARN(1)
      @ oTBROWSE:ROWPOS+5,58 GET DECKS->WINS
      @ oTBROWSE:ROWPOS+5,65 GET DECKS->LOSSES
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() == K_ESC .OR. EMPTY(DECK)
         DELETE
      ELSE
         SAVE SCREEN TO cSCREEN
         DECKBUILD(DECKS->NUMBER,2)
         SELECT DECKS
         SETCOLOR(MAIN_COLOR)
         RESTORE SCREEN FROM cSCREEN
      ENDIF
      @ 21,14 SAY " Add " COLOR MAIN_COLOR
      oTBROWSE:NBOTTOM  := 19
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:GOTOP()
   CASE nKEY == 69
      @ 21,20 SAY " Edit " COLOR BK2_COLOR
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      @ oTBROWSE:ROWPOS+4,8  GET DECKS->DECK
      @ oTBROWSE:ROWPOS+4,30 GET DECKS->TYPE    WHEN SUPPORT("*",1)
      @ oTBROWSE:ROWPOS+4,52 GET DECKS->CARDS   VALID DECK_WARN(1)
      @ oTBROWSE:ROWPOS+4,58 GET DECKS->WINS
      @ oTBROWSE:ROWPOS+4,65 GET DECKS->LOSSES
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF LASTKEY() <> 27
         SAVE SCREEN TO cSCREEN
         DECKBUILD(DECKS->NUMBER,3)
         SELECT DECKS
         SETCOLOR(MAIN_COLOR)
         RESTORE SCREEN FROM cSCREEN
      ENDIF
      @ 21,20 SAY " Edit " COLOR MAIN_COLOR
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
   CASE (nKEY == 75 .or. nKEY = K_DEL)
      SAVE SCREEN TO cSCREEN
      @ 21,27 SAY " Kill " COLOR BK2_COLOR
      SETCOLOR(ALT_COLOR)
      ZBOX(11,21,13,57,BK2_COLOR,.F.)
      IF lMOUSED
         @ 12,23 SAY "Shall I KILL this deck?     /    "
         @ 12,47 SAY " Y " COLOR BUTT_COLOR
         @ 12,53 SAY " N " COLOR BUTT_COLOR
      ELSE
         @ 12,23 SAY "Shall I KILL this deck? [Y] / [N]"
      ENDIF
      nKEY2 := IF(lMOUSED,MOUSEKEY(15),INKEY(0))
      RESTORE SCREEN FROM cSCREEN
      IF nKEY2 == 89 .or. nKEY2 == 121
         nDECK := DECKS->NUMBER
         DELETE

         * Delete all occurences in DAEMON4.DD

         SELECT DECKLINK
         SEEK STR(nDECK,3)
         IF FOUND()
            DO WHILE (DECKLINK->DECK = nDECK .AND. ! EOF())
               DELETE
               SKIP
            ENDDO
         ENDIF

         * Fix TBrowse

         SELECT DECKS
         IF oTBROWSE:ROWPOS = 1
            SKIP 1
            IF EOF()
               SKIP -1
            ENDIF
         ENDIF
         oTBROWSE:REFRESHALL()
         oTBROWSE:REFRESHCURRENT()
      ENDIF
      SETCOLOR(MAIN_COLOR)
   CASE nKEY == 83
      SAVE SCREEN TO cSCREEN
      @ 21,34 SAY " Statistics " COLOR BK2_COLOR
      DC_PAUSE(.4)
      DECK_WARN(1)
      DECKSTATS(DECKS->NUMBER)
      SELECT DECKS
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 82
      SAVE SCREEN TO cSCREEN
      @ 21,47 SAY " Random Drawing " COLOR BK2_COLOR
      nCARDS := 8
      SETCOLOR(ALT_COLOR)
      ZBOX(11,18,13,60,BK2_COLOR,.F.)
      @ 12,20 SAY "How many cards do you want to draw?" GET nCARDS PICTURE "@Z 999"
      SET CURSOR ON
      IF lMOUSED
         DC_READMODAL(GETLIST); GETLIST := {}
      ELSE
         READ
      ENDIF
      SET CURSOR OFF
      IF nCARDS > 0 .AND. LASTKEY() <> 27
         IF nCARDS <= DECKS->COUNT
            DECKDRAW(DECKS->NUMBER,nCARDS)
            SELECT DECKS
         ELSE
            BEEP_LONG
            SETCOLOR(WARN_COLOR)
            ZBOX(11,11,16,67,BK2_COLOR,.F.)
            @ 13,13 SAY "Sorry : You don't have that many cards in this deck."
            PAUSE(15,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         ENDIF
      ENDIF
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 81 .OR. nKEY == K_ESC)
      @ 21,64 SAY " Quit " COLOR BK2_COLOR
      DC_PAUSE(.3)
      CLOSE DECKS
      CLOSE DECKLINK
      Return (Nil)
   CASE nKEY == K_DOWN
      oTBROWSE:DOWN()
   CASE nKEY == K_UP
      oTBROWSE:UP()
   CASE nKEY == K_PGDN
      oTBROWSE:PAGEDOWN()
   CASE nKEY == K_PGUP
      oTBROWSE:PAGEUP()
   CASE nKEY == K_HOME
      oTBROWSE:GOTOP()
   CASE nKEY == K_END
      oTBROWSE:GOBOTTOM()
   ENDCASE
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                         Assign Default Counts                            */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function CHCK_CARDS
IF DECKS->CARDS < 1
   DO CASE
   CASE UPPER(DECKS->TYPE) = "TOURNAMENT"
      DECKS->CARDS := 60
   CASE UPPER(DECKS->TYPE) = "SIDEBOARD"
      DECKS->CARDS := 15
   CASE UPPER(DECKS->TYPE) = "GRAND MELEE"
      DECKS->CARDS := 100
   ENDCASE
ENDIF
Return (.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                          Deck Warning Messages                           */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function DECK_WARN (nMODE)
Local cSCREEN
SAVE SCREEN TO cSCREEN
DO CASE
CASE nMODE = 1
   DO CASE
   CASE UPPER(DECKS->TYPE) = "TOURNAMENT" .AND. CARDS < 60
      BEEP_LONG
      SETCOLOR(WARN_COLOR)
      ZBOX(10,15,15,63,BK2_COLOR,.F.)
      @ 12,17 SAY "Tournament Decks should be at least 60 cards."
      PAUSE(14,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
      RESTORE SCREEN FROM cSCREEN
   CASE UPPER(DECKS->TYPE) = "SIDEBOARD" .AND. CARDS <> 15
      BEEP_LONG
      SETCOLOR(WARN_COLOR)
      ZBOX(10,18,15,60,BK2_COLOR,.F.)
      @ 12,20 SAY "Sideboards should be exactly 15 cards."
      PAUSE(14,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
      RESTORE SCREEN FROM cSCREEN
   CASE UPPER(DECKS->TYPE) = "GRAND MELEE" .AND. CARDS < 100
      BEEP_LONG
      SETCOLOR(WARN_COLOR)
      ZBOX(10,14,15,64,BK2_COLOR,.F.)
      @ 12,16 SAY "Grand Melee Decks should be at least 100 cards."
      PAUSE(14,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
      RESTORE SCREEN FROM cSCREEN
   ENDCASE
   Return (CARDS > 0)
CASE nMODE = 2
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,20,16,72,BK2_COLOR,.F.)
   @ 13,22 SAY "Tournament Decks may contain only 4 of this card."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 3
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,22,16,71,BK2_COLOR,.F.)
   @ 13,24 SAY "Tournament Decks may not contain BANNED cards."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 4
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,17,16,75,BK2_COLOR,.F.)
   @ 13,18 SAY "Tournament Decks can't contain multiple RESTRICTED cards."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 5
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,20,16,71,BK2_COLOR,.F.)
   @ 13,22 SAY "Sorry : You've filled the capacity of this deck."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 6
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,17,16,75,BK2_COLOR,.F.)
   @ 13,19 SAY "Sorry : You don't have any of these cards in this deck."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 7
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,20,16,73,BK2_COLOR,.F.)
   @ 13,22 SAY "Grand Melee Decks may contain only 6 of this card."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 8
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,22,16,72,BK2_COLOR,.F.)
   @ 13,24 SAY "Grand Melee Decks may not contain BANNED cards."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
CASE nMODE = 9
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(11,17,16,76,BK2_COLOR,.F.)
   @ 13,18 SAY "Grand Melee Decks can't contain multiple RESTRICTED cards."
   PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   RESTORE SCREEN FROM cSCREEN
ENDCASE
Return (.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                         Actual Deck Construction                         */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function DECKBUILD (nDECK,nMODE)
Local oTBROWSE, nKEY, aCARDS[16], cTITLE, nRECNO, cSCREEN, lOK, nCOLUMN := 1
Local nQUANTITY, cSEARCH
AFILL(aCARDS,0)
IF lCOLOR
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(9),1840))
ELSE
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(0),1840))
ENDIF
SETCOLOR(MAIN_COLOR)
ZBOX(2,1,22,12,BK1_COLOR,.T.)
@  3,2 SAY "Black     "
@  4,2 SAY "Blue      "
@  5,2 SAY "Green     "
@  6,2 SAY "Red       "
@  7,2 SAY "White     "
@  8,2 SAY "Gold      "
@  9,2 SAY "Artfact   "
@ 10,2 SAY "Enchant   "
@ 11,2 SAY "Instant   "
@ 12,2 SAY "Intrrpt   "
@ 13,2 SAY "Land      "
@ 14,2 SAY "Sorcery   "
@ 15,2 SAY "Summon    "
@ 16,2 SAY "ÄÄÄÄÄÄÄÄÄÄ"
@ 17,2 SAY "Rstrctd   "
@ 18,2 SAY "Banned    "
@ 19,2 SAY "ÍÍÍÍÍÍÍÍÍÍ"
@ 20,2 SAY "Cards     "
@ 21,2 SAY "Deck      "
@ 21,8 SAY STR(DECKS->CARDS,4) COLOR SHOW_COLOR

* Load and display the statistics

SELECT DECKLINK
SEEK STR(nDECK,3)
IF FOUND()
   DO WHILE (DECKLINK->DECK = nDECK .AND. ! EOF())
      IF DECKLINK->COLOR <> 0
         aCARDS[DECKLINK->COLOR] := aCARDS[DECKLINK->COLOR] + QUANTITY
      ENDIF
      IF DECKLINK->TYPE  <> 0
         aCARDS[DECKLINK->TYPE] := aCARDS[DECKLINK->TYPE] + QUANTITY
      ENDIF
      IF DECKLINK->STATUS <> 0
         aCARDS[DECKLINK->STATUS] := aCARDS[DECKLINK->STATUS] + QUANTITY
      ENDIF
      aCARDS[16] := aCARDS[16] + QUANTITY
      SKIP
   ENDDO
ENDIF
FOR nX := 1 TO 16
   @ nX + IF(nX < 14,2,IF(nX < 16,3,4)),9 SAY STR(aCARDS[nX],3) COLOR SHOW_COLOR
NEXT nX
cTITLE := IF(nMODE = 1,"Viewing",IF(nMODE = 2,"Building","Editing")) + " : " +LTRIM(RTRIM(UPPER(DECKS->DECK)))
cTITLE := cTITLE + " (" + LTRIM(RTRIM(UPPER(DECKS->TYPE))) + ")"
ZBOX(2,15,22,77,BK1_COLOR,.T.)
@ 3,46-LEN(cTITLE)/2 SAY cTITLE
@ 5,16 SAY "      Series / Card Name       Color         Type         No."
@ 6,16 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄ"
IF lMOUSED
   SETCOLOR(BUTT_COLOR)
   @ 22,16 SAY " TOP "
   @ 22,22 SAY " PGUP "
   @ 22,29 SAY " LINE  "
   @ 22,38 SAY " QUIT "
   IF nMODE = 1
      @ 22,46 SAY " VIEW "
   ELSE
      @ 22,45 SAY " ORDER "
   ENDIF
   @ 22,53 SAY " LINE  "
   @ 22,62 SAY " PGDN "
   @ 22,69 SAY " BOTTOM "
   SETCOLOR(MAIN_COLOR)
ENDIF
IF nMODE = 1
   HELPIT("Commands : [], [], [Enter] Views, [Esc] Returns")
ELSE
   HELPIT("Commands : [+], [-], [Tab] Order, [Ent] View, [A-Z] Searches")
ENDIF
oTBROWSE := TBROWSEDB(7,15,21,77)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+SERIES+"ù"+LEFT(CARD,25)+" "+COLOR+" "+TYPE+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+" "}))

* Set temporary database, if viewing

IF nMODE = 1
   IF aCARDS[16] = 0
      SETCOLOR(ALT_COLOR)
      ZBOX(11,19,16,73,BK2_COLOR,.F.)
      @ 13,21 SAY "Sorry : No cards found in deck.  Use EDIT to build."
      PAUSE(15,45,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
      Return (Nil)
   ENDIF
   SAVE SCREEN TO cSCREEN
   SETCOLOR(ALT_COLOR)
   ZBOX(12,22,14,69,BK2_COLOR,.F.)
   @ 13,24 SAY "Please Wait : Gathering Cards for this Deck."
   SET CURSOR ON
   SELECT CARDS
   SET ORDER TO 2
   SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
   COPY TO DAEMON1.TMP FOR DECKLINK->QUANTITY > 0
   USE ("DAEMON1.TMP") ALIAS CARDTEMP NEW EXCLUSIVE
   SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
   RESTORE SCREEN FROM cSCREEN
   SET CURSOR OFF
ELSE
   SELECT CARDS
   SET ORDER TO 1
   SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
ENDIF
GO TOP
DO WHILE .T.
   DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
   nSELECTED := oTBROWSE:ROWPOS
   nKEY      := IF(lMOUSED,MOUSEKEY(IF(nMODE = 1,17,16)),ASC(UPPER(CHR(INKEY(0)))))
   DO CASE
   CASE ((nKEY == K_MOUSE40 .OR. nKEY == K_MOUSE41) .AND. oTBROWSE:ROWPOS <> nSELECTED)  && Mouse-Select
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()
   CASE ((nKEY == K_MOUSE40 .OR. nKEY == K_MOUSE41) .AND. oTBROWSE:ROWPOS = nSELECTED) .AND. nMODE = 1  && Mouse-View
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:STABILIZE()
      CARD_VIEW(IF(nMODE = 1,2,1))
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == K_TAB .AND. nMODE > 1                           && Change Order
      SETCOLOR(MAIN_COLOR)
      nCOLUMN := IF(nCOLUMN = 5,1,nCOLUMN + 1)
      DO CASE
      CASE nCOLUMN == 1
         @ 5,16 SAY "      Series / Card Name       Color         Type         No."
         @ 6,16 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+SERIES+"ù"+LEFT(CARD,25)+" "+COLOR+" "+TYPE+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+" "}))
      CASE nCOLUMN == 2
         @ 5,16 SAY "      Card Name / Series       Color         Type         No."
         @ 6,16 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+LEFT(CARD,25)+"ù"+SERIES+" "+COLOR+" "+TYPE+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+" "}))
      CASE nCOLUMN == 3
         @ 5,16 SAY "Color       Series / Card Name               Type         No."
         @ 6,16 SAY "ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+COLOR+" "+SERIES+"ù"+LEFT(CARD,25)+" "+TYPE+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+" "}))
      CASE nCOLUMN == 4
         @ 5,16 SAY "        Type               Series / Card Name       Color No."
         @ 6,16 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+TYPE+" "+SERIES+"ù"+LEFT(CARD,25)+" "+COLOR+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+" "}))
      CASE nCOLUMN == 5
         @ 5,16 SAY "Ser. Color         Card Name                 Type         No."
         @ 6,16 SAY "ÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄ"
         oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+SERIES+" "+COLOR+" "+LEFT(CARD,25)+" "+TYPE+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+" "}))
      ENDCASE
      SET ORDER TO nCOLUMN
      oTBROWSE:GOTOP()

   CASE (nKEY == K_SPACE .or. nKEY == 43 .or. (nKEY == K_MOUSE40 .AND. oTBROWSE:ROWPOS = nSELECTED)) .AND. nMODE > 1

    * Except for lands, which can be as many as wanted except for SPECIAL LANDS

      IF (aCARDS[16] < DECKS->CARDS)           /* Check to see if beyond max */
         lOK := .T.
         DO CASE
         CASE (DECKLINK->QUANTITY > 3 .AND. UPPER(DECKS->TYPE) = "TOURNAMENT") .AND. (UPPER(LEFT(CARDS->TYPE,4)) <> "LAND" .OR. "SPECIAL"$UPPER(CARDS->TYPE) .OR. "LEGENDARY"$UPPER(CARDS->TYPE))
            DECK_WARN(2)
            lOK := .F.
         CASE (DECKLINK->QUANTITY > 5 .AND. UPPER(DECKS->TYPE) = "GRAND MELEE") .AND. (UPPER(LEFT(CARDS->TYPE,4)) <> "LAND" .OR. "SPECIAL"$UPPER(CARDS->TYPE) .OR. "LEGENDARY"$UPPER(CARDS->TYPE))
            DECK_WARN(7)
            lOK := .F.
         CASE SUBSTR(CARDS->FLAGS,3,1) = "B" .AND. UPPER(DECKS->TYPE) = "TOURNAMENT"
            DECK_WARN(3)
            lOK := .F.
         CASE SUBSTR(CARDS->FLAGS,3,1) = "B" .AND. UPPER(DECKS->TYPE) = "GRAND MELEE"
            DECK_WARN(8)
            lOK := .F.
         CASE SUBSTR(CARDS->FLAGS,3,1) = "R" .AND. DECKLINK->QUANTITY > 0 .AND. UPPER(DECKS->TYPE) = "TOURNAMENT"
            DECK_WARN(4)
            lOK := .F.
         CASE SUBSTR(CARDS->FLAGS,3,1) = "R" .AND. DECKLINK->QUANTITY > 0 .AND. UPPER(DECKS->TYPE) = "GRAND MELEE"
            DECK_WARN(9)
            lOK := .F.
         ENDCASE

         * If no errors, then go ahead and add card to deck

         IF lOK
            SELECT DECKLINK
            SEEK STR(nDECK,3) + STR(CARDS->REFERENCE,5)
            IF ! FOUND()
               APPEND BLANK
               DECKLINK->DECK := nDECK
               DECKLINK->CARD := CARDS->REFERENCE
            ENDIF

            * Colors

            DO CASE
            CASE "BLACK"$UPPER(CARDS->COLOR)
               aCARDS[1]++; DECKLINK->COLOR := 1
            CASE "BLUE"$UPPER(CARDS->COLOR)
               aCARDS[2]++; DECKLINK->COLOR := 2
            CASE "GREEN"$UPPER(CARDS->COLOR)
               aCARDS[3]++; DECKLINK->COLOR := 3
            CASE "RED"$UPPER(CARDS->COLOR)
               aCARDS[4]++; DECKLINK->COLOR := 4
            CASE "WHITE"$UPPER(CARDS->COLOR)
               aCARDS[5]++; DECKLINK->COLOR := 5
            CASE "GOLD"$UPPER(CARDS->COLOR)
               aCARDS[6]++; DECKLINK->COLOR := 6
            ENDCASE

            * Types

            DO CASE
            CASE LEFT(UPPER(CARDS->TYPE),8) = "ARTIFACT"
               aCARDS[7]++; DECKLINK->TYPE  := 7
            CASE LEFT(UPPER(CARDS->TYPE),7) = "ENCHANT"
               aCARDS[8]++; DECKLINK->TYPE  := 8
            CASE LEFT(UPPER(CARDS->TYPE),7) = "INSTANT"
               aCARDS[9]++; DECKLINK->TYPE  := 9
            CASE LEFT(UPPER(CARDS->TYPE),9) = "INTERRUPT"
               aCARDS[10]++; DECKLINK->TYPE  := 10
            CASE LEFT(UPPER(CARDS->TYPE),4) = "LAND"
               aCARDS[11]++; DECKLINK->TYPE := 11
            CASE LEFT(UPPER(CARDS->TYPE),7) = "SORCERY"
               aCARDS[12]++; DECKLINK->TYPE := 12
            CASE LEFT(UPPER(CARDS->TYPE),6) = "SUMMON"
               aCARDS[13]++; DECKLINK->TYPE := 13
            ENDCASE

            * Tournament Play Status

            DO CASE
            CASE SUBSTR(CARDS->FLAGS,3,1) = "R"
               aCARDS[14]++; DECKLINK->STATUS := 14
            CASE SUBSTR(CARDS->FLAGS,3,1) = "B"
               aCARDS[15]++; DECKLINK->STATUS := 15
            ENDCASE

            * Final updates

            DECKLINK->QUANTITY++
            aCARDS[16]++
            FOR nX := 1 TO 16
               @ nX + IF(nX < 14,2,IF(nX < 16,3,4)),9 SAY STR(aCARDS[nX],3) COLOR SHOW_COLOR
            NEXT nX
            SELECT CARDS
            oTBROWSE:REFRESHCURRENT()
         ENDIF
      ELSE
         DECK_WARN(5)
         CLEAR TYPEAHEAD
      ENDIF
   CASE (nKEY == 45 .OR. (nKEY == K_MOUSE41 .AND. oTBROWSE:ROWPOS = nSELECTED)) .AND. nMODE > 1
      IF DECKLINK->QUANTITY > 0
         SELECT DECKLINK
         SEEK STR(nDECK,3) + STR(CARDS->REFERENCE,5)
         IF FOUND()
            aCARDS[ 1] := aCARDS[ 1] - IF("BLACK"$UPPER(CARDS->COLOR),1,0)
            aCARDS[ 2] := aCARDS[ 2] - IF("BLUE"$UPPER(CARDS->COLOR),1,0)
            aCARDS[ 3] := aCARDS[ 3] - IF("GREEN"$UPPER(CARDS->COLOR),1,0)
            aCARDS[ 4] := aCARDS[ 4] - IF("RED"$UPPER(CARDS->COLOR),1,0)
            aCARDS[ 5] := aCARDS[ 5] - IF("WHITE"$UPPER(CARDS->COLOR),1,0)
            aCARDS[ 6] := aCARDS[ 6] - IF("GOLD"$UPPER(CARDS->COLOR),1,0)
            aCARDS[ 7] := aCARDS[ 7] - IF(LEFT(UPPER(CARDS->TYPE),8) = "ARTIFACT",1,0)
            aCARDS[ 8] := aCARDS[ 8] - IF(LEFT(UPPER(CARDS->TYPE),7) = "ENCHANT",1,0)
            aCARDS[ 9] := aCARDS[ 9] - IF(LEFT(UPPER(CARDS->TYPE),7) = "INSTANT",1,0)
            aCARDS[10] := aCARDS[10] - IF(LEFT(UPPER(CARDS->TYPE),9) = "INTERRUPT",1,0)
            aCARDS[11] := aCARDS[11] - IF(LEFT(UPPER(CARDS->TYPE),4) = "LAND",1,0)
            aCARDS[12] := aCARDS[12] - IF(LEFT(UPPER(CARDS->TYPE),7) = "SORCERY",1,0)
            aCARDS[13] := aCARDS[13] - IF(LEFT(UPPER(CARDS->TYPE),6) = "SUMMON",1,0)
            aCARDS[14] := aCARDS[14] - IF(SUBSTR(CARDS->FLAGS,3,1) = "R",1,0)
            aCARDS[15] := aCARDS[15] - IF(SUBSTR(CARDS->FLAGS,3,1) = "B",1,0)
            aCARDS[16]--
            DECKLINK->QUANTITY--
            FOR nX := 1 TO 16
               @ nX + IF(nX < 14,2,IF(nX < 16,3,4)),9 SAY STR(aCARDS[nX],3) COLOR SHOW_COLOR
            NEXT nX
         ENDIF
         SELECT CARDS
         oTBROWSE:REFRESHCURRENT()
      ELSE
         DECK_WARN(6)
      ENDIF

*  CASE nKEY >= 49 .AND. nKEY <= 57                        && Set 1 Digit Quan.
*     oTBROWSE:AUTOLITE := .F.
*     oTBROWSE:REFRESHCURRENT()
*     DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
*     KEYBOARD CHR(nKEY)
*     nQUANTITY := DECKLINK->QUANTITY
*     @ oTBROWSE:ROWPOS+6,74 GET nQUANTITY PICTURE "@Z 999"
*     SET KEY K_UP   TO ENTER_UP()
*     SET KEY K_DOWN TO ENTER_DN()
*     SET CURSOR ON
*     IF lMOUSED
*        DC_READMODAL(GETLIST); GETLIST := {}
*     ELSE
*        READ
*     ENDIF
*     SET CURSOR OFF
*     SET KEY K_UP   TO
*     SET KEY K_DOWN TO
*     IF LASTKEY() <> 27 .AND. nQUANTITY > 0
*        nDIFF := nQUANTITY - DECKLINK->QUANTITY
*     ENDIF
*     oTBROWSE:AUTOLITE := .T.
*     oTBROWSE:REFRESHCURRENT()

   CASE nKEY == K_ENTER                                            && View Card
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:STABILIZE()
      CARD_VIEW(IF(nMODE = 1,2,1))
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == K_ESC
      IF nMODE = 1
         CLOSE CARDTEMP
         ERASE ("DAEMON1.TMP")
      ENDIF
      DECKS->COUNT := aCARDS[16]
      Return (Nil)
   CASE nKEY == K_DOWN
      oTBROWSE:DOWN()
   CASE nKEY == K_UP
      oTBROWSE:UP()
   CASE nKEY == K_PGDN
      oTBROWSE:PAGEDOWN()
   CASE nKEY == K_PGUP
      oTBROWSE:PAGEUP()
   CASE nKEY == K_HOME
      oTBROWSE:GOTOP()
   CASE nKEY == K_END
      oTBROWSE:GOBOTTOM()
   OTHERWISE
      IF (nKEY >= 65 .AND. nKEY <= 90) .AND. nMODE > 1
         oTBROWSE:AUTOLITE := .F.
         oTBROWSE:REFRESHCURRENT()
         oTBROWSE:STABILIZE()
         nRECNO := RECNO()
         SETCOLOR(ALT_COLOR)
         KEYBOARD CHR(nKEY)
         DO CASE
         CASE nCOLUMN == 2
            cSEARCH := SPACE(20)
            ZBOX(12,19,14,72,BK2_COLOR,.F.)
            @ 13,21 SAY "What card are you looking for" GET cSEARCH PICTURE "@!"
         CASE nCOLUMN == 3
            cSEARCH := SPACE(10)
            ZBOX(12,24,14,67,BK2_COLOR,.F.)
            @ 13,26 SAY "What color are you looking for" GET cSEARCH PICTURE "@!"
         CASE nCOLUMN == 4
            cSEARCH := SPACE(20)
            ZBOX(12,19,14,72,BK2_COLOR,.F.)
            @ 13,21 SAY "What type are you looking for" GET cSEARCH PICTURE "@!"
         OTHERWISE
            cSEARCH := SPACE(4)
            ZBOX(12,26,14,65,BK2_COLOR,.F.)
            @ 13,28 SAY "What series are you looking for" GET cSEARCH PICTURE "@!"
         ENDCASE
         SET CURSOR ON
         IF lMOUSED
            DC_READMODAL(GETLIST); GETLIST := {}
         ELSE
            READ
         ENDIF
         SET CURSOR OFF
         IF LASTKEY() <> 27 .AND. ! EMPTY(cSEARCH)
            SET SOFTSEEK ON
            SEEK cSEARCH
            IF EOF()
               GOTO nRECNO
               BEEP_LONG
            ENDIF
            SET SOFTSEEK ON
         ENDIF
         oTBROWSE:AUTOLITE := .T.
         oTBROWSE:REFRESHALL()
      ENDIF
   ENDCASE
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                           View Deck Statistics                           */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function DECKSTATS (nDECK)
Local oTBROWSE, nKEY, nTOTAL := 0

* Load and display the statistics

SELECT DECKLINK
SEEK STR(nDECK,3)
IF FOUND()
   DO WHILE (DECKLINK->DECK = nDECK .AND. ! EOF())
      nTOTAL := nTOTAL + QUANTITY
      SKIP
   ENDDO
ENDIF
IF lCOLOR
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(9),1840))
ELSE
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(0),1840))
ENDIF
SETCOLOR(MAIN_COLOR)
ZBOX(2,1,22,77,BK1_COLOR,.T.)
@ 3,29 SAY "Viewing Deck Statistics"
@ 5,2 SAY "    Card Name/Description       Color          Type         Cards Occurence"
@ 6,2 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÄÄÄÄÄ ÄÄÄÄÄÄÄÄÄ"
IF lMOUSED
   SETCOLOR(BUTT_COLOR)
   @ 22,3  SAY " TOP "
   @ 22,11 SAY " PGUP "
   @ 22,20 SAY " LINE  "
   @ 22,31 SAY " QUIT "
   @ 22,39 SAY " VIEW "
   @ 22,48 SAY " LINE  "
   @ 22,59 SAY " PGDN "
   @ 22,68 SAY " BOTTOM "
   SETCOLOR(MAIN_COLOR)
ENDIF
HELPIT("Commands : [], [], [Enter] Views, [Esc] Returns")
oTBROWSE := TBROWSEDB(7,1,21,77)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+CARD+"  "+COLOR+"  "+TYPE+TRANSFORM(DECKLINK->QUANTITY,"@Z 9999")+TRANSFORM((DECKLINK->QUANTITY / nTOTAL)*100,"@Z 999999.99")+" %  "}))

* Set temporary database, if viewing

IF nTOTAL = 0
   SETCOLOR(ALT_COLOR)
   ZBOX(11,11,16,65,BK2_COLOR,.F.)
   @ 13,13 SAY "Sorry : No cards found in deck.  Use EDIT to build."
   PAUSE(15,37,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   Return (Nil)
ENDIF
SAVE SCREEN TO cSCREEN
SETCOLOR(ALT_COLOR)
ZBOX(12,15,14,62,BK2_COLOR,.F.)
@ 13,17 SAY "Please Wait : Gathering Cards for this Deck."
SET CURSOR ON
SELECT CARDS
SET ORDER TO 2
SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
COPY TO DAEMON1.TMP FOR DECKLINK->QUANTITY > 0
USE ("DAEMON1.TMP") ALIAS CARDTEMP NEW EXCLUSIVE
SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
INDEX ON STR(999-DECKLINK->QUANTITY,3) + UPPER(CARD) TO ("DAEMON1A.TMP")
RESTORE SCREEN FROM cSCREEN
SETCOLOR(MAIN_COLOR)
SET CURSOR OFF
GO TOP
DO WHILE .T.
   DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
   nSELECTED := oTBROWSE:ROWPOS
   nKEY      := IF(lMOUSED,MOUSEKEY(18),ASC(UPPER(CHR(INKEY(0)))))
   DO CASE
   CASE (nKEY == K_MOUSE45 .AND. oTBROWSE:ROWPOS <> nSELECTED)                 && Mouse-Select
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()
   CASE nKEY == 13 .OR. (nKEY == K_MOUSE45 .AND. oTBROWSE:ROWPOS = nSELECTED)  && View Card
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:STABILIZE()
      CARD_VIEW(2)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == K_ESC
      CLOSE CARDTEMP
      ERASE ("DAEMON1.TMP")
      ERASE ("DAEMON1A.TMP")
      Return (Nil)
   CASE nKEY == K_DOWN
      oTBROWSE:DOWN()
   CASE nKEY == K_UP
      oTBROWSE:UP()
   CASE nKEY == K_PGDN
      oTBROWSE:PAGEDOWN()
   CASE nKEY == K_PGUP
      oTBROWSE:PAGEUP()
   CASE nKEY == K_HOME
      oTBROWSE:GOTOP()
   CASE nKEY == K_END
      oTBROWSE:GOBOTTOM()
   ENDCASE
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                       Draw Random Cards from Deck                        */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function DECKDRAW (nDECK,nCARDS)
Local oTBROWSE, nKEY, nTOTAL := 0, nRECORDS, nRECORD, nDRAW, lLOOKING

* Load and display the statistics

SELECT DECKLINK
SEEK STR(nDECK,3)
IF FOUND()
   DO WHILE (DECKLINK->DECK = nDECK .AND. ! EOF())
      nTOTAL := nTOTAL + QUANTITY
      SKIP
   ENDDO
ENDIF
IF lCOLOR
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(9),1840))
ELSE
   RESTSCREEN(1,0,23,79,REPLICATE(CHR(219)+CHR(0),1840))
ENDIF
SETCOLOR(MAIN_COLOR)
ZBOX(2,4,22,74,BK1_COLOR,.T.)
@ 3,25 SAY "Drawing Random Cards from Deck"
@ 5,6 SAY "Draw      Card Name/Description        Color           Type        "
@ 6,6 SAY "ÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄ  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
IF lMOUSED
   SETCOLOR(BUTT_COLOR)
   @ 22,5  SAY " TOP "
   @ 22,11 SAY " PGUP "
   @ 22,18 SAY " LINE  "
   @ 22,27 SAY " DRAW "
   @ 22,35 SAY " QUIT "
   @ 22,43 SAY " VIEW "
   @ 22,50 SAY " LINE  "
   @ 22,59 SAY " PGDN "
   @ 22,66 SAY " BOTTOM "
   SETCOLOR(MAIN_COLOR)
ENDIF
HELPIT("Commands : [], [], [D]raw, [Enter] Views, [Esc] Returns")
oTBROWSE := TBROWSEDB(7,5,21,73)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||STR(REFERENCE,5)+"  "+CARD+"  "+COLOR+"    "+TYPE+" "}))

* Set temporary database

IF nTOTAL < 1
   SETCOLOR(ALT_COLOR)
   ZBOX(11,11,16,65,BK2_COLOR,.F.)
   @ 13,13 SAY "Sorry : No cards found in deck.  Use EDIT to build."
   PAUSE(15,37,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
   Return (Nil)
ENDIF
SAVE SCREEN TO cSCREEN
SETCOLOR(ALT_COLOR)
ZBOX(12,22,14,55,BK2_COLOR,.F.)
@ 13,24 SAY "Please Wait : Shuffling Cards."
SET CURSOR ON

* First, initialize temporary file

SELECT CARDS
SET RELATION TO STR(nDECK,3) + STR(REFERENCE,5) INTO DECKLINK
COPY NEXT 0 TO DAEMON1.TMP
COPY NEXT 0 TO DAEMON2.TMP
USE ("DAEMON1.TMP") ALIAS CARDDECK NEW EXCLUSIVE
USE ("DAEMON2.TMP") ALIAS CARDTEMP NEW EXCLUSIVE

* Next, read through cards, making multiple copies to temporary database

SELECT CARDS
GO TOP
DO WHILE ! EOF()
   IF DECKLINK->QUANTITY > 0
      SELECT CARDDECK
      FOR nX := 1 TO DECKLINK->QUANTITY
         APPEND BLANK
         CARDDECK->SERIES     := CARDS->SERIES
         CARDDECK->CARD       := CARDS->CARD
         CARDDECK->COLOR      := CARDS->COLOR
         CARDDECK->TYPE       := CARDS->TYPE
         CARDDECK->FLAGS      := CARDS->FLAGS
         CARDDECK->COST       := CARDS->COST
         CARDDECK->ARTIST     := CARDS->ARTIST
         CARDDECK->DESC       := CARDS->DESC
         CARDDECK->REFERENCE  := 0
         CARDDECK->UPDATED    := CARDS->UPDATED
         CARDDECK->QUANTITY   := CARDS->QUANTITY
         CARDDECK->BUY_FROM   := CARDS->BUY_FROM
         CARDDECK->BUY_PRICE  := CARDS->BUY_PRICE
         CARDDECK->SOLD_TO    := CARDS->SOLD_TO
         CARDDECK->SOLD_PRICE := CARDS->SOLD_PRICE
      NEXT nX
      SELECT CARDS
   ENDIF
   SKIP
ENDDO

* Next, pull x cards from database

SET DELETED OFF
FOR nDRAW := 1 TO nCARDS
   SELECT CARDDECK
   lLOOKING := .T.
   DO WHILE lLOOKING
      GO RND(LASTREC()) + 1
      IF ! DELETED()
         SELECT CARDTEMP
         APPEND BLANK
         CARDTEMP->SERIES     := CARDDECK->SERIES
         CARDTEMP->CARD       := CARDDECK->CARD
         CARDTEMP->COLOR      := CARDDECK->COLOR
         CARDTEMP->TYPE       := CARDDECK->TYPE
         CARDTEMP->FLAGS      := CARDDECK->FLAGS
         CARDTEMP->COST       := CARDDECK->COST
         CARDTEMP->ARTIST     := CARDDECK->ARTIST
         CARDTEMP->DESC       := CARDDECK->DESC
         CARDTEMP->REFERENCE  := nDRAW
         CARDTEMP->UPDATED    := CARDDECK->UPDATED
         CARDTEMP->QUANTITY   := CARDDECK->QUANTITY
         CARDTEMP->BUY_FROM   := CARDDECK->BUY_FROM
         CARDTEMP->BUY_PRICE  := CARDDECK->BUY_PRICE
         CARDTEMP->SOLD_TO    := CARDDECK->SOLD_TO
         CARDTEMP->SOLD_PRICE := CARDDECK->SOLD_PRICE
         SELECT CARDDECK
         DELETE
         lLOOKING := .F.
      ENDIF
   ENDDO
NEXT nDRAW
SET DELETED ON

* Finally, display the cards

RESTORE SCREEN FROM cSCREEN
SETCOLOR(MAIN_COLOR)
SET CURSOR OFF
SELECT CARDTEMP
nDRAW := nCARDS
GO TOP
DO WHILE .T.
   DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
   nSELECTED := oTBROWSE:ROWPOS
   nKEY      := IF(lMOUSED,MOUSEKEY(19),ASC(UPPER(CHR(INKEY(0)))))
   DO CASE
   CASE (nKEY == K_MOUSE50 .AND. oTBROWSE:ROWPOS <> nSELECTED)  && Mouse-Select
      lPRESSED := .T.
      oTBROWSE:ROWPOS := nSELECTED
      oTBROWSE:REFRESHALL()
   CASE nKEY == K_ENTER .OR. (nKEY = K_MOUSE50 .AND. oTBROWSE:ROWPOS = nSELECTED)     && View Card
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:STABILIZE()
      CARD_VIEW(2)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 68 .or. nKEY == K_SPACE)                      && Draw Another
      IF nDRAW < nTOTAL
         SET DELETED OFF
         SELECT CARDDECK
         lLOOKING := .T.
         nDRAW++
         DO WHILE lLOOKING
            GO RND(LASTREC()) + 1
            IF ! DELETED()
               SELECT CARDTEMP
               APPEND BLANK
               CARDTEMP->SERIES     := CARDDECK->SERIES
               CARDTEMP->CARD       := CARDDECK->CARD
               CARDTEMP->COLOR      := CARDDECK->COLOR
               CARDTEMP->TYPE       := CARDDECK->TYPE
               CARDTEMP->FLAGS      := CARDDECK->FLAGS
               CARDTEMP->COST       := CARDDECK->COST
               CARDTEMP->ARTIST     := CARDDECK->ARTIST
               CARDTEMP->DESC       := CARDDECK->DESC
               CARDTEMP->REFERENCE  := nDRAW
               CARDTEMP->UPDATED    := CARDDECK->UPDATED
               CARDTEMP->QUANTITY   := CARDDECK->QUANTITY
               CARDTEMP->BUY_FROM   := CARDDECK->BUY_FROM
               CARDTEMP->BUY_PRICE  := CARDDECK->BUY_PRICE
               CARDTEMP->SOLD_TO    := CARDDECK->SOLD_TO
               CARDTEMP->SOLD_PRICE := CARDDECK->SOLD_PRICE
               SELECT CARDDECK
               DELETE
               lLOOKING := .F.
            ENDIF
         ENDDO
         SET DELETED ON
         SELECT CARDTEMP
         oTBROWSE:GOBOTTOM()
      ELSE
         SAVE SCREEN TO cSCREEN
         BEEP_LONG
         SETCOLOR(WARN_COLOR)
         ZBOX(11,10,16,68,BK2_COLOR,.F.)
         @ 13,12 SAY "Sorry : You have drawn all of the cards from this deck."
         PAUSE(15,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
         RESTORE SCREEN FROM cSCREEN
         SETCOLOR(MAIN_COLOR)
      ENDIF
   CASE nKEY == K_ESC
      CLOSE CARDDECK
      CLOSE CARDTEMP
      ERASE ("DAEMON1.TMP")
      ERASE ("DAEMON2.TMP")
      Return (Nil)
   CASE nKEY == K_DOWN
      oTBROWSE:DOWN()
   CASE nKEY == K_UP
      oTBROWSE:UP()
   CASE nKEY == K_PGDN
      oTBROWSE:PAGEDOWN()
   CASE nKEY == K_PGUP
      oTBROWSE:PAGEUP()
   CASE nKEY == K_HOME
      oTBROWSE:GOTOP()
   CASE nKEY == K_END
      oTBROWSE:GOBOTTOM()
   ENDCASE
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                         Prompt for Printer Ready                         */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function ADJUST (lSHOWPAUSE)
Local nADJUST := 1, nPRINTER := 1, cFILE := SPACE(30), cSCREEN, GETLIST := {}
SAVE SCREEN TO cSCREEN
SETCOLOR(ALT_COLOR)
ZBOX(17,12,21,67,BK2_COLOR,.F.)
@ 18,13 SAY "    Where would you like me to print this listing?    "
@ 19,13 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
IF lMOUSED
   DC_AT_PROMPT(20,21," Printer ","")
   DC_AT_PROMPT(20,32," File ","")
   DC_AT_PROMPT(20,40," Screen ","")
   DC_AT_PROMPT(20,50," Cancel ","")
   nADJUST := DC_MENU_TO(nADJUST)
ELSE
   @ 20,21 PROMPT " Printer "
   @ 20,32 PROMPT " File "
   @ 20,40 PROMPT " Screen "
   @ 20,50 PROMPT " Cancel "
   MENU TO nADJUST
ENDIF
DO CASE
CASE nADJUST == 1
   @ 18,13 SAY "           Please select the printer port :           "
   @ 19,13 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 20,13 SAY "                                                      "
   IF lMOUSED
      DC_AT_PROMPT(20,15," LPT1 ","")
      DC_AT_PROMPT(20,22," LPT2 ","")
      DC_AT_PROMPT(20,29," LPT3 ","")
      DC_AT_PROMPT(20,36," LPT4 ","")
      DC_AT_PROMPT(20,43," COM1 ","")
      DC_AT_PROMPT(20,50," COM2 ","")
      DC_AT_PROMPT(20,57," Cancel ","")
      nPRINTER := DC_MENU_TO(nADJUST)
   ELSE
      @ 20,15 PROMPT " LPT1 "
      @ 20,22 PROMPT " LPT2 "
      @ 20,29 PROMPT " LPT3 "
      @ 20,36 PROMPT " LPT4 "
      @ 20,43 PROMPT " COM1 "
      @ 20,50 PROMPT " COM2 "
      @ 20,57 PROMPT " Cancel "
      MENU TO nPRINTER
   ENDIF
   DO CASE
   CASE nPRINTER == 1
      cOUTPUT := "LPT1"
   CASE nPRINTER == 2
      cOUTPUT := "LPT2"
   CASE nPRINTER == 3
      cOUTPUT := "LPT3"
   CASE nPRINTER == 4
      cOUTPUT := "LPT4"
   CASE nPRINTER == 5
      cOUTPUT := "COM1"
   CASE nPRINTER == 6
      cOUTPUT := "COM2"
   OTHERWISE
      Return (.F.)
   ENDCASE
   @ 18,13 CLEAR TO 20,66
   @ 19,21 SAY "Please Wait : Printing in Progress ..."
   SET CURSOR ON
CASE nADJUST == 2
   @ 18,13 SAY "      Please enter the name of the ASCII file :       "
   @ 19,13 SAY "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   @ 20,13 SAY "                                                      "
   @ 20,20 SAY "Filename" GET cFILE PICTURE "@!"
   SET CURSOR ON
   IF lMOUSED
      DC_READMODAL(GETLIST); GETLIST := {}
   ELSE
      READ
   ENDIF
   SET CURSOR OFF
   IF EMPTY(cFILE) .OR. LASTKEY() = 27
      Return (.F.)
   ENDIF
   IF ! GOODPATH(cFILE)
      BEEP_LONG
      RESTORE SCREEN FROM cSCREEN
      SETCOLOR(ALT_COLOR)
      ZBOX(17,18,21,61,BK2_COLOR,.F.)
      @ 18,20 SAY "Sorry : I cannot write to that filename."
      PAUSE(20,38,IF(lMOUSED,BUTT_COLOR,MAIN_COLOR))
      Return (.F.)
   ENDIF
   cOUTPUT := LTRIM(RTRIM(cFILE))
   If lSHOWPAUSE
      @ 18,13 CLEAR TO 20,66
      @ 19,18 SAY "Please Wait : Generating ASCII Text File ..."
      SET CURSOR ON
   ENDIF
CASE nADJUST == 3
   cOUTPUT := PREVFILE
   If lSHOWPAUSE
      @ 18,13 CLEAR TO 20,66
      @ 19,19 SAY "Please Wait : Generating Screen Preview ..."
      SET CURSOR ON
   ENDIF
OTHERWISE
   Return (.F.)
ENDCASE
SET PRINTER TO (cOUTPUT)
SET CONSOLE OFF
SET PRINT ON
Return (.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                             Document Heading                             */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function HEADING (nPAGE,cTITLE,cTITLE2)
Local nAREA := SELECT()
nPAGE++
IF cOUTPUT = PREVFILE
   ? "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
   ? " ÚÂÄÂ¿  ÚÂÄÄÂ¿ ÚÂÄÄÂ¿ Ú¿  Ú¿    ÚÂÄÂ¿  ÚÂÄÄÂ¿ ÚÂÄÄÂ¿ ÚÂ¿ ÚÂ¿ ÚÂÄÄÂ¿ ÚÂ¿ Ú¿ "
   ? " ³³ ÀÅ¿ ³³  ÀÙ ³³  ÀÙ ³³ ÚÅÙ    ³³ ÀÅ¿ ³³  ³³ ³³  ÀÙ ³³ÀÂÙ³³ ³³  ³³ ³ÃÅ¿³³ "
   ? " ³³  ³³ ³ÃÄ´   ³³     ³ÃÄÅ´     ³³  ³³ ³ÃÄÄÅ´ ³ÃÄ´   ³³ Á ³³ ³³  ³³ ³³ÀÅ´³ "
   ? " ³³ ÚÅÙ ³³  Ú¿ ³³  Ú¿ ³³ ÀÅ¿    ³³ ÚÅÙ ³³  ³³ ³³  Ú¿ ³³   ³³ ³³  ³³ ³³ À´³ "
   ? " ÀÁÄÁÙ  ÀÁÄÄÁÙ ÀÁÄÄÁÙ ÀÙ  ÀÙ    ÀÁÄÁÙ  ÀÙ  ÀÙ ÀÁÄÄÁÙ ÀÙ   ÀÙ ÀÁÄÄÁÙ ÀÙ  ÀÙ "
   ?
   ? " Date : " + DTOC(DATE()) + SPACE(22-LEN(RTRIM(INFO->LP_HEADING))/2)
   ?? RTRIM(INFO->LP_HEADING) + SPACE(27.5-LEN(RTRIM(INFO->LP_HEADING))/2)
   ?? "Page :" + STR(nPAGE,3)
   ?
   ? SPACE(38-LEN(cTITLE)/2) + cTITLE
   IF ! EMPTY(cTITLE2)
      ?
      ? SPACE(38-LEN(cTITLE2)/2) + cTITLE2
   ENDIF
   ? "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ"
ELSE
   ? "      /////  ///// ///// //  //     /////  ////// ///// ///  /// ///// //   //"
   ? "     //  // //    //    // //      //  // //  // //    // // // // // //// // "
   ? "    //  // ////  //    ///        //  // ////// ////  // // // // // // ////  "
   ? "   //  // //    //    // //      //  // //  // //    //    // // // //   //   "
   ? "  /////  ///// ///// //   //    /////  //  // ///// //    // ///// //   //    "
   ?
   ? "  Date : " + DTOC(DATE()) + SPACE(23-LEN(RTRIM(INFO->LP_HEADING))/2)
   ?? RTRIM(INFO->LP_HEADING) + SPACE(29-LEN(RTRIM(INFO->LP_HEADING))/2)
   ?? "Page :" + STR(nPAGE,3)
   ?
   ? SPACE(40-LEN(cTITLE)/2) + cTITLE
   IF ! EMPTY(cTITLE2)
      ?
      ? SPACE(40-LEN(cTITLE2)/2) + cTITLE2
   ENDIF
   ? "  " + REPLICATE("-",76)
ENDIF
?
SELECT (nAREA)
Return (.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                         End-of-Document Routine                          */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function END_DOC
Local oTBROWSE, nKEY, cSCREEN
SET CURSOR OFF
IF cOUTPUT = PREVFILE
   SET PRINT OFF
   SET PRINTER TO
   SET CONSOLE ON
   SETCOLOR(MAIN_COLOR)
   @ 0,0 CLEAR TO 0,79
   @ 0,32 SAY " Screen Preview " COLOR BK2_COLOR
   ZBOX(2,1,22,77,BK1_COLOR,.T.)
   @ 24,0 CLEAR TO 24,79
   IF lMOUSED
      SETCOLOR(BUTT_COLOR)
      @ 24,4  SAY " TOP "
      @ 24,12 SAY " PAGE  "
      @ 24,23 SAY " LINE  "
      @ 24,35 SAY " QUIT "
      @ 24,45 SAY " LINE  "
      @ 24,56 SAY " PAGE  "
      @ 24,67 SAY " BOTTOM "
      SETCOLOR(MAIN_COLOR)
   ELSE
      @ 24,12 SAY "Commands : [], [], [PgUp], [PgDn] VIEWS, [Esc] RETURNS"
   ENDIF

   * Build temporary database

   CREATEDBF("PREVIEW.DD","LINE,C 75 0")
   USE ("PREVIEW.DD") ALIAS PREVIEW NEW EXCLUSIVE
   APPEND FROM PREVFILE SDF
   GO TOP
   DELETE
   GO TOP

   * Setup TBROWSE

   oTBROWSE := TBROWSEDB(3,2,21,76)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||LINE}))
   oTBROWSE:AUTOLITE := .F.
   DO WHILE .T.
      DO WHILE ! oTBROWSE:STABILIZE(); ENDDO
      nKEY := IF(lMOUSED,MOUSEKEY(9),ASC(UPPER(CHR(INKEY(0)))))
      DO CASE
      CASE nKEY == K_ESC
         CLOSE PREVIEW
         ERASE(PREVFILE)
         ERASE("PREVIEW.DD")
         Return (Nil)
      CASE nKEY == K_DOWN
         IF oTBROWSE:ROWPOS < 19; oTBROWSE:ROWPOS := 19; ENDIF
         oTBROWSE:DOWN()
      CASE nKEY == K_UP
         IF oTBROWSE:ROWPOS > 1;  oTBROWSE:ROWPOS := 1;  ENDIF
         oTBROWSE:UP()
      CASE nKEY == K_PGDN
         oTBROWSE:PAGEDOWN()
      CASE nKEY == K_PGUP
         oTBROWSE:PAGEUP()
      CASE nKEY == K_HOME
         oTBROWSE:GOTOP()
      CASE nKEY == K_END
         oTBROWSE:GOBOTTOM()
      ENDCASE
   ENDDO
ELSE
   ?? CHR(12)
   SET PRINT OFF
   SET PRINTER TO
   SET CONSOLE ON
ENDIF
Return (.T.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                        Rebuild Indexes if Missing                        */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function PREP_INDEX (lNEEDMSG)
USE ("DAEMON0.DD") NEW EXCLUSIVE
PACK
IF LASTREC() < 1
   APPEND BLANK
ENDIF
CLOSE
IF ! FILE("DAEMON1A.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON1.DD") NEW EXCLUSIVE
   INDEX ON UPPER(SERIES + CARD) TO ("DAEMON1A.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON1B.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON1.DD") NEW EXCLUSIVE
   INDEX ON UPPER(CARD + SERIES) TO ("DAEMON1B.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON1C.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON1.DD") NEW EXCLUSIVE
   INDEX ON UPPER(COLOR + SERIES + CARD) TO ("DAEMON1C.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON1D.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON1.DD") NEW EXCLUSIVE
   INDEX ON UPPER(TYPE + SERIES + CARD) TO ("DAEMON1D.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON1E.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON1.DD") NEW EXCLUSIVE
   INDEX ON UPPER(SERIES + COLOR + CARD) TO ("DAEMON1E.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON2A.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON2.DD") NEW EXCLUSIVE
   INDEX ON UPPER(TYPE + NAME) TO ("DAEMON2A.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON3A.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON3.DD") NEW EXCLUSIVE
   INDEX ON UPPER(DECK) TO ("DAEMON3A.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON4A.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON4.DD") NEW EXCLUSIVE
   INDEX ON STR(DECK,3) + STR(CARD,5) TO ("DAEMON4A.DD")
   CLOSE
ENDIF
IF ! FILE("DAEMON4B.DD")
   DO_MSG(@lNEEDMSG)
   USE ("DAEMON4.DD") NEW EXCLUSIVE
   INDEX ON CARD TO ("DAEMON4B.DD")
   CLOSE
ENDIF
SET CURSOR OFF
Return (.T.)

Function DO_MSG (lNEEDMSG)
IF lNEEDMSG
   ZWARN(12,"Please Wait : Preparing Databases",1,BK1_COLOR)
   SET CURSOR ON
   lNEEDMSG := .F.
ENDIF
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                   Convert Numbers to String with Zeros                   */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function ZPAD(nVAL,nLEN)
Return (REPLICATE("0",nLEN-LEN(LTRIM(STR(nVAL,nLEN)))) + LTRIM(STR(nVAL,nLEN)))

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                                 3d Box                                   */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function ZBOX (Y1,X1,Y2,X2,ZCOLOR,lBORDER)
Local Y, nCOLOR := SETCOLOR()
DO CASE
CASE lCOLOR .AND. (lNOFONT .OR. lBORDER)                  && Thin Shadow
   @ Y1,X1 CLEAR TO Y2,X2
   @ Y1,X2+1 SAY "ß" COLOR ZCOLOR
   SETCOLOR(SHAD_COLOR)
   @ Y1+1,X2+1 CLEAR TO Y2+1,X2+1
   @ Y2+1,X1+1 SAY REPLICATE("Ü",X2-X1+1) COLOR ZCOLOR
CASE lCOLOR .AND. ! (lNOFONT .OR. lBORDER)                && No Shadow, Lines
   @ Y1,X1-1 CLEAR TO Y2,X2+1
   @ Y1,X1,Y2,X2 BOX B_SINGLE
OTHERWISE                                                 && No Shadow or Lines
   @ Y1,X1 CLEAR TO Y2,X2
ENDCASE
SETCOLOR(nCOLOR)
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                      3d Warning Message Box Routine                      */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function ZWARN (nYPOS,cMSG,nMODE,cBKCOLOR)
Local nXOFF := INT(LEN(cMSG)/2), nCOLOR := SETCOLOR()
DO CASE
CASE nMODE == 1
   SETCOLOR(MAIN_COLOR)
   ZBOX(nYPOS-1,38-nXOFF,nYPOS+1,42+nXOFF,cBKCOLOR,.T.)
   @ nYPOS,40-nXOFF SAY cMSG
CASE nMODE == 2
   SETCOLOR(ALT_COLOR)
   ZBOX(nYPOS-1,38-nXOFF,nYPOS+1,42+nXOFF,cBKCOLOR,.F.)
   @ nYPOS,40-nXOFF SAY cMSG
CASE nMODE == 3
   SETCOLOR(WARN_COLOR)
   @ 24,0 CLEAR TO 24,79
   @ 24,40-LEN(cMSG)/2 SAY cMSG
   SET CURSOR ON
   INKEY(0)
   SET CURSOR OFF
CASE nMODE == 4
   BEEP_LONG
   SETCOLOR(WARN_COLOR)
   ZBOX(nYPOS-1,38-nXOFF,nYPOS+3,41+nXOFF,cBKCOLOR,.T.)
   @ nYPOS,40-nXOFF SAY cMSG
   PAUSE(nYPOS+2,38,BK2_COLOR)
ENDCASE
SETCOLOR(nCOLOR)
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                      Place a Help Message at Bottom                      */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function HELPIT (sMSG)
@ 24,0 SAY SPACE(61) COLOR MAIN_COLOR
@ 24,1 SAY sMSG      COLOR SHOW_COLOR
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                              Random Numbers                              */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function RND (nNUMBER)
Static nSEED := .123456789
IF nSEED = .123456789
   nSEED += VAL(SUBSTR(TIME(),7,2)) / 100
ENDIF
nSEED := (nSEED * 31415821 + 1) / 1000000
Return INT( (nSEED -= INT(nSEED)) * nNUMBER)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                     Convert Doe, John -> John Doe                        */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function NOCOMMA (cNAME)
Local nCOMMA := AT(",",cNAME)
cNAME := LTRIM(RTRIM(cNAME))
IF ! EMPTY(cNAME) .AND. nCOMMA > 0
   Return(RTRIM(LTRIM(SUBSTR(cNAME,nCOMMA+1,LEN(cNAME)-nCOMMA)) + " " + LEFT(cNAME,nCOMMA-1)))
ENDIF
Return (cNAME)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                  Check for valid Drive/Directory/File                    */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function GOODPATH (cFILESPEC)
IF MEMOWRIT(cFILESPEC," ")
   ERASE (cFILESPEC)
   Return (.T.)
ENDIF
Return (.F.)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*               Function to Build a .DBF from Schema-String                */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

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

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                      Moused Replacement for INKEY()                      */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function MOUSEKEY (nMODE,nITEMROW,nITEMCOL)
Local nKEY, nMOUSE, nROW, nCOL
SET CURSOR OFF
DC_MOUSHOW()
DO WHILE .T.
   IF (nKEY := INKEY()) <> 0
      DC_MOUHIDE()
      Return (ASC(UPPER(CHR(nKEY))))
   ELSE
      nMOUSE   := DC_MOUBUTTON()
      lPRESSED := IF(nMOUSE == 0,.F.,lPRESSED)
      nMOUSE   := IF((nMOUSE == 1 .OR. nMOUSE == 2) .AND. lPRESSED,0,nMOUSE)
      IF nMOUSE == 1
         lPRESSED := .T.
         DC_MOUGETPOSITION(@nROW,@nCOL)
         DO CASE

         * Main TBROWSE

         CASE nMODE = 1
            DO CASE
            CASE (nROW = 4 .AND. nCOL = 77) .OR. (nROW = 22 .AND. nCOL >= 4 .AND. nCOL <= 8 .AND. ! lNOBUTTONS)
               DC_MOUHIDE()
               Return (K_HOME)    && Top
            CASE nROW = 5 .AND. nCOL = 77   .OR. (nROW = 22 .AND. nCOL >= 12 .AND. nCOL <= 19 .AND. ! lNOBUTTONS)
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGUP)    && Up, Page
            CASE nROW = 6 .AND. nCOL = 77   .OR. (nROW = 22 .AND. nCOL >= 23 .AND. nCOL <= 30 .AND. ! lNOBUTTONS)
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_UP)      && Up, Line
            CASE nROW = 20 .AND. nCOL = 77  .OR. (nROW = 22 .AND. nCOL >= 45 .AND. nCOL <= 52 .AND. ! lNOBUTTONS)
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_DOWN)    && Down, Line
            CASE nROW = 21 .AND. nCOL = 77  .OR. (nROW = 22 .AND. nCOL >= 56 .AND. nCOL <= 63 .AND. ! lNOBUTTONS)
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGDN)    && Down, Page
            CASE nROW = 22 .AND. nCOL = 77  .OR. (nROW = 22 .AND. nCOL >= 67 .AND. nCOL <= 74 .AND. ! lNOBUTTONS)
               DC_MOUHIDE()
               Return (K_END)     && Bottom
            CASE nROW >= 5 .AND. nROW <= 21 .AND. nCOL >= 1 .AND. nCOL <= 76
               DC_MOUHIDE()
               IF lINVENTORY
                  lPRESSED := .F.
                  DC_PAUSE(.05)
               ENDIF
               nSELECTED := (nROW - 4)
               Return (K_MOUSE60) && Select
            CASE nROW = 0 .AND. nCOL >= 2 .AND. nCOL <= 5
               DC_MOUHIDE()
               Return (86)        && View
            CASE nROW = 0 .AND. nCOL >= 8 .AND. nCOL <= 11
               DC_MOUHIDE()
               Return (69)        && Edit
            CASE nROW = 0 .AND. nCOL >= 14 .AND. nCOL <= 16
               DC_MOUHIDE()
               Return (65)        && Add
            CASE nROW = 0 .AND. nCOL >= 19 .AND. nCOL <= 22
               DC_MOUHIDE()
               Return (67)        && Copy
            CASE nROW = 0 .AND. nCOL >= 25 .AND. nCOL <= 29
               DC_PAUSE(.1)
               DC_MOUHIDE()
               Return (79)        && Order
            CASE nROW = 0 .AND. nCOL >= 32 .AND. nCOL <= 36
               DC_MOUHIDE()
               Return (80)        && Print
            CASE nROW = 0 .AND. nCOL >= 39 .AND. nCOL <= 45
               DC_MOUHIDE()
               Return (83)        && Support
            CASE nROW = 0 .AND. nCOL >= 48 .AND. nCOL <= 52
               DC_MOUHIDE()
               Return (68)        && Decks
            CASE nROW = 0 .AND. nCOL >= 55 .AND. nCOL <= 58
               DC_MOUHIDE()
               Return (77)        && Misc.
            CASE nROW = 0 .AND. nCOL >= 61 .AND. nCOL <= 64
               DC_MOUHIDE()
               Return (81)        && Quit
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * ERASE Y/N options, from CARDS()

         CASE nMODE = 2
            DO CASE
            CASE nROW = 14 .AND. nCOL >= 47 .AND. nCOL <= 49
               DC_MOUHIDE()
               Return (89)        && Yes
            CASE nROW = 14 .AND. nCOL >= 53 .AND. nCOL <= 55
               DC_MOUHIDE()
               Return (78)        && No
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * QUIT Y/N options

         CASE nMODE = 3
            DO CASE
            CASE nROW = 12 .AND. nCOL >= 53 .AND. nCOL <= 55
               DC_MOUHIDE()
               Return (89)      && Yes
            CASE nROW = 12 .AND. nCOL >= 59 .AND. nCOL <= 61
               DC_MOUHIDE()
               Return (78)      && No
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * ADD/EDIT card

         CASE nMODE = 4
            DO CASE
            CASE nROW = 8 .AND. nCOL >= 3 .AND. nCOL <= 20
               nITEM := 1
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 9 .AND. nCOL >= 3 .AND. nCOL <= 46
               nITEM := 2
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 10 .AND. nCOL >= 3 .AND. nCOL <= 21
               nITEM := 3
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 11 .AND. nCOL >= 3 .AND. nCOL <= 36
               nITEM := 4
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 12 .AND. nCOL >= 3 .AND. nCOL <= 26
               nITEM := 5
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 13 .AND. nCOL >= 3 .AND. nCOL <= 36
               nITEM := 6
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 14 .AND. nCOL >= 3 .AND. nCOL <= 55
               nITEM := 7
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 15 .AND. nCOL >= 27 .AND. nCOL <= 33
               nITEM := 8
               DC_MOUHIDE()
               Return (K_MOUSE12)
            CASE nROW = 15 .AND. nCOL >= 36 .AND. nCOL <= 44
               nITEM := 8
               DC_MOUHIDE()
               Return (K_MOUSE13)
            CASE nROW = 15 .AND. nCOL >= 49 .AND. nCOL <= 53
               nITEM := 8
               DC_MOUHIDE()
               Return (K_MOUSE14)
            CASE nROW = 15 .AND. nCOL >= 3 .AND. nCOL <= 53
               nITEM := 8
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 16 .AND. nCOL >= 27 .AND. nCOL <= 31
               nITEM := 9
               DC_MOUHIDE()
               Return (K_MOUSE9)
            CASE nROW = 16 .AND. nCOL >= 34 .AND. nCOL <= 44
               nITEM := 9
               DC_MOUHIDE()
               Return (K_MOUSE10)
            CASE nROW = 16 .AND. nCOL >= 49 .AND. nCOL <= 55
               nITEM := 9
               DC_MOUHIDE()
               Return (K_MOUSE11)
            CASE nROW = 16 .AND. nCOL >= 3 .AND. nCOL <= 55
               nITEM := 9
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 17 .AND. nCOL >= 27 .AND. nCOL <= 31
               nITEM := 10
               DC_MOUHIDE()
               Return (K_MOUSE5)
            CASE nROW = 17 .AND. nCOL >= 34 .AND. nCOL <= 38
               nITEM := 10
               DC_MOUHIDE()
               Return (K_MOUSE6)
            CASE nROW = 17 .AND. nCOL >= 41 .AND. nCOL <= 46
               nITEM := 10
               DC_MOUHIDE()
               Return (K_MOUSE7)
            CASE nROW = 17 .AND. nCOL >= 49 .AND. nCOL <= 54
               nITEM := 10
               DC_MOUHIDE()
               Return (K_MOUSE8)
            CASE nROW = 17 .AND. nCOL >= 3 .AND. nCOL <= 54
               nITEM := 10
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 18 .AND. nCOL = 23
               nITEM    := 11
               lPRESSED := .F.
               DC_PAUSE(.15)
               DC_MOUHIDE()
               Return (K_MOUSE15)
            CASE nROW = 18 .AND. nCOL = 25
               nITEM    := 11
               lPRESSED := .F.
               DC_PAUSE(.15)
               DC_MOUHIDE()
               Return (K_MOUSE16)
            CASE nROW = 18 .AND. nCOL >= 3 .AND. nCOL <= 52
               nITEM := 11
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 19 .AND. nCOL >= 3 .AND. nCOL <= 53
               nITEM := 12
               DC_MOUHIDE()
               Return (K_MOUSE4)
            CASE nROW = 20 .AND. nCOL >= 3 .AND. nCOL <= 31
               nITEM := 13
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 20 .AND. nCOL >= 39 .AND. nCOL <= 52
               nITEM := 14
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 20 .AND. nCOL = 53
               nITEM    := 14
               lPRESSED := .F.
               DC_PAUSE(.15)
               DC_MOUHIDE()
               Return (K_MOUSE2)
            CASE nROW = 20 .AND. nCOL = 55
               nITEM    := 14
               lPRESSED := .F.
               DC_PAUSE(.15)
               DC_MOUHIDE()
               Return (K_MOUSE3)
            CASE nROW = 21 .AND. nCOL >= 3 .AND. nCOL <= 31
               nITEM := 15
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 21 .AND. nCOL >= 39 .AND. nCOL <= 52
               nITEM := 16
               DC_MOUHIDE()
               Return (K_MOUSE1)
            CASE nROW = 21 .AND. nCOL = 53
               nITEM    := 16
               lPRESSED := .F.
               DC_PAUSE(.15)
               DC_MOUHIDE()
               Return (K_MOUSE2)
            CASE nROW = 21 .AND. nCOL = 55
               nITEM    := 16
               lPRESSED := .F.
               DC_PAUSE(.15)
               DC_MOUHIDE()
               Return (K_MOUSE3)
            CASE nROW = 22 .AND. nCOL >= 27 .AND. nCOL <= 30
               DC_MOUHIDE()
               Return (K_MOUSE17)
            ENDCASE

         * SUPPORT TBrowse for Series

         CASE nMODE = 5
            DO CASE
            CASE nROW = 20 .AND. nCOL = 52
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 20 .AND. nCOL = 56
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 20 .AND. nCOL >= 59 .AND. nCOL <= 61
               DC_MOUHIDE()
               Return (65)          && Add
            CASE nROW = 20 .AND. nCOL >= 65 .AND. nCOL <= 68
               DC_MOUHIDE()
               Return (69)          && Edit
            CASE nROW = 20 .AND. nCOL >= 72 .AND. nCOL <= 75
               DC_MOUHIDE()
               Return (81)          && Quit
            CASE nROW >= 3 .AND. nROW <= 18 .AND. nCOL >= 52 .AND. nCOL <= 75
               DC_MOUHIDE()
               nSELECTED := (nROW - 2)
               Return (K_MOUSE20)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * SUPPORT TBrowse for Artists & Types

         CASE nMODE = 6
            DO CASE
            CASE nROW = 20 .AND. nCOL = 53
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 20 .AND. nCOL = 57
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 20 .AND. nCOL >= 60 .AND. nCOL <= 62
               DC_MOUHIDE()
               Return (65)          && Add
            CASE nROW = 20 .AND. nCOL >= 64 .AND. nCOL <= 67
               DC_MOUHIDE()
               Return (69)          && Edit
            CASE nROW = 20 .AND. nCOL >= 69 .AND. nCOL <= 72
               DC_MOUHIDE()
               Return (81)          && Quit
            CASE nROW >= 3 .AND. nROW <= 18 .AND. nCOL >= 52 .AND. nCOL <= 73
               DC_MOUHIDE()
               nSELECTED := (nROW - 2)
               Return (K_MOUSE20)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * SUPPORT TBrowse for Colors & Dealers

         CASE nMODE = 7
            DO CASE
            CASE nROW = 20 .AND. nCOL = 52
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 20 .AND. nCOL = 54
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 20 .AND. nCOL >= 56 .AND. nCOL <= 58
               DC_MOUHIDE()
               Return (65)          && Add
            CASE nROW = 20 .AND. nCOL >= 60 .AND. nCOL <= 63
               DC_MOUHIDE()
               Return (69)          && Edit
            CASE nROW = 20 .AND. nCOL >= 65 .AND. nCOL <= 68
               DC_MOUHIDE()
               Return (81)          && Quit
            CASE nROW >= 3 .AND. nROW <= 18 .AND. nCOL >= 52 .AND. nCOL <= 68
               DC_MOUHIDE()
               nSELECTED := (nROW - 2)
               Return (K_MOUSE20)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Select Deck for Printing

         CASE nMODE = 8
            DO CASE
            CASE nROW = 3 .AND. nCOL = 75
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 12 .AND. nCOL = 75
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 14 .AND. nCOL >= 52 .AND. nCOL <= 58
               DC_MOUHIDE()
               Return (K_ENTER)     && Select
            CASE nROW = 14 .AND. nCOL >= 66 .AND. nCOL <= 70
               DC_MOUHIDE()
               Return (K_ESC)       && Cancel
            CASE nROW >= 3 .AND. nROW <= 12 .AND. nCOL >= 48 .AND. nCOL <= 73
               DC_MOUHIDE()
               nSELECTED := (nROW - 2)
               Return (K_MOUSE25)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Screen Preview

         CASE nMODE = 9
            DO CASE
            CASE nROW = 24 .AND. nCOL >= 4 .AND. nCOL <= 8
               DC_MOUHIDE()
               Return (K_HOME)      && Top of Report
            CASE nROW = 24 .AND. nCOL >= 12 .AND. nCOL <= 19
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGUP)      && Page Up
            CASE nROW = 24 .AND. nCOL >= 23 .AND. nCOL <= 30
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_UP)        && Line Up
            CASE nROW = 24 .AND. nCOL >= 35 .AND. nCOL <= 40
               DC_MOUHIDE()
               Return (K_ESC)       && Quit
            CASE nROW = 24 .AND. nCOL >= 45 .AND. nCOL <= 52
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_DOWN)      && Line Down
            CASE nROW = 24 .AND. nCOL >= 56 .AND. nCOL <= 63
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGDN)      && Page Down
            CASE nROW = 24 .AND. nCOL >= 67 .AND. nCOL <= 74
               DC_MOUHIDE()
               Return (K_END)       && Bottom of Report
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * CARD_EDIT for Series & Color

         CASE nMODE = 10
            DO CASE
            CASE nROW = 11 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 20 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW >= 11 .AND. nROW <= 20 .AND. nCOL >= 60 .AND. nCOL <= 76
               DC_MOUHIDE()
               nSELECTED := (nROW - 10)
               Return (K_MOUSE30)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * CARD_EDIT for Type

         CASE nMODE = 11
            DO CASE
            CASE nROW = 11 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 20 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW >= 11 .AND. nROW <= 20 .AND. nCOL >= 55 .AND. nCOL <= 76
               DC_MOUHIDE()
               nSELECTED := (nROW - 10)
               Return (K_MOUSE30)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * CARD_EDIT for Artist

         CASE nMODE = 12
            DO CASE
            CASE nROW = 11 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 18 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 20 .AND. nCOL >= 58 .AND. nCOL <= 62
               DC_MOUHIDE()
               Return (65)          && Add
            CASE nROW = 20 .AND. nCOL >= 67 .AND. nCOL <= 72
               DC_MOUHIDE()
               Return (69)          && Edit
            CASE nROW >= 11 .AND. nROW <= 18 .AND. nCOL >= 55 .AND. nCOL <= 76
               DC_MOUHIDE()
               nSELECTED := (nROW - 10)
               Return (K_MOUSE30)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * CARD_EDIT for Dealers

         CASE nMODE = 13
            DO CASE
            CASE nROW = 11 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 18 .AND. nCOL = 77
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 20 .AND. nCOL >= 61 .AND. nCOL <= 65
               DC_MOUHIDE()
               Return (65)          && Add
            CASE nROW = 20 .AND. nCOL >= 70 .AND. nCOL <= 75
               DC_MOUHIDE()
               Return (69)          && Edit
            CASE nROW >= 11 .AND. nROW <= 18 .AND. nCOL >= 60 .AND. nCOL <= 76
               DC_MOUHIDE()
               nSELECTED := (nROW - 10)
               Return (K_MOUSE30)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Decks, Main Screen

         CASE nMODE = 14
            DO CASE
            CASE nROW = 5 .AND. nCOL = 71
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_UP)        && Up
            CASE nROW = 19 .AND. nCOL = 71
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.07)
               Return (K_DOWN)      && Down
            CASE nROW = 21 .AND. nCOL >= 7 .AND. nCOL <= 12
               DC_MOUHIDE()
               Return (86)          && View
            CASE nROW = 21 .AND. nCOL >= 14 .AND. nCOL <= 18
               DC_MOUHIDE()
               Return (65)          && Add
            CASE nROW = 21 .AND. nCOL >= 20 .AND. nCOL <= 25
               DC_MOUHIDE()
               Return (69)          && Edit
            CASE nROW = 21 .AND. nCOL >= 27 .AND. nCOL <= 32
               DC_MOUHIDE()
               Return (75)          && Kill
            CASE nROW = 21 .AND. nCOL >= 34 .AND. nCOL <= 45
               DC_MOUHIDE()
               Return (83)          && Statistics
            CASE nROW = 21 .AND. nCOL >= 47 .AND. nCOL <= 62
               DC_MOUHIDE()
               Return (82)          && Random Draw
            CASE nROW = 21 .AND. nCOL >= 64 .AND. nCOL <= 70
               DC_MOUHIDE()
               Return (81)          && Quit
            CASE nROW >= 5 .AND. nROW <= 19 .AND. nCOL >= 7 .AND. nCOL <= 70
               DC_MOUHIDE()
               nSELECTED := (nROW - 4)
               Return (K_MOUSE35)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * ERASE Y/N options, from DECKS()

         CASE nMODE = 15
            DO CASE
            CASE nROW = 12 .AND. nCOL >= 47 .AND. nCOL <= 49
               DC_MOUHIDE()
               Return (89)        && Yes
            CASE nROW = 12 .AND. nCOL >= 53 .AND. nCOL <= 55
               DC_MOUHIDE()
               Return (78)        && No
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Decks, DeckBuilder Screen, Add & Edit

         CASE nMODE = 16
            DO CASE
            CASE nROW = 22 .AND. nCOL >= 16 .AND. nCOL <= 20
               DC_MOUHIDE()
               Return (K_HOME)      && Top of List
            CASE nROW = 22 .AND. nCOL >= 22 .AND. nCOL <= 27
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGUP)      && Page Up
            CASE nROW = 22 .AND. nCOL >= 29 .AND. nCOL <= 36
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_UP)        && Line Up
            CASE nROW = 22 .AND. nCOL >= 38 .AND. nCOL <= 43
               DC_MOUHIDE()
               Return (K_ESC)       && Quit
            CASE nROW = 22 .AND. nCOL >= 45 .AND. nCOL <= 51
               DC_MOUHIDE()
               Return (K_TAB)       && Order
            CASE nROW = 22 .AND. nCOL >= 53 .AND. nCOL <= 60
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_DOWN)      && Line Down
            CASE nROW = 22 .AND. nCOL >= 62 .AND. nCOL <= 67
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGDN)      && Page Down
            CASE nROW = 22 .AND. nCOL >= 69 .AND. nCOL <= 76
               DC_MOUHIDE()
               Return (K_END)       && Bottom of Report
            CASE nROW >= 7 .AND. nROW <= 21 .AND. nCOL >= 15 .AND. nCOL <= 77
               DC_MOUHIDE()
               nSELECTED := (nROW - 6)
               Return (K_MOUSE40)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Decks, DeckBuilder Screen, View

         CASE nMODE = 17
            DO CASE
            CASE nROW = 22 .AND. nCOL >= 16 .AND. nCOL <= 20
               DC_MOUHIDE()
               Return (K_HOME)      && Top of List
            CASE nROW = 22 .AND. nCOL >= 22 .AND. nCOL <= 27
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGUP)      && Page Up
            CASE nROW = 22 .AND. nCOL >= 29 .AND. nCOL <= 36
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_UP)        && Line Up
            CASE nROW = 22 .AND. nCOL >= 38 .AND. nCOL <= 43
               DC_MOUHIDE()
               Return (K_ESC)       && Quit
            CASE nROW = 22 .AND. nCOL >= 46 .AND. nCOL <= 51
               DC_MOUHIDE()
               Return (K_ENTER)     && View
            CASE nROW = 22 .AND. nCOL >= 53 .AND. nCOL <= 60
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_DOWN)      && Line Down
            CASE nROW = 22 .AND. nCOL >= 62 .AND. nCOL <= 67
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGDN)      && Page Down
            CASE nROW = 22 .AND. nCOL >= 69 .AND. nCOL <= 76
               DC_MOUHIDE()
               Return (K_END)       && Bottom of List
            CASE nROW >= 7 .AND. nROW <= 21 .AND. nCOL >= 15 .AND. nCOL <= 77
               DC_MOUHIDE()
               nSELECTED := (nROW - 6)
               Return (K_MOUSE40)   && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Decks, Deck Statistics Screen

         CASE nMODE = 18
            DO CASE
            CASE nROW = 22 .AND. nCOL >= 3 .AND. nCOL <= 7
               DC_MOUHIDE()
               Return (K_HOME)      && Top of List
            CASE nROW = 22 .AND. nCOL >= 11 .AND. nCOL <= 16
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGUP)      && Page Up
            CASE nROW = 22 .AND. nCOL >= 20 .AND. nCOL <= 27
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_UP)        && Line Up
            CASE nROW = 22 .AND. nCOL >= 31 .AND. nCOL <= 36
               DC_MOUHIDE()
               Return (K_ESC)       && Quit
            CASE nROW = 22 .AND. nCOL >= 39 .AND. nCOL <= 44
               DC_MOUHIDE()
               Return (K_ENTER)     && View
            CASE nROW = 22 .AND. nCOL >= 48 .AND. nCOL <= 55
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_DOWN)      && Line Down
            CASE nROW = 22 .AND. nCOL >= 59 .AND. nCOL <= 64
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGDN)      && Page Down
            CASE nROW = 22 .AND. nCOL >= 68 .AND. nCOL <= 75
               DC_MOUHIDE()
               Return (K_END)       && Bottom of List
            CASE nROW >= 7 .AND. nROW <= 21 .AND. nCOL >= 1 .AND. nCOL <= 77
               DC_MOUHIDE()
               nSELECTED := (nROW - 6)
               Return (K_MOUSE45)     && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Decks, Deck Random Draw

         CASE nMODE = 19
            DO CASE
            CASE nROW = 22 .AND. nCOL >= 5 .AND. nCOL <= 9
               DC_MOUHIDE()
               Return (K_HOME)      && Top of List
            CASE nROW = 22 .AND. nCOL >= 11 .AND. nCOL <= 16
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGUP)      && Page Up
            CASE nROW = 22 .AND. nCOL >= 18 .AND. nCOL <= 25
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_UP)        && Line Up
            CASE nROW = 22 .AND. nCOL >= 27 .AND. nCOL <= 32
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(.15)
               Return (68)          && Draw
            CASE nROW = 22 .AND. nCOL >= 35 .AND. nCOL <= 40
               DC_MOUHIDE()
               Return (K_ESC)       && Quit
            CASE nROW = 22 .AND. nCOL >= 43 .AND. nCOL <= 48
               DC_MOUHIDE()
               Return (K_ENTER)     && View
            CASE nROW = 22 .AND. nCOL >= 50 .AND. nCOL <= 57
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,0,.15))
               Return (K_DOWN)      && Line Down
            CASE nROW = 22 .AND. nCOL >= 59 .AND. nCOL <= 64
               DC_MOUHIDE()
               lPRESSED := .F.
               DC_PAUSE(IF(lFASTMOUSE,.01,.15))
               Return (K_PGDN)      && Page Down
            CASE nROW = 22 .AND. nCOL >= 66 .AND. nCOL <= 73
               DC_MOUHIDE()
               Return (K_END)       && Bottom of List
            CASE nROW >= 7 .AND. nROW <= 21 .AND. nCOL >= 5 .AND. nCOL <= 73
               DC_MOUHIDE()
               nSELECTED := (nROW - 6)
               Return (K_MOUSE50)     && Select
            OTHERWISE
               BEEP_SHORT
            ENDCASE

         * Pause

         CASE nMODE = 99
            IF nROW == nITEMROW .AND. (nCOL >= nITEMCOL .AND. nCOL <= nITEMCOL + 3)
               DC_MOUHIDE()
               Return (13)
            ENDIF
         ENDCASE
      ELSE
         IF nMOUSE == 2
            DO CASE
            CASE nMODE == 1 .AND. lINVENTORY
               lPRESSED := .T.
               DC_MOUGETPOSITION(@nROW,@nCOL)
               IF nROW >= 5 .AND. nROW <= 21 .AND. nCOL >= 1 .AND. nCOL <= 77
                  DC_MOUHIDE()
                  lPRESSED := .F.
                  DC_PAUSE(.05)
                  nSELECTED := (nROW - 4)
                  Return (K_MOUSE61)
               ENDIF
            CASE nMODE == 16
               lPRESSED := .T.
               DC_MOUGETPOSITION(@nROW,@nCOL)
               IF nROW >= 7 .AND. nROW <= 21 .AND. nCOL >= 15 .AND. nCOL <= 77
                  DC_MOUHIDE()
                  nSELECTED := (nROW - 6)
                  Return (K_MOUSE41)
               ENDIF
            ENDCASE
         ENDIF
      ENDIF
   ENDIF
ENDDO
Return (Nil)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
/*                     Simple Pause Function, with "OK"                     */
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

Function PAUSE (nYPOS,nXPOS,cCOLOR)
Local nCURSOR := SETCURSOR()
IF (nYPOS <> Nil)
   @ nYPOS,nXPOS SAY " Ok " COLOR cCOLOR
ENDIF
SET CURSOR OFF
IF(lMOUSED,MOUSEKEY(99,nYPOS,nXPOS),INKEY(0))
SETCURSOR(nCURSOR)
Return (Nil)
