# Deck Daemon

Deck Daemon is a classic **Magic: The Gathering® collection and deck management tool** originally published in the mid-1990s by **Bard’s Quest Software** for PC (MS-DOS and later Windows).

This repository contains **source code and documentation for a modern, archival-friendly version of Deck Daemon** — preserving the spirit and workflow of the original tool while making it possible to study, rebuild, and run it on contemporary systems.

> ⚠️ **Note:** The original Deck Daemon was commercial, closed-source software. This project is an *unofficial* reconstruction/preservation effort based on historical references and reverse engineering. It is not affiliated with Bard’s Quest Software or Wizards of the Coast.

---

## 1. What Was Deck Daemon?

Historically, Deck Daemon was sold as a PC utility to help Magic players:

- Track their **card collections** (by set, condition, and price)  
- Build and save **decks** using a dedicated deckbuilder  
- Keep card information **up to date** via price lists from *Scrye on Disk* and magazine references

Period sources describe it as:

- A **collection tracker and deck builder** for Magic: The Gathering, version 1.2 selling around \$29.95 in the mid-90s
- A DOS program later supplemented by **Windows versions** (with some gotchas when transferring data between them)
- One of several early **unofficial Magic utilities**, alongside Apprentice, Magic Workstation, CardMaster, etc.

---

## 2. Project Goals

This source tree aims to:

1. **Recreate core functionality** of the original Deck Daemon:
   - Card database + collection management
   - Deck building and exporting
   - Basic printed / text reports

2. **Document the architecture and data formats** so that:
   - The app can be ported or reimplemented in the future
   - Other tools can read/write compatible collection and deck files

3. **Preserve historical context**, including:
   - How early MTG software handled sets, card editions, and pricing
   - Known quirks (e.g., Alpha/Beta/Unlimited/Revised handling mentioned in *The Duelist* magazine)
