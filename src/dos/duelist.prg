#include "inkey.ch"

#define PROG_NAME  "DUELIST.EXE"
#define ALT_COLOR  "N/W*,W+/N,,,B+/W*"
#define BK1_COLOR  "B+/N"
#define BK2_COLOR  "GR+/N"
#define CLR_COLOR  "W+/B*"
#define HEAD_COLOR "BG+/B"
#define MAIN_COLOR "N/GR*,W+/N,,,B+/GR*"
#define OFF_COLOR  "GR/GR*"
#define PASS_COLOR "W+/W*,N/N,,,W+/W*"
#define POP_COLOR  "N/BG,W+/N,,,GR+/BG"
#define SHAD_COLOR "W/N"
#define SHOW_COLOR "B+/W*"
#define WARN_COLOR "W+/R"

* Main Variables

Static cINITSCRN, cMAINSCRN, GETLIST := {}, lGOD := .F.
Static lACCT := .F., cBACKUP, lLOOKUP, dLASTDATE, cMAINMENU

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Main Menu Functions                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function MAIN_BLOCK (pPARM)
Local cSCREEN
Local lOKDATE := .F.

pPARM := IF(pPARM = Nil,"",pPARM)
SET SCOREBOARD OFF
SET DELETED ON
SET EXACT ON
SET BELL OFF
SET WRAP ON
@ 0,0 CLEAR
SETBLINK(.F.)
RESTORE SCREEN FROM REPLICATE(CHR(219)+CHR(9),2000)
SETCOLOR(ALT_COLOR)
@  0,0  SAY SPACE(80)
@ 24,0  SAY SPACE(80)
@  0,71 SAY DATE()
@ 24,67 SAY "Duelist 1.1"
@  0,69 SAY "і"
@ 24,65 SAY "і"
SETCOLOR(MAIN_COLOR)
PREP_INDEX(.T.)
RESTORE SCREEN FROM cSCREEN
MAINMENU()
SETBLINK(.T.)
SET CURSOR ON
SETCOLOR("W/N")
CLEAR SCREEN
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                Main Menu                                 */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function MAINMENU
Local nOPTION

SET MESSAGE TO 24
RESTSCREEN(1,0,23,79,cINITSCRN)
SETCOLOR(MAIN_COLOR)
ZBOX(2,16,8,62,BK1_COLOR)
@ 3,18 SAY "      Welcome to SofTrack      "
@ 5,18 SAY '    "The Software Behind the Software"     '
@ 7,18 SAY "Copyright 1994, Bard's Quest Software, Inc."
cMAINSCRN := SAVESCREEN(1,0,23,79)
ZBOX(13,29,18,50,BK1_COLOR)
DO WHILE .T.
   SET CURSOR OFF
   SETCOLOR(MAIN_COLOR)
   @ 14,30 SAY    "      Main Menu     "
   @ 15,30 SAY    "ДДДДДДДДДДДДДДДДДДДД"
   @ 16,30 PROMPT " Duelist Customers  "
   @ 17,30 PROMPT " Quit/Exit Program  "
   MENU TO nOPTION
   IF nOPTION == 0
      nOPTION := 2
   ELSE
      SET KEY K_F10 TO
      SAVE SCREEN TO cMAINMENU
      DO CASE
      CASE nOPTION == 1
         CUSTOMERS()
      CASE nOPTION == 2
         CLOSE ALL
         CLEAR ALL
         SET CURSOR ON
         SETBLINK(.T.)
         SETCOLOR("W/N")
         CLEAR SCREEN
         QUIT
      ENDCASE
      CLOSE ALL
      RESTORE SCREEN FROM cMAINMENU
   ENDIF
ENDDO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/* ZZZ                       Main Customer Screen                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CUSTOMERS
Local nKEY, oTBROWSE, cSCREEN, cSEARCH, nSEARCH, nFILTER, nRECNO, nFOUND
Local cFILTTYPE := " ", cFILTSTATE := "  ", nROW

USE ("CUSTOMER") NEW EXCLUSIVE
SET INDEX TO ("CUSTNAME")
@ 0,2  SAY "Add  Edit  Delete  Quit" COLOR ALT_COLOR
ZBOX(2,3,22,75,BK1_COLOR,"Duelist Customers")
@ 3,5  SAY "        Customer Name                 City          State  Zip Code "
@ 4,5  SAY "ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД ДДДДДДДДДДДДДДДДДДДД ДДДДД ДДДДДДДДДД"
oTBROWSE := TBROWSEDB(5,4,21,74)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" " + NAMESTR() + " " + CITY + "  " + STATE + "   " + ZIPCODE + " "}))

DO WHILE .T.
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE (nKEY == 65 .OR. nKEY == K_INS)
      SAVE SCREEN TO cSCREEN
      @ 0,2 SAY " Add " COLOR "W+/N"
      APPEND BLANK
      CUSTOMER->TYPE    := "X"
      CUSTOMER->COUNTRY := "United States"
      CUSTOMER->NOTE1   := "From Duelist Magazine #"
      CUSTFORM("Adding a Customer")
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 69 .OR. nKEY == K_ENTER)
      SAVE SCREEN TO cSCREEN
      @ 0,6 SAY " Edit " COLOR "W+/N"
      CUSTFORM("Editing Customer")
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 68 .or. nKEY == K_DEL)
      SAVE SCREEN TO cSCREEN
      @ 0,12 SAY " Delete " COLOR "W+/N"
      SETCOLOR(ALT_COLOR)
      ZBOX(13,21,15,58,BK2_COLOR)
      @ 14,23 SAY "Shall I Delete this Customer? Y/N"
      SET CURSOR ON
      nKEY := INKEY(0)
      SET CURSOR OFF
      IF nKEY == 89 .or. nKEY == 121
         SET EXACT ON
         DELETE
         IF oTBROWSE:ROWPOS = 1
            SKIP 1
            IF EOF()
               SKIP -1
            ENDIF
         ENDIF
         TONE(900,2)
      ENDIF
      RESTORE SCREEN FROM cSCREEN
      oTBROWSE:REFRESHALL()
   CASE (nKEY == 81 .OR. nKEY == K_ESC)
      SAVE SCREEN TO cSCREEN
      @ 0,62 SAY " Quit " COLOR "W+/N"
      INKEY(.1)
      Return (.F.)
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

Function NAMESTR
cFILL := RTRIM(CUSTOMER->LAST_NAME) + ", " + RTRIM(CUSTOMER->FIRST_NAME)
Return (cFILL + SPACE(30 - LEN(cFILL)))

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                            Data Entry Forms                              */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CUSTFORM (cMSG)
SETCOLOR(ALT_COLOR)
ZBOX(7,10,20,67,BK2_COLOR,cMSG)
@  9,12 SAY "Last Name ......." GET CUSTOMER->LAST_NAME
@ 10,12 SAY "First Name ......" GET CUSTOMER->FIRST_NAME
IF ! "ADD"$UPPER(cMSG)
   @ 11,12 SAY "Contact ........." GET CUSTOMER->CONTACT
ENDIF
@ 12,12 SAY "Address 1 ......." GET CUSTOMER->ADDRESS1
IF ! "ADD"$UPPER(cMSG)
   @ 13,12 SAY "Address 2 ......." GET CUSTOMER->ADDRESS2
ENDIF
@ 14,12 SAY "City ............" GET CUSTOMER->CITY
@ 15,12 SAY "State ..........." GET CUSTOMER->STATE      PICTURE "@!"
@ 16,12 SAY "Zip Code ........" GET CUSTOMER->ZIPCODE    PICTURE "@!"
@ 17,12 SAY "Country ........." GET CUSTOMER->COUNTRY    PICTURE "@!"
@ 18,12 SAY "Telephone ......." GET CUSTOMER->PHONE1     PICTURE "@R (###) ###-####"
IF ! "ADD"$UPPER(cMSG)
   @ 19,12 SAY "Notes ..........." GET CUSTOMER->NOTE1      PICTURE "@S37"
ENDIF
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                        Rebuild Indexes if Missing                        */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function PREP_INDEX (lNEEDMSG)
IF ! FILE("CUSTNAME.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("CUSTOMER") NEW EXCLUSIVE
   INDEX ON UPPER(LAST_NAME + FIRST_NAME) TO ("CUSTNAME")
   CLOSE
ENDIF
Return (Nil)

Function DO_MSG (lNEEDMSG)
IF lNEEDMSG
   ZWARN(12,"Please Wait : Rebuilding Indexes",1,BK1_COLOR)
   SET CURSOR ON
   lNEEDMSG := .F.
ENDIF
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                 3d Box                                   */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ZBOX (Y1,X1,Y2,X2,ZCOLOR,cMSG)
Local nCOLOR := SETCOLOR()
@ Y1,X1 CLEAR TO Y2,X2
@ Y1,X2+1 SAY "Я" COLOR ZCOLOR
SETCOLOR(SHAD_COLOR)
@ Y1+1,X2+1 CLEAR TO Y2+1,X2+1
@ Y2+1,X1+1 SAY REPLICATE("Ь",X2-X1+1) COLOR ZCOLOR
IF cMSG <> Nil
   SETCOLOR(HEAD_COLOR)
   @ Y1,X1 CLEAR TO Y1,X2
   @ Y1,(((X1+X2)/2)-LEN(cMSG)/2) SAY cMSG
ENDIF
SETCOLOR(nCOLOR)
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                      3d Warning Message Box Routine                      */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ZWARN (nYPOS,cMSG,nMODE,cBKCOLOR)
Local nXOFF := INT(LEN(cMSG)/2) + 3, nCURSOR := SETCURSOR(), nCOLOR := SETCOLOR()
DO CASE
CASE nMODE == 1
   SETCOLOR(MAIN_COLOR)
   ZBOX(nYPOS-1,40-nXOFF,nYPOS+1,40+nXOFF,cBKCOLOR)
   @ nYPOS,43-nXOFF SAY cMSG
CASE nMODE == 2
   SETCOLOR(WARN_COLOR)
   @ 24,0 CLEAR TO 24,79
   @ 24,40-LEN(cMSG)/2 SAY cMSG
   SET CURSOR ON
CASE nMODE == 3
   SETCOLOR(WARN_COLOR)
   ZBOX(nYPOS-1,40-nXOFF,nYPOS+1,40+nXOFF,cBKCOLOR)
   @ nYPOS,43-nXOFF SAY cMSG
   INKEY(0)
ENDCASE
SETCURSOR(nCURSOR)
SETCOLOR(nCOLOR)
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                      Place a Help Message at Bottom                      */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function HELPIT (sMSG)
@ 24,0 SAY SPACE(65) COLOR ALT_COLOR
@ 24,1 SAY sMSG      COLOR ALT_COLOR
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                     Simple Pause Function, with "OK"                     */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function PAUSE (nYPOS)
Local nCURSOR := SETCURSOR()
IF (nYPOS <> Nil)
   @ nYPOS,38 SAY " Ok " COLOR "W+/N"
ENDIF
SET CURSOR OFF
INKEY(0)
SETCURSOR(nCURSOR)
Return (Nil)
