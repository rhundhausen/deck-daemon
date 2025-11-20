# Deck Daemon Source Overview

## daemon.prg
A large, full-featured Clipper program that implements the main Deck Daemon application.  
It includes:
- The full UI (screens, menus, browsing)
- Card and deck management
- Editing features for series, artists, colors, types, dealers
- Printing, previewing, and deck statistics
- Core program logic

## view.prg
A price-guide browser for **Conjure on Disk (COD)** and **Scrye on Disk (SOD)** files.  
It lets users:
- Load and browse electronic price guides
- Sort by series, name/description, or value
- View detailed card/set/pack/box information
- Search text across records
- Re-select guides from disk
- Interface with Deck Daemon 1.2 to price cards, decks, or full collections

VIEW.EXE served as a general-purpose viewer for COD/SOD price-guide data and created temporary DBF files for fast browsing.

## update.prg
A utility used to import official Deck Daemon updates—such as new Magic: The Gathering expansions (e.g., the Chronicles update) or new deck volumes.  
It lets users:
- Reads update files (CARDS.LST, DECKS.LST) distributed with new sets  
- Merges new cards, rarities, series, and decks into the user’s DAEMON databases  
- Rebuilds indexes and writes updated ASCII lists  
- Adds missing artists, colors, series, or types to support tables  
- Creates backups and reports totals, duplicates, and changes

UPDATE.EXE was the official method for applying Bard’s Quest Software expansion updates and maintaining an up-to-date Deck Daemon 1.2 database.

## conjure.prg
A data-processing utility designed to import and convert files from Conjure magazine.  
It includes:
- Reading and parsing an external conversion data file
- Preparing intermediate DBF tables
- Cleaning, restructuring, and validating data
- Timing and progress output for each processing step
- Producing a final, standardized output file for use by another system

## duelist.prg
A data-import utility designed to read and convert card information distributed by *The Duelist* magazine.  
It includes:
- Parsing and interpreting Duelist-formatted card data files
- Preparing temporary tables for structured processing
- Cleaning, normalizing, and validating imported records
- Converting raw magazine export data into a usable standardized database format
- Interactive text-mode UI for controlling the import process

## softrack.prg
A standalone sales and customer tracking utility, unrelated to Deck Daemon.  
It includes:
- Customer and order management
- Tracking payments (VISA, checks, etc.)
- Shipping categories (US Mail, Priority, WorldEx, Other)
- Summaries and financial totals
- Basic Clipper UI for browsing and editing records
- Internal business-use reporting and database maintenance