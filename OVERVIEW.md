# It does cost a lot (IDCAL) — Personal Finance Tracker

## What is this?

It does cost a lot is a multi-user personal finance web application built with **Elixir + Phoenix LiveView + PostgreSQL**.

Each user creates a profile and uses it to track their **income sources** and **expenses** across months, with a visual dashboard showing the financial map of the year in a medieval RPG-inspired aesthetic (think RuneScape: cartoonish, warm, medieval mood — no proprietary assets).

---

## Core Concept

The app revolves around a simple monthly equation:

```
Monthly Balance = Σ Income (month) - Σ Expenses (month)
```

Both income and expenses can be:
- **Recurring monthly** — with a base value that can be overridden for a specific month
- **One-time / sporadic** — tied to a specific month

---

## Tech Stack

| Layer | Choice |
|---|---|
| Language | Elixir |
| Web Framework | Phoenix LiveView (fullstack, no separate frontend) |
| Database | PostgreSQL |
| CSS | Tailwind CSS + custom medieval theme |
| Auth | mix phx.gen.auth (built-in Phoenix auth generator) |
| Charts | VegaLite or Chart.js via LiveView hooks |

---

## Design Direction

**Mood:** Medieval RPG, cartoonish — inspired by early RuneScape (2007-era).

**Visual guidelines:**
- Dark parchment/brown background palette
- Gold and amber accent colors for numbers and highlights
- Deep red for expenses/negative balance
- Emerald green for income/positive balance
- Serif or gothic-leaning fonts (Google Fonts: `MedievalSharp`, `UnifrakturMaguntia`, or `Cinzel`)
- Chunky bordered UI panels resembling inventory slots or stat boxes
- Subtle texture on backgrounds (CSS-only, no external assets required)
- Icons: simple SVG coin, sword, shield metaphors where appropriate

**No proprietary Jagex/RuneScape assets.** Style is achieved purely through CSS, SVG, and Google Fonts.

---

## Project File Structure (planned)

```
idcal/
├── OVERVIEW.md           ← this file
├── DOMAIN.md             ← data model and business rules
├── FEATURES.md           ← full feature list with acceptance criteria
├── DESIGN.md             ← UI/UX guidelines and page map
└── ROADMAP.md            ← phased implementation plan
```
