# CLAUDE.md

## Project

IDCAL (It Does Cost A Lot) — a multi-user personal finance tracker with a medieval RPG aesthetic (RuneScape 2007-era inspired). Built with Elixir, Phoenix LiveView, PostgreSQL, Tailwind CSS.

## Tech Stack

- Elixir + Phoenix LiveView (fullstack, no separate frontend)
- PostgreSQL
- Tailwind CSS + custom medieval theme
- Auth via `mix phx.gen.auth`
- Charts via Chart.js with LiveView JS hooks
- Google Fonts: Cinzel (headings), IM Fell English (body)

## Architecture

- User → Profile → (IncomeCategory → IncomeSource → IncomeEntry) + (ExpenseCategory → ExpenseType → ExpenseEntry)
- Balance is always computed dynamically, never stored
- Monthly recurrence uses base_amount with optional per-month overrides via entries
- Sporadic sources only count when an explicit entry exists for that month
- All financial data is scoped to a Profile, not directly to a User

## Key Rules

- Always read OVERVIEW.md, DOMAIN.md, FEATURES.md, DESIGN.md, ROADMAP.md, and GLOSSARY.md before starting work to understand current state and goals
- Follow the phased roadmap in ROADMAP.md — check off items as they are completed
- Follow the design system in DESIGN.md (colors, fonts, component styles)
- Follow the domain model and business rules in DOMAIN.md exactly
- Features and acceptance criteria are defined in FEATURES.md

## Internationalization (i18n)

- The site is **bilingual**: `en-US` (English) and `pt-BR` (Brazilian Portuguese)
- Locale is switchable at runtime via a language switcher (button/modal) in the top bar
- Implemented with Phoenix **Gettext** — every user-facing string must go through `gettext/1` (or `dgettext`), never hardcoded
- GLOSSARY.md is the canonical EN ↔ PT term map — all translations (UI strings, domain terms, medieval flavor text) must stay consistent with it
- When adding any new user-facing string, also add its PT-BR translation and, if it is a domain/flavor term, add it to GLOSSARY.md

## Design Palette

- Background: #1a1208 (dark parchment), #2e1f0e (panels)
- Border: #7a5c1e (aged gold)
- Text: #f0dfa0 (cream), #a08050 (muted)
- Income/positive: #3d8b3d (emerald)
- Expense/negative: #8b1a1a (crimson)
- Highlight: #d4a017 (bright gold)
- Buttons: #6b3d0f / #8b5213

## Commands

- `mix setup` — install deps and set up database
- `mix phx.server` — start dev server
- `mix test` — run tests
- `mix ecto.migrate` — run migrations
