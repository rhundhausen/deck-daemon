/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                                                          */
/*   Program   : SOFTRACK.EXE                                               */
/*   Purpose   : Software Registration/Tracking Program                     */
/*   Started   : June 14, 1994                                              */
/*   Completed :                                                            */
/*                                                                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                                                          */
/*  Database        Index(s)        Expression(s)                           */
/*  ДДДДДДДДДДДД    ДДДДДДДДДДДД    ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД       */
/*  CUSTOMER.DBF .. CUSTNAME.NTX .. UPPER(NAME)                             */
/*                  CUSTSERN.NTX .. SERIAL NUMBER + TYPE + NAME             */
/*                  CUSTCODE.NTX .. NUMBER                                  */
/*  ORDERS.DBF .... ORDERS1.NTX ... STR(CUSTOMER,5)                         */
/*                  ORDERS2.NTX ... UPPER(NAME + PROD_CODE)                 */
/*  INVOICES.DBF .. INVOICES.NTX .. STR(CUSTOMER,5) + DTOS(ORDERED)         */
/*  INVLINES.DBF .. INVLINES.NTX .. STR(CUSTOMER,5) + DTOS(ORDERED)         */
/*  SYSTEM.DBF                                                              */
/*  PRODUCTS.DBF .. PRODUCTS.NTX .. TYPE + NAME                             */
/*                                                                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

#include "inkey.ch"

#define PROG_NAME  "SOFTRACK.EXE"
#define BKUP_PATH  "BACKUPS\"
#define RICH_PASS  "BRISCO"
#define DAVE_PASS  "DEXTER"
#define STATES1    "AK|AL|AR|AZ|CA|CO|CT|DC|FL|GA|HI|IA|ID|IL|IN|IO|KS|KY|LA|MA|MD|ME|MI|MN|MO|MS|"
#define STATES2    "MT|NC|ND|NE|NH|NJ|NM|NV|NY|OH|OK|OR|PA|RI|SC|SD|TN|TX|UT|VA|VT|WA|WI|WV|WY|"
#define METHODS    "AIRBORNE    |COUNTER     |DHL         |UPS GROUND  |UPS ORANGE  |UPS BLUE    |UPS RED     |US AIRMAIL  |US EXPRESS  |US POSTAL   |US PRIORITY |US WORLDEX  |** OTHER ** |"
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

* Program Arrays

Static aSHIPPING[13], aTYPES[8]

* Main Variables

Static cINITSCRN, cMAINSCRN, GETLIST := {}, lGOD := .F.
Static lACCT := .F., cBACKUP, lLOOKUP, dLASTDATE, cMAINMENU

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Main Menu Functions                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function MAIN_BLOCK (pPARM)
Local cSCREEN, cSYSPASS, cPASSWORD := SPACE(10), lASKDATE := .F., cFILL
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
@ 24,67 SAY "SofTrack 1.1"
@  0,69 SAY "і"
@ 24,65 SAY "і"

* Load Program Arrays

aSHIPPING[ 1] := " AIRBORNE    (Airborne Express)   "
aSHIPPING[ 2] := " COUNTER     (Sold at B.Q.)       "
aSHIPPING[ 3] := " DHL         (World Couriers)     "
aSHIPPING[ 4] := " UPS GROUND  (Standard UPS)       "
aSHIPPING[ 5] := " UPS ORANGE  (UPS 3-Day)          "
aSHIPPING[ 6] := " UPS BLUE    (UPS 2-Day)          "
aSHIPPING[ 7] := " UPS RED     (UPS Next-Day)       "
aSHIPPING[ 8] := " US AIRMAIL  (Standard Overseas)  "
aSHIPPING[ 9] := " US EXPRESS  (USPS Next Day)      "
aSHIPPING[10] := " US POSTAL   (Snail Mail)         "
aSHIPPING[11] := " US PRIORITY (Quicker Snail Mail) "
aSHIPPING[12] := " US WORLDEX  (World Express)      "
aSHIPPING[13] := " ** OTHER ** (Explain in Notes)   "

aTYPES[1] := " C. Mail Order Customers "
aTYPES[2] := " D. Dealers/Resellers    "
aTYPES[3] := " I. Distributors/Chains  "
aTYPES[4] := " R. Mailed Registrations "
aTYPES[5] := " M. Magazines/Books/Etc. "
aTYPES[6] := " B. Bard's Quest Sales   "
aTYPES[7] := " S. Outstanding Products "
aTYPES[8] := " O. Other                "

* Get variables from SYSTEM.DBF

SAVE SCREEN TO cSCREEN
cINITSCRN := SAVESCREEN(1,0,23,79)
USE ("SYSTEM") NEW EXCLUSIVE
cSYSPASS := SYSTEM->PASSWORD
cBACKUP  := SYSTEM->BACKUP_DRV
CLOSE

* Ask for Password

SETCOLOR(MAIN_COLOR)
IF ! DAVE_PASS$UPPER(pPARM) .AND. ! RICH_PASS$UPPER(pPARM)
   zBOX(11,32,14,47,BK1_COLOR)
   @ 11,32 SAY " Enter Password " COLOR ALT_COLOR
   @ 13,34 SAY "[          ]"
   @ 13,35 GET cPASSWORD PICTURE "@!" COLOR PASS_COLOR
   SET CURSOR ON
   READ
   SET CURSOR OFF
   RESTORE SCREEN FROM cSCREEN
   lASKDATE := .T.
ENDIF
DO CASE
CASE cPASSWORD = RICH_PASS .OR. RICH_PASS$UPPER(pPARM)
   lGOD  := .T.
CASE cPASSWORD = DAVE_PASS .OR. DAVE_PASS$UPPER(pPARM)
   lACCT := .T.
CASE (cPASSWORD <> cSYSPASS)
   TONE(900,2)
   SETCOLOR(MAIN_COLOR)
   ZBOX(9,11,16,69,BK1_COLOR)
   @ 10,13 SAY "          : Your password was entered incorrectly.     "
   @ 10,16 SAY " Sorry " COLOR CLR_COLOR
   @ 12,13 SAY "If you have forgotten the password or need it updated, "
   @ 13,13 SAY "contact BQS, Inc. Technical Support at (208) 336-9404."
   PAUSE(15)
   CLOSE ALL
   CLEAR ALL
   SET CURSOR ON
   SETBLINK(.T.)
   SETCOLOR("W/N")
   CLEAR SCREEN
   QUIT
ENDCASE

IF lASKDATE
   SETCOLOR(MAIN_COLOR)
   ZBOX(9,21,15,59,BK1_COLOR)
   cFILL := CDOW(DATE()) + ", " + CMONTH(DATE()) + " " + SUBSTR(DTOC(DATE()),4,2) + "," + STR(YEAR(DATE()),5)
   @ 10,40-LEN(cFILL)/2 SAY cFILL
   @ 12,36 SAY DTOC(DATE())
   @ 14,24 SAY "Is this the correct date? ... [ ]"
   @ 14,55 GET lOKDATE PICTURE "Y"
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF ! lOKDATE
      TONE(900,2)
      SETCOLOR(MAIN_COLOR)
      ZBOX(9,15,16,65,BK1_COLOR)
      @ 10,17 SAY "          : The system date must be corrected. "
      @ 10,20 SAY " Sorry " COLOR CLR_COLOR
      @ 12,17 SAY "Please return to DOS or Windows and correct the"
      @ 13,17 SAY "system TIME and/or DATE before running SOFTRACK."
      PAUSE(15)
      CLOSE ALL
      CLEAR ALL
      SET CURSOR ON
      SETBLINK(.T.)
      SETCOLOR("W/N")
      CLEAR SCREEN
      QUIT
   ENDIF
ENDIF

dLASTDATE := DATE()
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
ZBOX(11,29,21,50,BK1_COLOR)
DO WHILE .T.
   SET CURSOR OFF
   SETCOLOR(MAIN_COLOR)
   @ 12,30 SAY    "      Main Menu     "
   @ 13,30 SAY    "ДДДДДДДДДДДДДДДДДДДД"
   @ 14,30 PROMPT " Ordering Functions "
   @ 15,30 PROMPT " Lookup a Customer  "
   @ 16,30 PROMPT " Add Person/Company "
   @ 17,30 SAY    "ДДДДДДДДДДДДДДДДДДДД"
   @ 18,30 PROMPT " Reports & Listings "
   @ 19,30 PROMPT " Database Utilities "
   @ 20,30 PROMPT " Quit/Exit Program  "
   MENU TO nOPTION
   IF nOPTION == 0
      nOPTION := 6
   ELSE
      SET KEY K_F10 TO
      SAVE SCREEN TO cMAINMENU
      DO CASE
      CASE nOPTION == 1
         ORDERS()
      CASE nOPTION == 2
         CUSTOMERS(0)
      CASE nOPTION == 3
         ADD_MENU()
      CASE nOPTION == 4
         REPORTS()
      CASE nOPTION == 5
         UTILITY()
      CASE nOPTION == 6
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
/*                              Place an Order                              */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ORDERS
Local nOPTION := 1, cSCREEN, nORDERS, cFILL, nLASTCUST, nRECNO, cLASTCUST
Local nVISA, nCHECK, nGRAND, cPRODUCT, nPOSITION, nROWS, nKEY, oTBROWSE
Local cLINE1, cLINE2, cLINE3, cLINE4, lEDITING, cSCREEN2, nROW, cNAME
Local GETLIST := {}, lCONTINUE, dDATE := DATE()

USE ("SYSTEM") NEW EXCLUSIVE
USE ("ORDERS") NEW EXCLUSIVE
SET INDEX TO ("ORDERS2"), ("ORDERS1")
ZBOX(11,53,21,70,BK1_COLOR)
SAVE SCREEN TO cSCREEN
DO WHILE .T.
   SELECT ORDERS
   RESTORE SCREEN FROM cSCREEN
   SETCOLOR(MAIN_COLOR)
   @ 12,54 SAY    "  Orders :" + STR(LASTREC(),4) + "  " COLOR "BG/GR*"
   @ 13,54 SAY    "ДДДДДДДДДДДДДДДД"
   @ 14,54 PROMPT " Take an Order  "
   @ 15,54 PROMPT " Edit Order(s)  "
   @ 16,54 SAY    "ДДДДДДДДДДДДДДДД"
   @ 17,54 PROMPT " Daily Report   "
   @ 18,54 PROMPT " Mailing Labels "
   @ 19,54 SAY    "ДДДДДДДДДДДДДДДД"
   IF lACCT .OR. lGOD
      @ 20,54 PROMPT " Close Out Day  "
   ELSE
      @ 20,54 SAY    " Close Out Day  " COLOR "W/GR*"
   ENDIF
   MENU TO nOPTION
   DO CASE
   CASE nOPTION = 0
      Return (Nil)
   CASE nOPTION = 1
      USE ("CUSTOMER") NEW EXCLUSIVE
      SET INDEX TO ("CUSTSERN"), ("CUSTNAME"), ("CUSTCODE")
      cNAME   := SPACE(30)
      lLOOKUP := .F.
      ZBOX(2,8,22,70,BK1_COLOR)
      @  2,8  SAY SPACE(24) + "Taking an Order" + SPACE(24) COLOR ALT_COLOR
      @  4,10 SAY "Name (F1щSearch) ..." GET cNAME
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF ! EMPTY(cNAME) .AND. LASTKEY() <> 27
         SELECT CUSTOMER
         IF lLOOKUP
            COPY NEXT 1 TO NEWCUST
            USE ("NEWCUST") NEW EXCLUSIVE
            GO TOP
         ELSE
            COPY NEXT 0 TO NEWCUST
            USE ("NEWCUST") NEW EXCLUSIVE
            ZAP
            APPEND BLANK
            NEWCUST->TYPE    := "C"
            NEWCUST->COUNTRY := "United States"
            NEWCUST->NOTE1   := "Entered into system on "+DTOC(DATE())
         ENDIF
         @  5,10 SAY "   Type ............ [ ] ... (CDIRMBO)"
         @  5,32                            GET NEWCUST->TYPE       PICTURE "@!" VALID NEWCUST->TYPE$"CDIRMBO"
         @  6,10 SAY "   Contact ........." GET NEWCUST->CONTACT
         @  7,10 SAY "   Address 1 ......." GET NEWCUST->ADDRESS1
         @  8,10 SAY "   Address 2 ......." GET NEWCUST->ADDRESS2
         @  9,10 SAY "   City ............" GET NEWCUST->CITY
         @ 10,10 SAY "   State ..........." GET NEWCUST->STATE      PICTURE "@!"
         @ 11,10 SAY "   Country ........." GET NEWCUST->COUNTRY
         @ 12,10 SAY "   Zipcode ........." GET NEWCUST->ZIPCODE    PICTURE "@!"
         @ 13,10 SAY "   Telephone 1 ....." GET NEWCUST->PHONE1     PICTURE "@R (###) ###-####"
         @ 15,9  SAY REPLICATE("Д",22) + " Customer Notes " + REPLICATE("Д",23)
         @ 17,10 SAY "Notes 1 ..."          GET NEWCUST->NOTE1      PICTURE "@S47"
         @ 18,10 SAY "Notes 2 ..."          GET NEWCUST->NOTE2      PICTURE "@S47"
         @ 19,10 SAY "Notes 3 ..."          GET NEWCUST->NOTE3      PICTURE "@S47"
         @ 20,10 SAY "Notes 4 ..."          GET NEWCUST->NOTE4      PICTURE "@S47"
         @ 21,10 SAY "Notes 5 ..."          GET NEWCUST->NOTE5      PICTURE "@S47"
         HELPIT("Types : Cщust, Dщealer, IщDist, Rщeg, Mщag, Bщard's, Oщther")
         lCONTINUE := .T.
         IF lLOOKUP
            CLOSE NEWCUST
            CLEAR GETS
            TONE(900,2)
            ZWARN(0,"Is this the correct CUSTOMER? [Y/N]",2)
            INKEY(0)
            lCONTINUE := (LASTKEY() = 89 .OR. LASTKEY() = 121)
         ELSE
            KEYBOARD CHR(K_DOWN)
            SET CURSOR ON
            READ
            SET CURSOR OFF
            IF LASTKEY() <> 27
               NEWCUST->NAME := cNAME
               CLOSE NEWCUST
               SELECT CUSTOMER
               SET INDEX TO ("CUSTCODE"), ("CUSTSERN"), ("CUSTNAME")
               GO BOTTOM
               nLASTCODE := CUSTOMER->NUMBER
               APPEND FROM ("NEWCUST.DBF")
               CUSTOMER->NUMBER := (nLASTCODE + 1)
               COMMIT
               lCONTINUE := .T.
            ELSE
               CLOSE NEWCUST
            ENDIF
         ENDIF
         IF lCONTINUE
            RESTORE SCREEN FROM cSCREEN
            TAKE_ORDER()
         ENDIF
         ERASE("NEWCUST.DBF")
      ENDIF
      CLOSE CUSTOMER
   CASE nOPTION = 2
      SELECT ORDERS
      SET INDEX TO
      PACK
      INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
      INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
      SET INDEX TO ("ORDERS2"), ("ORDERS1")
      IF LASTREC() < 1
         TONE(900,2)
         ZWARN(16,"Sorry : There are no orders to Edit/Delete.",2,BK2_COLOR)
         INKEY(0)
      ELSE
         SELECT ORDERS
         SET ORDER TO 1
         GO TOP

         * Check for any orders here

         zBOX(2,1,22,77,BK1_COLOR)
         @ 0,2 SAY "Edit  Delete  Trivia                                         Quit" COLOR ALT_COLOR
         @ 2,1 SAY SPACE(31) + "Current Orders" + SPACE(32) COLOR ALT_COLOR
         @ 4,3 SAY "   Customer Name        Customer's City     Products  Qty   Shipping  Pay"
         @ 5,3 SAY "ДДДДДДДДДДДДДДДДДДДД  ДДДДДДДДДДДДДДДДДДДД  ДДДДДДДД  ДДД  ДДДДДДДДДД ДДД"
         HELPIT("Commands : [Enter] Edits Order, [D] Delete Order")
         oTBROWSE := TBROWSEDB(6,2,21,76)
         oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+LEFT(NAME,20)+"  "+LEFT(CITY_STATE,20)+"  "+PROD_CODE+STR(PROD_UNITS,5)+"  "+SHIP_METH+" "+IF("COD"$UPPER(CHECK),"COD",IF(EMPTY(VISA),"Chk","C/C"))+" "}))
         lEDITING := .T.
         DO WHILE lEDITING
            oTBROWSE:FORCESTABLE()
            nKEY := ASC(UPPER(CHR(INKEY(0))))
            DO CASE
            CASE nKEY == 69 .OR. nKEY == K_ENTER
               SAVE SCREEN TO cSCREEN2
               SETCOLOR(ALT_COLOR)
               zBOX(3,11,21,67,BK2_COLOR)
               @  3,11 SAY SPACE(20) + "Changing an Order" + SPACE(20) COLOR "W+/B"
               @  5,13 SAY "Customer Name ....." GET ORDERS->NAME
               @  6,13 SAY "   Address 1 ......" GET ORDERS->ADDRESS1
               @  7,13 SAY "   City/State ....." GET ORDERS->CITY_STATE
               @  8,13 SAY "   Telephone ......" GET ORDERS->TELEPHONE   PICTURE "@R (###) ###-####"
               @ 10,12 SAY "ДДДД To make changes above, use LOOKUP A CUSTOMER ДДДДД"
               CLEAR GETS
               @ 12,13 SAY "Date Ordered ......" GET ORDERS->ORDERED
               @ 13,13 SAY "Product Code ......" GET ORDERS->PROD_CODE   PICTURE "@!"
               @ 14,13 SAY "   Serial # ......." GET ORDERS->PROD_SN
               @ 15,13 SAY "   Units Sold ....." GET ORDERS->PROD_UNITS
               @ 16,13 SAY "   Price/Unit ....." GET ORDERS->PROD_PRICE
               @ 17,13 SAY "Shipping Method ..." GET ORDERS->SHIP_METH
               @ 17,53 SAY "Cost"                GET ORDERS->SHIP_PRICE
               @ 18,13 SAY "   Check Number ..." GET ORDERS->CHECK       PICTURE "@!"
               @ 19,13 SAY "   VISA ..........." GET ORDERS->VISA        PICTURE "@R ####-####-####-####"
               @ 19,53 SAY "Exp"                 GET ORDERS->VISA_EXP    PICTURE "@!"
               @ 20,13 SAY "Notes/Remarks ....." GET ORDERS->NOTES       PICTURE "@S33"
               SET CURSOR ON
               READ
               SET CURSOR OFF
               SETCOLOR(MAIN_COLOR)
               oTBROWSE:REFRESHALL()
               RESTORE SCREEN FROM cSCREEN2
            CASE nKEY == 68 .or. nKEY == K_DEL
               TONE(900,2)
               SAVE SCREEN TO cSCREEN2
               ZWARN(0,"Shall I Delete this ORDER? [Y/N]",2)
               INKEY(0)
               RESTORE SCREEN FROM cSCREEN2
               IF LASTKEY() == 89 .OR. LASTKEY() == 121
                  DELETE
                  IF oTBROWSE:ROWPOS = 1
                     SKIP 1
                     IF EOF()
                        SKIP -1
                     ENDIF
                  ENDIF
                  SELECT ORDERS
                  SET INDEX TO
                  PACK
                  INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
                  INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
                  SET INDEX TO ("ORDERS2"), ("ORDERS1")
               ENDIF
               oTBROWSE:REFRESHALL()
            CASE nKEY == K_ESC
               lEDITING := .F.
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
         RESTORE SCREEN FROM cSCREEN
      ENDIF
   CASE nOPTION = 3
      SELECT ORDERS
      SET INDEX TO
      PACK
      INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
      INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
      SET INDEX TO ("ORDERS2"), ("ORDERS1")
      IF LASTREC() < 1
         TONE(900,2)
         ZWARN(16,"Sorry : There are no orders to Print.",2,BK2_COLOR)
         INKEY(0)
      ELSE
         ZWARN(16,"Please Wait : Printing Daily Orders Report.",2,BK2_COLOR)

         * First, make some calculations

         nLASTCUST  := 0
         nGRAND     := 0
         SELECT ORDERS
         SET ORDER TO 2
         GO TOP
         DO WHILE ! EOF()
            IF ORDERS->CUSTOMER <> nLASTCUST .AND. nLASTCUST <> 0
               nRECNO := RECNO()
               REPLACE ORDERS->AMT_FINAL WITH (nGRAND + ORDERS->SHIP_PRICE) FOR ORDERS->CUSTOMER = nLASTCUST
               GO nRECNO
               nGRAND := 0
            ENDIF
            nGRAND    := nGRAND + (ORDERS->PROD_UNITS * ORDERS->PROD_PRICE)
            nLASTCUST := ORDERS->CUSTOMER
            SKIP
         ENDDO
         REPLACE ORDERS->AMT_FINAL WITH (nGRAND + ORDERS->SHIP_PRICE) FOR ORDERS->CUSTOMER = nLASTCUST

         * Begin Printing

         USE ("PRODUCTS") NEW EXCLUSIVE
         nVISA  := 0
         nCHECK := 0
         nGRAND := 0
         SET PRINTER TO (LTRIM(RTRIM(UPPER(SYSTEM->LP_DEVICE))))
         SET PRINT ON
         SET CONSOLE OFF
         ? IF(SYSTEM->LP_TYPE = "HP",CHR(27) + "&l1O" + CHR(27) + "(s0p16.67h6v0s0b6T","")
         ? "   Bard's Quest Software                                                                                                                  Daily Orders, Printed On "+DTOC(DATE())
         ?
         ?
         ? "           Customer Name                   City/State                    Product Description         Units  Shipping  Total Amount    Check       VISA/MasterCard   Expires"
         ? "   ------------------------------ ------------------------------ ----------------------------------- ----- ---------- ------------ ------------ ------------------- -------"
         SELECT ORDERS
         SET ORDER TO 1
         GO TOP
         cLASTCUST := ""
         DO WHILE ! EOF()
            IF UPPER(ORDERS->NAME) = cLASTCUST .AND. ! EMPTY(cLASTCUST)
               ? SPACE(65)
            ELSE
               ? "   " + ORDERS->NAME + " " + ORDERS->CITY_STATE + " "
            ENDIF

            * Lookup Product Name(s)

            SELECT PRODUCTS
            LOCATE FOR PRODUCTS->CODE = ORDERS->PROD_CODE
            cPRODUCT := IF(FOUND(),PRODUCTS->NAME,"Unknown Product Code               ")
            SELECT ORDERS
            ?? cPRODUCT + STR(ORDERS->PROD_UNITS,5) + " "
            IF UPPER(ORDERS->NAME) <> cLASTCUST .OR. EMPTY(cLASTCUST)
               ?? " " + ORDERS->SHIP_METH
               ?? "  $" + STR(AMT_FINAL,9,2) + "  " + ORDERS->CHECK + " "
               IF EMPTY(ORDERS->VISA) .AND. EMPTY(ORDERS->VISA_EXP)
                  nCHECK := nCHECK + ORDERS->AMT_FINAL
                  nGRAND := nGRAND + ORDERS->AMT_FINAL
               ELSE
                  ?? TRANSFORM(ORDERS->VISA,"@R ####-####-####-####") + "   " + ORDERS->VISA_EXP
                  nVISA  := nVISA  + ORDERS->AMT_FINAL
                  nGRAND := nGRAND + ORDERS->AMT_FINAL
               ENDIF
            ENDIF
            cLASTCUST := UPPER(ORDERS->NAME)
            SKIP
         ENDDO
         IF nVISA <> 0 .OR. nCHECK <> 0
            ? SPACE(120) + "----------"
         ENDIF
         IF nVISA <> 0
            ? SPACE(102) + "Credit Card Total $" + STR(nVISA,8,2)
         ENDIF
         IF nCHECK <> 0
            ? SPACE(102) + " Check/Cash Total $" + STR(nCHECK,8,2)
         ENDIF
         ? SPACE(120) + "=========="
         ? SPACE(102) + "      GRAND Total $" + STR(nGRAND,8,2)
         IF SYSTEM->LP_TYPE = "HP"
            ?? CHR(27) + "&l0O" + CHR(27) + "(s0p10h12v0s0b3T"
         ELSE
            ?? CHR(12)
         ENDIF
         SET PRINT OFF
         SET CONSOLE ON
         SET PRINTER TO

         * Next, Generate VISA Listing for Faxing

         SET PRINTER TO ("VISA.REP")
         SET PRINT ON
         SET CONSOLE OFF
         SELECT ORDERS
         SET ORDER TO 1
         GO TOP
         cLASTCUST := ""
         ? "           Customer Name                   City/State                    Product Description         Units  Shipping    VISA/MasterCard   Expires Total Amount"
         ? "   ------------------------------ ------------------------------ ----------------------------------- ----- ---------- ------------------- ------- ------------"
         DO WHILE ! EOF()
            IF ! EMPTY(ORDERS->VISA)
               IF UPPER(ORDERS->NAME) = cLASTCUST .AND. ! EMPTY(cLASTCUST)
                  ? SPACE(65)
               ELSE
                  ? "   " + ORDERS->NAME + " " + ORDERS->CITY_STATE + " "
               ENDIF

               * Lookup Product Name(s)

               SELECT PRODUCTS
               LOCATE FOR PRODUCTS->CODE = ORDERS->PROD_CODE
               cPRODUCT := IF(FOUND(),PRODUCTS->NAME,"Unknown Product Code               ")
               SELECT ORDERS
               ?? cPRODUCT + STR(ORDERS->PROD_UNITS,5) + " "
               IF UPPER(ORDERS->NAME) <> cLASTCUST .OR. EMPTY(cLASTCUST)
                  ?? " " + ORDERS->SHIP_METH + " "
                  ?? TRANSFORM(ORDERS->VISA,"@R ####-####-####-####") + "   " + LEFT(ORDERS->VISA_EXP,6)
                  ?? " $" + STR(AMT_FINAL,8,2)
               ENDIF
               cLASTCUST := UPPER(ORDERS->NAME)
            ENDIF
            SKIP
         ENDDO
         SET PRINT OFF
         SET CONSOLE ON
         SET PRINTER TO
         CLOSE PRODUCTS
         ERASE("TEMP.NTX")
      ENDIF
   CASE nOPTION = 4
      SELECT ORDERS
      SET INDEX TO
      PACK
      INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
      INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
      SET INDEX TO ("ORDERS2"), ("ORDERS1")
      IF LASTREC() < 1
         TONE(900,2)
         ZWARN(16,"Sorry : There are no orders to Print.",2,BK2_COLOR)
         INKEY(0)
      ELSE
         SAVE SCREEN TO cSCREEN
         ZWARN(0,"Insert Sheet(s) of Labels and press any key.  [Esc] Cancels.",2)
         INKEY(0)
         IF LASTKEY() <> 27
            ZWARN(16,"Please Wait : Printing Mailing Labels.",2,BK2_COLOR)
            SET PRINTER TO (LTRIM(RTRIM(UPPER(SYSTEM->LP_DEVICE))))
            SET PRINT ON
            SET CONSOLE OFF
            cFILL := IF(SYSTEM->LP_TYPE = "HP",CHR(27) + "(s0p16.67h6v0s0b6T","")
            SELECT ORDERS
            SET ORDER TO 1
            GO TOP
            nROWS     := 0
            nPOSITION := 1
            cLASTCUST := ""
            cLINE1    := ""
            cLINE2    := ""
            cLINE3    := ""
            cLINE4    := ""
            DO WHILE ! EOF()
               IF UPPER(ORDERS->NAME) <> cLASTCUST .OR. EMPTY(cLASTCUST)
                  DO CASE
                  CASE nPOSITION = 1
                     cLINE1 := cFILL + "    " + ORDERS->NAME
                     cLINE2 := "    " + ORDERS->ADDRESS1
                     cLINE3 := "    " + IF(EMPTY(ORDERS->ADDRESS2),ORDERS->CITY_STATE,ORDERS->ADDRESS2)
                     cLINE4 := "    " + IF(EMPTY(ORDERS->ADDRESS2),"",ORDERS->CITY_STATE)
                     cFILL  := ""
                     nPOSITION++
                  CASE nPOSITION = 2
                     cLINE1 := cLINE1 + SPACE(15) + ORDERS->NAME
                     cLINE2 := cLINE2 + SPACE(15) + ORDERS->ADDRESS1
                     cLINE3 := cLINE3 + SPACE(15) + IF(EMPTY(ORDERS->ADDRESS2),ORDERS->CITY_STATE,ORDERS->ADDRESS2)
                     cLINE4 := cLINE4 + SPACE(15) + IF(EMPTY(ORDERS->ADDRESS2),"",ORDERS->CITY_STATE)
                     nPOSITION++
                  CASE nPOSITION = 3
                     ? cLINE1 + SPACE(15) + ORDERS->NAME
                     ? cLINE2 + SPACE(15) + ORDERS->ADDRESS1
                     ? cLINE3 + SPACE(15) + IF(EMPTY(ORDERS->ADDRESS2),ORDERS->CITY_STATE,ORDERS->ADDRESS2)
                     ? cLINE4 + SPACE(15) + IF(EMPTY(ORDERS->ADDRESS2),"",ORDERS->CITY_STATE)
                     nROWS++
                     IF nROWS > 9
                        ?? CHR(12)
                        nROWS := 0
                     ELSE
                        ?
                        ?
                     ENDIF
                     nPOSITION := 1
                     cLINE1    := ""
                     cLINE2    := ""
                     cLINE3    := ""
                     cLINE4    := ""
                  ENDCASE
               ENDIF
               cLASTCUST := UPPER(ORDERS->NAME)
               SKIP
            ENDDO
            IF nPOSITION <> 1
               ? cLINE1
               ? cLINE2
               ? cLINE3
               ? cLINE4
               ?
               ?
            ENDIF
            IF SYSTEM->LP_TYPE = "HP"
               ?? CHR(27) + "(s0p10h12v0s0b3T"
            ENDIF
            ?? CHR(12)
            SET PRINT OFF
            SET CONSOLE ON
            SET PRINTER TO
            ERASE("TEMP.NTX")
         ENDIF
      ENDIF
   CASE nOPTION = 5 .AND. (lACCT .OR. lGOD)
      SELECT ORDERS
      SET INDEX TO
      PACK
      INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
      INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
      SET INDEX TO ("ORDERS2"), ("ORDERS1")
      IF LASTREC() < 1
         TONE(900,2)
         ZWARN(16,"Sorry : There are no orders to Close Out.",2,BK2_COLOR)
         INKEY(0)
      ELSE
         ZWARN(16,"Shall I Post these orders to the permanent databases?",2,BK2_COLOR)
         INKEY(0)
         IF LASTKEY() = 89 .OR. LASTKEY() = 121
            RESTORE SCREEN FROM cMAINMENU

            ZBOX(13,53,16,68,BK1_COLOR)
            @ 14,55 SAY "Date Shipped"
            @ 15,55 SAY " [        ] "
            @ 15,57 GET dDATE
            SET CURSOR ON
            READ
            SET CURSOR OFF
            IF LASTKEY() <> 27
               USE ("INVOICES") NEW EXCLUSIVE
               SET INDEX TO ("INVOICES")

               USE ("INVLINES") NEW EXCLUSIVE
               SET INDEX TO ("INVLINES")

               nLASTCUST := 0
               nGRAND    := 0
               nRECNO    := 0
               SELECT ORDERS
               SET ORDER TO 2
               GO TOP
               DO WHILE ! EOF()

                  SELECT INVOICES
                  IF ORDERS->CUSTOMER <> nLASTCUST .OR. nLASTCUST = 0
                     IF nGRAND > 0
                        GO nRECNO
                        INVOICES->AMT_ORDER := (INVOICES->AMT_ORDER + nGRAND)
                        INVOICES->AMT_FINAL := (INVOICES->AMT_ORDER + INVOICES->AMT_SHIP)
                     ENDIF
                     APPEND BLANK
                     INVOICES->CUSTOMER  := ORDERS->CUSTOMER
                     INVOICES->ORDERED   := ORDERS->ORDERED
                     INVOICES->SHIPPED   := dDATE
                     INVOICES->AMT_ORDER := (ORDERS->PROD_UNITS * ORDERS->PROD_PRICE)
                     INVOICES->AMT_SHIP  := ORDERS->SHIP_PRICE
                     INVOICES->AMT_FINAL := (ORDERS->PROD_UNITS * ORDERS->PROD_PRICE) + ORDERS->SHIP_PRICE
                     INVOICES->CHECK     := ORDERS->CHECK
                     INVOICES->VISA      := ORDERS->VISA
                     INVOICES->VISA_EXP  := ORDERS->VISA_EXP
                     INVOICES->SHIPPING  := ORDERS->SHIP_METH
                     INVOICES->NOTES     := ORDERS->NOTES
                     nRECNO := RECNO()
                     nGRAND := 0
                  ELSE
                     nGRAND := nGRAND + (ORDERS->PROD_UNITS * ORDERS->PROD_PRICE)
                  ENDIF

                  SELECT INVLINES
                  APPEND BLANK
                  INVLINES->CUSTOMER := ORDERS->CUSTOMER
                  INVLINES->ORDERED  := ORDERS->ORDERED
                  INVLINES->PRODUCT  := ORDERS->PROD_CODE
                  INVLINES->SERIAL   := ORDERS->PROD_SN
                  INVLINES->UNITS    := ORDERS->PROD_UNITS
                  INVLINES->AMT_EACH := ORDERS->PROD_PRICE

                  SELECT ORDERS
                  nLASTCUST := ORDERS->CUSTOMER
                  SKIP
               ENDDO

               IF nGRAND > 0
                  GO nRECNO
                  INVOICES->AMT_ORDER := (INVOICES->AMT_ORDER + nGRAND)
                  INVOICES->AMT_FINAL := (INVOICES->AMT_ORDER + INVOICES->AMT_SHIP)
               ENDIF

               * Finishing Touches

               CLOSE INVOICES
               CLOSE INVLINES
               SELECT ORDERS
               SET INDEX TO
               ZAP
               INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
               INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
               SET INDEX TO ("ORDERS2"), ("ORDERS1")
            ENDIF
         ENDIF
      ENDIF
   ENDCASE
ENDDO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Order Taking Screen                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function TAKE_ORDER
Local dDATE := DATE(), nITEMS := 0, nTOTAL := 0, nSERIAL := 0, oTBROWSE
Local cCHECK := SPACE(12), cVISA := SPACE(16), cEXPIRES := SPACE(10)
Local cSHIPPING := "US POSTAL   ", nSHIPPING := 0, cNOTES := SPACE(48)
Local lORDERING := .T., nBEFORE := 0, nRECNO, nSPECIAL, lSERIAL

* Draw Screen and Prompt for Date

SETCOLOR(MAIN_COLOR)
ZBOX(2,1,22,77,BK1_COLOR,"New Order for : " + LTRIM(RTRIM(CUSTOMER->NAME)))
@ 4,2 SAY "Order Date ..." GET dDATE
SET CURSOR ON
READ
SET CURSOR OFF
IF LASTKEY() = 27 .OR. EMPTY(dDATE)
   Return (Nil)
ENDIF

USE ("PRODUCTS") NEW EXCLUSIVE
 SET INDEX TO ("PRODUCTS")
REPLACE ALL ORDERED WITH 0, DISCOUNT WITH 0
SET FILTER TO ACTIVE
GO TOP
@ 6,2 SAY "  Code    System                Product                Each  Units  Amount "
@ 7,2 SAY "ДДДДДДДД ДДДДДДДД ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД ДДДДДД ДДДДД ДДДДДДДД"
@ 15,2  SAY REPLICATE("Д",75)
HELPIT("Commands : [+]/[-], [Enter], [Esc], [D]iscounts")
oTBROWSE := TBROWSEDB(8,1,14,77)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+CODE+" "+PLATFORM+"  "+NAME+STR(PRICE * ((100-PRODUCTS->DISCOUNT)/100),7,2)+STR(ORDERED,6)+STR(PRICE * ORDERED * ((100-PRODUCTS->DISCOUNT)/100),9,2)+" "}))
DO WHILE lORDERING

   * Tally Results

   nRECNO    := RECNO()
   nITEMS    := 0
   nTOTAL    := 0
   nSHIPPING := 0
   lSERIAL   := .F.
   GO TOP
   DO WHILE ! EOF()
      IF PRODUCTS->ORDERED > 0
         lSERIAL := IF(SERIAL,.T.,lSERIAL)
         nITEMS  := nITEMS + PRODUCTS->ORDERED
         nTOTAL  := nTOTAL + (PRODUCTS->ORDERED * PRODUCTS->PRICE * ((100-PRODUCTS->DISCOUNT)/100))
         IF PRODUCTS->SHIPPING > nSHIPPING .AND. PRODUCTS->DISCOUNT <> 100
            nSHIPPING := PRODUCTS->SHIPPING
         ENDIF
      ENDIF
      SKIP
   ENDDO
   IF nTOTAL > 150
      nSHIPPING := 0
   ENDIF
   GO nRECNO

   * Display Results

   @ 16,58 SAY "Product  $" + STR(nTOTAL,9,2)
   @ 17,58 SAY "Shipping $" + STR(nSHIPPING,9,2)
   @ 18,58 SAY "TOTAL    $" + STR(nTOTAL + nSHIPPING,9,2)
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE nKEY == 43 .OR. nKEY == K_SPACE
      TONE(600,1)
      PRODUCTS->ORDERED ++
      oTBROWSE:REFRESHALL()
   CASE nKEY == 45 .AND. PRODUCTS->ORDERED > 0
      TONE(600,1)
      PRODUCTS->ORDERED --
      oTBROWSE:REFRESHALL()
   CASE nKEY == K_ENTER
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:FORCESTABLE()
      nBEFORE := PRODUCTS->ORDERED
      @ oTBROWSE:ROWPOS() + 7,63 GET PRODUCTS->ORDERED RANGE 0,99999
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF LASTKEY() = 27
         PRODUCTS->ORDERED := nBEFORE
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
   CASE nKEY == K_ESC
      IF nITEMS < 1
         CLOSE PRODUCTS
         Return (Nil)
      ENDIF
      SAVE SCREEN TO cSCREEN
      SETCOLOR(ALT_COLOR)
      zBOX(13,22,15,57,BK2_COLOR)
      @ 14,24 SAY "Are you ready to Continue? [Y/N]"
      SET CURSOR ON
      INKEY(0)
      SET CURSOR OFF
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
      IF LASTKEY() = 89 .OR. LASTKEY() = 121
         lORDERING := .F.
      ENDIF
   CASE nKEY == 68
      SAVE SCREEN TO cSCREEN
      SETCOLOR(ALT_COLOR)
      zBOX(10,21,18,58,BK2_COLOR,"Special Discount Functions")
      @ 12,22 PROMPT " A. Replacement Product - No Charge "
      @ 13,22 PROMPT " B. Discount 10% (Good Guy)         "
      @ 14,22 PROMPT " C. Discount 50% (Dealers)          "
      @ 15,22 PROMPT " D. Discount 60% (Distributors)     "
      @ 16,22 SAY    "ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД"
      @ 17,22 PROMPT " E. Cancel Discounts (Full Price)   "
      MENU TO nSPECIAL
      RESTORE SCREEN FROM cSCREEN
      nRECNO := RECNO()
      DO CASE
      CASE nSPECIAL = 1
         REPLACE ALL PRODUCTS->DISCOUNT WITH 100
         @ 15,33 SAY "  No Charge   " COLOR WARN_COLOR
      CASE nSPECIAL = 2
         REPLACE ALL PRODUCTS->DISCOUNT WITH 10
         @ 15,33 SAY " 10% Discount "
      CASE nSPECIAL = 3
         REPLACE ALL PRODUCTS->DISCOUNT WITH 50
         @ 15,33 SAY " 50% Discount "
      CASE nSPECIAL = 4
         REPLACE ALL PRODUCTS->DISCOUNT WITH 60
         @ 15,33 SAY " 60% Discount "
      CASE nSPECIAL = 5
         REPLACE ALL PRODUCTS->DISCOUNT WITH 0
         @ 15,33 SAY " No Discounts "
      ENDCASE
      GO nRECNO
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:REFRESHALL()
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

* Entering Rest of Information

HELPIT("")
@ 17,2  SAY "Shipping Method ........." GET cSHIPPING WHEN POP_SHIP(cSHIPPING)
@ 18,2  SAY "Check/Money Order/COD ..." GET cCHECK
@ 19,2  SAY "VISA/Mastercard ........." GET cVISA     PICTURE "@R ####-####-####-####"
@ 20,2  SAY "   Expiration MM/YY ....." GET cEXPIRES  PICTURE "@!"
@ 21,2  SAY "Notes ..................." GET cNOTES
SET CURSOR ON
READ
SET CURSOR OFF
IF LASTKEY() <> 27

   * Prompt for Serial Number

   IF lSERIAL
      SETCOLOR(ALT_COLOR)
      zBOX(13,28,15,51,BK2_COLOR)
      @ 14,30 SAY "Serial Number" GET nSERIAL PICTURE "@Z 999999"
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SETCOLOR(MAIN_COLOR)
   ENDIF

   * Write Orders Record

   SELECT PRODUCTS
   GO TOP
   DO WHILE ! EOF()
      IF PRODUCTS->ORDERED > 0
         SELECT ORDERS
         APPEND BLANK
         ORDERS->ORDERED    := dDATE
         ORDERS->CUSTOMER   := CUSTOMER->NUMBER
         ORDERS->NAME       := CUSTOMER->NAME
         ORDERS->ADDRESS1   := CUSTOMER->ADDRESS1
         ORDERS->ADDRESS2   := CUSTOMER->ADDRESS2
         ORDERS->CITY_STATE := RTRIM(CUSTOMER->CITY) + ", " + RTRIM(CUSTOMER->STATE) + "  " + CUSTOMER->ZIPCODE
         ORDERS->TELEPHONE  := CUSTOMER->PHONE1
         ORDERS->PROD_CODE  := PRODUCTS->CODE
         ORDERS->PROD_SN    := nSERIAL
         ORDERS->PROD_UNITS := PRODUCTS->ORDERED
         ORDERS->PROD_PRICE := PRODUCTS->PRICE * ((100-PRODUCTS->DISCOUNT)/100)
         ORDERS->SHIP_METH  := cSHIPPING
         ORDERS->SHIP_PRICE := nSHIPPING
         ORDERS->AMT_FINAL  := nTOTAL + nSHIPPING
         ORDERS->CHECK      := cCHECK
         ORDERS->VISA       := cVISA
         ORDERS->VISA_EXP   := cEXPIRES
         ORDERS->NOTES      := cNOTES
         COMMIT
         SELECT PRODUCTS
      ENDIF
      SKIP
   ENDDO
ENDIF
CLOSE PRODUCTS
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                             Calculate Order                              */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CALC (nAMT1,nAMT2,nAMT3,nAMT4,nSHIPPING,nTOTAL)
IF nAMT1 > 0 .OR. nAMT2 > 0 .OR. nAMT3 > 0 .OR. nAMT4 > 0
   IF nSHIPPING = 0 .OR. nSHIPPING = 2.5 .OR. nSHIPPING = 5
      IF nAMT1 > 0
         nSHIPPING := 5
      ELSE
         nSHIPPING := 2.50
      ENDIF
   ENDIF
ELSE
   nSHIPPING := 0
ENDIF
nTOTAL := (nAMT1 * 29.95) + (nAMT2 * 14.95) + (nAMT3 * 4.95) + (nAMT4 * 17.95) + nSHIPPING
@ 19,32 SAY STR(nSHIPPING,8,2) COLOR "B+/GR*"
@ 20,32 SAY STR(nTOTAL,8,2)    COLOR "B+/GR*"
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                          Add New Record(s) to DBF                        */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function ADD_MENU
Local nOPTION := 1, cSCREEN

* Prompt the User

ZBOX(15,53,18,69,BK1_COLOR)
SAVE SCREEN TO cSCREEN
DO WHILE .T.
   RESTORE SCREEN FROM cSCREEN
   SETCOLOR(MAIN_COLOR)
   @ 16,54 PROMPT " Registration  "
   @ 17,54 PROMPT " Other Contact "
   MENU TO nOPTION
   DO CASE
   CASE nOPTION = 0
      Return (Nil)
   CASE nOPTION = 1
      REGISTER(.T.)
   CASE nOPTION = 2
      REGISTER(.F.)
   ENDCASE
   RESTORE SCREEN FROM cSCREEN
ENDDO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                        Add New Customer/Contact                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function REGISTER (lPRODUCT)
Local nLASTCODE := 0, GETLIST := {}, aINTERESTS := {}, cFILL, lPICKING := .T.
Local nROW, cINTERESTS, cPRODUCT := "BQS001  ", nSERIAL := 127000, dDATE

SETCOLOR(CLR_COLOR)
@ 1,0 CLEAR TO 23,79
SETCOLOR(MAIN_COLOR)
IF lPRODUCT
   ZBOX(2,7,21,71,BK1_COLOR,"User Registration")
ELSE
   ZBOX(2,7,21,71,BK1_COLOR,"Add a New Contact (Page 1 of 3)")
ENDIF

* Open Databases & Prepare Record

USE ("CUSTOMER") NEW EXCLUSIVE
SET INDEX TO ("CUSTSERN"), ("CUSTNAME"), ("CUSTCODE")
COPY NEXT 0 TO ("REGISTER")
USE ("REGISTER") NEW EXCLUSIVE
ZAP
APPEND BLANK
IF lPRODUCT
   REGISTER->TYPE    := "R"
   REGISTER->COUNTRY := "United States"
   REGISTER->NOTE1   := "Registration Entered into system on "+DTOC(DATE())
   REGISTER->NOTE2   := "Purchased from"
   dDATE             := dLASTDATE
ELSE
   REGISTER->TYPE    := "C"
   REGISTER->COUNTRY := "United States"
   REGISTER->NOTE1   := "Entered into system on "+DTOC(DATE())
ENDIF

* Load Products into Array

USE ("PRODUCTS") NEW EXCLUSIVE
 SET INDEX TO ("PRODUCTS")
GO TOP
DO WHILE ! EOF()
   IF ACTIVE
      cFILL := " " + LTRIM(RTRIM(PRODUCTS->NAME)) + " for " + PRODUCTS->PLATFORM
      cFILL := RTRIM(cFILL) + " " + REPLICATE(".",48-LEN(RTRIM(cFILL))) + CODE + " [ ]"
      AADD(aINTERESTS,cFILL)
   ENDIF
   SKIP
ENDDO
ASORT(aINTERESTS)
AADD(aINTERESTS," Other - Competetors ........................... COMPETE  [ ]")
AADD(aINTERESTS," Other - Diskette Duplication Services ......... DISKDUP  [ ]")
AADD(aINTERESTS," Other - Magazine/Publisher .................... MAGAZINE [ ]")
AADD(aINTERESTS," Other - Other Business or Corporate Contact ... OTHERBUS [ ]")
AADD(aINTERESTS," Other - Vendor/Service Provider ............... VENDOR   [ ]")
AADD(aINTERESTS," Other - Wizard's of the Coast Related ......... WOTC     [ ]")

* New Information

IF lPRODUCT
   @ 4,9 SAY "Registration Date ......." GET dDATE
   @ 5,9 SAY "Product [F1щLookup] ....." GET cPRODUCT             PICTURE "@!"        VALID OK_PROD(cPRODUCT,1)
   @ 6,9 SAY "   Description .........."
   @ 7,9 SAY "Product Serial Number ..." GET nSERIAL              PICTURE "@Z 999999"
ELSE
   @ 4,9 SAY "Registration Date ......." COLOR OFF_COLOR
   @ 5,9 SAY "Product [F1щLookup] ....." COLOR OFF_COLOR
   @ 6,9 SAY "   Description .........." COLOR OFF_COLOR
   @ 7,9 SAY "Product Serial Number ..." COLOR OFF_COLOR
ENDIF
@  8,8  SAY REPLICATE("Д",63)
@  9,9  SAY "Name [F1щLookup] ............" GET REGISTER->NAME       VALID ! EMPTY(REGISTER->NAME)
@ 10,9  SAY "Type [F1щLookup] ............ [ ] ... (CDIRMBO)"
@ 10,40                                     GET REGISTER->TYPE       PICTURE "@!" VALID REGISTER->TYPE$"BCDIMORS" WHEN POP_TYPES(REGISTER->TYPE,1)
@ 11,9  SAY "Contact Person (Business) ..." GET REGISTER->CONTACT
@ 12,9  SAY "Street Address, Line 1 ......" GET REGISTER->ADDRESS1
@ 13,9  SAY "Street Address, Line 2 ......" GET REGISTER->ADDRESS2
@ 14,9  SAY "City ........................" GET REGISTER->CITY
@ 15,9  SAY "State ......................." GET REGISTER->STATE      PICTURE "@!"
@ 16,9  SAY "Country ....................." GET REGISTER->COUNTRY
@ 17,9  SAY "Zip Code ...................." GET REGISTER->ZIPCODE    PICTURE "@!"
@ 18,9  SAY "Telephone Number ............" GET REGISTER->PHONE1     PICTURE "@R (###) ###-####"
@ 19,9  SAY "Telephone Number ............" GET REGISTER->PHONE2     PICTURE "@R (###) ###-####"
@ 20,9  SAY "          Type .............." GET REGISTER->PHONE2DESC PICTURE "@!"
HELPIT("Types : Cщust, Dщealer, IщDist, Rщeg, Mщag, Bщard's, Oщther")
SET CURSOR ON
READ
SET CURSOR OFF
IF LASTKEY() <> 27 .AND. ! EMPTY(REGISTER->NAME)

   * Prompt for Items of Interest

   ZBOX(2,7,22,71,BK1_COLOR,"Add a New Contact (Page 2 of 3)")
   @ 4,13 SAY "Please Select All Applicable Category(s) of Interest"
   HELPIT("Commands : Use arrows to select, [Enter] to pick, [Esc] quits")
   nPICK    := 1
   nPOS     := 0
   lPICKING := .T.
   DO WHILE lPICKING
      nPICK := ACHOICE(6,8,21,70,aINTERESTS,,,nPICK,nPOS)
      IF nPICK <> 0
         nROW := ROW()
         IF SUBSTR(aINTERESTS[nPICK],60,1) = " "
            aINTERESTS[nPICK] := LEFT(aINTERESTS[nPICK],59) + "]"
         ELSE
            aINTERESTS[nPICK] := LEFT(aINTERESTS[nPICK],59) + " ]"
         ENDIF
         nPOS := (nROW - 6)
         KEYBOARD CHR(K_DOWN)
      ENDIF
      lPICKING := (nPICK <> 0)
   ENDDO

   * Build Interest String

   cINTERESTS := ""
   FOR nX := 1 TO LEN(aINTERESTS)
      IF SUBSTR(aINTERESTS[nX],60,1) = ""
         cINTERESTS := cINTERESTS + SUBSTR(aINTERESTS[nX],50,8) + "|"
      ENDIF
   NEXT nX
   REGISTER->INTERESTS := cINTERESTS

   * User Notes Screen

   SETCOLOR(CLR_COLOR)
   @ 1,0 CLEAR TO 23,79
   SETCOLOR(MAIN_COLOR)
   ZBOX(6,11,19,66,BK1_COLOR,"Add a New Contact (Page 3 of 3)")
   HELPIT("")
   @  8,18 SAY "Please enter any notes about this contact"
   @  9,12 SAY REPLICATE("Д",54)
   @ 11,12 GET REGISTER->NOTE1
   @ 12,12 GET REGISTER->NOTE2
   @ 13,12 GET REGISTER->NOTE3
   @ 14,12 GET REGISTER->NOTE4
   @ 15,12 GET REGISTER->NOTE5
   @ 16,12 GET REGISTER->NOTE6
   @ 17,12 GET REGISTER->NOTE7
   @ 18,12 GET REGISTER->NOTE8
   KEYBOARD CHR(K_DOWN) + IF(lPRODUCT,CHR(K_END) + CHR(32),"")
   SET CURSOR ON
   READ
   SET CURSOR OFF

   * Write to Customer Database

   CLOSE REGISTER
   SELECT CUSTOMER
   SET INDEX TO ("CUSTCODE"), ("CUSTSERN"), ("CUSTNAME")
   GO BOTTOM
   nLASTCODE := CUSTOMER->NUMBER
   APPEND FROM ("REGISTER.DBF")
   CUSTOMER->NUMBER := (nLASTCODE + 1)
   COMMIT

   * If Product Registration, Write to Invoices & Invlines

   IF lPRODUCT
      CUSTOMER->SERIAL   := nSERIAL
      COMMIT

      USE ("INVOICES") NEW EXCLUSIVE
      SET INDEX TO ("INVOICES")
      APPEND BLANK
      INVOICES->CUSTOMER := (nLASTCODE + 1)
      INVOICES->ORDERED  := dDATE
      INVOICES->SHIPPED  := dDATE
      INVOICES->SHIPPING := "Reseller"
      INVOICES->NOTES    := "Product Registered on " + DTOC(dDATE)
      COMMIT

      USE ("INVLINES") NEW EXCLUSIVE
      SET INDEX TO ("INVLINES")
      APPEND BLANK
      INVLINES->CUSTOMER := (nLASTCODE + 1)
      INVLINES->ORDERED  := dDATE
      INVLINES->PRODUCT  := cPRODUCT
      INVLINES->SERIAL   := nSERIAL
      INVLINES->UNITS    := 1
      COMMIT
      dLASTDATE := dDATE
   ENDIF
ENDIF
CLOSE ALL
ERASE("REGISTER.DBF")
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Verify Serial Number                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CHECK_SN
Local cSCREEN
IF ! lLOOKUP .AND. ! STR(REGISTER->SERIAL,6)$"120000127000     0"
   SAVE SCREEN TO cSCREEN
   SELECT CUSTOMER
   SET INDEX TO ("CUSTSERN"), ("CUSTNAME"), ("CUSTCODE")
   SET EXACT OFF
   SEEK STR(REGISTER->SERIAL,6)
   IF FOUND()
      TONE(900,2)
      ZWARN(16,"Sorry : Serial number already on file.",3,BK2_COLOR)
      RESTORE SCREEN FROM cSCREEN
   ENDIF
   SET EXACT ON
ENDIF
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Main Customer Screen                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CUSTOMERS (nMODE)
Local nKEY, oTBROWSE, cSCREEN, cSEARCH, nSEARCH, nFILTER, nRECNO, nFOUND
Local cFILTTYPE := " ", cFILTSTATE := "  ", nROW

IF nMODE = 0
   USE ("CUSTOMER") NEW EXCLUSIVE
   SET INDEX TO ("CUSTNAME"), ("CUSTSERN"), ("CUSTCODE")
ELSE
   SELECT CUSTOMER
   SET INDEX TO ("CUSTNAME"), ("CUSTSERN"), ("CUSTCODE")
ENDIF
DO CASE
CASE (nMODE = 0 .AND. lGOD)
   @ 0,2  SAY "View  Edit  Notes  Orders  Delete  Filters  Search           Quit" COLOR ALT_COLOR
CASE (nMODE <> 0)
   @ 0,2  SAY "View  Edit  Notes  Orders  Delete  Filters  Search           Quit" COLOR "W/W*"
   @ 0,37 SAY "Filters  Search           Quit" COLOR ALT_COLOR
   HELPIT("Locate the USER and press [Enter]")
OTHERWISE
   @ 0,2  SAY "View  Edit  Notes  Orders          Filters  Search           Quit" COLOR ALT_COLOR
   @ 0,29 SAY "Delete" COLOR "W/W*"
ENDCASE
ZBOX(2,3,22,75,BK1_COLOR)
@ 3,5  SAY "        Customer Name                  City         State Type Serial"
@ 4,5  SAY "ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД ДДДДДДДДДДДДДДДДДДДД ДДДДД ДДДД ДДДДДД"
oTBROWSE := TBROWSEDB(5,4,21,74)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" " + NAME + " " + CITY + "  " + STATE + "   " + TYPESTR() + TRANSFORM(SERIAL,"@Z 9999999") + " "}))
DO WHILE .T.
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE (nKEY == K_ENTER .AND. nMODE = 2)
      Return (.T.)
   CASE (nKEY == K_ENTER .AND. nMODE = 1)
      lLOOKUP := .T.
      KEYBOARD CUSTOMER->NAME
      Return (.T.)
   CASE (nKEY == 81 .OR. nKEY == K_ESC) .AND. (nMODE <> 0)
      SAVE SCREEN TO cSCREEN
      @ 0,62 SAY " Quit " COLOR "W+/N"
      INKEY(.1)
      Return (.F.)
   CASE (nKEY == 86 .OR. nKEY == K_ENTER) .AND. (nMODE = 0)
      SAVE SCREEN TO cSCREEN
      RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 6,4 CLEAR TO 6,74
      @ 7,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 5
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()
      @ 0,1 SAY " View " COLOR "W+/N"
      CUSTFORM(1,"Viewing Customer #"+LTRIM(STR(CUSTOMER->NUMBER,5)))
      CLEAR GETS
      PAUSE(21)
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 69 .AND. (nMODE = 0)
      SAVE SCREEN TO cSCREEN
      RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 6,4 CLEAR TO 6,74
      @ 7,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 5
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()
      @ 0,7 SAY " Edit " COLOR "W+/N"
      CUSTFORM(1,"Editing Customer #"+LTRIM(STR(CUSTOMER->NUMBER,5)))
      KEYBOARD CHR(K_DOWN)
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 78 .AND. (nMODE = 0)
      SAVE SCREEN TO cSCREEN
      RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 6,4 CLEAR TO 6,74
      @ 7,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 5
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()
      @ 0,13 SAY " Notes " COLOR "W+/N"
      CUSTFORM(2,"Customer Notes")
      SET CURSOR ON
      READ
      SET CURSOR OFF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:NBOTTOM  := 21
      oTBROWSE:ROWPOS   := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 79 .AND. (nMODE = 0)
      SAVE SCREEN TO cSCREEN
      RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 6,4 CLEAR TO 6,74
      @ 7,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 5
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()
      @ 0,20 SAY " Orders " COLOR "W+/N"
      INVOICES()
      SELECT CUSTOMER
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 68 .or. nKEY == K_DEL) .AND. (nMODE = 0) .AND. lGOD
      SAVE SCREEN TO cSCREEN
      RESTSCREEN(7,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 6,4 CLEAR TO 6,74
      @ 7,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 5
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()
      @ 0,28 SAY " Delete " COLOR "W+/N"
      ZBOX(13,6,15,72,BK1_COLOR)
      @ 14,8 SAY "Shall I Delete this Customer and all Related Records? [Y] / [N]"
      SET CURSOR ON
      nKEY := INKEY(0)
      SET CURSOR OFF
      IF nKEY == 89 .or. nKEY == 121

         USE ("INVLINES") NEW EXCLUSIVE
         SET INDEX TO ("INVLINES")
         DELETE FOR CUSTOMER = CUSTOMER->NUMBER
         CLOSE

         USE ("INVOICES") NEW EXCLUSIVE
         SET INDEX TO ("INVOICES")
         DELETE FOR CUSTOMER = CUSTOMER->NUMBER
         CLOSE

         /* Old Way, But Faster

         SET EXACT OFF
         SEEK STR(CUSTOMER->NUMBER,5)
         IF FOUND()
            DO WHILE (INVOICES->CUSTOMER = CUSTOMER->NUMBER .AND. ! EOF())
               SELECT INVLINES
               SEEK STR(CUSTOMER->NUMBER,5) + DTOS(INVOICES->ORDERED)
               IF FOUND()
                  DO WHILE (INVLINES->CUSTOMER = CUSTOMER->NUMBER .AND. INVLINES->ORDERED = INVOICES->ORDERED .AND. ! EOF())
                     DELETE
                     SKIP
                  ENDDO
               ENDIF
               SELECT INVOICES
               DELETE
               SKIP
            ENDDO
         ENDIF

         */

         SET EXACT ON
         SELECT CUSTOMER
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
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == 70
      SAVE SCREEN TO cSCREEN
      @ 0,36 SAY " Filters " COLOR "W+/N"
      SETCOLOR(ALT_COLOR)
      ZBOX(2,27,7,53,BK2_COLOR)
      nFILTER := 1
      @ 3,28 PROMPT " A. Filter by TYPE  ["+cFILTTYPE+"]  "
      @ 4,28 PROMPT " B. Filter by STATE ["+cFILTSTATE+"] "
      @ 5,28 SAY    "ДДДДДДДДДДДДДДДДДДДДДДДДД"
      @ 6,28 PROMPT " C. All (Remove Filters) "
      MENU TO nFILTER
      DO CASE
      CASE nFILTER == 1
         @ 3,28 SAY " A. Filter by TYPE  [ ]  "
         @ 3,49 GET cFILTTYPE PICTURE "!" VALID cFILTTYPE$"CDIRMBO "
         HELPIT("Types : Cщust, Dщealer, IщDist, Rщeg, Mщag, Bщard's, Oщther")
         SET CURSOR ON
         READ
         SET CURSOR OFF
      CASE nFILTER == 2
         @ 4,28 SAY " B. Filter by STATE [  ] "
         @ 4,49 GET cFILTSTATE PICTURE "@!"
         SET CURSOR ON
         READ
         SET CURSOR OFF
      CASE nFILTER == 3
         SET FILTER TO
         cFILTTYPE  := " "
         cFILTSTATE := "  "
      ENDCASE
      IF nFILTER <> 3 .AND. LASTKEY() <> 27
         DO CASE
         CASE EMPTY(cFILTTYPE) .AND. EMPTY(cFILTSTATE)
            SET FILTER TO
         CASE EMPTY(cFILTTYPE) .AND. ! EMPTY(cFILTSTATE)
            SET FILTER TO STATE = cFILTSTATE
         CASE ! EMPTY(cFILTTYPE) .AND. EMPTY(cFILTSTATE)
            SET FILTER TO TYPE = cFILTTYPE
         CASE ! EMPTY(cFILTTYPE) .AND. ! EMPTY(cFILTSTATE)
            SET FILTER TO TYPE = cFILTTYPE .AND. STATE = cFILTSTATE
         ENDCASE
      ENDIF
      oTBROWSE:GOTOP()
      RESTORE SCREEN FROM cSCREEN
      SETCOLOR(MAIN_COLOR)
   CASE nKEY == 83
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:FORCESTABLE()
      SAVE SCREEN TO cSCREEN
      @ 0,45 SAY " Search " COLOR "W+/N"
      SETCOLOR(ALT_COLOR)
      ZBOX(11,18,14,59,BK2_COLOR)
      cSEARCH := SPACE(20)
      nSEARCH := 0
      @ 12,20 SAY "Search Name ....." GET cSEARCH PICTURE "@!"        VALID SKIPOTHER(cSEARCH)
      @ 13,20 SAY "Serial Number ..." GET nSEARCH PICTURE "@Z 999999"
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF ! EMPTY(cSEARCH) .AND. LASTKEY() <> 27
         SET ORDER TO 1
         SET SOFTSEEK ON
         nRECNO := RECNO()
         SEEK cSEARCH
         IF EOF()
            GOTO nRECNO
            TONE(900,2)
         ENDIF
         SET SOFTSEEK OFF
         SET ORDER TO 1
         oTBROWSE:REFRESHALL()
      ELSE
         IF ! EMPTY(nSEARCH) .AND. LASTKEY() <> 27
            SET ORDER TO 2
            nFOUND := 0
            nRECNO := RECNO()
            SEEK STR(nSEARCH,6)
            IF FOUND()
               nRECNO := RECNO()
               DO WHILE (CUSTOMER->SERIAL = nSEARCH .AND. ! EOF())
                  nFOUND++
                  SKIP
               ENDDO
               IF nFOUND > 1
                  TONE(900,2)
                  RESTORE SCREEN FROM cSCREEN
                  ZWARN(12,"Note : There are "+LTRIM(STR(nFOUND,3))+" customers with that number.",3,BK2_COLOR)
               ENDIF
               GOTO nRECNO
            ELSE
               GOTO nRECNO
               TONE(900,2)
            ENDIF
            SET ORDER TO 1
            oTBROWSE:REFRESHALL()
         ENDIF
      ENDIF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE ((nKEY == 81 .OR. nKEY == K_ESC) .AND. nMODE = 0)
      SAVE SCREEN TO cSCREEN
      @ 0,62 SAY " Quit " COLOR "W+/N"
      INKEY(.1)
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
      TONE(900,2)
   ENDCASE
ENDDO
Return (Nil)

Function SKIPOTHER (cENTRY)
IF ! EMPTY(cENTRY)
   KEYBOARD CHR(K_ENTER)
ENDIF
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                            TBrowse Type Field                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function TYPESTR
DO CASE
CASE CUSTOMER->TYPE = "C"; Return ("Mail")
CASE CUSTOMER->TYPE = "D"; Return ("Dlr ")
CASE CUSTOMER->TYPE = "I"; Return ("Dist")
CASE CUSTOMER->TYPE = "R"; Return ("Reg.")
CASE CUSTOMER->TYPE = "M"; Return ("Mag.")
CASE CUSTOMER->TYPE = "B"; Return ("B.Q.")
CASE CUSTOMER->TYPE = "O"; Return ("Othr")
ENDCASE
Return ("    ")

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                            Data Entry Forms                              */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function CUSTFORM (nPAGE,cMSG)
ZBOX(8,10,21,67,BK1_COLOR,cMSG)
IF nPAGE = 1
   @ 10,12 SAY "Type ............ [ ] ... (CDIRMBO)"
   @ 10,31                         GET CUSTOMER->TYPE       PICTURE "@!" VALID CUSTOMER->TYPE$"CDIRMBO"
   @ 11,11 SAY REPLICATE("Д",56)
   @ 12,12 SAY "Name ............" GET CUSTOMER->NAME
   @ 13,12 SAY "Contact ........." GET CUSTOMER->CONTACT
   @ 14,12 SAY "Address 1 ......." GET CUSTOMER->ADDRESS1
   @ 15,12 SAY "Address 2 ......." GET CUSTOMER->ADDRESS2
   @ 16,12 SAY "City ............" GET CUSTOMER->CITY
   @ 16,52 SAY "State"             GET CUSTOMER->STATE      PICTURE "@!"
   @ 17,12 SAY "Zip Code ........" GET CUSTOMER->ZIPCODE    PICTURE "@!"
   @ 18,12 SAY "Telephone 1 ....." GET CUSTOMER->PHONE1     PICTURE "@R (###) ###-####"
   @ 19,12 SAY "Telephone 2 ....." GET CUSTOMER->PHONE2     PICTURE "@R (###) ###-####"
   @ 19,52 SAY "Type"              GET CUSTOMER->PHONE2DESC
   @ 20,12 SAY "Serial Number ..." GET CUSTOMER->SERIAL     PICTURE "@Z"
   HELPIT("Types : Cщust, Dщealer, IщDist, Rщeg, Mщag, Bщard's, Oщther")
ELSE
   @ 10,11 SAY REPLICATE("Д",56)
   @ 11,12 GET NOTE1
   @ 12,12 GET NOTE2
   @ 13,12 GET NOTE3
   @ 14,12 GET NOTE4
   @ 15,12 GET NOTE5
   @ 16,12 GET NOTE6
   @ 17,12 GET NOTE7
   @ 18,12 GET NOTE8
   @ 19,12 GET NOTE9
   @ 20,12 GET NOTE10
ENDIF
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Order Detail Screen                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function INVOICES
Local nKEY, oTBROWSE, cSCREEN, lNEWSUB := .T., lANY, nSUBCOUNT, nRECNO, nROW
Local oTBROWSE2, lNECESSARY, lNEWSUB2 := .T., lANY2, nSUBCOUNT2 := 0, cSCREEN2
Local nRECNO2

zBOX(8,3,22,75,BK1_COLOR)
@  9,5 SAY "Ordered    Amount  Shipping Method/Cost  Total     Check    Ship Date"
@ 10,5 SAY "ДДДДДДДД  ДДДДДДДД ДДДДДДДДДДДДДДДДДДДД ДДДДДДДД ДДДДДДДДД  ДДДДДДДДД"
IF lGOD
   HELPIT("Commands : [E] Edit, [S] Show Product Detail, [D] Delete")
ELSE
   HELPIT("Commands : [E] Edit, [S] Show Product Detail")
ENDIF
USE ("INVOICES") NEW EXCLUSIVE
 SET INDEX TO ("INVOICES")
USE ("INVLINES") NEW EXCLUSIVE
 SET INDEX TO ("INVLINES")
USE ("PRODUCTS") NEW EXCLUSIVE
 SET INDEX TO ("PRODUCTS")
oTBROWSE := TBROWSEDB(11,4,21,74)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+DTOC(ORDERED)+STR(AMT_ORDER,10,2)+" "+SHIPPING + " $" + STR(AMT_SHIP,6,2) + STR(AMT_FINAL,9,2) + " " + LEFT(CHECK,9) + "  " + DTOC(SHIPPED)+"  "}))
DO WHILE .T.
   IF lNEWSUB
      SELECT INVOICES
      SET INDEX TO
      nSUBCOUNT := SUBNTX("INVOICES.NTX","SUBINV.NTX",STR(CUSTOMER->NUMBER,5))
      SET INDEX TO ("SUBINV.NTX")
      lANY := .F.
      IF nSUBCOUNT > 0
         GO TOP
         DO WHILE (! lANY .AND. ! EOF()); lANY := ! DELETED(); SKIP; ENDDO
         GO TOP
      ENDIF
      IF ! lANY
         TONE(900,2)
         ZWARN(16,"Sorry : There are no orders on file for this customer.",3,BK2_COLOR)
         Return (Nil)
      ENDIF
      lNEWSUB := .F.
      GO TOP
   ENDIF
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE (nKEY == K_ENTER .OR. nKEY == 69)
      SAVE SCREEN TO cSCREEN
      nRECNO := RECNO()
      SET INDEX TO ("INVOICES")
      GO nRECNO
      SETCOLOR(ALT_COLOR)
      ZBOX(9,8,20,69,BK2_COLOR,"Editing an Existing Order")
      @ 15,10 SAY "Final Amount ......" GET INVOICES->AMT_FINAL
      CLEAR GETS
      @ 11,10 SAY "Order Date ........" GET INVOICES->ORDERED
      @ 12,10 SAY "Shipping Date ....." GET INVOICES->SHIPPED
      @ 13,10 SAY "    Method ........" GET INVOICES->SHIPPING WHEN POP_SHIP(INVOICES->SHIPPING)
      @ 14,10 SAY "    Cost .........." GET INVOICES->AMT_SHIP
      @ 16,10 SAY "Check Number ......" GET INVOICES->CHECK
      @ 17,10 SAY "VISA Number ......." GET INVOICES->VISA
      @ 18,10 SAY "     Expires ......" GET INVOICES->VISA_EXP
      @ 19,10 SAY "Notes ..."           GET INVOICES->NOTES
      SET CURSOR ON
      READ
      SET CURSOR OFF
      lNEWSUB := .T.
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 83)
      SAVE SCREEN TO cSCREEN
      SETCOLOR(MAIN_COLOR)
      RESTSCREEN(13,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 12,4 CLEAR TO 12,74
      @ 13,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 11
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()

      SELECT INVLINES
      SET INDEX TO ("INVLINES")
      SET RELATION TO PRODUCT INTO PRODUCTS

      zBOX(14,1,22,77,BK1_COLOR)
      @ 15,3 SAY "Product                  Description                 Units Price  Total  "
      @ 16,3 SAY "ДДДДДДДД ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД ДДДДД ДДДДД ДДДДДДДД"
      IF lGOD
         HELPIT("Commands : [E] Edit, [D] Delete")
      ELSE
         HELPIT("Commands : [E] Edit")
      ENDIF
      oTBROWSE2 := TBROWSEDB(17,2,21,76)
      oTBROWSE2:ADDCOLUMN(TBCOLUMNNEW("",{||" "+PRODUCT+" "+PRODUCTS->PLATFORM+"щ"+IF(SERIAL=0,PRODUCTS->NAME,LEFT(PRODUCTS->NAME,26)+" ("+STR(SERIAL,6)+")")+IF(AMT_EACH = 0,"    User Registration",STR(UNITS,5)+STR(AMT_EACH,7,2)+STR(UNITS*AMT_EACH,9,2))+" "}))
      lNEWSUB2   := .T.
      lNECESSARY := .T.
      DO WHILE lNECESSARY
         IF lNEWSUB2
            SELECT INVLINES
            SET INDEX TO
            nSUBCOUNT2 := SUBNTX("INVLINES.NTX","SUBLINE.NTX",STR(CUSTOMER->NUMBER,5)+DTOS(INVOICES->ORDERED))
            SET INDEX TO ("SUBLINE.NTX")
            lANY2 := .F.
            IF nSUBCOUNT2 > 0
               GO TOP
               DO WHILE (! lANY2 .AND. ! EOF()); lANY2 := ! DELETED(); SKIP; ENDDO
               GO TOP
            ENDIF
            IF ! lANY2
               TONE(900,2)
               ZWARN(18,"Sorry : There is no Product Information on file for this invoice.",3,BK2_COLOR)
               lNECESSARY := .F.
            ELSE
               lNEWSUB2 := .F.
               GO TOP
            ENDIF
         ENDIF
         IF lNECESSARY
            oTBROWSE2:FORCESTABLE()
            nKEY := ASC(UPPER(CHR(INKEY(0))))
            DO CASE
            CASE (nKEY == K_ENTER .OR. nKEY == 69)
               SAVE SCREEN TO cSCREEN2
               nRECNO2 := RECNO()
               SET INDEX TO ("INVLINES")
               GO nRECNO2
               SETCOLOR(ALT_COLOR)
               ZBOX(14,8,21,69,BK2_COLOR,"Editing Order Detail")
               @ 16,10 SAY "Product [F1] ......" GET INVLINES->PRODUCT VALID OK_PROD(INVLINES->PRODUCT,0)
               @ 17,10 SAY "    Description ..."
               @ 18,10 SAY "Serial Number ....." GET INVLINES->SERIAL
               @ 19,10 SAY "Number of Units ..." GET INVLINES->UNITS
               @ 20,10 SAY "Amount Each ......." GET INVLINES->AMT_EACH
               OK_PROD(INVLINES->PRODUCT,0)
               SET CURSOR ON
               READ
               SET CURSOR OFF
               lNEWSUB2 := .T.
               SETCOLOR(MAIN_COLOR)
               oTBROWSE2:REFRESHALL()
               RESTORE SCREEN FROM cSCREEN2
            CASE (nKEY == 68 .or. nKEY == K_DEL) .AND. lGOD
               SAVE SCREEN TO cSCREEN2
               SETCOLOR("W+/R")
               ZBOX(18,10,20,66,BK2_COLOR)
               @ 19,12 SAY "Shall I Delete this Product from the Order? [Y] / [N]"
               SET CURSOR ON
               nKEY := INKEY(0)
               SET CURSOR OFF
               RESTORE SCREEN FROM cSCREEN2
               IF nKEY == 89 .or. nKEY == 121
                  DELETE
                  IF oTBROWSE2:ROWPOS = 1
                     SKIP 1
                     IF EOF()
                        SKIP -1
                     ENDIF
                  ENDIF
                  TONE(900,2)
                  lNEWSUB2 := .T.
               ENDIF
               SETCOLOR(MAIN_COLOR)
               oTBROWSE2:REFRESHALL()
               RESTORE SCREEN FROM cSCREEN2

            CASE nKEY == K_ESC
               lNECESSARY := .F.
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
         ENDIF
      ENDDO

      * All Done, Recalculate Totals

      SET RELATION TO
      SELECT INVOICES

      * Reset Screen

      SETCOLOR(MAIN_COLOR)
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 68 .or. nKEY == K_DEL) .AND. lGOD
      SAVE SCREEN TO cSCREEN
      RESTSCREEN(13,0,23,79,REPLICATE(CHR(219)+CHR(9),1360))
      @ 12,4 CLEAR TO 12,74
      @ 13,4 SAY REPLICATE("Ь",73) COLOR BK1_COLOR
      nROW := oTBROWSE:ROWPOS
      oTBROWSE:NBOTTOM  := 11
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:STABILIZE()
      oTBROWSE:FORCESTABLE()
      ZBOX(16,7,18,70,BK1_COLOR)
      @ 17,9 SAY "Shall I Delete this Order and all Related Records? [Y] / [N]"
      SET CURSOR ON
      nKEY := INKEY(0)
      SET CURSOR OFF
      RESTORE SCREEN FROM cSCREEN
      IF nKEY == 89 .or. nKEY == 121
         SELECT INVLINES
         SET INDEX TO ("INVLINES")
         SEEK STR(CUSTOMER->NUMBER,5) + DTOS(INVOICES->ORDERED)
         IF FOUND()
            DO WHILE (INVLINES->CUSTOMER = CUSTOMER->NUMBER .AND. INVLINES->ORDERED = INVOICES->ORDERED .AND. ! EOF())
               DELETE
               SKIP
            ENDDO
         ENDIF
         SET EXACT ON
         SELECT INVOICES
         DELETE
         IF oTBROWSE:ROWPOS = 1
            SKIP 1
            IF EOF()
               SKIP -1
            ENDIF
         ENDIF
         TONE(900,2)
         lNEWSUB := .T.
      ENDIF
      oTBROWSE:NBOTTOM := 21
      oTBROWSE:ROWPOS  := nROW
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:CONFIGURE()
      oTBROWSE:REFRESHALL()
      oTBROWSE:REFRESHCURRENT()
      RESTORE SCREEN FROM cSCREEN
   CASE nKEY == K_ESC
      CLOSE INVOICES
      CLOSE INVLINES
      CLOSE PRODUCTS
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

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Main Customer Screen                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function OLD
Local nKEY, oTBROWSE, cSCREEN, nHIGHCODE, nORDER := 1, nOPTION := 2, dLASTSHIP
Local cFILL, nVISA, nCHECK, nGRAND, nLASTNUM, nCOUNT, nTOTAL, cLASTDLR
Local nLINES, dDATE, nFILTER := 9, aDETAIL := {}, nADDTYPE

USE ("CUSTOMER") NEW EXCLUSIVE
SET INDEX TO ("CUSTNAME"), ("CUSTSERN"), ("CUSTCODE")
SETCOLOR(MAIN_COLOR)
@ 0,34 SAY "Items                  Misc" COLOR "W/W*"
IF lGOD
   @ 0,2  SAY "Add  Edit  Copy  Delete  Order"
ELSE
   @ 0,2  SAY "Add  View  Copy  Delete  Order"
ENDIF
@ 0,41 SAY "Filters  Print"
@ 0,63 SAY "Quit"
ZBOX(2,3,22,75,BK1_COLOR)
@ 2,3  SAY "                          Bard's Quest Software                          " COLOR ALT_COLOR
@ 4,5  SAY "        Customer Name            Date    Ver  Serial#  Units   Price "
@ 4,13 SAY "Customer Name" COLOR "R+/W*"
@ 5,5  SAY "ДДДДДДДДДДДДДДДДДДДДДДДДДДДДД  ДДДДДДДД  ДДД  ДДДДДДД  ДДДДД  ДДДДДДД"
oTBROWSE := TBROWSEDB(6,4,21,74)
oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" " + TB_COL1 + TB_COL2 + TB_COL3 + "  "}))
DO WHILE .T.
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE (nKEY == 65 .or. nKEY == K_INS) .AND. lGOD
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:FORCESTABLE()
      @ 0,1 SAY " Add " COLOR "W+/N"
      nADDTYPE := 1
      SETCOLOR(ALT_COLOR)
      ZBOX(11,32,14,47,BK2_COLOR)
      @ 12,33 PROMPT " Mail Order   "
      @ 13,33 PROMPT " Registration "
      MENU TO nADDTYPE
      SETCOLOR(MAIN_COLOR)
      IF nADDTYPE <> 0 .AND. LASTKEY() <> 27
         RESTSCREEN(1,0,23,79,cINITSCRN)
         ZBOX(2,10,22,69,BK1_COLOR)

      * Find next customer number

         SET INDEX TO ("CUSTCODE"), ("CUSTNAME"), ("CUSTDATE"), ("CUSTVERS"), ("CUSTSERN"), ("CUSTCODE")
         GO BOTTOM
         nHIGHCODE := IF(EOF(),0,CUSTOMER->NUMBER)
         SET INDEX TO ("CUSTNAME"), ("CUSTDATE"), ("CUSTVERS"), ("CUSTSERN"), ("CUSTCODE"), ("CUSTCODE")
         APPEND BLANK
         CUSTOMER->NUMBER       := (nHIGHCODE + 1)
         CUSTOMER->DATE         := DATE()
         CUSTOMER->PROGRAM      := "Deck Daemon"
         CUSTOMER->VERSION      := 1.2
         CUSTOMER->LAST_SET     := "Fallen Emp"
         CUSTOMER->UNITS        := 1
         IF nADDTYPE = 1
            CUSTOMER->SHIPPING  := "US Postal"
            CUSTOMER->AMT_EACH  := 29.95
            CUSTOMER->AMT_SHIP  := 5.00
            CUSTOMER->AMT_FINAL := 34.95
            CUSTOMER->SENT      := "1.2 Manual, Reg. Card"
         ELSE
            CUSTOMER->TYPE      := "R"
            CUSTOMER->SHIPPING  := "Off Shelf"
            CUSTOMER->SENT      := "Boxed Deck Daemon Package"
            CUSTOMER->NOTE1     := "Registration Card Received"
            CUSTOMER->NOTE2     := "Purchased From"
            KEYBOARD CHR(K_ENTER)
         ENDIF
         @ 3,12 SAY "Adding Customer Number " + LTRIM(STR(CUSTOMER->NUMBER,5))
         SOFTFORM(1,nADDTYPE = 2)
         SET CURSOR ON
         READ
         SET CURSOR OFF
         IF LASTKEY() == K_ESC .or. EMPTY(CUSTOMER->NAME)
            DELETE
            oTBROWSE:GOTOP()
         ELSE
            SOFTFORM(2,.F.)
            KEYBOARD IF(nADDTYPE = 2,CHR(K_ENTER) + CHR(K_END) + CHR(K_SPACE),"")
            SET CURSOR ON
            READ
            SET CURSOR OFF
         ENDIF
      ENDIF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 69 .AND. lGOD) .or. (nKEY == 86 .AND. ! lGOD) .or. nKEY = K_ENTER
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:FORCESTABLE()
      RESTSCREEN(1,0,23,79,cINITSCRN)
      IF lGOD
         @ 0,6 SAY " Edit " COLOR "W+/N"
      ELSE
         @ 0,6 SAY " View " COLOR "W+/N"
      ENDIF
      ZBOX(2,10,22,69,BK1_COLOR)
      @  3,12 SAY "Editing Customer Number " + LTRIM(STR(CUSTOMER->NUMBER,5))
      SOFTFORM(1,.F.)
      IF lGOD
         SET CURSOR ON
         READ
         SET CURSOR OFF
      ELSE
         PAUSE(22)
      ENDIF
      IF LASTKEY() <> K_ESC
         SOFTFORM(2,.F.)
         IF lGOD
            SET CURSOR ON
            READ
            SET CURSOR OFF
         ELSE
            PAUSE(19)
         ENDIF
      ENDIF
      SETCOLOR(MAIN_COLOR)
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN

   CASE (nKEY == 67) .AND. lGOD
      SAVE SCREEN TO cSCREEN
      @ 0,12 SAY " Copy " COLOR "W+/N"
      COPY NEXT 1 TO ("COPYTEMP")
      SET INDEX TO ("CUSTCODE"), ("CUSTNAME"), ("CUSTDATE"), ("CUSTVERS"), ("CUSTSERN"), ("CUSTCODE")
      GO BOTTOM
      nHIGHCODE := IF(EOF(),0,CUSTOMER->NUMBER)
      SET INDEX TO ("CUSTNAME"), ("CUSTDATE"), ("CUSTVERS"), ("CUSTSERN"), ("CUSTCODE"), ("CUSTCODE")
      APPEND FROM ("COPYTEMP")
      CUSTOMER->DATE   := DATE()
      CUSTOMER->NUMBER := (nHIGHCODE + 1)
      COMMIT
      ERASE ("COPYTEMP.DBF")
      TONE(900,2)
      oTBROWSE:REFRESHALL()
      RESTORE SCREEN FROM cSCREEN

   CASE (nKEY == 68 .or. nKEY == K_DEL) .AND. lGOD
      SAVE SCREEN TO cSCREEN
      @ 0,18 SAY " Delete " COLOR "W+/N"
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:FORCESTABLE()
      SETCOLOR(ALT_COLOR)
      ZBOX(11,19,13,59,BK2_COLOR)
      @ 12,21 SAY "Shall I Delete this Record? [Y] / [N]"
      nKEY := INKEY(0)
      RESTORE SCREEN FROM cSCREEN
      IF nKEY == 89 .or. nKEY == 121
         DELETE
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
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHCURRENT()
   CASE (nKEY == 79 .OR. nKEY == K_TAB)
      SAVE SCREEN TO cSCREEN
      @ 0,26 SAY " Order " COLOR "W+/N"
      nORDER := IF(nORDER = 4,1,nORDER + 1)
      INKEY(.15)
      RESTORE SCREEN FROM cSCREEN
      DO CASE
      CASE nORDER = 1
         @ 4,5  SAY "        Customer Name            Date    Ver  Serial#  Units   Price "
         @ 4,13 SAY "Customer Name" COLOR "R+/W*"
      CASE nORDER = 2
         @ 4,5  SAY "        Customer Name            Date    Ver  Serial#  Units   Price "
         @ 4,38 SAY "Date" COLOR "R+/W*"
      CASE nORDER = 3
         @ 4,5  SAY "        Customer Name            Date    Ver  Serial#  Units   Price "
         @ 4,46 SAY "Ver" COLOR "R+/W*"
      CASE nORDER = 4
         @ 4,5  SAY "        Customer Name            Date    Ver  Serial#  Units   Price "
         @ 4,51 SAY "Serial#" COLOR "R+/W*"
      ENDCASE
      SET ORDER TO nORDER
      oTBROWSE:GOTOP()
   CASE (nKEY == 70)
      SAVE SCREEN TO cSCREEN
      @ 0,40 SAY " Filters " COLOR "W+/N"
      SETCOLOR(ALT_COLOR)
      ZBOX(2,31,13,57,BK2_COLOR)
      @  3,32 PROMPT " A. Mail Order Customers "
      @  4,32 PROMPT " B. Dealers/Resellers    "
      @  5,32 PROMPT " C. Distributors/Chains  "
      @  6,32 PROMPT " D. Mailed Registrations "
      @  7,32 PROMPT " E. Magazines/Books/Etc. "
      @  8,32 PROMPT " F. Bard's Quest Sales   "
      @  9,32 PROMPT " G. Outstanding Products "
      @ 10,32 PROMPT " H. Other                "
      @ 11,32 SAY    "ДДДДДДДДДДДДДДДДДДДДДДДДД"
      @ 12,32 PROMPT " I. All (No Filtering)   "
      MENU TO nFILTER
      RESTORE SCREEN FROM cSCREEN
      DO CASE
      CASE nFILTER == 1
         @ 2,3  SAY "                           Mail Order Customers                          " COLOR ALT_COLOR
         SET FILTER TO TYPE = "C"
         oTBROWSE:GOTOP()
      CASE nFILTER == 2
         @ 2,3  SAY "                  Software Dealers / Game & Hobby Stores                 " COLOR ALT_COLOR
         SET FILTER TO TYPE = "D"
         oTBROWSE:GOTOP()
      CASE nFILTER == 3
         @ 2,3  SAY "                      Distributors / National Chains                     " COLOR ALT_COLOR
         SET FILTER TO TYPE = "I"
         oTBROWSE:GOTOP()
      CASE nFILTER == 4
         @ 2,3  SAY "                    Registrations Received in the Mail                   " COLOR ALT_COLOR
         SET FILTER TO TYPE = "R"
         oTBROWSE:GOTOP()
      CASE nFILTER == 5
         @ 2,3  SAY "                   Magazines / Publishers / Competition                  " COLOR ALT_COLOR
         SET FILTER TO TYPE = "M"
         oTBROWSE:GOTOP()
      CASE nFILTER == 6
         @ 2,3  SAY "                       Sales at Bard's Quest, Inc.                       " COLOR ALT_COLOR
         SET FILTER TO TYPE = "B"
         oTBROWSE:GOTOP()
      CASE nFILTER == 7
         @ 2,3  SAY "               Outstanding Products (Awaiting Registrations)             " COLOR ALT_COLOR
         SET FILTER TO TYPE = "S"
         oTBROWSE:GOTOP()
      CASE nFILTER == 8
         @ 2,3  SAY "                       Sales at Bard's Quest, Inc.                       " COLOR ALT_COLOR
         SET FILTER TO TYPE = "O"
         oTBROWSE:GOTOP()
      CASE nFILTER == 9
         @ 2,3  SAY "                          Bard's Quest Software                          " COLOR ALT_COLOR
         SET FILTER TO
         oTBROWSE:GOTOP()
      ENDCASE
      SETCOLOR(MAIN_COLOR)
   CASE (nKEY == 80)
      SAVE SCREEN TO cSCREEN
      @ 0,49 SAY " Print " COLOR "W+/N"
      SETCOLOR(ALT_COLOR)
      ZBOX(2,39,13,64,BK2_COLOR)
      @  3,40 PROMPT " A. User Name Listing   "
      @  4,40 PROMPT " B. Registration Report "
      @  5,40 PROMPT " C. Comprehensive List  "
      @  6,40 SAY    "ДДДДДДДДДДДДДДДДДДДДДДДД"
      @  7,40 PROMPT " D. Daily Transmittal   "
      @  8,40 PROMPT " E. Daily Mail Labels   "
      @  9,40 PROMPT " F. Monthly Transmittal "
      @ 10,40 PROMPT " G. Activity Report     "
      @ 11,40 SAY    "ДДДДДДДДДДДДДДДДДДДДДДДД"
      @ 12,40 PROMPT " H. Distributors & Dlrs "
      MENU TO nOPTION
      DO CASE
      CASE nOPTION = 2
         SET PRINTER TO OUTPUT.TXT
         SET PRINT ON
         SET CONSOLE OFF
         SET ORDER TO 4
         GO TOP
         nLASTNUM := 0
         nLINES   := 0
         nCOUNT   := 0
         nTOTAL   := 0
         DO WHILE ! EOF()
            IF ! EMPTY(SERIAL) .AND. SERIAL <> 999999
               IF nLINES = 0
                  ?
                  ? cLP_B10 + "    SERIAL NUMBER LISTING" + SPACE(46) + DTOC(DATE())
                  ?
                  ?
                  ? cLP_N10 + "    " + cLP_B16 + "Serial #   Customer                   City/State              Telephone       Total Amt  Shipped   Last Set    What Was Sent"
                  ? cLP_N10 + "    " + cLP_B16 + "---------  -------------------------  ----------------------  --------------  ---------  --------  ----------  ----------------------------------------" + cLP_N16
               ELSE
                  IF ((SERIAL - nLASTNUM) <> 1) .AND. ((SERIAL - nLASTNUM) <> 0) .AND. nLASTNUM <> 0
                     ?
                     nLINES++
                  ENDIF
               ENDIF
               cFILL := LTRIM(RTRIM(CITY)) + ", " + LTRIM(RTRIM(STATE))
               cFILL := cFILL + SPACE(22 - LEN(cFILL))
               ? cLP_N10 + "    " + cLP_N16 + "DD-" + STR(SERIAL,6) + "  " + LEFT(NAME,25) + "  " + cFILL
               IF EMPTY(PHONE1)
                  ?? SPACE(16)
               ELSE
                  ?? "  " + TRANSFORM(PHONE1,"@R (###) ###-####")
               ENDIF
               ?? STR(AMT_FINAL,11,2) + "  " + IF(EMPTY(SHIPPED),SPACE(8),DTOC(SHIPPED))
               ?? "  " + LAST_SET + "  " + SENT
               nCOUNT++
               nLINES++
               nTOTAL := nTOTAL + AMT_FINAL
               nLASTNUM := SERIAL
               IF nLINES > 49
                  ? CHR(12)
                  nLINES := 0
               ENDIF
            ENDIF
            SKIP
         ENDDO
         ? cLP_N10 + "    " + cLP_B16 + "---------" + SPACE(69) + "---------"
         ? cLP_B16 + STR(nCOUNT,17) + STR(nTOTAL,78,2)
         ?? cLP_N10 + CHR(12)
         SET PRINT OFF
         SET CONSOLE ON
         SET PRINTER TO
         SET ORDER TO nORDER
         oTBROWSE:GOTOP()
      CASE nOPTION = 3
         SET PRINTER TO OUTPUT.TXT
         SET PRINT ON
         SET CONSOLE OFF
         ? "ALPHABETICAL ARCHIVAL REPORT"
         ? REPLICATE("-",79)
         ?
         SET ORDER TO 1
         GO TOP
         DO WHILE ! EOF()
            ? NAME + "  " + ADDRESS1 + "  " + CITY + "  " + STATE + "  " + ZIPCODE
            ? "   " + DTOC(DATE) + "  " + TRANSFORM(PHONE1,"@R (###) ###-####") + STR(VERSION,6,1) + STR(SERIAL,9) + "  " + LAST_SET
            ? "   Sold    : " + LTRIM(STR(UNITS,3)) + STR(AMT_EACH,8,2) + STR(AMT_SHIP,8,2) + STR(AMT_FINAL,8,2)
            ? "   Payment :" + CHECK + "  " + VISA + "  " + VISA_EXP + "  " + DTOC(SHIPPED) + "  "
            IF ! EMPTY(SENT);   ? "   Sent    : " + SENT; ENDIF
            IF ! EMPTY(NOTE1);  ? "   " + NOTE1;  ENDIF
            IF ! EMPTY(NOTE2);  ? "   " + NOTE2;  ENDIF
            IF ! EMPTY(NOTE3);  ? "   " + NOTE3;  ENDIF
            IF ! EMPTY(NOTE4);  ? "   " + NOTE4;  ENDIF
            IF ! EMPTY(NOTE5);  ? "   " + NOTE5;  ENDIF
            IF ! EMPTY(NOTE6);  ? "   " + NOTE6;  ENDIF
            IF ! EMPTY(NOTE7);  ? "   " + NOTE7;  ENDIF
            IF ! EMPTY(NOTE8);  ? "   " + NOTE8;  ENDIF
            IF ! EMPTY(NOTE9);  ? "   " + NOTE9;  ENDIF
            IF ! EMPTY(NOTE10); ? "   " + NOTE10; ENDIF
            ?
            SKIP
         ENDDO
         SET PRINT OFF
         SET CONSOLE ON
         SET PRINTER TO
         SET ORDER TO nORDER
         oTBROWSE:GOTOP()
      CASE nOPTION = 4
      CASE nOPTION = 5
         dDATE := DATE()
         @ 8,40 SAY " E. For Date [        ] "
         @ 8,54 GET dDATE
         SET CURSOR ON
         READ
         SET CURSOR OFF
         IF LASTKEY() <> 27 .AND. ! EMPTY(dDATE)
            SET PRINTER TO OUTPUT.TXT
            SET PRINT ON
            SET CONSOLE OFF
            SET ORDER TO 5
            GO TOP
            DO WHILE ! EOF()
               IF SHIPPED = dDATE
                  ? NAME
                  ? ADDRESS1
                  IF EMPTY(ADDRESS2)
                     ? RTRIM(CITY) + "  " + STATE + "  " + ZIPCODE
                     ?
                  ELSE
                     ? ADDRESS2
                     ? RTRIM(CITY) + "  " + STATE + "  " + ZIPCODE
                  ENDIF
                  ?
                  ?
               ENDIF
               SKIP
            ENDDO
            SET PRINT OFF
            SET CONSOLE ON
            SET PRINTER TO
            SET ORDER TO nORDER
         ENDIF
         oTBROWSE:GOTOP()
      CASE nOPTION = 6
         SET PRINTER TO OUTPUT.TXT
         SET PRINT ON
         SET CONSOLE OFF

         * Reset all Print Flags

         REPLACE ALL PRINTED WITH .F.

         * First, list the ones that HAVE shipped

         ? cLP_B10 + "     " + DTOC(DATE()) + " ... DAILY TRANSMITTAL REPORT FOR SHIPPED COPIES"
         ?
         ?
         ? cLP_N10 + "     " + cLP_B16 + "Shipped   Customer              City/State              Serial #   Total Amt  VISA Number          Expire"
         ? cLP_N10 + "     " + cLP_B16 + "--------  --------------------  ----------------------  ---------  ---------  -------------------  ------" + cLP_N16
         INDEX ON DTOS(SHIPPED) + STR(SERIAL,6) TO TEMP
         GO TOP
         dLASTSHIP := CTOD("")
         nVISA     := 0
         nCHECK    := 0
         nGRAND    := 0
         DO WHILE ! EOF()
          * IF ! EMPTY(SHIPPED) .AND. ! EMPTY(AMT_FINAL) .AND. ! EMPTY(SERIAL) .AND. SERIAL >= 120000
            IF ! EMPTY(SHIPPED) .AND. ! EMPTY(SERIAL) .AND. SERIAL >= 120000
               IF SHIPPED <> dLASTSHIP .AND. ! EMPTY(dLASTSHIP)
                  IF nVISA <> 0 .OR. nCHECK <> 0
                     ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
                  ENDIF
                  IF nVISA <> 0
                     ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "Credit Card Total $" + STR(nVISA,8,2)
                  ENDIF
                  IF nCHECK <> 0
                     ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + " Check/Cash Total $" + STR(nCHECK,8,2)
                  ENDIF
                  IF nVISA <> 0 .AND. nCHECK <> 0
                     ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
                     ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "        Sub Total $" + STR(nVISA + nCHECK,8,2)
                  ENDIF
                  ?
                  nVISA  := 0
                  nCHECK := 0
               ENDIF
               cFILL := LTRIM(RTRIM(CITY)) + ", " + LTRIM(RTRIM(STATE))
               cFILL := cFILL + SPACE(22 - LEN(cFILL))
               ? cLP_N10 + "     " + cLP_N16 + DTOC(SHIPPED) + "  " + LEFT(NAME,20) + "  " + cFILL
               IF SERIAL = 999999
                  ?? "  ShrnkWrap"
               ELSE
                  ?? "  DD-" + STR(SERIAL,6)
               ENDIF
               ?? "  $" + STR(AMT_FINAL,8,2) + IF("COD"$UPPER(CHECK),"* ","  ")
               CUSTOMER->PRINTED := .T.
               IF EMPTY(VISA) .AND. EMPTY(VISA_EXP)
                  ?? "Check # " + CHECK
                  nCHECK := nCHECK + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ELSE
                  ?? TRANSFORM(VISA,"@R ####-####-####-####") + "  " + VISA_EXP
                  nVISA  := nVISA + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ENDIF
               dLASTSHIP := SHIPPED
            ENDIF
            SKIP
         ENDDO
         IF nVISA <> 0 .OR. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
         ENDIF
         IF nVISA <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "Credit Card Total $" + STR(nVISA,8,2)
         ENDIF
         IF nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + " Check/Cash Total $" + STR(nCHECK,8,2)
         ENDIF
         IF nVISA <> 0 .AND. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "        Sub Total $" + STR(nVISA + nCHECK,8,2)
         ENDIF
         ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "========="
         ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "    SHIPPED Total $" + STR(nGRAND,8,2)

         * Next, list the Bard's Quest Counter Sales

         ?
         ?
         ? cLP_B10 + "     SALES AT BARD'S QUEST"
         ?
         ?
         ? cLP_N10 + "     " + cLP_B16 + "Shipped   Customer              City/State              Serial #   Total Amt  VISA Number          Expire"
         ? cLP_N10 + "     " + cLP_B16 + "--------  --------------------  ----------------------  ---------  ---------  -------------------  ------" + cLP_N16
         INDEX ON STR(SERIAL,6) TO TEMP
         GO TOP
         nVISA     := 0
         nCHECK    := 0
         DO WHILE ! EOF()
            IF "BQ"$CHECK
               cFILL := LTRIM(RTRIM(CITY)) + ", " + LTRIM(RTRIM(STATE))
               cFILL := cFILL + SPACE(22 - LEN(cFILL))
               ? cLP_N10 + "     " + cLP_N16 + DTOC(DATE) + "  " + LEFT(NAME,20) + "  " + cFILL + "  DD-" + STR(SERIAL,6)
               ?? "  $" + STR(AMT_FINAL,8,2) + "  "
               CUSTOMER->PRINTED := .T.
               IF EMPTY(VISA) .AND. EMPTY(VISA_EXP)
                  ?? "Check # " + CHECK
                  nCHECK := nCHECK + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ELSE
                  ?? TRANSFORM(VISA,"@R ####-####-####-####") + "  " + VISA_EXP
                  nVISA  := nVISA + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ENDIF
               dLASTSHIP := SHIPPED
            ENDIF
            SKIP
         ENDDO
         IF nVISA <> 0 .OR. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
         ENDIF
         IF nVISA <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "Credit Card Total $" + STR(nVISA,8,2)
         ENDIF
         IF nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + " Check/Cash Total $" + STR(nCHECK,8,2)
         ENDIF
         IF nVISA <> 0 .AND. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
            ? cLP_N10 + "     " + cLP_B16 + SPACE(48) + "BARD'S QUEST Total $" + STR(nVISA + nCHECK,8,2)
         ENDIF

         * Next, list the older version sales

         ?
         ?
         ? cLP_B10 + "     OLDER VERSIONS"
         ?
         ?
         ? cLP_N10 + "     " + cLP_B16 + "Shipped   Customer              City/State              Serial #   Total Amt  VISA Number          Expire"
         ? cLP_N10 + "     " + cLP_B16 + "--------  --------------------  ----------------------  ---------  ---------  -------------------  ------" + cLP_N16
         INDEX ON STR(SERIAL,6) TO TEMP
         GO TOP
         nVISA     := 0
         nCHECK    := 0
         DO WHILE ! EOF()
            IF (SERIAL < 120000 .AND. SERIAL > 0) .OR. (VERSION > 0 .AND. VERSION < 1.2)
               cFILL := LTRIM(RTRIM(CITY)) + ", " + LTRIM(RTRIM(STATE))
               cFILL := cFILL + SPACE(22 - LEN(cFILL))
               ? cLP_N10 + "     " + cLP_N16 + "  N.A.    " + LEFT(NAME,20) + "  " + cFILL + "  DD-" + STR(SERIAL,6)
               ?? "  $" + STR(AMT_FINAL,8,2) + "  "
               CUSTOMER->PRINTED := .T.
               IF EMPTY(VISA) .AND. EMPTY(VISA_EXP)
                  ?? "Check # " + CHECK
                  nCHECK := nCHECK + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ELSE
                  ?? TRANSFORM(VISA,"@R ####-####-####-####") + "  " + VISA_EXP
                  nVISA  := nVISA + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ENDIF
               dLASTSHIP := SHIPPED
            ENDIF
            SKIP
         ENDDO
         IF nVISA <> 0 .OR. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
         ENDIF
         IF nVISA <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "Credit Card Total $" + STR(nVISA,8,2)
         ENDIF
         IF nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + " Check/Cash Total $" + STR(nCHECK,8,2)
         ENDIF
         IF nVISA <> 0 .AND. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "OLD VERSION Total $" + STR(nVISA + nCHECK,8,2)
         ENDIF

         * Next, list the ones that HAVEN'T shipped yet

         ?
         ?
         ? cLP_B10 + "     NOT YET SHIPPED/OTHERS"
         ?
         ?
         ? cLP_N10 + "     " + cLP_B16 + "Shipped   Customer              City/State              Serial #   Total Amt  VISA Number          Expire"
         ? cLP_N10 + "     " + cLP_B16 + "--------  --------------------  ----------------------  ---------  ---------  -------------------  ------" + cLP_N16
         INDEX ON DTOS(SHIPPED) + STR(SERIAL,6) TO TEMP
         GO TOP
         nVISA     := 0
         nCHECK    := 0
         DO WHILE ! EOF()
            * IF (EMPTY(SHIPPED) .OR. EMPTY(AMT_FINAL) .OR. EMPTY(SERIAL)) .AND. (SERIAL = 0 .OR. SERIAL >= 120000)
            IF ! PRINTED .AND. (! DEALER .OR. AMT_FINAL > 0 .OR. UNITS > 0)
               cFILL := LTRIM(RTRIM(CITY)) + ", " + LTRIM(RTRIM(STATE))
               cFILL := cFILL + SPACE(22 - LEN(cFILL))
               ? cLP_N10 + "     " + cLP_N16 + "  N.A.    " + LEFT(NAME,20) + "  " + cFILL + "  DD-" + STR(SERIAL,6)
               ?? "  $" + STR(AMT_FINAL,8,2) + IF("COD"$UPPER(CHECK),"* ","  ")
               CUSTOMER->PRINTED := .T.
               IF EMPTY(VISA) .AND. EMPTY(VISA_EXP)
                  ?? "Check # " + CHECK
                  nCHECK := nCHECK + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ELSE
                  ?? TRANSFORM(VISA,"@R ####-####-####-####") + "  " + VISA_EXP
                  nVISA  := nVISA + AMT_FINAL
                  nGRAND := nGRAND + AMT_FINAL
               ENDIF
               dLASTSHIP := SHIPPED
            ENDIF
            SKIP
         ENDDO
         IF nVISA <> 0 .OR. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
         ENDIF
         IF nVISA <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "Credit Card Total $" + STR(nVISA,8,2)
         ENDIF
         IF nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + " Check/Cash Total $" + STR(nCHECK,8,2)
         ENDIF
         IF nVISA <> 0 .AND. nCHECK <> 0
            ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "---------"
            ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "     OTHERS Total $" + STR(nVISA + nCHECK,8,2)
         ENDIF
         ? cLP_N10 + "     " + cLP_B16 + SPACE(67) + "========="
         ? cLP_N10 + "     " + cLP_B16 + SPACE(49) + "      GRAND Total $" + STR(nGRAND,8,2)

         ?? cLP_N10 + CHR(12)
         SET PRINT OFF
         SET CONSOLE ON
         SET PRINTER TO
         SET INDEX TO ("CUSTCODE"), ("CUSTNAME"), ("CUSTDATE"), ("CUSTVERS"), ("CUSTSERN"), ("CUSTCODE")
         SET ORDER TO nORDER
         oTBROWSE:GOTOP()
      CASE nOPTION = 7
         dDATE1 := CTOD("01/01/"+RIGHT(STR(YEAR(DATE()),4),2))
         dDATE2 := CTOD("12/31/"+RIGHT(STR(YEAR(DATE()),4),2))
         @ 10,40 SAY " G. [        -        ] "
         @ 10,45 GET dDATE1
         @ 10,54 GET dDATE2
         SET CURSOR ON
         READ
         SET CURSOR OFF
         IF LASTKEY() <> 27 .AND. ! EMPTY(dDATE1) .AND. ! EMPTY(dDATE2)
            aDETAIL := {}
            AADD(aDETAIL,"Mail Order, US Postal                0        0        0.00")
            AADD(aDETAIL,"Mail Order, US Priority              0        0        0.00")
            AADD(aDETAIL,"Mail Order, US Air Mail              0        0        0.00")
            AADD(aDETAIL,"Mail Order, US Express               0        0        0.00")
            AADD(aDETAIL,"Mail Order, US World Express         0        0        0.00")
            AADD(aDETAIL,"Mail Order, UPS Ground               0        0        0.00")
            AADD(aDETAIL,"Mail Order, UPS Orange               0        0        0.00")
            AADD(aDETAIL,"Mail Order, UPS Blue                 0        0        0.00")
            AADD(aDETAIL,"Mail Order, UPS Red                  0        0        0.00")
            AADD(aDETAIL,"Mail Order, Airborne                 0        0        0.00")
            AADD(aDETAIL,"Mail Order, DHL                      0        0        0.00")
            AADD(aDETAIL,"Mail Order, Other                    0        0        0.00")
            AADD(aDETAIL,"Mail Order, Updates                  0        0        0.00")
            AADD(aDETAIL,"Dealers, Credit Card                 0        0        0.00")
            AADD(aDETAIL,"Dealers, COD                         0        0        0.00")
            AADD(aDETAIL,"Distributors                         0        0        0.00")
            AADD(aDETAIL,"Bard's Quest, Inc. Sales             0        0        0.00")
            AADD(aDETAIL,"Bard's Quest, Inc. Updates           0        0        0.00")
            AADD(aDETAIL,"Eval Copies, Magazines               0        0        0.00")
            AADD(aDETAIL,"Eval Copies, Other                   0        0        0.00")
            AADD(aDETAIL,"Registered Users by Mail             0        0        0.00")
            SET PRINTER TO OUTPUT.TXT
            SET PRINT ON
            SET CONSOLE OFF
            ?
            ?
            ? cLP_B10 + "    ACTIVITY REPORT FOR " + DTOC(dDATE1) + " THROUGH " + DTOC(dDATE2) + SPACE(23) + DTOC(DATE())
            ? cLP_N10
            ?
            ?
            ?
            ? SPACE(13) + "         Description             Number   Units    Total $ "
            ? SPACE(13) + "------------------------------   ------   -----   ---------"

            * Begin Reading Data

            SET FILTER TO
            GO TOP
            DO WHILE ! EOF()
               DO CASE
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("US POSTAL"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,1,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("USPRIORITY"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,2,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("US AIRMAIL"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,3,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("US EXPRESS"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,4,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("US WORLDEX"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,5,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("UPS GROUND"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,6,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("UPS ORANGE"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,7,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("UPS BLUE"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,8,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("UPS RED"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,9,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("AIRBORNE"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,10,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10 .AND. ("DHL"$UPPER(SHIPPING))
                  aBUMP(@aDETAIL,11,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 10
                  aBUMP(@aDETAIL,12,1,UNITS,AMT_EACH)
               CASE TYPE = "C" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 0 .AND. AMT_EACH < 10
                  aBUMP(@aDETAIL,13,1,UNITS,AMT_EACH)
               CASE TYPE = "D" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 0 .AND. (! "COD"$CHECK)
                  aBUMP(@aDETAIL,14,1,UNITS,AMT_EACH)
               CASE TYPE = "D" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 0 .AND. ("COD"$CHECK)
                  aBUMP(@aDETAIL,15,1,UNITS,AMT_EACH)
               CASE TYPE = "I" .AND. ! EMPTY(SERIAL) .AND. AMT_EACH > 0
                  aBUMP(@aDETAIL,16,1,UNITS,AMT_EACH)
               CASE TYPE = "B" .AND. AMT_EACH > 20
                  aBUMP(@aDETAIL,17,1,UNITS,AMT_EACH)
               CASE TYPE = "B" .AND. AMT_EACH < 20 .AND. AMT_EACH > 0
                  aBUMP(@aDETAIL,18,1,UNITS,AMT_EACH)
               CASE TYPE = "M" .AND. ! EMPTY(SHIPPED) .AND. ! EMPTY(SERIAL)
                  aBUMP(@aDETAIL,19,1,UNITS,AMT_EACH)
               CASE TYPE = "O" .AND. ! EMPTY(SHIPPED) .AND. ! EMPTY(SERIAL)
                  aBUMP(@aDETAIL,20,1,UNITS,AMT_EACH)
               CASE TYPE = "R" .AND. ! EMPTY(SERIAL)
                  aBUMP(@aDETAIL,21,1,UNITS,AMT_EACH)
               ENDCASE
               SKIP
            ENDDO

            * Print Results

            FOR nX := 1 TO LEN(aDETAIL)
               ? SPACE(13) + aDETAIL[nX]
               DO CASE
               CASE nX = 13
                  ? SPACE(13) + "                                 ------   -----   ---------"
                  ? SPACE(13) + ATOTAL(aDETAIL,1,13)
                  ?
               CASE nX = 15
                  ? SPACE(13) + "                                 ------   -----   ---------"
                  ? SPACE(13) + ATOTAL(aDETAIL,14,15)
                  ?
               CASE nX = 16
                  ? SPACE(13) + "                                 ------   -----   ---------"
                  ? SPACE(13) + ATOTAL(aDETAIL,16,16)
                  ?
               CASE nX = 18
                  ? SPACE(13) + "                                 ------   -----   ---------"
                  ? SPACE(13) +  ATOTAL(aDETAIL,17,18)
                  ?
               CASE nX = 20
                  ? SPACE(13) + "                                 ------   -----   ---------"
                  ? SPACE(13) + ATOTAL(aDETAIL,19,20)
                  ? SPACE(13) + "                                 ======   =====   ========="
                  ? SPACE(13) + ATOTAL(aDETAIL,1,20)
                  ?
                  ?
                  ?
                  ? SPACE(13) + "         Description             Number   Units    Total $ "
                  ? SPACE(13) + "------------------------------   ------   -----   ---------"
               ENDCASE
            NEXT nX
            ?? cLP_N10 + CHR(12)
            SET PRINT OFF
            SET CONSOLE ON
            SET PRINTER TO
            SET INDEX TO ("CUSTNAME"), ("CUSTDATE"), ("CUSTVERS"), ("CUSTSERN"), ("CUSTCODE"), ("CUSTCODE")
            SET ORDER TO nORDER
            SET FILTER TO nFILTER
         ENDIF
         oTBROWSE:GOTOP()
      CASE nOPTION = 8
         SET PRINTER TO OUTPUT.TXT
         SET PRINT ON
         SET CONSOLE OFF
         ? "DISTRIBUTOR / DEALER LISTING"
         ? REPLICATE("-",79)
         ?
         SET ORDER TO 1
         GO TOP
         cLASTDLR := ""
         DO WHILE ! EOF()
            IF TYPE$"DI" .AND. cLASTDLR <> DLRPACK()
               ? NAME
               ? ADDRESS1
               ? RTRIM(CITY) + "  " + STATE + "  " + ZIPCODE
               ? TRANSFORM(PHONE1,"@R (###) ###-####")
               IF ! EMPTY(PHONE2)
                  ? TRANSFORM(PHONE2,"@R (###) ###-####") + "   " + PHONE2DESC
               ENDIF
               ?
               ? "   " + DTOC(DATE) + " : "

               IF ! EMPTY(NOTE1);  ?? "   " + NOTE1;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE2);  ?? "   " + NOTE2;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE3);  ?? "   " + NOTE3;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE4);  ?? "   " + NOTE4;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE5);  ?? "   " + NOTE5;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE6);  ?? "   " + NOTE6;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE7);  ?? "   " + NOTE7;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE8);  ?? "   " + NOTE8;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE9);  ?? "   " + NOTE9;  ? SPACE(14); ENDIF
               IF ! EMPTY(NOTE10); ?? "   " + NOTE10; ? SPACE(14); ENDIF
               cLASTDLR := DLRPACK()
            ENDIF
            SKIP
         ENDDO
         SET PRINT OFF
         SET CONSOLE ON
         SET PRINTER TO
         SET ORDER TO nORDER
         oTBROWSE:GOTOP()
      ENDCASE
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == 81 .OR. nKEY == K_ESC)
      SAVE SCREEN TO cSCREEN
      @ 0,62 SAY " Quit " COLOR "W+/N"
      INKEY(.1)
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
      TONE(900,2)
   ENDCASE
ENDDO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                      Support Functions for Printing                      */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function DLRPACK
Return UPPER(NAME + ADDRESS1 + CITY + STATE + ZIPCODE + PHONE1)

Function aBUMP (aDETAIL,nREF,nCOUNT,nUNITS,nPRICE)
Local nNUM1 := 0, nNUM2 := 0, nNUM3 := 0, cLINE
nNUM1 := VAL(SUBSTR(aDETAIL[nREF],31,8))  + nCOUNT
nNUM2 := VAL(SUBSTR(aDETAIL[nREF],39,9))  + nUNITS
nNUM3 := VAL(SUBSTR(aDETAIL[nREF],48,12)) + (nUNITS * nPRICE)
cLINE := LEFT(aDETAIL[nREF],30) + STR(nNUM1,8) + STR(nNUM2,9) + STR(nNUM3,12,2)
aDETAIL[nREF] := cLINE
Return (Nil)

Function aTOTAL (aDETAIL,nREF1,nREF2)
Local nNUM1 := 0, nNUM2 := 0, nNUM3 := 0, nX
FOR nX := nREF1 TO nREF2
   nNUM1 := nNUM1 + VAL(SUBSTR(aDETAIL[nX],31,8))
   nNUM2 := nNUM2 + VAL(SUBSTR(aDETAIL[nX],39,9))
   nNUM3 := nNUM3 + VAL(SUBSTR(aDETAIL[nX],48,12))
NEXT nX
Return (STR(nNUM1,38) + STR(nNUM2,9) + STR(nNUM3,12,2))

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                            Data Entry Forms                              */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function SOFTFORM (nPAGE,lJUMPTYPE)
DO CASE
CASE nPAGE = 1
   @  4,11 SAY REPLICATE("Д",58)
   @  4,51 SAY " Type [ ] "
   IF lJUMPTYPE
      @  4,58                      GET CUSTOMER->TYPE       PICTURE "@!" VALID CUSTOMER->TYPE$"BCDIMORS"
   ELSE
      @  4,58                      GET CUSTOMER->TYPE       PICTURE "@!" VALID CUSTOMER->TYPE$"BCDIMORS" WHEN POP_TYPES(CUSTOMER->TYPE,2)
   ENDIF
   @  5,12 SAY "Date ............" GET CUSTOMER->DATE
   @  6,12 SAY "Customer ........" GET CUSTOMER->NAME
   @  7,12 SAY "Address 1 ......." GET CUSTOMER->ADDRESS1
   @  8,12 SAY "Address 2 ......." GET CUSTOMER->ADDRESS2
   @  9,12 SAY "City ............" GET CUSTOMER->CITY
   @  9,53 SAY "State"             GET CUSTOMER->STATE      PICTURE "@!"
   @ 10,12 SAY "Zip Code ........" GET CUSTOMER->ZIPCODE    PICTURE "@!"
   @ 11,12 SAY "Telephone 1 ....." GET CUSTOMER->PHONE1     PICTURE "@R (###) ###-####"
   @ 12,12 SAY "Telephone 2 ....." GET CUSTOMER->PHONE2     PICTURE "@R (###) ###-####"
   @ 12,54 SAY "Type"              GET CUSTOMER->PHONE2DESC
   @ 13,11 SAY REPLICATE("Д",58)
   @ 14,12 SAY "Program ........." GET CUSTOMER->PROGRAM
   @ 14,55 SAY "Ver"               GET CUSTOMER->VERSION    PICTURE "@Z"
   @ 15,12 SAY "Serial Number ..." GET CUSTOMER->SERIAL     PICTURE "@Z"
   @ 15,50 SAY "Includes"          GET CUSTOMER->LAST_SET
   @ 16,12 SAY "Number Sold ....." GET CUSTOMER->UNITS      PICTURE "@Z"
   @ 16,47 SAY "Amount Each"       GET CUSTOMER->AMT_EACH   PICTURE "@Z"
   @ 17,12 SAY "Check Number ...." GET CUSTOMER->CHECK      PICTURE "@!"
   @ 17,50 SAY "Shipping"          GET CUSTOMER->AMT_SHIP   PICTURE "@Z"
   @ 18,12 SAY "VISA/MC Number .." GET CUSTOMER->VISA       PICTURE "@R ####-####-####-####"
   @ 18,53 SAY "Total"             GET CUSTOMER->AMT_FINAL  PICTURE "@Z"
   @ 19,12 SAY "Expiration Date ." GET CUSTOMER->VISA_EXP
   @ 19,52 SAY "Method"            GET CUSTOMER->SHIPPING
   @ 20,11 SAY REPLICATE("Д",58)
   @ 21,12 SAY "Shipped"           GET CUSTOMER->SHIPPED
   @ 21,29 SAY "... Sent"          GET CUSTOMER->SENT       PICTURE "@S30"
CASE nPAGE = 2
   RESTSCREEN(1,0,23,79,cINITSCRN)
   ZBOX(5,14,19,65,BK1_COLOR)
   @  6,16 SAY "Notes for Customer Number " + LTRIM(STR(CUSTOMER->NUMBER,5))
   @  7,15 SAY REPLICATE("Д",50)
   @  9,16 GET CUSTOMER->NOTE1
   @ 10,16 GET CUSTOMER->NOTE2
   @ 11,16 GET CUSTOMER->NOTE3
   @ 12,16 GET CUSTOMER->NOTE4
   @ 13,16 GET CUSTOMER->NOTE5
   @ 14,16 GET CUSTOMER->NOTE6
   @ 15,16 GET CUSTOMER->NOTE7
   @ 16,16 GET CUSTOMER->NOTE8
   @ 17,16 GET CUSTOMER->NOTE9
   @ 18,16 GET CUSTOMER->NOTE10
ENDCASE
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                Type Help                                 */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function POP_TYPES (cTYPE,nMODE)
Local nPICK, cSCREEN
IF LASTKEY() <> K_UP
   SAVE SCREEN TO cSCREEN
   KEYBOARD REPLICATE(CHR(K_DOWN),AT(cTYPE,"CDIRMBSO")-1)
   SETCOLOR(ALT_COLOR)
   IF nMODE = 1
      ZBOX(8,25,18,51,BK2_COLOR,"Select Record Type")
      nPICK := ACHOICE(10,26,17,50,aTYPES)
   ELSE
      ZBOX(3,40,13,66,BK2_COLOR,"Select Record Type")
      nPICK := ACHOICE(5,41,19,65,aTYPES)
   ENDIF
   KEYBOARD IF(nPICK == 0,"",SUBSTR(aTYPES[nPICK],2,1))
   RESTORE SCREEN FROM cSCREEN
   SETCOLOR(MAIN_COLOR)
ENDIF
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                                Type Help                                 */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function POP_SHIP (cSHIP)
Local nPICK, cSCREEN

IF LASTKEY() <> K_UP
   cSHIP := UPPER(cSHIP)
   SAVE SCREEN TO cSCREEN
   DO CASE
   CASE (cSHIP+"|")$METHODS
      KEYBOARD REPLICATE(CHR(K_DOWN),((AT((cSHIP+"|"),METHODS)-1)/13))
   CASE EMPTY(cSHIP)
      KEYBOARD REPLICATE(CHR(K_DOWN),9)
   OTHERWISE
      KEYBOARD CHR(K_END)
   ENDCASE
   SETCOLOR(POP_COLOR)
   ZBOX(11,38,20,73,BK2_COLOR,"Select Shipping Method")
   nPICK := ACHOICE(13,39,19,72,aSHIPPING)
   KEYBOARD IF(nPICK == 0 .or. nPICK = LEN(aSHIPPING),"",SUBSTR(aSHIPPING[nPICK],2,12))
   RESTORE SCREEN FROM cSCREEN
   SETCOLOR(MAIN_COLOR)
ENDIF
Return (.T.)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                             Reports/Listings                             */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function REPORTS
Local nOPTION := 1, cSCREEN

* Prompt the User

ZBOX(15,53,21,71,BK1_COLOR)
SAVE SCREEN TO cSCREEN
USE ("SYSTEM") NEW EXCLUSIVE
DO WHILE .T.
   RESTORE SCREEN FROM cSCREEN
   SETCOLOR(MAIN_COLOR)
   @ 16,54 PROMPT " Customer List   "
   @ 17,54 PROMPT " Activity Report "
   @ 18,54 PROMPT " Product Summary "
   @ 19,54 SAY    "ДДДДДДДДДДДДДДДДД"
   @ 20,54 PROMPT " Mailing Labels  "
   MENU TO nOPTION
   DO CASE
   CASE nOPTION = 0
      Return (Nil)
   CASE nOPTION = 1
      REPORT1()
   CASE nOPTION = 2
      REPORT2()
   CASE nOPTION = 3
      SUMMARY1()
   CASE nOPTION = 4
      LABELS()
   ENDCASE
   RESTORE SCREEN FROM cSCREEN
ENDDO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Print Customer List                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function REPORT1
Local cINITIAL, nLINES := 0, nCOUNT := 0, nORDERS := 0
Local nTOTORD := 0, nGORDERS := 0, nGTOTORD := 0

ZWARN(16,"Please Wait : Printing in Progress.",2,BK2_COLOR)
SET PRINTER TO (LTRIM(RTRIM(UPPER(SYSTEM->LP_DEVICE))))
SET CONSOLE OFF
SET PRINT ON
USE ("INVOICES") NEW EXCLUSIVE
SET INDEX TO ("INVOICES")
USE ("CUSTOMER") NEW EXCLUSIVE
SET INDEX TO ("CUSTNAME")
GO TOP
nGORDERS := 0
nGTOTORD := 0
DO WHILE ! EOF()
   IF nLINES = 0
      ? IF(SYSTEM->LP_TYPE = "HP",CHR(27) + "&l1O" + CHR(27) + "(s0p16.67h6v0s0b6T","")
      ? "   Bard's Quest Software                                                                                                              Customer Listing, Printed On "+DTOC(DATE())
      ?
      ?
      ? "           Customer Name                    City/State             Serial No    Telephone     Orders  Total Spent       Last Order    "
      ? "   ------------------------------  ------------------------------  ---------  --------------  ------  -----------  -------------------"
   ENDIF
   cFILL := LTRIM(RTRIM(CITY)) + ", " + LTRIM(RTRIM(STATE))
   cFILL := IF(LEN(cFILL) > 28,LEFT(cFILL,28),cFILL)
   cFILL := cFILL + SPACE(30 - LEN(cFILL))
   ? "   " + NAME + "  " + cFILL
   ?? IF(SERIAL < 120000,"             ","  DD-" + STR(SERIAL,6) + "  ")
   ?? IF(EMPTY(PHONE1),SPACE(14),TRANSFORM(PHONE1,"@R (###) ###-####"))

   * Lookup Invoices

   nORDERS := 0
   nTOTORD := 0
   SELECT INVOICES
   SET INDEX TO ("INVOICES")
   SET EXACT OFF
   SEEK STR(CUSTOMER->NUMBER,5)
   IF FOUND()
      DO WHILE (INVOICES->CUSTOMER = CUSTOMER->NUMBER .AND. ! EOF())
         nORDERS++
         nTOTORD := nTOTORD + AMT_ORDER
         SKIP
      ENDDO
   ENDIF
   SELECT CUSTOMER

   ?? STR(nORDERS,7) + "   " + TRANSFORM(nTOTORD,"@R $ ##,###.##")

   nGORDERS := nGORDERS + nORDERS
   nGTOTORD := nGTOTORD + nTOTORD
   nCOUNT++
   nLINES++
   IF nLINES > 49
      ? CHR(12)
      nLINES := 0
   ENDIF
   SKIP
ENDDO

? SPACE(94) + "======  ==========="
? STR(nGORDERS,99) + "   " + TRANSFORM(nGTOTORD,"@R $ ##,###.##")

IF SYSTEM->LP_TYPE = "HP"
   ?? CHR(27) + "&l0O" + CHR(27) + "(s0p10h12v0s0b3T"
ELSE
   ?? CHR(12)
ENDIF
SET PRINT OFF
SET CONSOLE ON
SET PRINTER TO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Print Activity List                            */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function REPORT2
ZWARN(16,"Please Wait : Printing in Progress.",2,BK2_COLOR)
SET PRINTER TO (LTRIM(RTRIM(UPPER(SYSTEM->LP_DEVICE))))
SET CONSOLE OFF
SET PRINT ON

USE ("PRODUCTS") NEW EXCLUSIVE
REPLACE ALL PRODUCTS->COUNT WITH 0, PRODUCTS->TOTAL WITH 0
USE ("INVLINES") NEW EXCLUSIVE

SELECT PRODUCTS
GO TOP
DO WHILE ! EOF()

   nORDERS := 0
   nTOTORD := 0
   SELECT INVLINES
   GO TOP
   DO WHILE ! EOF()
      IF UPPER(INVLINES->PRODUCT) = UPPER(PRODUCTS->PRODUCT)
         nORDERS := nORDERS + UNITS
         nTOTORD := nTOTORD + (UNITS * AMT_EACH)
      ENDIF
      SKIP
   ENDDO

   SELECT PRODUCTS
   REPLACE COUNT WITH nORDERS
   REPLACE TOTAL WITH nTOTORD
   SKIP
ENDDO

* Display Findings

IF SYSTEM->LP_TYPE = "HP"
   ?? CHR(27) + "&l0O" + CHR(27) + "(s0p10h12v0s0b3T"
ELSE
   ?? CHR(12)
ENDIF
SET PRINT OFF
SET CONSOLE ON
SET PRINTER TO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                          Print Product Summary                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function SUMMARY1
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Print Mailing Labels                           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function LABELS
Local nTYPE := 1, lOK := .F., cNAME, nCOL := 0, nLINES := 0
Local cLINE1, cLINE2, cLINE3, cLINE4, cLINE5, cLINE6

ZBOX(12,53,21,76,BK1_COLOR)
@ 13,54 PROMPT " Customers (Mail+Reg) "
@ 14,54 PROMPT " Distributors + Dlrs  "
@ 15,54 PROMPT " Bard's Quest Counter "
@ 16,54 PROMPT " Others               "
@ 17,54 SAY    "ДДДДДДДДДДДДДДДДДДДДДД"
@ 18,54 PROMPT " All of the Above     "
@ 19,54 SAY    "ДДДДДДДДДДДДДДДДДДДДДД"
@ 20,54 PROMPT " Foreign Countries    "
MENU TO nTYPE
IF nTYPE = 0
   Return (Nil)
ENDIF
ZWARN(16,"Please Wait : Printing in Progress.",2,BK2_COLOR)

* If foreign, 1st print report

IF nTYPE = 6
   SET PRINTER TO ("FOREIGN.REP")
   SET CONSOLE OFF
   SET PRINT ON
   USE ("CUSTOMER") NEW EXCLUSIVE
   INDEX ON UPPER(COUNTRY) TO ("CUSTTEMP")
   GO TOP
   DO WHILE ! EOF()
      IF COUNTRY <> "US" .OR. ! EMPTY(ZIPCODE)
         IF ! (STATE+"|")$STATES1+STATES2
            ? STR(RECNO(),6) + " " + NAME + " " + ADDRESS1 + " " + CITY + " " + STATE + " " + ZIPCODE + " " + COUNTRY
         ENDIF
      ENDIF
      SKIP
   ENDDO
   CLOSE CUSTOMER
   SET PRINT OFF
   SET CONSOLE ON
   SET PRINTER TO
   ERASE ("CUSTTEMP.NTX")
ENDIF

* Print Labels

SET PRINTER TO ("LABELS.REP")
SET CONSOLE OFF
SET PRINT ON
USE ("CUSTOMER") NEW EXCLUSIVE
IF nTYPE = 6
   INDEX ON UPPER(COUNTRY) TO ("CUSTTEMP")
ELSE
   SET INDEX TO ("CUSTNAME")
ENDIF
GO TOP
DO WHILE ! EOF()
   IF ! EMPTY(ZIPCODE) .OR. COUNTRY <> "US"
      lOK := .F.
      DO CASE
      CASE nTYPE = 1 .AND. TYPE$"CR"; lOK := .T.
      CASE nTYPE = 2 .AND. TYPE$"DI"; lOK := .T.
      CASE nTYPE = 3 .AND. TYPE$"B" ; lOK := .T.
      CASE nTYPE = 4 .AND. TYPE$"MO"; lOK := .T.
      CASE nTYPE = 5; lOK := .T.
      CASE nTYPE = 6 .AND. UPPER(COUNTRY) <> "US"; lOK := .T.
      ENDCASE

      cLINE1 := IF(EMPTY(ADDRESS1),ADDRESS2,ADDRESS1)
      cLINE2 := CITY + STATE + ZIPCODE

      IF lOK .AND. ! EMPTY(NAME) .AND. ! EMPTY(cLINE1) .AND. ! EMPTY(cLINE2)
         cNAME := LTRIM(RTRIM(NAME))

         IF ","$cNAME
            ? LTRIM(SUBSTR(cNAME,AT(",",cNAME)+1,LEN(cNAME)-AT(",",cNAME))) + " " + LEFT(cNAME,AT(",",cNAME)-1)
         ELSE
            ? RTRIM(NAME)
         ENDIF

         /*
         IF SERIAL <> 0
            ?? " (DD-" + LTRIM(STR(SERIAL,6)) + ")"
         ENDIF
         */

         DO CASE
         CASE nTYPE = 6 .AND. EMPTY(ADDRESS2)
            ? ADDRESS1
            ? RTRIM(CITY) + ", " + LTRIM(STATE + "  ") + RTRIM(ZIPCODE)
            IF COUNTRY <> "APO" .AND. COUNTRY <> "FPO"
               ? COUNTRY
            ELSE
               ?
            ENDIF
            ?
            ?
         CASE nTYPE = 6
            ? ADDRESS1
            ? ADDRESS2
            ? RTRIM(CITY) + ", " + LTRIM(STATE + "  ") + RTRIM(ZIPCODE)
            IF COUNTRY <> "APO" .AND. COUNTRY <> "FPO"
               ? COUNTRY
            ELSE
               ?
            ENDIF
            ?
         CASE EMPTY(ADDRESS1)
            ? ADDRESS2
            ? RTRIM(CITY) + ", " + LTRIM(STATE + "  ") + ZIPCODE
            ?
            ?
            ?
         CASE EMPTY(ADDRESS2)
            ? ADDRESS1
            ? RTRIM(CITY) + ", " + LTRIM(STATE + "  ") + ZIPCODE
            ?
            ?
            ?
         OTHERWISE
            ? ADDRESS1
            ? ADDRESS2
            ? RTRIM(CITY) + ", " + LTRIM(STATE + "  ") + ZIPCODE
            ?
            ?
         ENDCASE
      ENDIF
   ENDIF
   SKIP
ENDDO
CLOSE CUSTOMER
IF nTYPE = 6
   ERASE ("CUSTTEMP.NTX")
ENDIF
SET PRINT OFF
SET CONSOLE ON
SET PRINTER TO

* Ready to Re-Read and Create Form

SET PRINTER TO (LTRIM(RTRIM(UPPER(SYSTEM->LP_DEVICE))))
SET CONSOLE OFF
SET PRINT ON
?
CREATEDBF("LABELS.DBF","LINE,C 55 0")
USE LABELS NEW EXCLUSIVE
APPEND FROM ("LABELS.REP") SDF
APPEND BLANK
GO TOP
DELETE
PACK
GO TOP
nCOL   := 1
nLINES := 0
cLINE1 := ""
cLINE2 := ""
cLINE3 := ""
cLINE4 := ""
cLINE5 := ""
cLINE6 := ""
DO WHILE ! EOF()
   DO CASE
   CASE nCOL = 1
      cLINE1 := LINE; SKIP
      cLINE2 := LINE; SKIP
      cLINE3 := LINE; SKIP
      cLINE4 := LINE; SKIP
      cLINE5 := LINE; SKIP
      cLINE6 := LINE; SKIP
      nCOL++
   CASE nCOL = 2
      cLINE1 := cLINE1 + LINE; SKIP
      cLINE2 := cLINE2 + LINE; SKIP
      cLINE3 := cLINE3 + LINE; SKIP
      cLINE4 := cLINE4 + LINE; SKIP
      cLINE5 := cLINE5 + LINE; SKIP
      cLINE6 := cLINE6 + LINE; SKIP
      nCOL++
   CASE nCOL = 3
      ? "     " + cLINE1 + RTRIM(LINE); SKIP
      ? "     " + cLINE2 + RTRIM(LINE); SKIP
      ? "     " + cLINE3 + RTRIM(LINE); SKIP
      ? "     " + cLINE4 + RTRIM(LINE); SKIP
      ? "     " + cLINE5 + RTRIM(LINE); SKIP
      ? "     " + cLINE6 + RTRIM(LINE); SKIP
      nLINES := nLINES + 1
      IF nLINES > 9
         ?? CHR(12)
         ?
         nLINES := 0
      ENDIF
      nCOL   := 1
   ENDCASE
ENDDO
IF nCOL <> 1
   ? "     " + RTRIM(cLINE1)
   ? "     " + RTRIM(cLINE2)
   ? "     " + RTRIM(cLINE3)
   ? "     " + RTRIM(cLINE4)
   ? "     " + RTRIM(cLINE5)
   ? "     " + RTRIM(cLINE6)
ENDIF
?? CHR(12)
CLOSE
SET PRINT OFF
SET CONSOLE ON
SET PRINTER TO
ERASE ("LABELS.DBF")
ERASE ("LABELS.REP")
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                           Maintenance Functions                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function UTILITY
Local nOPTION, cSCREEN

SETCOLOR(MAIN_COLOR)
ZBOX(15,53,21,71,BK1_COLOR)
DO WHILE .T.
   SETCOLOR(MAIN_COLOR)
   @ 16,54 PROMPT " Product Codes   "
   @ 17,54 SAY    "ДДДДДДДДДДДДДДДДД"
   @ 18,54 PROMPT " Backup Database "
   @ 19,54 PROMPT " Defaults Screen "
   @ 20,54 PROMPT " Rebuild Indexes "
   MENU TO nOPTION
   SAVE SCREEN TO cSCREEN
   DO CASE
   CASE nOPTION = 0
      Return (Nil)
   CASE nOPTION = 1
      PRODUCTS(0)
   CASE nOPTION = 2
      BACKUPS()
   CASE nOPTION = 3
      DEFAULTS()
   CASE nOPTION = 4
      RE_INDEX()
   OTHERWISE
      TONE(900,2)
   ENDCASE
   RESTORE SCREEN FROM cSCREEN
ENDDO
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                       Table : Product Maintenance                        */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function PRODUCTS (nMODE)
Local nKEY, oTBROWSE, cSCREEN, cINITSCRN

DO CASE
CASE nMODE = 0
   USE ("PRODUCTS") NEW EXCLUSIVE
   SET INDEX TO ("PRODUCTS")
   GO TOP
   RESTSCREEN(1,0,23,79,cMAINSCRN)
   SETCOLOR(MAIN_COLOR)
   ZBOX(10,2,22,75,BK1_COLOR,"Maintain SofTrack Products")
   IF lGOD
      HELPIT("Commands : [A] Add, [E] Edit, [D] Delete")
   ELSE
      HELPIT("Commands : Press [Esc] when you are finished")
   ENDIF
   @ 12,3 SAY "  Code   System                Product               Retail  S/H  Active"
   @ 13,3 SAY "ДДДДДДДД ДДДДДДД ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД ДДДДДД ДДДДД ДДДДДД"
   oTBROWSE := TBROWSEDB(14,2,21,75)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+CODE+" "+PLATFORM+" "+NAME+STR(PRICE,7,2)+STR(SHIPPING,6,2)+"  "+IF(ACTIVE,"Yes","No ")+"   "}))
CASE nMODE = 1
   SAVE SCREEN TO cINITSCRN
   SELECT PRODUCTS
   SET FILTER TO ACTIVE .AND. SERIAL
   GO TOP
   SETCOLOR(ALT_COLOR)
   ZBOX(8,12,17,67,BK2_COLOR,"Please Select the Product")
   @ 10,14 SAY "  Code   System                Product              "
   @ 11,14 SAY "ДДДДДДДД ДДДДДДД ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД"
   oTBROWSE := TBROWSEDB(12,13,16,66)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+CODE+" "+PLATFORM+" "+NAME+STR(PRICE,7,2)+STR(SHIPPING,6,2)+"  "+IF(ACTIVE,"Yes","No ")+"   "}))
CASE nMODE = 2
   SAVE SCREEN TO cINITSCRN
   SELECT PRODUCTS
   SET FILTER TO ACTIVE
   GO TOP
   LOCATE FOR UPPER(PRODUCTS->CODE) = UPPER(INVLINES->PRODUCT)
   IF ! FOUND()
      GO TOP
   ENDIF
   ZBOX(8,12,22,67,BK1_COLOR,"Please Select the Product")
   @ 10,14 SAY "  Code   System                Product              "
   @ 11,14 SAY "ДДДДДДДД ДДДДДДД ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД"
   oTBROWSE := TBROWSEDB(12,13,21,66)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+CODE+" "+PLATFORM+" "+NAME+STR(PRICE,7,2)+STR(SHIPPING,6,2)+"  "+IF(ACTIVE,"Yes","No ")+"   "}))
ENDCASE
DO WHILE .T.
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE (nKEY == 69 .or. nKEY == K_ENTER) .AND. lGOD .AND. nMODE = 0
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:FORCESTABLE()
      @ oTBROWSE:ROWPOS+13,3  GET PRODUCTS->CODE      PICTURE "@!"
      @ oTBROWSE:ROWPOS+13,12 GET PRODUCTS->PLATFORM  PICTURE "@!"
      @ oTBROWSE:ROWPOS+13,20 GET PRODUCTS->NAME
      @ oTBROWSE:ROWPOS+13,56 GET PRODUCTS->PRICE
      @ oTBROWSE:ROWPOS+13,63 GET PRODUCTS->SHIPPING
      @ oTBROWSE:ROWPOS+13,70 GET PRODUCTS->ACTIVE    PICTURE "Y"
      SET CURSOR ON
      READ
      SET CURSOR OFF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()
   CASE (nKEY == 65 .or. nKEY == K_INS) .AND. lGOD .AND. nMODE = 0
      oTBROWSE:NBOTTOM := 20
      oTBROWSE:GOBOTTOM()
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHCURRENT()
      oTBROWSE:FORCESTABLE()
      APPEND BLANK
      PRODUCTS->ACTIVE := .T.
      @ oTBROWSE:ROWPOS+14,2 CLEAR TO oTBROWSE:ROWPOS+14,75
      @ oTBROWSE:ROWPOS+14,3  GET PRODUCTS->CODE      PICTURE "@!"
      @ oTBROWSE:ROWPOS+14,12 GET PRODUCTS->PLATFORM  PICTURE "@!"
      @ oTBROWSE:ROWPOS+14,20 GET PRODUCTS->NAME
      @ oTBROWSE:ROWPOS+14,56 GET PRODUCTS->PRICE
      @ oTBROWSE:ROWPOS+14,63 GET PRODUCTS->SHIPPING
      @ oTBROWSE:ROWPOS+14,70 GET PRODUCTS->ACTIVE    PICTURE "Y"
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF LASTKEY() == K_ESC .or. EMPTY(PRODUCTS->CODE) .or. EMPTY(PRODUCTS->NAME)
         DELETE
         oTBROWSE:GOTOP()
      ENDIF
      oTBROWSE:NBOTTOM  := 21
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:GOTOP()
   CASE (nKEY == 68 .or. nKEY == K_DEL) .AND. lGOD .AND. nMODE = 0
      SAVE SCREEN TO cSCREEN
      ZWARN(0,"Shall I Delete this PRODUCT? [Y/N]",2)
      INKEY(0)
      RESTORE SCREEN FROM cSCREEN
      IF LASTKEY() == 89 .OR. LASTKEY() == 121
         DELETE
         IF oTBROWSE:ROWPOS = 1
            SKIP 1
            IF EOF()
               SKIP -1
            ENDIF
         ENDIF
         lNEWSUB := .T.
      ENDIF
      oTBROWSE:REFRESHALL()
   CASE nKEY == K_ESC .AND. nMODE = 0
      CLOSE ALL
      Return (Nil)
   CASE nKEY == K_ENTER .AND. nMODE = 1
      RESTORE SCREEN FROM cINITSCRN
      KEYBOARD PRODUCTS->CODE
      SET FILTER TO
      SELECT REGISTER
      Return (.T.)
   CASE nKEY == K_ESC .AND. nMODE = 1
      RESTORE SCREEN FROM cINITSCRN
      SET FILTER TO
      SELECT REGISTER
      Return (.T.)
   CASE nKEY == K_ENTER .AND. nMODE = 2
      RESTORE SCREEN FROM cINITSCRN
      KEYBOARD PRODUCTS->CODE
      SET FILTER TO
      SELECT INVLINES
      Return (.T.)
   CASE nKEY == K_ESC .AND. nMODE = 2
      RESTORE SCREEN FROM cINITSCRN
      SET FILTER TO
      SELECT INVLINES
      Return (.T.)
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

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                          Lookup Product Code                             */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function OK_PROD (cPARM,nMODE)
Local lFOUND := .F., nAREA := SELECT()

IF nMODE = 0
   @ 16,40 SAY SPACE(30)
   @ 17,30 SAY SPACE(40)
ELSE
   @ 5,45 SAY SPACE(25)
   @ 6,35 SAY SPACE(35)
ENDIF
SELECT PRODUCTS
SEEK cPARM
lFOUND := (FOUND() .AND. ACTIVE .AND. (SERIAL .OR. nMODE = 0))
IF lFOUND
   IF nMODE = 0
      @ 16,40 SAY "(" + RTRIM(PRODUCTS->PLATFORM) + ")" COLOR SHOW_COLOR
      @ 17,30 SAY RTRIM(PRODUCTS->NAME)                 COLOR SHOW_COLOR
   ELSE
      @  5,45 SAY "(" + RTRIM(PRODUCTS->PLATFORM) + ")"
      @  6,35 SAY RTRIM(PRODUCTS->NAME)
   ENDIF
ELSE
   TONE(900,2)
ENDIF
SELECT (nAREA)
RETURN (lFOUND)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                        Edit the System Defaults                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function BACKUPS
SETCOLOR(CLR_COLOR)
@ 1,0 CLEAR TO 23,79
SETCOLOR(MAIN_COLOR)
HELPIT("Press [ESC] to abort or any other key to continue")
ZBOX(8,13,17,67,BK1_COLOR)
@  9,15 SAY "This procedure will copy all database files to the "
@ 10,15 SAY "\BACKUPS directory as well as to a floppy diskette."
@ 12,15 SAY "ДД Please insert the correct backup diskette now ДД"
@ 14,15 SAY "Press [ESC] to abort or any other key to continue. "
PAUSE(16)
IF LASTKEY() == K_ESC
   Return (Nil)
ENDIF
SETCOLOR(CLR_COLOR)
@ 1,0 CLEAR TO 23,79
SETCOLOR(MAIN_COLOR)
ZWARN(12,"Please Wait : Backing Up Database",1,BK1_COLOR)
SET CURSOR ON
COPY FILE ("CUSTOMER.DBF") TO (BKUP_PATH + "CUSTOMER.DBF")
COPY FILE ("ORDERS.DBF")   TO (BKUP_PATH + "ORDERS.DBF")
COPY FILE ("INVOICES.DBF") TO (BKUP_PATH + "INVOICES.DBF")
COPY FILE ("INVLINES.DBF") TO (BKUP_PATH + "INVLINES.DBF")
COPY FILE ("PRODUCTS.DBF") TO (BKUP_PATH + "PRODUCTS.DBF")
COPY FILE ("SYSTEM.DBF")   TO (BKUP_PATH + "SYSTEM.DBF")
COPY FILE ("CUSTOMER.DBF") TO (cBACKUP + ":\CUSTOMER.DBF")
COPY FILE ("ORDERS.DBF")   TO (cBACKUP + ":\ORDERS.DBF")
COPY FILE ("INVOICES.DBF") TO (cBACKUP + ":\INVOICES.DBF")
COPY FILE ("INVLINES.DBF") TO (cBACKUP + ":\INVLINES.DBF")
COPY FILE ("PRODUCTS.DBF") TO (cBACKUP + ":\PRODUCTS.DBF")
COPY FILE ("SYSTEM.DBF")   TO (cBACKUP + ":\SYSTEM.DBF")
SET CURSOR OFF
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                        Edit the System Defaults                          */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function DEFAULTS
SETCOLOR(CLR_COLOR)
USE ("SYSTEM") NEW EXCLUSIVE
@ 1,0 CLEAR TO 23,79
SETCOLOR(MAIN_COLOR)
HELPIT("Press [PgDn] to save or [ESC] to abort")
ZBOX(4,7,20,72,BK1_COLOR)
@  5,32 SAY "Program Defaults"
@  7,9  SAY "Company .................." GET COMPANY
@  8,9  SAY "Address .................." GET ADDRESS
@  9,9  SAY "City ....................." GET CITY
@ 10,9  SAY "State ...................." GET STATE
@ 11,9  SAY "Zip Code ................." GET ZIPCODE
@ 12,9  SAY "Phone Number, Voice ......" GET PHONE      PICTURE "@R (###) ###-####"
@ 13,9  SAY "Phone Number, Fax ........" GET FAX        PICTURE "@R (###) ###-####"
@ 14,8  SAY REPLICATE("Д",64)
@ 15,9  SAY "Printer Port .............              ..... (Any DOS device)"
@ 15,36                                  GET LP_DEVICE  PICTURE "@!"
@ 16,9  SAY "Printer Type .............       ............... (EPSON,HP,NONE)"
@ 16,36                                  GET LP_TYPE    PICTURE "@!" VALID (LP_TYPE+"|")$"HP   |EPSON|NONE |"
@ 17,9  SAY "Report Title ............." GET REP_TITLE
@ 18,9  SAY "Password .................            ....... (Blank for None)"
@ 18,36                                  GET PASSWORD   PICTURE "@!"
@ 19,9  SAY "Backup Drive (A-D) ....... [ ]"
@ 19,37                                  GET BACKUP_DRV PICTURE "!" VALID BACKUP_DRV$"ABCD"
SET CURSOR ON
READ
SET CURSOR OFF
cBACKUP  := BACKUP_DRV
CLOSE ALL
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*          Erase Index(s), Pack Databases, and Call PREP_INDEX()           */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function RE_INDEX
Local nTOTAL := 0

SETCOLOR(CLR_COLOR)
@ 1,0 CLEAR TO 23,79
SETCOLOR(MAIN_COLOR)
HELPIT("Press [ESC] to abort or any other key to continue")
ZBOX(8,12,17,68,BK1_COLOR)
@  9,14 SAY "This procedure creates new indexes for all databases."
@ 10,14 SAY "It is usually not necessary to run this option unless"
@ 11,14 SAY "you have experienced an abnormal system shutdown or  "
@ 12,14 SAY "you have found corrupted files.                      "
@ 14,14 SAY "  Press [ESC] to abort or any other key to continue. "
PAUSE(16)
IF LASTKEY() == K_ESC
   Return (Nil)
ENDIF
SETCOLOR(CLR_COLOR)
@ 1,0 CLEAR TO 23,79
SETCOLOR(MAIN_COLOR)
ZWARN(12,"Please Wait : Rebuilding Database Indexes",1,BK1_COLOR)
SET CURSOR ON
USE ("CUSTOMER") NEW EXCLUSIVE
PACK
CLOSE
ERASE ("CUSTNAME.NTX")
ERASE ("CUSTSERN.NTX")
ERASE ("CUSTCODE.NTX")
USE ("ORDERS") NEW EXCLUSIVE
PACK
CLOSE
ERASE ("ORDERS1.NTX")
ERASE ("ORDERS2.NTX")
USE ("INVOICES") NEW EXCLUSIVE
PACK
CLOSE
ERASE ("INVOICES.NTX")
USE ("INVLINES") NEW EXCLUSIVE
PACK
CLOSE
ERASE ("INVLINES.NTX")
USE ("PRODUCTS") NEW EXCLUSIVE
PACK
CLOSE
ERASE ("PRODUCTS.NTX")
PREP_INDEX(.F.)

* Recalculate the amounts in INVOICES.DBF

SET EXACT OFF
USE ("INVLINES") NEW EXCLUSIVE
SET INDEX TO ("INVLINES")
USE ("INVOICES") NEW EXCLUSIVE
SET INDEX TO ("INVOICES")
GO TOP
DO WHILE ! EOF()
   nTOTAL := 0
   SELECT INVLINES
   SEEK STR(INVOICES->CUSTOMER,5) + DTOS(INVOICES->ORDERED)
   IF FOUND()
      DO WHILE (INVLINES->CUSTOMER = INVOICES->CUSTOMER .AND. INVLINES->ORDERED = INVOICES->ORDERED .AND. ! EOF())
         nTOTAL := nTOTAL + (UNITS * AMT_EACH)
         SKIP
      ENDDO
   ENDIF
   SELECT INVOICES
   INVOICES->AMT_ORDER := nTOTAL
   INVOICES->AMT_FINAL := (nTOTAL + INVOICES->AMT_SHIP)
   SKIP
ENDDO
CLOSE ALL
SET EXACT ON
SET CURSOR OFF
Return (Nil)

/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/
/*                        Rebuild Indexes if Missing                        */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Function PREP_INDEX (lNEEDMSG)
USE ("SYSTEM") NEW EXCLUSIVE
PACK
IF LASTREC() < 1
   APPEND BLANK
ENDIF
CLOSE
IF ! FILE("CUSTNAME.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("CUSTOMER") NEW EXCLUSIVE
   INDEX ON UPPER(NAME) TO ("CUSTNAME")
   CLOSE
ENDIF
IF ! FILE("CUSTSERN.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("CUSTOMER") NEW EXCLUSIVE
   INDEX ON STR(SERIAL,6) + TYPE + UPPER(NAME) TO ("CUSTSERN")
   CLOSE
ENDIF
IF ! FILE("CUSTCODE.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("CUSTOMER") NEW EXCLUSIVE
   INDEX ON NUMBER TO ("CUSTCODE")
   CLOSE
ENDIF
IF ! FILE("ORDERS1.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("ORDERS") NEW EXCLUSIVE
   INDEX ON STR(CUSTOMER,5) TO ("ORDERS1")
   CLOSE
ENDIF
IF ! FILE("ORDERS2.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("ORDERS") NEW EXCLUSIVE
   INDEX ON UPPER(NAME + PROD_CODE) TO ("ORDERS2")
   CLOSE
ENDIF
IF ! FILE("INVOICES.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("INVOICES") NEW EXCLUSIVE
   INDEX ON STR(CUSTOMER,5) + DTOS(ORDERED) TO ("INVOICES")
   CLOSE
ENDIF
IF ! FILE("INVLINES.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("INVLINES") NEW EXCLUSIVE
   INDEX ON STR(CUSTOMER,5) + DTOS(ORDERED) TO ("INVLINES")
   CLOSE
ENDIF
IF ! FILE("PRODUCTS.NTX")
   DO_MSG(@lNEEDMSG)
   USE ("PRODUCTS") NEW EXCLUSIVE
   INDEX ON UPPER(CODE) TO ("PRODUCTS")
   CLOSE
ENDIF
SET CURSOR OFF
Return (Nil)

Function DO_MSG (lNEEDMSG)
IF lNEEDMSG
   ZWARN(12,"Please Wait : Rebuilding Indexes",1,BK1_COLOR)
   SET CURSOR ON
   lNEEDMSG := .F.
ENDIF
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
/*                             Help Commander                               */
/*ДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДДД*/

Procedure HELP (cFUNCTION,nLINENUM,cVARIABLE)
Local nCURSOR := SETCURSOR(), nCOLOR := SETCOLOR(), cSCREEN, lSUCCESS
SAVE SCREEN TO cSCREEN
SET CURSOR OFF
SET KEY 28 TO
DO CASE
CASE (cFUNCTION = "ORDERS" .AND. cVARIABLE = "CNAME")
   lSUCCESS := CUSTOMERS(1)
   RESTORE SCREEN FROM cSCREEN
CASE (cFUNCTION = "REGISTER" .AND. cVARIABLE = "REGISTER->NAME")
   CUSTOMERS(2)
   RESTORE SCREEN FROM cSCREEN
   SELECT REGISTER
CASE (cFUNCTION = "REGISTER" .AND. UPPER(cVARIABLE) = "CPRODUCT")
   PRODUCTS(1)
   RESTORE SCREEN FROM cSCREEN
   SELECT REGISTER
CASE (cFUNCTION = "INVOICES" .AND. cVARIABLE = "INVLINES->PRODUCT")
   PRODUCTS(2)
   RESTORE SCREEN FROM cSCREEN
   SELECT INVLINES
OTHERWISE
   RESTORE SCREEN FROM cSCREEN
ENDCASE
SET KEY 28 TO HELP
SETCURSOR(nCURSOR)
SETCOLOR(nCOLOR)
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
