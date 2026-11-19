# Deck Daemon DOS Source Overview

All programs here are written for **CA-Clipper 5.2** (5.2c and 5.2d) with the DBFNTX driver. The files are in **code page 437** with CRLF line endings, so the box-drawing characters in comments and screens only display correctly in a CP437-aware editor. Build requirements are listed in the [main README](../../README.md#building-the-dos-source).

| File | Program | Purpose |
| --- | --- | --- |
| `daemon.prg` | `DAEMON.EXE` | Deck Daemon itself |
| `view.prg` | `VIEW.EXE` | Price Guide on Disk browser |
| `update.prg` | `UPDATE.EXE` | Card and deck update installer |
| `conjure.prg` | (internal) | Converts Conjure magazine price data to Conjure on Disk format |
| `softrack.prg` | `SOFTRACK.EXE` | Bard's Quest order and registration tracking |
| `duelist.prg` | `DUELIST.EXE` | Customer list for leads from The Duelist magazine |

## daemon.prg

The main Deck Daemon 1.2 application. It includes:

- The full text-mode UI: screens, pull-down menus, browsing, mouse support through dCLIP
- Card and collection management (condition, quantity, purchase and sale prices, trade flags)
- Editing of the support tables: series, artists, colors, types, dealers
- Deck building, deck statistics and a random-draw playtester
- Printing, print-to-file and on-screen preview
- The Trivia screen with collection totals

Its data lives in `DAEMON0.DD` (owner and settings), `DAEMON1.DD` (cards), `DAEMON2.DD` (support tables), `DAEMON3.DD` (decks) and `DAEMON4.DD` (deck contents). The lettered `.DD` files are NTX indexes that the program rebuilds when they are missing.

## view.prg

The Price Guide on Disk browser for **Conjure on Disk (COD)** and **Scrye on Disk (SOD)** files. It lets users:

- Load and browse electronic price guides
- Sort by series, name or description, or value
- View card, set, pack and box details
- Search text across records
- Pick a different guide from disk
- Price cards, decks or a whole collection from Deck Daemon 1.2

`VIEW.EXE` was distributed as freeware on the price guide disks. It builds temporary DBF files for fast browsing.

## update.prg

The installer for official Deck Daemon updates, such as new expansions (for example Chronicles) and new Daemon Decks volumes. It:

- Reads the update files (`CARDS.LST`, `DECKS.LST`) shipped on each update disk
- Merges new cards, rarities, series and decks into the user's DAEMON databases
- Adds any missing artists, colors, series or types to the support tables
- Rebuilds the indexes and writes updated ASCII lists
- Makes backups and reports totals, duplicates and changes

## conjure.prg

An in-house tool, begun in January 1995 and first shown at GenghisCon 1995, that converts the data file Conjure magazine supplied for each issue (`CONJURE.ASC`) into the `MAGIC.COD` format read by `VIEW.EXE` and Deck Daemon for Windows. The header notes track the files for Conjure #2, #3 and #4. It:

- Parses the tab-separated Conjure file, which covered many collectible card games besides Magic (Spellfire, Jyhad, Star Trek, On the Edge, Doom Trooper, SimCity, Blood Wars and others)
- Builds intermediate DBF tables, then cleans and normalizes card names, rarities and values
- Matches Conjure card names to Deck Daemon card names
- Prints timing and progress for each step
- Writes one `.COD` price guide file per game (`MAGIC.COD`, `SIMCITY.COD`, `DOOM.COD` and so on)

The header also lists known data problems and a planned feature to repackage Scrye on Disk `.SOD` files into COD format.

## softrack.prg

**SofTrack**, "The Software Behind the Software": Bard's Quest's internal business program, unrelated to Deck Daemon's features. It covers:

- Customers, product registrations and serial numbers
- Orders and invoices, with payment methods and shipping methods
- Products and dealer packs
- Reports, summaries, mailing labels, backups and reindexing

Access is controlled by passwords compiled into the program.

## duelist.prg

A cut-down copy of SofTrack (version "Duelist 1.1") with a single option, **Duelist Customers**. It keeps a `CUSTOMER.DBF` of names and addresses for people who contacted Bard's Quest through The Duelist magazine; new records default to the note "From Duelist Magazine #". It does not import card data.
