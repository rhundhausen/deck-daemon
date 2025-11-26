   CONJURE ON DISK VOLUME 3                              MARCH 1, 1995
   ===================================================================

   CONJURE ON DISK

   Contains all of the hottest collectible card game price guides as
   published in CONJURE Magazine.  All files are fixed length ASCII.

   CONJURE on Disk contains these price lists :

         DIXIE.COD           : Dixie (TM)
                               Columbia Games, Inc.

         DOOM.COD            : Doom Trooper (TM)
                               Heartbreaker Hobbies

         FLIGHTS.COD         : Flights of Fantasy (TM)
                               Destini Productions

         GALACTIC.COD        : Galactic Empires (TM)
                               Companion Games, Inc.

         JYHAD.COD           : Jyhad (TM)
                               Wizards of the Coast, Inc.

         MAGIC.COD           : Magic:The Gathering (R)
                               Wizards of the Coast, Inc.

         EDGE.COD            : On the Edge (TM)
                               Atlas Games & Trident, Inc

         SPLLFIRE.COD        : Spellfire (TM)
                               TSR, Inc.

         STARTREK.COD        : Star Trek:The Next Generation (R)
                               Decipher, Inc.

         GUARDIAN.COD        : Star of the Guardians (TM)
                               Mag Force 7

         WYVERN.COD          : Wyvern (TM)
                               U.S. Game Systems

   Each file contains prices and information about cards, packs, decks,
   sets and boxes.  These files are in a format that is readable by
   most spreadsheet, database, word processing and/or collectible game
   card software.  Slight modifications may be necessary.

   CONJURE MAGAZINE

   Published 6 times a year by
   Thee Keep of Comics & Games, Inc.
   2272 Kresge Drive
   Amherst,  OH  44001
   (216) 282-2666 ... Phone
   (216) 282-7926 ... Fax

   CONJURE LITE

   CONJURE Lite is the Ultimate Game Trading Card Price List brought
   to you by CONJURE magazine.  Available where you purchase CONJURE.
   It is the perfect, inbetween-meal snack for CONJURE readers.


   PRICE GUIDE ON DISK BROWSER (1.0b)                    MARCH 1, 1995
   ===================================================================

   VIEW.EXE

   Use the VIEW.EXE program to browse the various price lists found on
   this diskette.  The VIEW.EXE program will also read SCRYE on DISK
   files that are consistent with their Version 5.0 format.

   A. System Requirements

      . An IBM PC, XT, AT, PS/2 or 100% compatible
      . DOS 3.0 (or above) or 100% compatible environment
      . 8086/8088 computer or higher (286, 386, 486, Pentium, etc.)
      . 640k of RAM with at least 512k available to programs
      . 3.5" high density floppy diskette drive

      RECOMMENDED HARDWARE

      . A hard drive with at least 1 meg of space is recommended
      . A color VGA monitor is recommended
      . A printer is required to print listings

   B. To Run the Program

      Type VIEW.EXE at the DOS prompt.  Make sure that you know where
      the CONJURE (*.COD) and/or SCRYE (*.SOD) files are located, since
      you will be asked to enter the path.  Also, make sure that the
      drive that you are running on has at least 500k of available disk
      space, for creation of temporary files.  Here are some command
      line parameters that are available :

         VIEW                : VGA Color Mode
         VIEW [/CGA]         : CGA Color Mode
         VIEW [/BW]          : Black & White (Monochrome)
         VIEW [/MONO]        : Black & White (Monochrome)
         VIEW [?] or [/HELP] : Displays a Syntax Help Screen

   C. Entering the File Path and File Mask

      If the price guide files are located in the current directory,
      then press enter and use the default path.  If the files are
      stored elsewhere, such as in custom history directories, then you
      can enter that path here instead.  Leave the file mask alone,
      unless you have renamed the files from their original names.

   D. Select a Price Guide and Card Game

      Once the path has been specified, a listing of the price guide
      files will pop-up for your selection.  Each entry may be an
      entire card game or just one series of a larger card game.  Using
      the arrow keys, select the guide that you wish to browse.  The
      program will then load the appropriate file from disk and allow
      you to browse it.  Note : CONJURE on Disk files will load faster
      than SCRYE on disk files.

   E. The Browse Screen

      The appearance of the browse program will change slightly,
      depending upon the price guide that you are browsing.

      At the bottom of the Conjure on disk price guide browse, you will
      find prices and information about packs, decks, sets and boxes.
      Arrow or page down to the bottom to view this information.  These
      records are noted by their description in the second column.

      The columns may be sorted in one of three orders.

         Order 1 (Default)   : Column 1 (Series/Set Name)
         Order 2             : Column 2 (Card Name/Description)
         Order 3             : Value    (Medium Value)

   F. Using the browse commands

         CHANGE THE SORTING ORDER ....................... [O] or [TAB]

         Toggles between sort order 1, 2 and 3.  Your current position
         will be maintained as the sort order changes.

         CARD ZOOM (DISPLAY) .......................... [Z] or [ENTER]

         Pops-up a screen showing all available information about the
         card, set, series, pack or box.  This screen will change
         slightly dependent upon the price guide that you are browsing.

         TEXT SEARCH ............................................. [S]

         Performs a serial search beginning at the next record after
         the currently highlighted one.  Any character or string of
         characters can be searched for in the Game, Series, Card Name
         or Card Value.

         RE-SELECT PRICE GUIDE ................................... [R]

         When you are ready to select a new price guide and/or card
         game, use this command to bring back the original selection
         list that you used when you first ran the program.

         INTERFACE WITH DECK DAEMON .............................. [D]

         Use this command to interface with your Deck Daemon for DOS,
         version 1.2 databases and calculate the worth of your cards,
         sets, decks and entire collection.

         Note : Currently, only the Magic: The Gathering card game is
         available for comparison.  If you hear a beep when you press
         [D], then you are currently browsing a non-Magic price guide.

         First, you must enter the data path where your Deck Daemon
         databases are located.  Typically, this is C:\DAEMON.  You
         must also select the destination of the report.  Choices are
         Screen, File or Printer.

              Screen  : Screen preview.  Use the arrow and page keys.
              File    : ASCII DOS file.  Enter the full path and name.
              Printer : Choose from LPT1, LPT2, LPT3, LPT4, COM1, COM2

         Next, several steps will be performed : creating temporary
         databases (in your Deck Daemon directory), appending cards,
         appending decks, applying price guide values and generating
         the output.

         Notes

         a) Revised cards (*) have been assigned their Expansion set
            price.
         b) Missing values (n/a) may be user changed/added cards or
            misspellings.
         c) Cards are listed in the first section by series.
         d) Decks are listed in the second section by name.

         QUIT AND EXIT PROGRAM .......................... [Q] or [ESC]

         If you are ready to quit and exit, press the [Y] key.

   G. Performance Tips

         For best results, copy the VIEW.EXE program and all *.COD
         and/or *.SOD files to your hard drive.  You may copy to any
         directory that you wish.  Although it is possible to run
         VIEW.EXE from the floppy diskette, it isn't recommended that
         you do this.  If you are planning on interfacing with your
         DECK DAEMON databases, then you will definitely want to copy
         files to your hard drive.

   H. Saving a History of Price Lists

         If you copy the price guide files from your new diskette to
         the same directory each time, you will be overwriting the
         previous price guide files.  To avoid this, you must copy the
         new files to a different directory each time.

         Here is an example of a possible directory structure that
         would save each set of price guide files :

              C:.
              읕컴DAEMON       <--- DECK DAEMON Program & Databases
                  쳐컴COD3     <--- CONJURE on Disk # 3
                  쳐컴COD4     <--- CONJURE on Disk # 4
                  쳐컴COD5     <--- CONJURE on Disk # 5
                  쳐컴SCRYE5   <--- SCRYE on Disk # 5
                  쳐컴SCRYE6   <--- SCRYE on Disk # 6
                  읕컴SCRYE7   <--- SCRYE on Disk # 7

         Use the DOS command (MKDIR) or the Windows (TM) File Manager
         to create the directory structure.  Next, copy all of the
         price guide files and the VIEW.EXE browse program from the
         floppy diskette(s) into the corresponding directory(s).

         You may optionally copy the VIEW.EXE program into a directory
         that has been mentioned in your DOS (PATH) statement.  This
         way you will not need to have multiple copies of the same
         program, and it will also insure that you are always running
         the newest version of the VIEW.EXE program.  Consult your DOS
         reference guide for more assistance.


   BARD'S QUEST SOFTWARE                                 MARCH 1, 1995
   ===================================================================

   REACHING US

   As always, please call us here at Bard's Quest Software anytime
   between 10am - 7pm (MST), Monday through Saturday.  We always love
   to hear from our users.  You can also reach us by fax and modem.

         BARD'S QUEST SOFTWARE, INC.
         620 VISTA, SUITE C.
         BOISE, ID  83705
         (208) 336-9404 ... PHONE
         (208) 336-9315 ... FAX
         (208) 345-6121 ... BBS (28.8, 14.4, 9600, 2400, N-8-1)
         ahbqs.com ........ TELNET ADDRESS

   ACKNOWLEDGEMENTS

   CONJURE (TM) Magazine
   (c) 1995 and property of Conjure Press

   SCRYE Magazine (TM) and SCRYE on Disk (TM)
   (c) 1994 and property of ILM International, Inc.

   Deck Daemon (TM)
   (c) 1994 and property of Bard's Quest Software, Inc.

   Price Guide on Disk Browser
   (c) 1995 and property of Bard's Quest Software, Inc.

   Windows (TM)
   registered trademark and property of Microsoft Corporation

   DISCLAIMER

   BQS, Inc. disclaims all warranties relating to this software,
   whether express or implied, including but not limited to any
   implied warranties of merchantability and fitness for a
   particular purpose, and all such warranties are expressly and
   specifically disclaimed.  Neither BQS, Inc. nor anyone else who
   had been involved in the creation, production, or delivery of
   this software shall be liable for any indirect, consequential,
   or incidental damages arising out of the use or inability to
   use such software even if BQS, Inc. has been advised of the
   possibility of such damages or claims.  In no event shall BQS,
   Inc. liability for any damages ever exceed the price paid for
   the license to use the software, regardless of the form of
   claim.  The person using the software bears all risk as to the
   quality and performance of the software.
