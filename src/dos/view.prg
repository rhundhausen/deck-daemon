/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                                                                          */
/*   Program           : VIEW.EXE                                           */
/*   Title             : Price Guide on Disk (TM) Browsing Utility          */
/*   Version           : 1.0c                                               */
/*   Purpose           : View Price Data on Update Disk                     */
/*   Author(s)         : Richard Hundhausen                                 */
/*   Copyright         : 1994, Richard Hundhausen                           */
/*   Distributor       : Bard's Quest Software, Inc.                        */
/*   Started           : February 7, 1995                                   */
/*   Completed         :                                                    */
/*   Clipper Libraries : Clipper, Extend, Terminal, DBFNTX                  */
/*   Complier Version  : Clipper 5.2d                                       */
/*                                                                          */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                                                                          */
/*  1. Make Mouseable?                                                      */
/*                                                                          */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

#Include "inkey.ch"

#Define PROG_NAME "VIEW.EXE"
#Define PREV_FILE "PREVIEW.$$$"
#Define VERSION   "1.0c"
#Define B_SINGLE  "зд©ЁыдюЁ"
#Define B_DOUBLE  "им╩╨╪мх╨"
#Define CONJURE1  "GAME,C  4 0SERIES,C 15 0TYPE,C  1 0NAME,C 40 0COLOR,C  5 0ARTIST,C  3 0RARITY,C  3 0"
#Define CONJURE2  "REFERENCE,N  5 0SOURCE,C 20 0VALUE_LOW,N  8 2VALUE_MED,N  8 2VALUE_HI,N  8 2"
#Define SCRYE1    "NAME,C 40 0REFERENCE,N  5 0FIELD2,C 35 0FIELD3,C 35 0FIELD4,C 35 0FIELD5,C 35 0"
#Define SCRYE2    "FIELD6,C 35 0FIELD7,C 35 0VALUE_LOW,N  8 2VALUE_MED,N  8 2VALUE_HI,N  8 2"
#Define DAEMON12  "DECK,C 20 0SERIES,C  4 0CARD,C 30 0COLOR,C  5 0TYPE,C 20 0FLAGS,C  4 0QUANTITY,N  3 0VALUE,N 10 2"
#Define FSTRUCT1  "GAME,C  4 0SERIES,C 15 0TYPE,C  1 0NAME,C 40 0COLOR,C  5 0ARTIST,C  3 0RARITY,C  3 0"
#Define FSTRUCT2  "REFERENCE,N  5 0SOURCE,C 20 0VALUE_LOW,N  8 2VALUE_MED,N  8 2VALUE_HI,N  8 2"
#Define COLORS    "A  |B  |BE |G  |GLD|R  |U  |W  |B/G|B/R|B/U|B/W|G/R|G/W|R/W|U/W|U/G|U/R|"
#Define COLORSTR  IF((UPPER(LEFT(PRICES->COLOR,3))+"|")$COLORS,aCOLORS[ ((AT( UPPER(LEFT(PRICES->COLOR,3))+"|",COLORS ) +3)/4) ],PRICES->COLOR)

* Color Variables

Static BK1_COLOR, BK2_COLOR, MAIN_COLOR, POP_COLOR, HEAD_COLOR, OFF_COLOR
Static WARN_COLOR

* Main Variables

Static GETLIST := {}, aSERIES := {}, lBW := .F., lCGA := .F., cSETNAME := ""
Static nCHOICE := 1, nROW := 0, nMAG := 0, lCOLOR, cPATH := ""
Static nMAX1 := 0, nMAX2 := 0, nMAX3 := 0, nMAX4 := 0, nMAX5 := 0, nMAX6 := 0
Static nMAX7 := 0, cNAME2 := "", cNAME3 := "", cNAME4 := ""
Static cNAME5 := "", cNAME6 := "", cNAME7 := "", aMTG := {}, cPICKDBF := ""

* Constant Variables

Static aCOLORS := { "Artifact","Black   ","Beige   ","Green   ","Gold    ","Red     ","Blue    ","White   ",;
                    "Blck/Grn","Blck/Red","Blk/Blue","Blck/Wht","Grn/Red ","Grn/Wht ","Red/Wht ","Blue/Wht",;
                    "Blue/Grn","Blue/Red" }

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                              Main Routine                                */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function MAIN_BLOCK (pPARM)
Local cPARMS, aFILES := {}, lBADPATH := .T., cMASK := "*.?OD", nX, cMAG, cSET
Local cSET2, cSCRYE

SET SCOREBOARD OFF
SET DELETED ON
SET CURSOR OFF
* SETCANCEL(.F.)
SET EXACT ON
SET BELL OFF
SET WRAP ON

* Check Parameters

cPARMS := IF(pPARM = Nil,"",UPPER(pPARM))
lBW    := ("BW"$cPARMS .OR. "MONO"$cPARMS)
lCGA   := ("CGA"$cPARMS)
IF "?"$cPARMS
   PROG_HELP()
ENDIF
SETBLINK(lBW .OR. lCGA)

* Set Colors

BK1_COLOR  := IF(lCGA,"N/B"              ,IF(lBW,"W/N"          ,"B+/N"))
BK2_COLOR  := IF(lCGA,"N/B"              ,IF(lBW,"W/N"          ,"W+/N"))
CLR_COLOR  := IF(lCGA,"N/B"              ,IF(lBW,"W/N"          ,"N/B*"))
POP_COLOR  := IF(lCGA,"W+/B,W+/N,,,GR+/B",IF(lBW,"W/N,N/W,,,W/N","W+/B*,W+/N,,,GR+/B*"))
SHOW_COLOR := IF(lCGA,"GR+/B"            ,IF(lBW,"W/N"          ,"GR+/B*"))
OFF_COLOR  := IF(lCGA,"B+/B"             ,IF(lBW,"N+/N",         "B/B*"))
HEAD_COLOR := IF(lCGA,"N/BG"             ,IF(lBW,"W/N"          ,"N/GR*"))
DD_COLOR   := IF(lCGA,"N/BG"             ,IF(lBW,"W/N"          ,"B+/GR*"))
MAIN_COLOR := IF(lCGA,"N/W,W+/N,,,B+/W"  ,IF(lBW,"N/W,W/N,,,N/W","N/W*,W+/N,,,B+/W*"))
LITE_COLOR := IF(lCGA,"N/W,W+/N,,,B+/W"  ,IF(lBW,"N/W,W/N,,,N/W","N+/W*,W+/N,,,B+/W*"))
WARN_COLOR := IF(lCGA,"W+/R"             ,IF(lBW,"W/N"          ,"W+/R"))

* Draw Main Screen

SETCOLOR(CLR_COLOR)
@ 0,0   CLEAR TO 24,79
SETCOLOR(HEAD_COLOR)
@ 0,0   CLEAR TO 0,79
@ 0,19  SAY "Price Guide on Disk Browser, Version " + VERSION
@ 24,0  CLEAR TO 24,79
@ 24,16 SAY "Copyright (c) 1995, Bard's Quest Software, Inc."

* Prompt for File Path

SETCOLOR(MAIN_COLOR)
zBOX(9,17,15,60,BK1_COLOR,"Where are the files located?")
DO WHILE lBADPATH
   cPATH := cPATH + SPACE(40)
   cMASK := cMASK + SPACE(40)
   @ 11,19 SAY "Price Guide Path  :" GET cPATH PICTURE "@S20"
   @ 12,19 SAY "Price Guide Files :" GET cMASK PICTURE "@S20"
   @ 14,19 SAY "  Price Guide Files are *.COD or *.SOD  " COLOR LITE_COLOR
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF EMPTY(cMASK) .OR. LASTKEY() = 27
      SETCOLOR("W/N")
      @ 0,0 CLEAR
      SET CURSOR ON
      CLOSE ALL
      CLEAR ALL
      QUIT
   ENDIF
   cPATH  := LTRIM(RTRIM(UPPER(cPATH)))
   cMASK  := LTRIM(RTRIM(UPPER(cMASK)))
   aFILES := {}
   aFILES := DIRECTORY(cPATH+cMASK)
   IF LEN(aFILES) < 1
      cPATH  := cPATH + "\"
      aFILES := {}
      aFILES := DIRECTORY(cPATH+cMASK)
      IF LEN(aFILES) < 1
         TONE(900,2)
         @ 14,20 SAY " Sorry : No Price Guide Files Found! " COLOR WARN_COLOR
         cPATH := LEFT(cPATH,LEN(cPATH)-1)
         INKEY(0)
      ELSE
         lBADPATH := .F.
      ENDIF
   ELSE
      lBADPATH := .F.
   ENDIF
ENDDO

* Load Descriptions of Each Price Guide

CREATEDBF("HEADER.DD","LINE,C 80 0")
USE HEADER.DD NEW EXCLUSIVE
FOR nX := 1 TO LEN(aFILES)
   DO CASE
   CASE "GAMES.COD"$UPPER(aFILES[nX,1])                      && Conjure on Disk
      ZAP
      APPEND FROM (cPATH+aFILES[nX,1]) SDF
      GO TOP
      GO 2
      cMAG := RTRIM(LINE)
      cMAG := cMAG + SPACE(20 - LEN(cMAG))
      SKIP
      DO WHILE ! EOF()
         aADD(aSERIES," "+LEFT(cMAG,20) + ": " + SUBSTR(LINE,5,30) + SPACE(10) + SUBSTR(LINE,65,12))
         SKIP
      ENDDO
   CASE ".SOD"$UPPER(aFILES[nX,1])                             && Scrye on Disk
      ZAP
      APPEND NEXT 14 FROM (cPATH+aFILES[nX,1]) SDF
      GO TOP
      IF "BEGIN TEMPLATE"$UPPER(LINE)

         GO 2
         cMAG := SUBSTR(LINE,AT("SCRYE ON DISK",UPPER(LINE)),LEN(LINE)-AT("SCRYE ON DISK",UPPER(LINE)))
         cSET := LTRIM(RTRIM(LEFT(LINE,AT("SCRYE ON DISK",UPPER(LINE))-1)))
         GO 3
         IF "ILLUMINATI"$UPPER(cSET) .AND. ! "ILLUMINATI"$LINE
            cSET2 := LTRIM(RTRIM(SUBSTR(LINE,8,LEN(LINE)-8)))
            cSET  := cSET + " - " + cSET2
         ELSE
            cSET  := LTRIM(RTRIM(SUBSTR(LINE,8,LEN(LINE)-8)))
         ENDIF
         cSET := IF(LEN(cSET) > 40,LEFT(cSET,40),cSET + SPACE(40 - LEN(cSET)))

         GO 4
       * aADD(aSERIES," "+LEFT(cMAG,20) + ": " + LEFT(cSET,40) + aFILES[nX,1])
         aADD(aSERIES," "+LEFT(cMAG,20) + ": " + cSET + aFILES[nX,1])

         DO CASE
         CASE "ARABIAN NIGHTS"$UPPER(cMAG) .OR. "ARABIAN NIGHTS"$UPPER(cSET)
            aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Arabian Nights  ARAB")
         CASE "ANIQUITIES"$UPPER(cMAG) .OR. "ANTIQUITIES"$UPPER(cSET)
            aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Antiquities     ANTQ")
         CASE "THE DARK"$UPPER(cMAG) .OR. "THE DARK"$UPPER(cSET)
            aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" The Dark        DARK")
         CASE "LEGENDS"$UPPER(cMAG) .OR. "LEGENDS"$UPPER(cSET)
            aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Legends         LGND")
         CASE "FALLEN EMPIRES"$UPPER(cMAG) .OR. "FALLEN EMPIRES"$UPPER(cSET)
            aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Fallen Empires  FALL")
         CASE "ICE AGE"$UPPER(cMAG) .OR. "ICE AGE"$UPPER(cSET)
            aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Ice Age         ICE ")
         CASE "MTG"$UPPER(cMAG) .OR. "MTG"$UPPER(cSET)
            DO CASE
            CASE "ALPHA"$UPPER(cMAG)     .OR. "ALPHA"$UPPER(cSET)
               aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Alpha Unlimited ALPH")
            CASE "BETA"$UPPER(cMAG)      .OR. "BETA"$UPPER(cSET)
               aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Beta Unlimited  BETA")
            CASE "UNLIMITED"$UPPER(cMAG) .OR. "UNLIMITED"$UPPER(cSET)
               aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Unlimited       UNLT")
            CASE "REVISED"$UPPER(cMAG)   .OR. "REVISED"$UPPER(cSET)
               aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Revised         RVSD")
            ENDCASE
       * CASE "PACKS & SETS"$UPPER(cMAG) .OR. "PACKS & SETS"$UPPER(cSET)
       *    aADD(aMTG," "+aFILES[nX,1]+" "+REPLICATE(".",13-LEN(aFILES[nX,1]))+" Packs & Sets    ****")
         ENDCASE
      ENDIF
   ENDCASE
NEXT nX
CLOSE HEADER
ERASE("HEADER.DD")
ASORT(aSERIES)
BROWSE()

* All Done, Finishing Touches

CLOSE ALL
ERASE("PRICES.DD")
ERASE("PRICES1.DD")
ERASE("PRICES2.DD")
ERASE("PRICES3.DD")
ERASE("PRICES4.DD")
ERASE("PRICES5.DD")
CLEAR ALL
SET CURSOR ON
SETCOLOR("W/N")
SETBLINK(.T.)
CLEAR SCREEN
Return (Nil)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                            Select Source/Set                             */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function PICK_SET (nMODE,cDBF)

Local cFILE := "", nHEADERS, nSFIELDS, nSHEADER, aFIELDS[12], nCOLUMN, cFIELD
Local cSPICK := ""

IF cDBF = Nil
   IF nMODE = 0
      SETCOLOR(MAIN_COLOR)
      zBOX(4,8,20,70,BK1_COLOR,"Please Select Price Guide and/or Card Series")
      @ 20,8 SAY SPACE(22)+"Press [Esc] to Exit"+SPACE(22) COLOR HEAD_COLOR
   ELSE
      SETCOLOR(POP_COLOR)
      zBOX(4,8,20,70,BK2_COLOR,"Please Select Price Guide and/or Card Series")
      @ 20,8 SAY SPACE(21)+"Press [Esc] to Cancel"+SPACE(21) COLOR HEAD_COLOR
   ENDIF
   IF LEN(aSERIES) = 0
      TONE(900,2)
      @ 11,22 SAY "Sorry : No Records to Choose From"
      @ 13,22 SAY "    Press Any Key to Continue    "
      INKEY(0)
      cPICKDBF := ""
      Return ("")
   ENDIF
   nCHOICE := aCHOICE(6,9,18,69,aSERIES,,,nCHOICE,nROW)
   IF nCHOICE < 1
      cPICKDBF := ""
      Return("")
   ENDIF
   nROW := (ROW() - 6)
   IF nMODE = 1
      CLOSE PRICES
   ENDIF
   nMAG   := 0
   cSPICK := aSERIES[nCHOICE]
   cFILE  := UPPER(LTRIM(RTRIM(RIGHT(aSERIES[nCHOICE],12))))
   lCOLOR := .F.
ELSE

   nMAG   := 0
   cSPICK := ""
   cFILE  := cDBF
   lCOLOR := .F.

ENDIF
DO CASE
CASE "CONJURE ON DISK"$UPPER(cSPICK)
   nMAG := 1
   CREATEDBF("PRICES.DD",CONJURE1 + CONJURE2)
   USE PRICES.DD NEW EXCLUSIVE ALIAS PRICES
   APPEND FROM (cPATH+cFILE) SDF
   INDEX ON UPPER(TYPE + SERIES + NAME) TO ("PRICES1.DD")
   INDEX ON UPPER(TYPE + NAME + SERIES) TO ("PRICES2.DD")
   INDEX ON STR(VALUE_MED,8,2)          TO ("PRICES3.DD")
   SET INDEX TO ("PRICES1.DD"), ("PRICES2.DD"), ("PRICES3.DD")
CASE "SCRYE ON DISK"$UPPER(cSPICK) .OR. cDBF <> Nil
   nMAG := 2
   CREATEDBF("HEADER.DD","LINE,C 80 0")
   USE HEADER.DD NEW EXCLUSIVE
   ZAP
   APPEND FROM (cPATH+cFILE) SDF

   * Read Header

   nSFIELDS := 0
   nSHEADER := 0
   lDEFINE  := .F.
   cNAME2   := ""
   cNAME3   := ""
   cNAME4   := ""
   cNAME5   := ""
   cNAME6   := ""
   cNAME7   := ""
   AFILL(aFIELDS,"")
   GO TOP
   DO WHILE (nSHEADER = 0 .AND. ! EOF())
      DO CASE
      CASE "FIELDS"$UPPER(LINE)
         nSFIELDS := VAL(SUBSTR(LINE,8,3))
         lDEFINE  := .T.
      CASE "END TEMPLATE"$UPPER(LINE)
         nSHEADER := (RECNO() + 1)
      CASE lDEFINE .AND. VAL(LINE) > 0 .AND. VAL(LINE) <= 12 .AND. "="$LINE
         aFIELDS[VAL(LINE)] := SUBSTR(LINE, AT("=",LINE)+1, (LEN(RTRIM(LINE)) - AT("=",LINE)))
         DO CASE
         CASE VAL(aFIELDS[VAL(LINE)]) = 2 .AND. ","$aFIELDS[VAL(LINE)]
            cNAME2 := SUBSTR(aFIELDS[VAL(LINE)],AT(",",aFIELDS[VAL(LINE)])+1,10)
         CASE VAL(aFIELDS[VAL(LINE)]) = 3 .AND. ","$aFIELDS[VAL(LINE)]
            cNAME3 := SUBSTR(aFIELDS[VAL(LINE)],AT(",",aFIELDS[VAL(LINE)])+1,10)
         CASE VAL(aFIELDS[VAL(LINE)]) = 4 .AND. ","$aFIELDS[VAL(LINE)]
            cNAME4 := SUBSTR(aFIELDS[VAL(LINE)],AT(",",aFIELDS[VAL(LINE)])+1,10)
         CASE VAL(aFIELDS[VAL(LINE)]) = 5 .AND. ","$aFIELDS[VAL(LINE)]
            cNAME5 := SUBSTR(aFIELDS[VAL(LINE)],AT(",",aFIELDS[VAL(LINE)])+1,10)
         CASE VAL(aFIELDS[VAL(LINE)]) = 6 .AND. ","$aFIELDS[VAL(LINE)]
            cNAME6 := SUBSTR(aFIELDS[VAL(LINE)],AT(",",aFIELDS[VAL(LINE)])+1,10)
         CASE VAL(aFIELDS[VAL(LINE)]) = 7 .AND. ","$aFIELDS[VAL(LINE)]
            cNAME7 := SUBSTR(aFIELDS[VAL(LINE)],AT(",",aFIELDS[VAL(LINE)])+1,10)
         ENDCASE
      ENDCASE
      SKIP
   ENDDO

   * Check for Invalid Record

   IF nSFIELDS < 1 .or. nSFIELDS > 12 .or. nSHEADER = 0 .or. ! lDEFINE
      SETCOLOR(WARN_COLOR)
      zBOX(8,15,15,63,BK2_COLOR,"Warning, Please Note :")
      TONE(900,2)
      @ 10,17 SAY "This file cannot be read by this version of  "
      @ 11,17 SAY "VIEW.EXE  Please contact Bard's Quest Sofware"
      @ 12,17 SAY "at (208) 336-9404 and request an update.     "
      @ 14,17 SAY "          Press Any Key to Continue          "
      INKEY(0)
      cPICKDBF := ""
      Return ("")
   ENDIF

   * Continue Reading Body

   nMAX1 := 0
   nMAX2 := 0
   nMAX3 := 0
   nMAX4 := 0
   nMAX5 := 0
   nMAX6 := 0
   nMAX7 := 0
   CREATEDBF("PRICES.DD",SCRYE1 + SCRYE2)
   USE PRICES.DD NEW EXCLUSIVE ALIAS PRICES
   SELECT HEADER
   GO nSHEADER
   DO WHILE ! EOF()

      * Begin Parsing Record

      nCOLUMN := 1
      cTEMP   := HEADER->LINE
      DO WHILE LEN(cTEMP) > 0
         cFIELD := IF(CHR(9)$cTEMP,LEFT(cTEMP,AT(CHR(9),cTEMP)-1),cTEMP)
         cFIELD := LTRIM(RTRIM(cFIELD))
         cTEMP  := DELTAB(cTEMP)
         IF nCOLUMN > 0 .AND. nCOLUMN <= 12
            SELECT PRICES
            DO CASE
            CASE nCOLUMN = 1 .AND. EMPTY(aFIELDS[1])
               * Skip it, it's the series code
            CASE nCOLUMN = 2 .AND. EMPTY(aFIELDS[1])
               APPEND BLANK
               PRICES->REFERENCE := VAL(cFIELD)
            OTHERWISE
               IF nCOLUMN = 1
                  APPEND BLANK
               ENDIF
               IF ! EMPTY(aFIELDS[nCOLUMN])
                  DO CASE
                  CASE VAL(aFIELDS[nCOLUMN]) = 1
                     PRICES->NAME     := cFIELD

                     * Check for Quotation Marks

                     IF LEFT(PRICES->NAME,1) = CHR(34)
                        PRICES->NAME := SUBSTR(PRICES->NAME,2,LEN(RTRIM(PRICES->NAME))-2)
                     ENDIF
                     nMAX1 := IF(LEN(RTRIM(PRICES->NAME)) > nMAX1,LEN(RTRIM(PRICES->NAME)),nMAX1)
                  CASE VAL(aFIELDS[nCOLUMN]) = 2
                     PRICES->FIELD2    := MASSAGE(cFIELD,cNAME2)
                     nMAX2 := IF(LEN(RTRIM(PRICES->FIELD2)) > nMAX2,LEN(RTRIM(PRICES->FIELD2)),nMAX2)
                  CASE VAL(aFIELDS[nCOLUMN]) = 3
                     PRICES->FIELD3    := MASSAGE(cFIELD,cNAME3)
                     nMAX3 := IF(LEN(RTRIM(PRICES->FIELD3)) > nMAX3,LEN(RTRIM(PRICES->FIELD3)),nMAX3)
                  CASE VAL(aFIELDS[nCOLUMN]) = 4
                     PRICES->FIELD4    := MASSAGE(cFIELD,cNAME4)
                     nMAX4 := IF(LEN(RTRIM(PRICES->FIELD4)) > nMAX4,LEN(RTRIM(PRICES->FIELD4)),nMAX4)
                  CASE VAL(aFIELDS[nCOLUMN]) = 5
                     PRICES->FIELD5    := MASSAGE(cFIELD,cNAME5)
                     nMAX5 := IF(LEN(RTRIM(PRICES->FIELD5)) > nMAX5,LEN(RTRIM(PRICES->FIELD5)),nMAX5)
                  CASE VAL(aFIELDS[nCOLUMN]) = 6
                     PRICES->FIELD6    := MASSAGE(cFIELD,cNAME6)
                     nMAX6 := IF(LEN(RTRIM(PRICES->FIELD6)) > nMAX6,LEN(RTRIM(PRICES->FIELD6)),nMAX6)
                  CASE VAL(aFIELDS[nCOLUMN]) = 7
                     PRICES->FIELD7    := MASSAGE(cFIELD,cNAME7)
                     nMAX7 := IF(LEN(RTRIM(PRICES->FIELD7)) > nMAX7,LEN(RTRIM(PRICES->FIELD7)),nMAX7)
                  CASE VAL(aFIELDS[nCOLUMN]) = 10
                     PRICES->VALUE_HI  := VAL(cFIELD)
                  CASE VAL(aFIELDS[nCOLUMN]) = 11
                     PRICES->VALUE_MED := VAL(cFIELD)
                  CASE VAL(aFIELDS[nCOLUMN]) = 12
                     PRICES->VALUE_LOW := VAL(cFIELD)
                  ENDCASE
               ENDIF
            ENDCASE
         ENDIF
         nCOLUMN++
      ENDDO
      SELECT HEADER
      SKIP
   ENDDO

   * Indexes

   SELECT PRICES
   IF cDBF = Nil
      DO CASE
      CASE nMAX2 > 2
         INDEX ON UPPER(NAME + FIELD2)          TO ("PRICES1.DD")
         INDEX ON UPPER(FIELD2 + NAME)          TO ("PRICES2.DD")
      CASE nMAX3 > 2
         INDEX ON UPPER(NAME + FIELD3)          TO ("PRICES1.DD")
         INDEX ON UPPER(FIELD3 + NAME)          TO ("PRICES2.DD")
      CASE nMAX4 > 2
         INDEX ON UPPER(NAME + FIELD4)          TO ("PRICES1.DD")
         INDEX ON UPPER(FIELD4 + NAME)          TO ("PRICES2.DD")
      OTHERWISE
         INDEX ON UPPER(NAME + FIELD2)          TO ("PRICES1.DD")
         INDEX ON UPPER(FIELD2 + NAME)          TO ("PRICES2.DD")
      ENDCASE
    * INDEX ON UPPER(NAME + FIELD2)             TO ("PRICES1.DD")
    * INDEX ON UPPER(FIELD2 + NAME)             TO ("PRICES2.DD")
      INDEX ON UPPER(STR(VALUE_HI,8,2) + NAME)  TO ("PRICES3.DD")
      INDEX ON UPPER(STR(VALUE_MED,8,2) + NAME) TO ("PRICES4.DD")
      INDEX ON UPPER(STR(VALUE_LOW,8,2) + NAME) TO ("PRICES5.DD")
      SET INDEX TO ("PRICES1.DD"), ("PRICES2.DD"), ("PRICES3.DD"), ("PRICES4.DD"), ("PRICES5.DD")
   ENDIF
   CLOSE HEADER
   ERASE("HEADER.DD")
ENDCASE

cPICKDBF := cFILE
IF cDBF = Nil
   cSETNAME := UPPER(RTRIM(SUBSTR(cSPICK,24,30)))
   Return (RTRIM(LEFT(cSPICK,20)) + " / (" + UPPER(RTRIM(SUBSTR(aSERIES[nCHOICE],24,30))) + ")" )
ENDIF
Return (Nil)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                          Massage Scrye Records                           */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function MASSAGE (cITEM,cTYPE)

cITEM := UPPER(cITEM)
cTYPE := UPPER(cTYPE)
DO CASE
CASE cTYPE = "COLOR"  .AND. cITEM = "A";    Return ("Artifact")
CASE cTYPE = "COLOR"  .AND. cITEM = "BE";   Return ("Beige")
CASE cTYPE = "COLOR"  .AND. cITEM = "B";    Return ("Black")
CASE cTYPE = "COLOR"  .AND. cITEM = "B/G";  Return ("Blck/Grn")
CASE cTYPE = "COLOR"  .AND. cITEM = "B/R";  Return ("Blck/Red")
CASE cTYPE = "COLOR"  .AND. cITEM = "B/U";  Return ("Blk/Blue")
CASE cTYPE = "COLOR"  .AND. cITEM = "B/W";  Return ("Blck/Wht")
CASE cTYPE = "COLOR"  .AND. cITEM = "G";    Return ("Green")
CASE cTYPE = "COLOR"  .AND. cITEM = "G/R";  Return ("Grn/Red")
CASE cTYPE = "COLOR"  .AND. cITEM = "G/W";  Return ("Grn/Wht")
CASE cTYPE = "COLOR"  .AND. cITEM = "R";    Return ("Red")
CASE cTYPE = "COLOR"  .AND. cITEM = "R/G";  Return ("Red/Grn")
CASE cTYPE = "COLOR"  .AND. cITEM = "R/W";  Return ("Red/Wht")
CASE cTYPE = "COLOR"  .AND. cITEM = "U";    Return ("Blue")
CASE cTYPE = "COLOR"  .AND. cITEM = "U/G";  Return ("Blue/Grn")
CASE cTYPE = "COLOR"  .AND. cITEM = "U/R";  Return ("Blue/Red")
CASE cTYPE = "COLOR"  .AND. cITEM = "U/W";  Return ("Blue/Wht")
CASE cTYPE = "COLOR"  .AND. cITEM = "W";    Return ("White")
CASE cTYPE = "COLOR"  .AND. cITEM = "GLD";  Return ("Gold")
CASE cTYPE = "COLOR"  .AND. cITEM = "L";    Return ("Land")
CASE cTYPE = "TYPE"   .AND. cITEM = "A";    Return ("Artifact")
CASE cTYPE = "TYPE"   .AND. cITEM = "ART";  Return ("Artifact")
CASE cTYPE = "TYPE"   .AND. cITEM = "ACR";  Return ("Artifact-Creature")
CASE cTYPE = "TYPE"   .AND. cITEM = "CR";   Return ("Artifact-Creature")
CASE cTYPE = "TYPE"   .AND. cITEM = "C";    Return ("Artifact-Continuous")
CASE cTYPE = "TYPE"   .AND. cITEM = "DL";   Return ("Land-Dual")
CASE cTYPE = "TYPE"   .AND. cITEM = "E";    Return ("Enchantment")
CASE cTYPE = "TYPE"   .AND. cITEM = "EE";   Return ("Enchantment")
CASE cTYPE = "TYPE"   .AND. cITEM = "EART"; Return ("Enchant-Artifact")
CASE cTYPE = "TYPE"   .AND. cITEM = "ECR";  Return ("Enchant-Creature")
CASE cTYPE = "TYPE"   .AND. cITEM = "EDCR"; Return ("Enchant-Creature")
CASE cTYPE = "TYPE"   .AND. cITEM = "EL";   Return ("Enchant-Land")
CASE cTYPE = "TYPE"   .AND. cITEM = "EW";   Return ("Enchant-World")
CASE cTYPE = "TYPE"   .AND. cITEM = "EV";   Return ("Event")
CASE cTYPE = "TYPE"   .AND. cITEM = "INS";  Return ("Instant")
CASE cTYPE = "TYPE"   .AND. cITEM = "INT";  Return ("Interrupt")
CASE cTYPE = "TYPE"   .AND. cITEM = "L";    Return ("Land")
CASE cTYPE = "TYPE"   .AND. cITEM = "LEG";  Return ("Legends")
CASE cTYPE = "TYPE"   .AND. cITEM = "LL";   Return ("Land-Legendary")
CASE cTYPE = "TYPE"   .AND. cITEM = "M";    Return ("Artifact-Mono")
CASE cTYPE = "TYPE"   .AND. cITEM = "P";    Return ("Artifact-Poly")
CASE cTYPE = "TYPE"   .AND. cITEM = "R";    Return ("Realm")
CASE cTYPE = "TYPE"   .AND. cITEM = "SML";  Return ("Summon Legend")
CASE cTYPE = "TYPE"   .AND. cITEM = "SOR";  Return ("Sorcery")
CASE cTYPE = "TYPE"   .AND. cITEM = "SUM";  Return ("Summon")
CASE cTYPE = "TYPE"   .AND. cITEM = "S";    Return ("Summon")
CASE cTYPE = "RARITY" .AND. cITEM = "C";    Return ("Common")
CASE cTYPE = "RARITY" .AND. cITEM = "C1";   Return ("Common")
CASE cTYPE = "RARITY" .AND. cITEM = "R";    Return ("Rare")
CASE cTYPE = "RARITY" .AND. cITEM = "RARE"; Return ("Rare")
CASE cTYPE = "RARITY" .AND. cITEM = "U";    Return ("Uncommon")
CASE cTYPE = "RARITY" .AND. cITEM = "U1";   Return ("Uncommon")
CASE cTYPE = "RARITY" .AND. cITEM = "U2";   Return ("Uncommon")
CASE cTYPE = "RARITY" .AND. cITEM = "U3";   Return ("Uncommon")
CASE cTYPE = "RARITY" .AND. cITEM = "UR";   Return ("Ultra Rare")
CASE cTYPE = "RARITY" .AND. cITEM = "VR";   Return ("Very Rare")
ENDCASE
Return (cITEM)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                             Delete Next Tab                              */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function DELTAB (cPARM)
IF ! CHR(9)$cPARM
   Return ("")
ENDIF
cPARM := STUFF(cPARM,1,AT(CHR(9),cPARM),"")

* Take another one if Conjure

IF nMAG = 1
   IF LEFT(cPARM,1) = CHR(9)
      cPARM := STUFF(cPARM,1,AT(CHR(9),cPARM),"")
   ENDIF
ENDIF

Return (cPARM)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                           Begin Browsing File                            */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function BROWSE

Local cSET, oTBROWSE, nKEY, nRECNO, nORDER := 1, cSCREEN, cSEARCH := SPACE(20)
Local lFOUND, cTYPE, lBADPATH, cDPATH := "C:\DAEMON", cOUTPUT, nOUTPUT, nPORT
Local nDECKS, lALPHA := .F., cGUIDEDBF := "", lDAEMON := .F., cNEWSET := ""

cSET := PICK_SET(0)
cGUIDEDBF := cPICKDBF
IF EMPTY(cSET) .OR. nMAG = 0
   Return (Nil)
ENDIF

SETCOLOR(MAIN_COLOR)
zBOX(2,1,22,77,BK1_COLOR,cSET)
DO CASE
CASE nMAG = 1
   @  4,2  SAY "  Series/Set              Name/Description                Type     Value "
   @  5,2  SAY "дддддддддддддддд дддддддддддддддддддддддддддддддддддддддд ддддддддд ддддддд"
   oTBROWSE := TBROWSEDB(6,1,21,77)
   oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+SERIES+"  "+NAME+" "+COLOR+STR(VALUE_MED,12,2)+" "}))
CASE nMAG = 2
   @  4,2  SAY "                Name/Description                  High $   Med $   Low $ "
   @  5,2  SAY "дддддддддддддддддддддддддддддддддддддддддддддддддд дддддддд ддддддд ддддддд"
   oTBROWSE := TBROWSEDB(6,1,21,77)
   DO CASE
   CASE nMAX2 > 2
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD2,nMAX2)+SPACE(49-nMAX1-nMAX2)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
   CASE nMAX3 > 2
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD3,nMAX3)+SPACE(49-nMAX1-nMAX3)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
   CASE nMAX4 > 2
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD4,nMAX4)+SPACE(49-nMAX1-nMAX4)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
   OTHERWISE
      oTBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD2,nMAX2)+SPACE(49-nMAX1-nMAX2)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
   ENDCASE
ENDCASE
@ 24,0  SAY "   [Z]ЫZoom, [S]ЫSearch, [O]ЫOrder, [D]ЫDeck Daemon, [Q]ЫQuit, [R]ЫRe-Select" COLOR HEAD_COLOR
@ 24,36 SAY "[D]ЫDeck Daemon" COLOR DD_COLOR
SELECT PRICES
GO TOP
DO WHILE .T.
   oTBROWSE:FORCESTABLE()
   nKEY := ASC(UPPER(CHR(INKEY(0))))
   DO CASE
   CASE nKEY == K_ESC .or. nKEY == 81
      SAVE SCREEN TO cSCREEN
      SET CURSOR ON
      SETCOLOR(POP_COLOR)
      zBOX(12,24,14,56,BK2_COLOR)
      @ 13,26 SAY "Are you ready to Quit? [Y/N]"
      SET CURSOR ON
      INKEY(0)
      SET CURSOR OFF
      IF LASTKEY() = 89 .OR. LASTKEY() = 121
         Return (Nil)
      ENDIF
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
   CASE (nKEY == K_ENTER .or. nKEY = 90)
      SAVE SCREEN TO cSCREEN
      SETCOLOR(POP_COLOR)
      DO CASE
      CASE nMAG = 1
         zBOX(5,9,21,69,BK2_COLOR)
       * cTYPE := IF(TYPE = "C","Single Card","Starter, Booster, Set or Unopened Box")
         cTYPE := IF(TYPE = "C","Single Card","Set, Deck, Pack, Box or Special Card(s)")
         @  5,9  SAY "                         Record Zoom                         " COLOR HEAD_COLOR
         @  7,11 SAY "Game ............:" GET PRICES->GAME
         @  7,35                          GET cSETNAME
         @  8,11 SAY "Series ..........:" GET PRICES->SERIES
         @  9,11 SAY "Type ............:" GET cTYPE
         @ 10,11 SAY "Name ............:" GET PRICES->NAME
         @ 11,11 SAY "Color (Magic) ...:" GET PRICES->COLOR
         @ 12,11 SAY "Artist ..........:" GET PRICES->ARTIST
         DO CASE
         CASE UPPER(PRICES->RARITY) = "C";  cFILL := "Common"
         CASE UPPER(PRICES->RARITY) = "E";  cFILL := "Only one per display box"
         CASE UPPER(PRICES->RARITY) = "LC"; cFILL := "Limited Set Common"
         CASE UPPER(PRICES->RARITY) = "LM"; cFILL := "Limited Set Most Common"
         CASE UPPER(PRICES->RARITY) = "LR"; cFILL := "Limited Set Rare"
         CASE UPPER(PRICES->RARITY) = "LU"; cFILL := "Limited Set Uncommon"
         CASE UPPER(PRICES->RARITY) = "M";  cFILL := "Most Common"
         CASE UPPER(PRICES->RARITY) = "P";  cFILL := "Special offering only"
         CASE UPPER(PRICES->RARITY) = "R";  cFILL := "Rare"
         CASE UPPER(PRICES->RARITY) = "R+"; cFILL := "2x as many as Rare"
         CASE UPPER(PRICES->RARITY) = "S";  cFILL := "Subset"
         CASE UPPER(PRICES->RARITY) = "U";  cFILL := "Uncommon"
         CASE UPPER(PRICES->RARITY) = "U+"; cFILL := "2x as many as Uncommon"
         CASE UPPER(PRICES->RARITY) = "UR"; cFILL := "Ultra-Rare (1 in 1,000)"
         CASE UPPER(PRICES->RARITY) = "V";  cFILL := "2 versions of this card exist"
         OTHERWISE;                         cFILL := UPPER(PRICES->RARITY)
         ENDCASE
         @ 13,11 SAY "Rarity ..........:" GET cFILL
         @ 14,11 SAY "Source ..........:" GET PRICES->SOURCE
         @ 15,11 SAY "Value, High .....:" GET PRICES->VALUE_HI
         @ 16,11 SAY "Value, Med ......:" GET PRICES->VALUE_MED
         @ 17,11 SAY "Value, Low ......:" GET PRICES->VALUE_LOW
         @ 18,10 SAY "ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд"
         @ 19,11 SAY "Reference # .....:" GET PRICES->REFERENCE
         CLEAR GETS
         PAUSE(21)
      CASE nMAG = 2
         zBOX(5,9,20,69,BK2_COLOR)
         @  5,9  SAY "                         Record Zoom                         " COLOR HEAD_COLOR
         @  7,11 SAY "Game/Series .....:" GET cSETNAME
         @  8,11 SAY "Name ............:" GET PRICES->NAME
         IF EMPTY(cNAME2)
            @  9,11 SAY "Other ...........:"                GET PRICES->FIELD2
         ELSE
            @  9,11 SAY cNAME2+" "+REPLICATE(".",16-LEN(cNAME2))+":" GET PRICES->FIELD2
         ENDIF
         IF EMPTY(cNAME3)
            @ 10,11 SAY "Other ...........:"                GET PRICES->FIELD3
         ELSE
            @ 10,11 SAY cNAME3+" "+REPLICATE(".",16-LEN(cNAME3))+":" GET PRICES->FIELD3
         ENDIF
         IF EMPTY(cNAME4)
            @ 11,11 SAY "Other ...........:"                GET PRICES->FIELD4
         ELSE
            @ 11,11 SAY cNAME4+" "+REPLICATE(".",16-LEN(cNAME4))+":" GET PRICES->FIELD4
         ENDIF
         IF EMPTY(cNAME5)
            @ 12,11 SAY "Other ...........:"                GET PRICES->FIELD5
         ELSE
            @ 12,11 SAY cNAME5+" "+REPLICATE(".",16-LEN(cNAME5))+":" GET PRICES->FIELD5
         ENDIF
         IF EMPTY(cNAME6)
            @ 13,11 SAY "Other ...........:"                GET PRICES->FIELD6
         ELSE
            @ 13,11 SAY cNAME6+" "+REPLICATE(".",16-LEN(cNAME6))+":" GET PRICES->FIELD6
         ENDIF
         IF EMPTY(cNAME7)
            @ 14,11 SAY "Other ...........:"                GET PRICES->FIELD7
         ELSE
            @ 14,11 SAY cNAME7+" "+REPLICATE(".",16-LEN(cNAME7))+":" GET PRICES->FIELD7
         ENDIF
         @ 15,11 SAY "Value, Low ......:" GET PRICES->VALUE_LOW
         @ 16,11 SAY "Value, Med ......:" GET PRICES->VALUE_MED
         @ 17,11 SAY "Value, High .....:" GET PRICES->VALUE_HI
         @ 18,10 SAY "ддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд"
         @ 19,11 SAY "Reference # .....:" GET PRICES->REFERENCE
         CLEAR GETS
         PAUSE(20)
      ENDCASE
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
      oTBROWSE:REFRESHALL()
   CASE nKEY == 83
      SAVE SCREEN TO cSCREEN
      SET CURSOR ON
      SETCOLOR(POP_COLOR)
      zBOX(11,20,15,60,BK2_COLOR)
      cSEARCH := cSEARCH + SPACE(20 - LEN(cSEARCH))
      @ 12,25 SAY "Search For" GET cSEARCH PICTURE "@!"
      @ 14,22 SAY "(Search starts after current record.)"
      IF LEN(RTRIM(cSEARCH)) > 0
         KEYBOARD CHR(K_END)
      ENDIF
      SET CURSOR ON
      READ
      SET CURSOR OFF
      IF LASTKEY() <> 27 .AND. ! EMPTY(cSEARCH)
         nRECNO  := RECNO()
         SKIP
         cSEARCH := UPPER(LTRIM(RTRIM(cSEARCH)))
         lFOUND  := .F.
         DO WHILE ! lFOUND .AND. ! EOF()
            DO CASE
          * CASE nMAG = 1 .AND. cSEARCH$UPPER(GAME + SERIES + NAME + STR(VALUE_MED,8,2))
            CASE nMAG = 1 .AND. cSEARCH$UPPER(SERIES + NAME + COLOR + STR(VALUE_MED,8,2))
               lFOUND   := .T.
            CASE nMAG = 2 .AND. cSEARCH$UPPER(NAME + STR(VALUE_MED,8,2))
               lFOUND   := .T.
            OTHERWISE
               SKIP
            ENDCASE
         ENDDO
         IF ! lFOUND
            TONE(900,2)
            GO nRECNO
         ENDIF
      ENDIF
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
      oTBROWSE:REFRESHALL()
   CASE nKEY == 79 .or. nKEY == K_TAB
      nRECNO := RECNO()
      DO CASE
      CASE nMAG = 1
         nORDER := IF(nORDER = 3,1,nORDER + 1)
         DO CASE
         CASE nORDER = 1
            @ 4,2  SAY "  Series/Set              Name/Description                Type     Value "
         CASE nORDER = 2
            @ 4,2  SAY "   Series/Set              Name/Description               Type     Value "
         CASE nORDER = 3
            @ 4,2  SAY "   Series/Set               Name/Description                Type    Value"
         ENDCASE
      CASE nMAG = 2
         DO CASE
       * CASE nORDER = 1 .AND. EMPTY(cNAME2)
         CASE nORDER = 1 .AND. EMPTY(IF(nMAX2 > 2,cNAME2,IF(nMAX3 > 2,cNAME3,IF(nMAX4 > 2,cNAME4,cNAME2))))
            nORDER := 3
         CASE nORDER = 5
            nORDER := 1
         OTHERWISE
            nORDER++
         ENDCASE

       * nORDER := IF(nORDER = 5,1,nORDER + 1)

         DO CASE
         CASE nORDER = 1
            @  4,2  SAY "                Name/Description                  High $   Med $   Low $ "
         CASE nORDER = 2
            @  4,2  SAY "                Name/Description                 High $   Med $   Low $ "
         CASE nORDER = 3
            @  4,2  SAY "                 Name/Description                  High $  Med $   Low $ "
         CASE nORDER = 4
            @  4,2  SAY "                 Name/Description                   High $  Med $  Low $ "
         CASE nORDER = 5
            @  4,2  SAY "                 Name/Description                   High $   Med $  Low $"
         ENDCASE
      ENDCASE
      GO nRECNO
      SET ORDER TO nORDER
      oTBROWSE:REFRESHALL()
   CASE nKEY == 82
      SAVE SCREEN TO cSCREEN
      oTBROWSE:AUTOLITE := .F.
      oTBROWSE:REFRESHALL()
      oTBROWSE:FORCESTABLE()
      cNEWSET := PICK_SET(1)
      IF ! EMPTY(cNEWSET)
         cSET      := cNEWSET
         cGUIDEDBF := cPICKDBF
      ENDIF
      SETCOLOR(MAIN_COLOR)
      IF ! EMPTY(cSET)
         RESTORE SCREEN FROM cSCREEN
         @ 2,1 SAY SPACE(77)         COLOR HEAD_COLOR
         @ 2,40-LEN(cSET)/2 SAY cSET COLOR HEAD_COLOR
         nORDER := 1
         DO CASE
         CASE nMAG = 1
            @  4,2  SAY "  Series/Set              Name/Description                Type     Value "
            @  5,2  SAY "дддддддддддддддд дддддддддддддддддддддддддддддддддддддддд ддддддддд ддддддд"
            oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+SERIES+"  "+NAME+" "+COLOR+STR(VALUE_MED,12,2)+" "}))
         CASE nMAG = 2
            @  4,2  SAY "                Name/Description                  High $   Med $   Low $ "
            @  5,2  SAY "дддддддддддддддддддддддддддддддддддддддддддддддддд дддддддд ддддддд ддддддд"
            DO CASE
            CASE nMAX2 > 2
               oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD2,nMAX2)+SPACE(48-nMAX1-nMAX2)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
            CASE nMAX3 > 2
               oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD3,nMAX3)+SPACE(48-nMAX1-nMAX3)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
            CASE nMAX4 > 2
               oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD4,nMAX4)+SPACE(48-nMAX1-nMAX4)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
            OTHERWISE
               oTBROWSE:SETCOLUMN(1,TBCOLUMNNEW("",{||" "+LEFT(NAME,nMAX1)+" "+LEFT(FIELD2,nMAX2)+SPACE(48-nMAX1-nMAX2)+STR(VALUE_HI,9,2)+STR(VALUE_MED,8,2)+STR(VALUE_LOW,8,2)+" "}))
            ENDCASE
         ENDCASE
         oTBROWSE:GOTOP()
      ELSE
         RESTORE SCREEN FROM cSCREEN
      ENDIF
      oTBROWSE:AUTOLITE := .T.
      oTBROWSE:REFRESHALL()

 * CASE nKEY == 68 .AND. (("MAGIC"$UPPER(cSET) .AND. "GATHERING"$UPPER(cSET)) .OR. "SCRYE"$UPPER(cSET))
   CASE nKEY == 68
      SAVE SCREEN TO cSCREEN
      SETCOLOR(POP_COLOR)
      zBOX(11,17,16,61,BK2_COLOR,"Deck Daemon Options")
      @ 13,18 PROMPT " Interface with Deck Daemon, Using CONJURE "
      @ 14,18 PROMPT " Interface with Deck Daemon, Using SCRYE   "
      @ 15,18 PROMPT " Convert Scrye Files to the .COD Format    "
      MENU TO nDAEMON
      DO CASE
      CASE (nDAEMON = 1 .AND. ("MAGIC"$UPPER(cSET) .AND. "GATHERING"$UPPER(cSET))) .or. ;
           (nDAEMON = 2 .AND. FILE("SCRYE.COD"))

         SETCOLOR(POP_COLOR)
         IF nDAEMON = 1
            zBOX(11,6,16,73,BK2_COLOR,"Interfacing with Deck Daemon (TM) using CONJURE")
         ELSE
            zBOX(11,6,16,73,BK2_COLOR,"Interfacing with Deck Daemon (TM) using SCRYE")
         ENDIF
         lBADPATH := .T.
         DO WHILE lBADPATH .AND. LASTKEY() <> 27
            cDPATH  := LTRIM(RTRIM(cDPATH))
            cDPATH  := cDPATH + SPACE(28 - LEN(cDPATH))
            lALPHA  := .F.
            cSOURCE := ""
            IF ! EMPTY(cDPATH)
               KEYBOARD CHR(K_END)
            ENDIF
            @ 13,8  SAY "Deck Daemon Data Files Path ......:" GET cDPATH   PICTURE "@!"
            @ 14,8  SAY "Using Alpha, Beta, Rvsd, etc.? ...: [ ]"
            @ 14,45                                           GET lALPHA  PICTURE "Y"
            @ 15,8  SAY "Select the Report Destination ....: Screen"
            SET CURSOR ON
            READ
            SET CURSOR OFF
            IF ! EMPTY(cDPATH) .AND. LASTKEY() <> 27
               cDPATH := LTRIM(RTRIM(UPPER(cDPATH)))
               IF ! FILE(cDPATH + "DAEMON1.DD") .OR. ! FILE(cDPATH + "DAEMON2.DD") .OR. ! FILE(cDPATH + "DAEMON3.DD") .OR. ! FILE(cDPATH + "DAEMON4.DD")
                  IF ! FILE(cDPATH + "\DAEMON1.DD") .OR. ! FILE(cDPATH + "\DAEMON2.DD") .OR. ! FILE(cDPATH + "\DAEMON3.DD") .OR. ! FILE(cDPATH + "\DAEMON4.DD")
                     SAVE SCREEN TO cSCREEN2
                     HELPIT("Sorry : Required DECK DAEMON file(s) are missing from that directory.")
                     RESTORE SCREEN FROM cSCREEN2
                  ELSE
                     cDPATH    := cDPATH + "\"
                     lBADPATH := .F.
                  ENDIF
               ELSE
                  lBADPATH := .F.
               ENDIF
            ENDIF
         ENDDO

         IF ! lBADPATH
            @ 15,8  SAY "Select the Report Destination ....: Screen    /  Selects"
            @ 15,43 PROMPT " Screen  "
            @ 15,43 PROMPT " File    "
            @ 15,43 PROMPT " Printer "
            nOUTPUT := 1
            MENU TO nOUTPUT
            DO CASE
            CASE nOUTPUT = 0
               lBADPATH := .T.
            CASE nOUTPUT = 2
               cOUTPUT := "DAEMON.REP          "
               KEYBOARD CHR(K_END)
               @ 15,8 SAY "Enter File Name ..................:                       "
               @ 15,8 SAY "Enter File Name ..................:" GET cOUTPUT PICTURE "@!"
               SET CURSOR ON
               READ
               SET CURSOR OFF
               IF EMPTY(cOUTPUT) .OR. LASTKEY() = 27
                  lBADPATH := .T.
               ENDIF

               * Check drive status

            CASE nOUTPUT = 3
               @ 15,8 SAY "Select Printer Port ..............: LPT1      /  Selects"
               @ 15,43 PROMPT " LPT1 "
               @ 15,43 PROMPT " LPT2 "
               @ 15,43 PROMPT " LPT3 "
               @ 15,43 PROMPT " LPT4 "
               @ 15,43 PROMPT " COM1 "
               @ 15,43 PROMPT " COM2 "
               nPORT := 1
               MENU TO nPORT
               IF nPORT = 0
                  lBADPATH := .T.
               ENDIF
            ENDCASE
         ENDIF

         IF ! lBADPATH

            @ 13,8 CLEAR TO 15,71

            * Create Temporary Databases

            @ 14,15 SAY "Please Wait ... Creating Temporary Database     "
            CREATEDBF(cPATH+"SUMMARY.DD",DAEMON12)
            USE (cPATH+"SUMMARY.DD") NEW EXCLUSIVE ALIAS SUMMARY
            USE (cDPATH+"DAEMON2.DD") NEW EXCLUSIVE ALIAS SUPPORT

            * Append CARDS from Existing Database

            @ 14,15 SAY "Please Wait ... Appending CARDS from Deck Daemon"
            SELECT SUMMARY
            APPEND FROM (cDPATH+"DAEMON1.DD") FOR ! EMPTY(SERIES) .AND. ! EMPTY(CARD)

            * Append DECKS from Existing Database

            @ 14,15 SAY "Please Wait ... Appending DECKS from Deck Daemon"
            nDECKS := 0
            SELECT SUMMARY
            USE (cDPATH+"DAEMON1.DD") NEW EXCLUSIVE ALIAS DAEMON
            INDEX ON REFERENCE TO (cPATH+"DDTEMP.DD")
            USE (cDPATH+"DAEMON3.DD") NEW EXCLUSIVE ALIAS DECKS
            USE (cDPATH+"DAEMON4.DD") NEW EXCLUSIVE ALIAS DECKLINK
            GO TOP
            DO WHILE ! EOF()
               IF DECKLINK->DECK > 0 .AND. DECKLINK->CARD > 0 .AND. DECKLINK->QUANTITY > 0

                  * Lookup Deck Name

                  SELECT DECKS
                  LOCATE FOR DECKS->NUMBER = DECKLINK->DECK
                  cDECK := IF(FOUND(),DECK,"Unknown Deck #" + STR(DECKLINK->DECK,3) + "   ")

                  * Lookup Card Name

                  SELECT DAEMON
                  SEEK DECKLINK->CARD
                  IF FOUND()
                     SELECT SUMMARY
                     APPEND BLANK
                     SUMMARY->DECK     := cDECK
                     SUMMARY->SERIES   := DAEMON->SERIES
                     SUMMARY->COLOR    := DAEMON->COLOR
                     SUMMARY->TYPE     := DAEMON->TYPE
                     SUMMARY->FLAGS    := DAEMON->FLAGS
                     SUMMARY->CARD     := DAEMON->CARD
                     SUMMARY->QUANTITY := DECKLINK->QUANTITY
                     nDECKS := nDECKS + 1
                  ENDIF
                  SELECT DECKLINK
               ENDIF
               SKIP
            ENDDO
            CLOSE DAEMON
            CLOSE DECKS
            CLOSE DECKLINK

            * Load Price Values from Conjure

            @ 14,15 SAY "Please Wait ... Applying Price Guide's Prices   "
            SELECT SUMMARY
            INDEX ON UPPER(SERIES + CARD) TO (cPATH+"SUMMARY1.DD")
            INDEX ON UPPER(CARD)          TO (cPATH+"SUMMARY2.DD")
            SET INDEX TO (cPATH+"SUMMARY1.DD"), (cPATH+"SUMMARY2.DD")

            IF nDAEMON = 1
               SELECT PRICES
               COPY ALL TO (cPATH+"COMPARE.DD")
               USE (cPATH+"COMPARE.DD") NEW EXCLUSIVE ALIAS COMPARE
            ELSE
             * SELECT PRICES
             * COPY NEXT 0 TO (cPATH+"COMPARE.DD")
               CREATEDBF("COMPARE.DD",CONJURE1 + CONJURE2)
               USE (cPATH+"COMPARE.DD") NEW EXCLUSIVE ALIAS COMPARE
               APPEND FROM (cPATH+"SCRYE.COD") SDF
            ENDIF
            cSOURCE := SOURCE

            SELECT COMPARE
            GO TOP
            DO WHILE ! EOF()
               SET EXACT OFF
               DO CASE
               CASE UPPER(SERIES) = "ANTIQUITIES";                  cKEY := "ANTQ"
               CASE UPPER(SERIES) = "ARABIAN NIGHTS";               cKEY := "ARAB"
               CASE UPPER(SERIES) = "FALLEN EMPIRES";               cKEY := "FALL"
               CASE UPPER(SERIES) = "LEGENDS";                      cKEY := "LGND"
               CASE UPPER(SERIES) = "THE DARK";                     cKEY := "DARK"
               CASE UPPER(SERIES) = "UNLIMITED" .AND. ! lALPHA;     cKEY := "M:TG"
               CASE UPPER(SERIES) = "REVISED"   .AND. ! lALPHA;     cKEY := "M:TG"
               CASE UPPER(SERIES) = "UNLIMITED"       .AND. lALPHA; cKEY := "UNLT"
               CASE UPPER(SERIES) = "REVISED"         .AND. lALPHA; cKEY := "RVSD"
               CASE UPPER(SERIES) = "ALPHA UNLIMITED" .AND. lALPHA; cKEY := "ALPH"
               CASE UPPER(SERIES) = "BETA UNLIMITED"  .AND. lALPHA; cKEY := "BETA"
               CASE UPPER(SERIES) = "LIMITED"         .AND. lALPHA; cKEY := "LMTD"
               OTHERWISE;                                           cKEY := ""
               ENDCASE
               SET EXACT ON

               * Look for Revised Cards (*)

               DO CASE
               CASE UPPER(COMPARE->SERIES) = "REVISED" .AND. ! EMPTY(cKEY) .AND. ! lALPHA
                  cNAME := LEFT(COMPARE->NAME,30)
                  cNAME := UPPER(LTRIM(RTRIM(cNAME))) + " *"
                  cNAME := cNAME + SPACE(30 - LEN(cNAME))
                  SELECT SUMMARY
                  SET ORDER TO 2
                  SEEK cNAME
                  IF FOUND()
                     DO WHILE (UPPER(SUMMARY->CARD) = cNAME .AND. ! EOF())
                        SUMMARY->VALUE := COMPARE->VALUE_MED
                        SKIP
                     ENDDO
                  ELSE
                     cNAME := UPPER(LTRIM(RTRIM(cNAME))) + "*"
                     cNAME := cNAME + SPACE(30 - LEN(cNAME))
                     SEEK cNAME
                     IF FOUND()
                        DO WHILE (UPPER(SUMMARY->CARD) = cNAME .AND. ! EOF())
                           SUMMARY->VALUE := COMPARE->VALUE_MED
                           SKIP
                        ENDDO
                     ENDIF
                  ENDIF
             * CASE UPPER(COMPARE->SERIES) <> "REVISED" .AND. ! EMPTY(cKEY)
               CASE ! EMPTY(cKEY)
                  cNAME := UPPER(LEFT(COMPARE->NAME,30))
                  cNAME := LTRIM(RTRIM(cNAME))
                  cNAME := cNAME + SPACE(30 - LEN(cNAME))
                  SELECT SUMMARY
                  SET ORDER TO 1
                  SEEK cKEY + cNAME
                  IF FOUND()
                     DO WHILE (UPPER(SUMMARY->SERIES) = cKEY .AND. UPPER(SUMMARY->CARD) = cNAME .AND. ! EOF())
                        SUMMARY->VALUE := COMPARE->VALUE_MED
                        SKIP
                     ENDDO
                  ELSE
                     SET EXACT OFF
                     cNAME := UPPER(LTRIM(LEFT(COMPARE->NAME,30)))

                     DO CASE
                     CASE cNAME = "ADUN OAKENSHIELD"              ; cNAME := "ADUM OAKENSHIELD"
                     CASE cNAME = "BADLANDS"                      ; cNAME := "BADLANDS  (BLACK/RED)"
                     CASE cNAME = "BAYOU"                         ; cNAME := "BAYOU (BLACK/GREEN)"
                     CASE cNAME = "FUNGUSAUR"                     ; cNAME := "FUNGASAUR"
                     CASE cNAME = "HASRAN OGRESS"                 ; cNAME := "HASRAN OGRES"
                     CASE cNAME = "MERFOLK OF THE PEARL TRIDENT"  ; cNAME := "MERFOLK OF THE PEARLED TRIDENT"
                     CASE cNAME = "NAFS ASP"                      ; cNAME := "NAF'S ASP"
                     CASE cNAME = "OUBLIETTE"                     ; cNAME := "OUBILETTE"
                     CASE cNAME = "PLATEAU"                       ; cNAME := "PLATEAU (RED/WHITE)"
                     CASE cNAME = "PRODIGAL SORCERER"             ; cNAME := "PRODIGAL SORCEROR"
                     CASE cNAME = "ROC OF KHER RIDGES"            ; cNAME := "ROC OF KHER RIDGE"
                     CASE cNAME = "ROYAL ASSASSIN"                ; cNAME := "ROYAL ASSASIN"
                     CASE cNAME = "SAVANNAH"                      ; cNAME := "SAVANNAH (GREEN/WHITE)"
                     CASE cNAME = "SCRUBLAND"                     ; cNAME := "SCRUBLAND (BLACK/WHITE)"
                     CASE cNAME = "SINDBAD"                       ; cNAME := "SINBAD"
                     CASE cNAME = "TAIGA"                         ; cNAME := "TAIGA (GREEN/RED)"
                     CASE cNAME = "THE TABERNACLE AT PENDRELL VAL"; cNAME := "TABERNACLE AT PENDRELL VALE"
                     CASE cNAME = "TROPICAL ISLAND"               ; cNAME := "TROPICAL ISLAND (GREEN/BLUE)"
                     CASE cNAME = "TUNDRA"                        ; cNAME := "TUNDRA (BLUE/WHITE)"
                     CASE cNAME = "TWO-HEADED GIANT OF FORIYS"    ; cNAME := "TWO-HEADED GIANT OF FORYIIS"
                     CASE cNAME = "UNDERGROUND SEA"               ; cNAME := "UNDERGROUND SEA (BLACK/BLUE)"
                     CASE cNAME = "VOLCANIC ISLAND"               ; cNAME := "VOLCANIC ISLAND (RED/BLUE)"
                     CASE cNAME = "CURSED RACK"                   ; cNAME := "CURSED RACK *"
                     CASE cNAME = "DETONATE"                      ; cNAME := "DETONATE *"
                     CASE cNAME = "GRAPESHOT CATAPULT"            ; cNAME := "GRAPESHOT CATAPULT *"
                     CASE cNAME = "MILLSTONE"                     ; cNAME := "MILLSTONE *"
                     CASE cNAME = "SANDALS OF ABDALLAH"           ; cNAME := "SANDALS OF ABDALLAH *"
                     ENDCASE

                     SET EXACT ON
                     cNAME := cNAME + SPACE(30 - LEN(cNAME))
                     SEEK cKEY + cNAME
                     IF FOUND()
                        DO WHILE (UPPER(SUMMARY->SERIES) = cKEY .AND. UPPER(SUMMARY->CARD) = cNAME .AND. ! EOF())
                           SUMMARY->VALUE := COMPARE->VALUE_MED
                           SKIP
                        ENDDO
                     ENDIF
                  ENDIF
               ENDCASE

               SELECT COMPARE
               SKIP
            ENDDO

            * Write to Text File

            DO CASE
            CASE nOUTPUT = 1
               @ 14,15 SAY "Please Wait ... Writing Output to Preview File  "
            CASE nOUTPUT = 2
               @ 14,15 SAY "Please Wait ... Generating ASCII Text File      "
            CASE nOUTPUT = 3
               @ 14,15 SAY "Please Wait ... Printing in Progress            "
            ENDCASE
            nCARDS   := 0
            nWVALUE  := 0
            nTOTQTY  := 0
            nTOTVAL  := 0
            nTOTTOT  := 0
            nGCARDS  := 0
            nGWVALUE := 0
            nGTOTQTY := 0
            nGTOTVAL := 0
            nGTOTTOT := 0
            cLASTSET := ""
            SET PRINTER TO (cPATH + PREV_FILE)
            SET CONSOLE OFF
            SET PRINT ON

            ? SPACE(21) + "Card, Deck and Collection Prices"
            ?
            ? SPACE(18) + "Source of Prices : " + cSOURCE
            ?
            ?

            SELECT SUMMARY
            INDEX ON UPPER(DECK + SERIES + CARD + STR(VALUE,10,2)) TO (cPATH+"SUMMARY1.DD")
            GO TOP
            DO WHILE ! EOF()
               IF EMPTY(DECK)
                  IF cLASTSET <> UPPER(SERIES) .OR. cLASTSET = ""
                     IF ! EMPTY(cLASTSET)
                        IF (nOUTPUT = 1)
                           ? "дддддддддддддддддддддддддддддд                дддд   ддддддддд   ддддддддд"
                        ELSE
                           ? "------------------------------                ----   ---------   ---------"
                        ENDIF
                        ? STR(nCARDS,5) + " Different Cards" + STR(nTOTQTY,29) + STR(nTOTVAL/nWVALUE,12,2) + "av" + STR(nTOTTOT,10,2)
                        ?
                        ?
                        nCARDS  := 0
                        nWVALUE := 0
                        nTOTQTY := 0
                        nTOTVAL := 0
                        nTOTTOT := 0
                     ENDIF

                     * Lookup Long Series Name

                     SELECT SUPPORT
                     LOCATE FOR UPPER(SUPPORT->TYPE) = "S" .AND. UPPER(SUPPORT->SHORT) = UPPER(SUMMARY->SERIES)
                     IF FOUND()
                        ? "Series/Set : " + LTRIM(RTRIM(SUPPORT->NAME)) + " (" + UPPER(LTRIM(RTRIM(SUMMARY->SERIES))) + ")"
                     ELSE
                        ? "Series/Set : " + SUMMARY->SERIES
                     ENDIF
                     SELECT SUMMARY
                     ?
                     ? "Card Name                      Color Rarity   Qty.     Value       Total"
                     IF (nOUTPUT = 1)
                        ? "дддддддддддддддддддддддддддддд ддддд дддддддд дддд   ддддддддд   ддддддддд"
                     ELSE
                        ? "------------------------------ ----- -------- ----   ---------   ---------"
                     ENDIF
                  ENDIF
                  ? CARD + " " + COLOR + " "
                  DO CASE
                  CASE LEFT(FLAGS,1) = "C"; ?? "Common  "
                  CASE LEFT(FLAGS,1) = "U"; ?? "Uncommon"
                  CASE LEFT(FLAGS,1) = "R"; ?? "Rare    "
                  OTHERWISE
                     ?? "        "
                  ENDCASE
                  ?? STR(QUANTITY,5) + " x" + IF(VALUE = 0,"    n/a   ",STR(VALUE,10,2))
                  ?? " =" + IF(VALUE = 0,"    n/a   ",STR(QUANTITY * VALUE,10,2))
                  nCARDS++
                  nWVALUE  := nWVALUE + IF(VALUE = 0,0,1)
                  nTOTQTY  := nTOTQTY + QUANTITY
                  nTOTVAL  := nTOTVAL + VALUE
                  nTOTTOT  := nTOTTOT + (QUANTITY * VALUE)
                  nGCARDS++
                  nGWVALUE := nGWVALUE + IF(VALUE = 0,0,1)
                  nGTOTQTY := nGTOTQTY + QUANTITY
                  nGTOTVAL := nGTOTVAL + VALUE
                  nGTOTTOT := nGTOTTOT + (QUANTITY * VALUE)
                  cLASTSET := UPPER(SERIES)
               ENDIF
               SKIP
            ENDDO

            * Print Final Totals

            IF (nOUTPUT = 1)
               ? "дддддддддддддддддддддддддддддд                дддд   ддддддддд   ддддддддд"
            ELSE
               ? "------------------------------                ----   ---------   ---------"
            ENDIF
            ? STR(nCARDS,5) + " Different Cards" + STR(nTOTQTY,29) + STR(nTOTVAL/nWVALUE,12,2) + "av" + STR(nTOTTOT,10,2)
            ?
            IF (nOUTPUT = 1)
               ? "мммммммммммммммммммммммммммммм                мммм   ммммммммм   ммммммммм"
            ELSE
               ? "==============================                ====   =========   ========="
            ENDIF
            ? STR(nGCARDS,5) + " Total Different Cards" + STR(nGTOTQTY,23) + STR(nGTOTVAL/nGWVALUE,12,2) + "av" + STR(nGTOTTOT,10,2)

            * Print Decks

            IF nDECKS > 0
               ?
               ? REPLICATE(IF(nOUTPUT = 1,"д","-"),74)
               ? SPACE(28) + "Inventory of Decks"
               ? REPLICATE(IF(nOUTPUT = 1,"д","-"),74)
               ?
               nCARDS   := 0
               nWVALUE  := 0
               nTOTQTY  := 0
               nTOTVAL  := 0
               nTOTTOT  := 0
               nGCARDS  := 0
               nGWVALUE := 0
               nGTOTQTY := 0
               nGTOTVAL := 0
               nGTOTTOT := 0
               cLASTSET := ""
               SELECT SUMMARY
               SET ORDER TO 1
               GO TOP
               DO WHILE ! EOF()
                  IF ! EMPTY(DECK)
                     IF cLASTSET <> UPPER(DECK) .OR. cLASTSET = ""
                        IF ! EMPTY(cLASTSET)
                           IF (nOUTPUT = 1)
                              ? "дддддддддддддддддддддддддддддд                дддд   ддддддддд   ддддддддд"
                           ELSE
                              ? "------------------------------                ----   ---------   ---------"
                           ENDIF
                           ? STR(nCARDS,5) + " Different Cards" + STR(nTOTQTY,29) + STR(nTOTVAL/nWVALUE,12,2) + "av" + STR(nTOTTOT,10,2)
                           ?
                           ?
                           nCARDS  := 0
                           nWVALUE := 0
                           nTOTQTY := 0
                           nTOTVAL := 0
                           nTOTTOT := 0
                        ENDIF
                        ? "Deck Name : " + UPPER(DECK)
                        ?
                        ? "Card Name                      Color Rarity   Qty.     Value       Total"
                        IF (nOUTPUT = 1)
                           ? "дддддддддддддддддддддддддддддд ддддд дддддддд дддд   ддддддддд   ддддддддд"
                        ELSE
                           ? "------------------------------ ----- -------- ----   ---------   ---------"
                        ENDIF
                     ENDIF
                     ? CARD + " " + COLOR + " "
                     DO CASE
                     CASE LEFT(FLAGS,1) = "C"; ?? "Common  "
                     CASE LEFT(FLAGS,1) = "U"; ?? "Uncommon"
                     CASE LEFT(FLAGS,1) = "R"; ?? "Rare    "
                     OTHERWISE
                        ?? "        "
                     ENDCASE
                     ?? STR(QUANTITY,5) + " x" + IF(VALUE = 0,"    n/a   ",STR(VALUE,10,2))
                     ?? " =" + IF(VALUE = 0,"    n/a   ",STR(QUANTITY * VALUE,10,2))
                     nCARDS++
                     nWVALUE  := nWVALUE + IF(VALUE = 0,0,1)
                     nTOTQTY  := nTOTQTY + QUANTITY
                     nTOTVAL  := nTOTVAL + VALUE
                     nTOTTOT  := nTOTTOT + (QUANTITY * VALUE)
                     nGCARDS++
                     nGWVALUE := nGWVALUE + IF(VALUE = 0,0,1)
                     nGTOTQTY := nGTOTQTY + QUANTITY
                     nGTOTVAL := nGTOTVAL + VALUE
                     nGTOTTOT := nGTOTTOT + (QUANTITY * VALUE)
                     cLASTSET := UPPER(DECK)
                  ENDIF
                  SKIP
               ENDDO

               * Print Final Totals

               IF (nOUTPUT = 1)
                  ? "дддддддддддддддддддддддддддддд                дддд   ддддддддд   ддддддддд"
               ELSE
                  ? "------------------------------                ----   ---------   ---------"
               ENDIF
               ? STR(nCARDS,5) + " Different Cards" + STR(nTOTQTY,29) + STR(nTOTVAL/nWVALUE,12,2) + "av" + STR(nTOTTOT,10,2)
               ?
               IF (nOUTPUT = 1)
                  ? "мммммммммммммммммммммммммммммм                мммм   ммммммммм   ммммммммм"
               ELSE
                  ? "==============================                ====   =========   ========="
               ENDIF
               ? STR(nGCARDS,5) + " Total Different Cards" + STR(nGTOTQTY,23) + STR(nGTOTVAL/nGWVALUE,12,2) + "av" + STR(nGTOTTOT,10,2)
            ENDIF

            * Print Notes

            ?
            ?
            ? "Notes"
            ?
            IF lALPHA
               ? " a) Missing values (n/a) may be user changed/added cards or misspellings."
            ELSE
               ? " a) Revised cards (*) have been assigned their Expansion set price"
               ? " b) Missing values (n/a) may be user changed/added cards or misspellings."
            ENDIF
            SET PRINT OFF
            SET PRINTER TO
            SET CONSOLE ON

            * Finishing Touches

            @ 14,15 SAY "Please Wait ... Finishing Up                    "
            CLOSE SUMMARY
            CLOSE SUPPORT
            ERASE(cPATH+"SUMMARY.DD")
            ERASE(cPATH+"DDTEMP.DD")
            ERASE(cPATH+"SUMMARY1.DD")
            ERASE(cPATH+"SUMMARY2.DD")
            CREATEDBF(cPATH+"PREVIEW.DD","LINE,C 75 0")
            USE (cPATH+"PREVIEW.DD") NEW EXCLUSIVE ALIAS PREVIEW
            APPEND FROM (cPATH + PREV_FILE) SDF
            GO TOP
            DELETE
            GO TOP

            * Bring up the Preview Screen

            IF nOUTPUT = 1
               SETCOLOR(HEAD_COLOR)
               @ 2,1   CLEAR TO 2,78
               @ 2,24  SAY "Deck Daemon (TM) Inventory Value"
               SETCOLOR(MAIN_COLOR)
               @ 3,1   CLEAR TO 22,78
               @ 24,0  CLEAR TO 24,79
               @ 24,11 SAY "Commands : [], [], [PgUp], [PgDn], [Esc] Returns"
               oRBROWSE := TBROWSEDB(4,3,21,77)
               oRBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||LINE}))
               oRBROWSE:AUTOLITE := .F.
               lVIEWING := .T.
               DO WHILE lVIEWING
                  oRBROWSE:FORCESTABLE()
                  nKEY := ASC(UPPER(CHR(INKEY(0))))
                  DO CASE
                  CASE nKEY == K_ESC .or. nKEY == K_ENTER
                     lVIEWING := .F.
                  CASE nKEY == K_DOWN
                     IF oRBROWSE:ROWPOS < 19; oRBROWSE:ROWPOS := 19; ENDIF
                     oRBROWSE:DOWN()
                  CASE nKEY == K_UP
                     IF oRBROWSE:ROWPOS > 1;  oRBROWSE:ROWPOS := 1;  ENDIF
                     oRBROWSE:UP()
                  CASE nKEY == K_PGDN
                     oRBROWSE:PAGEDOWN()
                  CASE nKEY == K_PGUP
                     oRBROWSE:PAGEUP()
                  CASE nKEY == K_HOME
                     oRBROWSE:GOTOP()
                  CASE nKEY == K_END
                     oRBROWSE:GOBOTTOM()
                  ENDCASE
               ENDDO
            ELSE
               SET PRINTER TO (cOUTPUT)
               SET CONSOLE OFF
               SET PRINT ON
               SELECT PREVIEW
               GO TOP
               DO WHILE ! EOF()
                  ? "   " + LINE
                  SKIP
               ENDDO
               ?? CHR(12)
               SET PRINT OFF
               SET CONSOLE ON
               SET PRINTER TO
            ENDIF
            CLOSE COMPARE
            CLOSE PREVIEW
            ERASE(cPATH+"COMPARE.DD")
            ERASE(cPATH+"PREVIEW.DD")
            ERASE(cPATH+PREV_FILE)
            SELECT PRICES
            GO TOP
         ENDIF
      CASE nDAEMON = 3 .AND. "SCRYE"$UPPER(cSET)
         SETCOLOR(POP_COLOR)
         zBOX(9,9,21,69,BK2_COLOR,"Converting Scrye Price Guides to .COD Format")
         IF ! FILE("MASTER.DD")
            TONE(900,2)
            @ 13,21 SAY "Sorry : The file MASTER.DD is missing."
            @ 15,18 SAY "Please re-install it from the original disk."
            @ 17,27 SAY "Press any key to continue."
            INKEY(0)
         ELSE
            @ 11,11 SAY "Conversion Start Time ... 12:12:12, Stop Time ..."
            @ 11,37 SAY TIME() COLOR SHOW_COLOR
            @ 12,10 SAY REPLICATE("д",59)
            @ 13,11 SAY "Step 1 : Open Files ....."

            * First, Generate SCRYE.DBF

            CLOSE PRICES
            CREATEDBF("SCRYE.DBF",FSTRUCT1 + FSTRUCT2)
            USE SCRYE.DBF NEW EXCLUSIVE ALIAS SCRYE
            ZAP
            @ 13,37 SAY "Done" COLOR SHOW_COLOR

            @ 14,11 SAY "Step 2 : Price Guides ..."
            FOR nX := 1 TO LEN(aMTG)
               @ 14,37 SAY LTRIM(LEFT(aMTG[nX],31)) COLOR SHOW_COLOR
               PICK_SET(0,LTRIM(LEFT(aMTG[nX],AT(".",aMTG[nX])+3)))
               SELECT PRICES
               GO TOP
               DO WHILE ! EOF()
                  SELECT SCRYE
                  APPEND BLANK
                  SCRYE->GAME   := "M:TG"
                  SCRYE->SERIES := SUBSTR(aMTG[nX],17,15)
                  SCRYE->TYPE   := "C"
                  SCRYE->NAME   := PRICES->NAME

                  DO CASE
                  CASE UPPER(PRICES->FIELD2) = "ARTIFACT"; SCRYE->COLOR := "Beige"
                  CASE UPPER(PRICES->FIELD2) = "LAND";     SCRYE->COLOR := "Beige"
                  CASE "/"$UPPER(PRICES->FIELD2);          SCRYE->COLOR := "Beige"
                  OTHERWISE;                               SCRYE->COLOR := PRICES->FIELD2
                  ENDCASE

                  IF "FALLEN EMPIRES"$UPPER(SUBSTR(aMTG[nX],17,15))
                     DO CASE
                     CASE UPPER(PRICES->FIELD3) = "UNCOMMON"; SCRYE->RARITY := "U"
                     CASE UPPER(PRICES->FIELD3) = "COMMON";   SCRYE->RARITY := "C"
                     CASE UPPER(PRICES->FIELD3) = "RARE";     SCRYE->RARITY := "R"
                     OTHERWISE;                               SCRYE->RARITY := PRICES->FIELD4
                     ENDCASE
                  ELSE
                     DO CASE
                     CASE UPPER(PRICES->FIELD4) = "UNCOMMON"; SCRYE->RARITY := "U"
                     CASE UPPER(PRICES->FIELD4) = "COMMON";   SCRYE->RARITY := "C"
                     CASE UPPER(PRICES->FIELD4) = "RARE";     SCRYE->RARITY := "R"
                     OTHERWISE;                               SCRYE->RARITY := PRICES->FIELD4
                     ENDCASE
                  ENDIF

                * SCRYE->SOURCE    := LTRIM(LEFT(cSET,AT("/",cSET)-1))
                  SCRYE->VALUE_LOW := PRICES->VALUE_LOW
                  SCRYE->VALUE_MED := PRICES->VALUE_MED
                  SCRYE->VALUE_HI  := PRICES->VALUE_HI
                  SELECT PRICES
                  SKIP
               ENDDO
               CLOSE PRICES
            NEXT nX
            @ 14,37 SAY "Done (" + LTRIM(STR(LEN(aMTG),2)) + " Price Guides)         " COLOR SHOW_COLOR

            * Next, open and initialize MASTER.DD

            @ 15,11 SAY "Step 3 : Initializing ..."
            USE MASTER.DD NEW EXCLUSIVE ALIAS DAEMON
            REPLACE ALL VALUE_LOW WITH 0, VALUE_MED WITH 0, VALUE_HI WITH 0
            IF ! FILE("MASTER.DDX")
               INDEX ON UPPER(SERIES + NAME) TO MASTER.DDX
            ENDIF
            SET INDEX TO MASTER.DDX
            @ 15,37 SAY "Done" COLOR SHOW_COLOR

            * Next, begin reading both and comparing

            @ 16,11 SAY "Step 4 : Comparison ....."
            SET PRINTER TO CONVERT.REP
            SET CONSOLE OFF
            SET PRINT ON
            ? "         Converting SCRYE on DISK (tm) to Deck Daemon .COD Format"
            ?
            ? SPACE(33) + DTOC(DATE())
            ?
            ?

            SET EXACT ON
            SET SOFTSEEK OFF
            nCARDS := 0

            SELECT SCRYE
            GO TOP
            DO WHILE ! EOF()
               @ 16,37 SAY LEFT(SCRYE->NAME,31) COLOR SHOW_COLOR

             * ? SCRYE->SERIES + "Ы" + RTRIM(SCRYE->NAME) + " "
               ? SCRYE->SERIES + "Ы" + RTRIM(SCRYE->NAME) + " "
               ?? REPLICATE(".",40-LEN(RTRIM(SCRYE->NAME))) + " "
               nCARDS++

               * First, Try It Out

               lFOUND := .F.
               cNAME := ""
               SELECT DAEMON
               SEEK UPPER(SCRYE->SERIES + SCRYE->NAME)
               IF FOUND()
                  IF UPPER(DAEMON->NAME) = UPPER(SCRYE->NAME)
                     IF LEN(LTRIM(RTRIM(DAEMON->NAME))) = LEN(LTRIM(RTRIM(SCRYE->NAME)))
                        DAEMON->VALUE_LOW := SCRYE->VALUE_LOW
                        DAEMON->VALUE_MED := SCRYE->VALUE_MED
                        DAEMON->VALUE_HI  := SCRYE->VALUE_HI
                      * ? SCRYE->SERIES + " : " + SCRYE->NAME
                        ?? "Found"
                        lFOUND := .T.
                     ENDIF
                  ENDIF
               ENDIF

               * Next, Try Massage #1

               IF ! lFOUND
                  SELECT SCRYE
                  DO CASE
                  CASE "(A)"$UPPER(SCRYE->NAME)
                     cNAME := RTRIM(LEFT(NAME,AT("(A)",UPPER(NAME))-1)) + " 1"
                  CASE "(B)"$UPPER(SCRYE->NAME)
                     cNAME := RTRIM(LEFT(NAME,AT("(B)",UPPER(NAME))-1)) + " 2"
                  CASE "(C)"$UPPER(SCRYE->NAME)
                     cNAME := RTRIM(LEFT(NAME,AT("(C)",UPPER(NAME))-1)) + " 3"
                  CASE "(D)"$UPPER(SCRYE->NAME)
                     cNAME := RTRIM(LEFT(NAME,AT("(D)",UPPER(NAME))-1)) + " 4"
                  CASE UPPER(SCRYE->NAME) = "MOUNTAIN" .AND. UPPER(SCRYE->SERIES) = "ARABIAN NIGHTS"
                     cNAME := "Mountain (Arabian Nights)"
                  CASE UPPER(SCRYE->SERIES) = "FALLEN EMPIRES"  .AND. UPPER(SCRYE->NAME) = "ICATIAN SKIRMISHES"
                     cNAME := "Icatian Skirmishers"
                  CASE UPPER(SCRYE->SERIES) = "FALLEN EMPIRES"  .AND. UPPER(SCRYE->NAME) = "THRULL WIZARDS"
                     cNAME := "Thrull Wizard"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROTECTION: ARTIFACTS"
                     cNAME := "Circle of Protection:Artifacts"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "MISHRA'S FACTORY, AUTUMN"
                     cNAME := "Mishra's Factory (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "MISHRA'S FACTORY, SPRING/BLUE BALLOON"
                     cNAME := "Mishra's Factory (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "MISHRA'S FACTORY, SUMMER"
                     cNAME := "Mishra's Factory (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "MISHRA'S FACTORY, WINTER"
                     cNAME := "Mishra's Factory (Type 4)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "STRIP MINE, SMALL TOWER IN FOREGROUND"
                     cNAME := "Strip Mine (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "STRIP MINE, NO TOWER, NO VISIBLE HORIZ"
                     cNAME := "Strip Mine (Type 4)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "STRIP MINE, VISIBLE HORIZON, EVENLY SP"
                     cNAME := "Strip Mine (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "STRIP MINE, VISIBLE HORIZON, UNEVEN TE"
                     cNAME := "Strip Mine (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S MINE, CLAWED SPHERE"
                     cNAME := "Urza's Mine (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S MINE, MOUTH"
                     cNAME := "Urza's Mine (Type 4)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S MINE, PULLEY"
                     cNAME := "Urza's Mine (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S MINE, TOWER"
                     cNAME := "Urza's Mine (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S POWER PLANT, BUG"
                     cNAME := "Urza's Power Plant (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S POWER PLANT, COLUMNS"
                     cNAME := "Urza's Power Plant (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S POWER PLANT, COPPER SPHERE"
                     cNAME := "Urza's Power Plant (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S POWER PLANT, ROCK IN POT"
                     cNAME := "Urza's Power Plant (Type 4)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S TOWER, FOREST"
                     cNAME := "Urza's Tower (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S TOWER, MOUNTAINS"
                     cNAME := "Urza's Tower (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S TOWER, PLAINS"
                     cNAME := "Urza's Tower (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "ANTIQUITIES"     .AND. UPPER(SCRYE->NAME) = "URZA'S TOWER, SHORE"
                     cNAME := "Urza's Tower (Type 4)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "ASPECT OF WOLF"
                     cNAME := "Aspect of the Wolf"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "COP:BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "COP:BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "COP:GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "COP:RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "COP:WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT:BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT:BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT:GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT:RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT:WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "FOREST PATH"
                     cNAME := "Forest (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "FOREST ROCKS"
                     cNAME := "Forest (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "ISLAND BLUE"
                     cNAME := "Island (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "ISLAND GOLDEN"
                     cNAME := "Island (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "MERFOLK OF THE PEARL TR"
                     cNAME := "Merfolk of the Pearl Trident"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BLUE"
                     cNAME := "Mountain (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BROWN"
                     cNAME := "Mountain (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "PLAINS NO TREES"
                     cNAME := "Plains (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "PLAINS TREES"
                     cNAME := "Plains (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "SWAMP HIGH BRANCH"
                     cNAME := "Swamp (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "SWAMP LOW BRANCH"
                     cNAME := "Swamp (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "TWO-HEADED GIANT"
                     cNAME := "Two-Headed Giant of Foriys"
                  CASE UPPER(SCRYE->SERIES) = "ALPHA UNLIMITED" .AND. UPPER(SCRYE->NAME) = "VESUVAN DOPPELGANGER"
                     cNAME := "Vesuvan Doppleganger"
                  CASE UPPER(SCRYE->SERIES) = "LEGENDS"         .AND. UPPER(SCRYE->NAME) = "ENCHANTING BEING"
                     cNAME := "Enchanted Being"
                  CASE UPPER(SCRYE->SERIES) = "LEGENDS"         .AND. UPPER(SCRYE->NAME) = "INDESTRUCIBLE AURA"
                     cNAME := "Indestructible Aura"
                  CASE UPPER(SCRYE->SERIES) = "LEGENDS"         .AND. UPPER(SCRYE->NAME) = "(AE)RATHI BERSERKER"
                     cNAME := "Aerathi Berserker"
                  CASE UPPER(SCRYE->SERIES) = "LEGENDS"         .AND. UPPER(SCRYE->NAME) = "SEA KING'S BLESSING"
                     cNAME := "Sea Kings' Blessing"
                  CASE UPPER(SCRYE->SERIES) = "LEGENDS"         .AND. UPPER(SCRYE->NAME) = "SPINAL VILLIAN"
                     cNAME := "Spinal Villain"
                  CASE UPPER(SCRYE->SERIES) = "LEGENDS"         .AND. UPPER(SCRYE->NAME) = "THE TABERNACLE AT PENDRELL VALE"
                     cNAME := "Tabernacle at Pendrell Vale"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "ASPECT OF WOLF"
                     cNAME := "Aspect of the Wolf"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "COP:BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "COP:BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "COP:GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "COP:RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "COP:WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "FOREST EYES"
                     cNAME := "Forest (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "FOREST PATH"
                     cNAME := "Forest (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "FOREST ROCKS"
                     cNAME := "Forest (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "ISLAND BLUE"
                     cNAME := "Island (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "ISLAND GOLDEN"
                     cNAME := "Island (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "ISLAND RED"
                     cNAME := "Island (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "MERFOLK OF THE PEARL TR"
                     cNAME := "Merfolk of the Pearl Trident"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BLUE"
                     cNAME := "Mountain (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BROWN"
                     cNAME := "Mountain (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "MOUNTAIN GREEN SKY"
                     cNAME := "Mountain (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "PLAINS NO TREES"
                     cNAME := "Plains (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "PLAINS PINK HORIZON"
                     cNAME := "Plains (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "PLAINS TREES"
                     cNAME := "Plains (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "SWAMP HIGH BRANCH"
                     cNAME := "Swamp (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "SWAMP LOW BRANCH"
                     cNAME := "Swamp (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "SWAMP TWO BRANCH"
                     cNAME := "Swamp (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "TWO-HEADED GIANT"
                     cNAME := "Two-Headed Giant of Foriys"
                  CASE UPPER(SCRYE->SERIES) = "UNLIMITED"       .AND. UPPER(SCRYE->NAME) = "VESUVAN DOPPELGANGER"
                     cNAME := "Vesuvan Doppleganger"
                  CASE UPPER(SCRYE->SERIES) = "THE DARK"        .AND. UPPER(SCRYE->NAME) = "ELVES OF DEEP SHADOWS"
                     cNAME := "Elves of Deep Shadow"
                  CASE UPPER(SCRYE->SERIES) = "THE DARK"        .AND. UPPER(SCRYE->NAME) = "SAFEHAVEN"
                     cNAME := "Safe Haven"
                  CASE UPPER(SCRYE->SERIES) = "THE DARK"        .AND. UPPER(SCRYE->NAME) = "SPLITTING SLUG"
                     cNAME := "Spitting Slug"
                  CASE UPPER(SCRYE->SERIES) = "THE DARK"        .AND. UPPER(SCRYE->NAME) = "TOWER OF COIRALL"
                     cNAME := "Tower of Coireall"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "ASPECT OF WOLF"
                     cNAME := "Aspect of the Wolf"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "COP:BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "COP:BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "COP:GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "COP:RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "COP:WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "FOREST EYES"
                     cNAME := "Forest (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "FOREST PATH"
                     cNAME := "Forest (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "FOREST ROCKS"
                     cNAME := "Forest (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "ISLAND BLUE"
                     cNAME := "Island (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "ISLAND GOLDEN"
                     cNAME := "Island (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "ISLAND RED"
                     cNAME := "Island (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "MERFOLK OF THE PEARL TR"
                     cNAME := "Merfolk of the Pearl Trident"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BLUE"
                     cNAME := "Mountain (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BROWN"
                     cNAME := "Mountain (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "MOUNTAIN GREEN SKY"
                     cNAME := "Mountain (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "PLAINS NO TREES"
                     cNAME := "Plains (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "PLAINS PINK HORIZON"
                     cNAME := "Plains (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "PLAINS TREES"
                     cNAME := "Plains (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "SWAMP HIGH BRANCH"
                     cNAME := "Swamp (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "SWAMP LOW BRANCH"
                     cNAME := "Swamp (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "SWAMP TWO BRANCH"
                     cNAME := "Swamp (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "TWO-HEADED GIANT"
                     cNAME := "Two-Headed Giant of Foriys"
                  CASE UPPER(SCRYE->SERIES) = "BETA UNLIMITED"  .AND. UPPER(SCRYE->NAME) = "VESUVAN DOPPELGANGER"
                     cNAME := "Vesuvan Doppleganger"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "ASPECT OF WOLF"
                     cNAME := "Aspect of the Wolf"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "COP:BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "COP:BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "COP:GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "COP:RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "COP:WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLACK"
                     cNAME := "Circle of Protection:Black"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: BLUE"
                     cNAME := "Circle of Protection:Blue"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: GREEN"
                     cNAME := "Circle of Protection:Green"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: RED"
                     cNAME := "Circle of Protection:Red"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "CIRCLE OF PROT: WHITE"
                     cNAME := "Circle of Protection:White"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "EL -HAJJAJ"
                     cNAME := "El-Hajjaj"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "FOREST EYES"
                     cNAME := "Forest (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "FOREST PATH"
                     cNAME := "Forest (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "FOREST ROCKS"
                     cNAME := "Forest (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "ISLAND BLUE"
                     cNAME := "Island (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "ISLAND GOLDEN"
                     cNAME := "Island (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "ISLAND RED"
                     cNAME := "Island (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BLUE"
                     cNAME := "Mountain (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "MOUNTAIN BROWN"
                     cNAME := "Mountain (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "MOUNTAIN GREEN SKY"
                     cNAME := "Mountain (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "PLAINS NO TREES"
                     cNAME := "Plains (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "PLAINS PINK HORIZON"
                     cNAME := "Plains (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "PLAINS TREES"
                     cNAME := "Plains (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "SWAMP HIGH BRANCH"
                     cNAME := "Swamp (Type 1)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "SWAMP LOW BRANCH"
                     cNAME := "Swamp (Type 2)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "SWAMP TWO BRANCH"
                     cNAME := "Swamp (Type 3)"
                  CASE UPPER(SCRYE->SERIES) = "REVISED"         .AND. UPPER(SCRYE->NAME) = "VESUVAN DOPPELGANGER"
                     cNAME := "Vesuvan Doppleganger"
                  OTHERWISE
                     cNAME := NAME
                  ENDCASE

                  SELECT DAEMON
                  SEEK UPPER(SCRYE->SERIES + cNAME)
                  IF FOUND()
                     IF UPPER(DAEMON->NAME) = UPPER(cNAME)
                        IF LEN(LTRIM(RTRIM(DAEMON->NAME))) = LEN(LTRIM(RTRIM(cNAME)))
                           DAEMON->VALUE_LOW := SCRYE->VALUE_LOW
                           DAEMON->VALUE_MED := SCRYE->VALUE_MED
                           DAEMON->VALUE_HI  := SCRYE->VALUE_HI
                         * ? SCRYE->SERIES + " : " + cNAME
                           ?? "Adjusted & Found"
                           lFOUND := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
               cALTER := cNAME

               * Next, Try Massage #2

               IF ! lFOUND
                  cNAME := ""
                  SELECT SCRYE
                  DO CASE
                  CASE "(A)"$UPPER(SCRYE->NAME)
                     cNAME := RTRIM(LEFT(NAME,AT("(A)",UPPER(NAME))-1))
                  ENDCASE

                  SELECT DAEMON
                  SEEK UPPER(SCRYE->SERIES + cNAME)
                  IF FOUND()
                     IF UPPER(DAEMON->NAME) = UPPER(cNAME)
                        IF LEN(LTRIM(RTRIM(DAEMON->NAME))) = LEN(LTRIM(RTRIM(cNAME)))
                           DAEMON->VALUE_LOW := SCRYE->VALUE_LOW
                           DAEMON->VALUE_MED := SCRYE->VALUE_MED
                           DAEMON->VALUE_HI  := SCRYE->VALUE_HI
                         * ? SCRYE->SERIES + " : " + cNAME
                           ?? "Adjusted & Found"
                           lFOUND := .T.
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF

               * Next, Just Report It

               IF ! lFOUND
                  IF "(B)"$UPPER(SCRYE->NAME)
                     ?? "Skipped"
                  ELSE
                   * ? SCRYE->SERIES + " : " + SCRYE->NAME + " ... Not Found!"
                   * IF ! EMPTY(cALTER)
                   *    ? "   (" + cALTER + ")"
                   * ENDIF
                     ?? "Not Found"
                  ENDIF
               ENDIF

               SELECT SCRYE
               SKIP
            ENDDO
            @ 16,37 SAY "Done (" + LTRIM(STR(nCARDS,4)) + " Cards Read)           " COLOR SHOW_COLOR

            * Finishing Up

            @ 17,11 SAY "Step 5 : Finishing Up ..."
            SET PRINT OFF
            SET CONSOLE ON
            SET PRINTER TO
            SELECT DAEMON

            REPLACE ALL SOURCE WITH LTRIM(LEFT(cSET,AT("/",cSET)-1))

            COPY ALL TO SCRYE.COD SDF
            CLOSE ALL
            ERASE("SCRYE.DBF")
            ERASE("MASTER.DDX")
            @ 11,61 SAY TIME() COLOR SHOW_COLOR
            @ 17,37 SAY "Done" + SPACE(27) COLOR SHOW_COLOR
            @ 19,11 SAY "Details of the conversion have been saved under the file"
            @ 20,11 SAY "CONVERT.REP.  Do you wish to browse that file now? [Y/N]"
            SET CURSOR ON
            INKEY(0)
            SET CURSOR OFF

            IF LASTKEY() = 89 .OR. LASTKEY() = 121
               CREATEDBF(cPATH+"PREVIEW.DD","LINE,C 75 0")
               USE (cPATH+"PREVIEW.DD") NEW EXCLUSIVE ALIAS PREVIEW
               APPEND FROM ("CONVERT.REP") SDF
               GO TOP
               DELETE
               GO TOP
               SETCOLOR(HEAD_COLOR)
               @ 2,1   CLEAR TO 2,78
               @ 2,24  SAY "Deck Daemon (TM) Inventory Value"
               SETCOLOR(MAIN_COLOR)
               @ 3,1   CLEAR TO 22,78
               @ 24,0  CLEAR TO 24,79
               @ 24,11 SAY "Commands : [], [], [PgUp], [PgDn], [Esc] Returns"
               oRBROWSE := TBROWSEDB(4,3,21,77)
               oRBROWSE:ADDCOLUMN(TBCOLUMNNEW("",{||LINE}))
               oRBROWSE:AUTOLITE := .F.
               lVIEWING := .T.
               DO WHILE lVIEWING
                  oRBROWSE:FORCESTABLE()
                  nKEY := ASC(UPPER(CHR(INKEY(0))))
                  DO CASE
                  CASE nKEY == K_ESC .or. nKEY == K_ENTER
                     lVIEWING := .F.
                  CASE nKEY == K_DOWN
                     IF oRBROWSE:ROWPOS < 19; oRBROWSE:ROWPOS := 19; ENDIF
                     oRBROWSE:DOWN()
                  CASE nKEY == K_UP
                     IF oRBROWSE:ROWPOS > 1;  oRBROWSE:ROWPOS := 1;  ENDIF
                     oRBROWSE:UP()
                  CASE nKEY == K_PGDN
                     oRBROWSE:PAGEDOWN()
                  CASE nKEY == K_PGUP
                     oRBROWSE:PAGEUP()
                  CASE nKEY == K_HOME
                     oRBROWSE:GOTOP()
                  CASE nKEY == K_END
                     oRBROWSE:GOBOTTOM()
                  ENDCASE
               ENDDO
               CLOSE PREVIEW
               ERASE(cPATH+"PREVIEW.DD")
            ENDIF

            PICK_SET(0,cGUIDEDBF)
            SET INDEX TO ("PRICES1.DD"), ("PRICES2.DD"), ("PRICES3.DD"), ("PRICES4.DD"), ("PRICES5.DD")
            SET ORDER TO nORDER
            oTBROWSE:GOTOP()
            oTBROWSE:AUTOLITE := .T.
            oTBROWSE:REFRESHALL()
         ENDIF
      CASE nDAEMON = 0

         * Nothing

      OTHERWISE
         TONE(900,2)
      ENDCASE
      SELECT PRICES
      SETCOLOR(MAIN_COLOR)
      RESTORE SCREEN FROM cSCREEN
      oTBROWSE:REFRESHALL()
   CASE nKEY == 68
      TONE(900,2)
   CASE nKEY == 82
      SAVE SCREEN TO cSCREEN
      SET CURSOR ON
      SETCOLOR(POP_COLOR)
      zBOX(12,30,14,49)
      @ 13,33 SAY "Please Wait ..."
      SET CURSOR ON
      SETCOLOR(MAIN_COLOR)
      CLOSE ALL
      CREATEDBF("PRICES.DD",CONJURE1 + CONJURE2)
      USE PRICES.DD NEW EXCLUSIVE ALIAS PRICES
      APPEND FROM PRICES.TXT SDF
      APPEND BLANK
      PRICES->GAME   := "M:TG"
      PRICES->TYPE   := "M"
      PRICES->SERIES := "---------------"
      PRICES->NAME   := "---------------------------------------"
      PRICES->COLOR  := "-----"
      INDEX ON UPPER(GAME + TYPE + SERIES + NAME) TO ("PRICES1.DD")
      INDEX ON UPPER(GAME + TYPE + NAME + SERIES) TO ("PRICES2.DD")
      INDEX ON STR(VALUE_MED,8,2) TO ("PRICES3.DD")
      CLOSE ALL
      USE PRICES.DD NEW EXCLUSIVE ALIAS PRICES INDEX PRICES1.DD, PRICES2.DD, PRICES3.DD
      nLINEREC := LASTREC()
      GO TOP
    * cSOURCE := LTRIM(RTRIM(PRICES->SOURCE))
      RESTORE SCREEN FROM cSCREEN
      SET CURSOR OFF
      oTBROWSE:GOTOP()
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

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                                 3d Box                                   */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function ZBOX (Y1,X1,Y2,X2,cBK_COLOR,cMSG)
Local Y, cCOLOR := SETCOLOR()

@ Y1,X1 CLEAR TO Y2,X2
@ Y1,X2+1 SAY "ъ" COLOR cBK_COLOR
FOR Y := Y1+1 TO Y2+1
   @ Y,X2+1 SAY " " COLOR cBK_COLOR
NEXT
@ Y2+1,X1 SAY "ш"+REPLICATE("э",X2-X1+1) COLOR cBK_COLOR
IF cMSG <> Nil
   SETCOLOR(HEAD_COLOR)
   @ Y1,X1 CLEAR TO Y1,X2
   @ Y1,(X2+X1)/2 - LEN(cMSG)/2 SAY cMSG
ENDIF
SETCOLOR(cCOLOR)
Return (Nil)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                             Helpit Function                              */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function HELPIT (cMSG)
Local cCOLOR := SETCOLOR(), nCURSOR := SETCURSOR()

TONE(900,2)
SETCOLOR(WARN_COLOR)
@ 24,0 CLEAR TO 24,79
@ 24,40-LEN(cMSG)/2 SAY cMSG
SET CURSOR OFF
INKEY(0)
SETCOLOR(cCOLOR)
SETCURSOR(nCURSOR)
Return (Nil)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                     Simple Pause Function, with "OK"                     */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function PAUSE (nYPOS)
Local nCURSOR := SETCURSOR()
IF (nYPOS <> Nil)
   @ nYPOS,38 SAY " Ok " COLOR MAIN_COLOR
ENDIF
SET CURSOR OFF
INKEY(0)
SETCURSOR(nCURSOR)
Return (Nil)

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*               Function to Build a .DBF from Schema-String                */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

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

/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/
/*                        Program Help (Parameters)                         */
/*дддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд*/

Function PROG_HELP
? "Price Guide Browsing Utility                                       Version " + VERSION
? "Copyright 1994, Bard's Quest Software, Inc.                 All Rights Reserved"
?
? "VIEW [/BW] [/MONO] [/CGA] [/?] [/HELP]"
?
? "   /BW or /MONO ... Force program to use B&W / Mono / Laptop colors"
? "   /CGA ........... Force program to use CGA colors"
? "   /? or /HELP .... Displays this screen"
?
SET CURSOR ON
SETBLINK(.T.)
CLOSE ALL
CLEAR ALL
QUIT
Return (Nil)
