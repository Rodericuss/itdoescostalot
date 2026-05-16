# IDCAL — It Does Cost A Lot

> A multi-user personal finance tracker with a medieval RPG aesthetic.

IDCAL ("It Does Cost A Lot") helps you map the coin of your realm — your income
and expenses across the months of a year — through a warm, cartoonish interface
inspired by early-2000s RPGs. Track recurring wages and sporadic bounties, watch
your balance rise and fall, and see your whole financial year at a glance.

## The idea behind it

Most finance apps are cold spreadsheets. IDCAL reframes budgeting as charting a
year of adventure: each profile is a **ledger**, income flows in like loot, and
expenses drain the coffers. The medieval theme is purely cosmetic — under the
hood it is an honest, dynamic ledger — but it makes the dull task of tracking
money a little more inviting.

The core of the app is a single equation, computed live and never stored:

```
Monthly Balance = Σ Income (month) − Σ Expenses (month)
```

Both income and expenses can be **recurring monthly** (a base amount that may be
overridden for any single month) or **one-time / sporadic** (counted only when an
explicit entry exists). Balances are always derived from the data — the database
is the single source of truth.

## Features

- **Authentication** — register, log in, log out (email + password).
- **Profiles** — keep multiple independent ledgers per account (e.g. Personal,
  Freelance). All financial data is scoped to a profile.
- **Income & expenses** — user-defined categories, named sources/types, monthly
  or sporadic recurrence, and per-month value overrides.
- **Monthly summary** — income and expense breakdowns with a colour-coded net
  balance.
- **Annual dashboard** — twelve month cards plus charts of income vs. expenses
  and cumulative balance across the year.
- **Bilingual** — full English (en-US) and Brazilian Portuguese (pt-BR) support,
  switchable at any time from the top bar.
- **Real-time** — all updates happen in-page via Phoenix LiveView.

## Tech stack

| Layer         | Choice                                             |
|---------------|----------------------------------------------------|
| Language      | Elixir                                             |
| Web framework | Phoenix LiveView (fullstack, no separate frontend) |
| Database      | PostgreSQL                                         |
| Styling       | Tailwind CSS + daisyUI, custom medieval theme      |
| Auth          | `phx.gen.auth`                                     |
| Charts        | Chart.js via LiveView JS hooks                     |
| i18n          | Gettext (en-US / pt-BR)                            |
| Fonts         | Cinzel (headings), IM Fell English (body)          |

## Getting started

Prerequisites: Elixir, Erlang/OTP, and a running PostgreSQL server.

```bash
# 1. Install dependencies and set up the database
mix setup

# 2. Start the development server
mix phx.server
```

Then visit [`localhost:4000`](http://localhost:4000), register an account, and
forge your first ledger.

```bash
mix test          # run the test suite
mix ecto.migrate  # run pending migrations
```

## Project documentation

The repository carries its own design docs, which double as the development
roadmap:

- `OVERVIEW.md` — high-level concept and goals
- `DOMAIN.md` — data model and business rules
- `FEATURES.md` — feature list with acceptance criteria
- `DESIGN.md` — UI/UX guidelines, colour palette, page map
- `ROADMAP.md` — phased implementation plan
- `GLOSSARY.md` — canonical EN ↔ PT-BR term map for translations

## License

Released under the [MIT License](LICENSE) — free for open-source and commercial
use. No proprietary game assets are used; the medieval look is achieved purely
with CSS, inline SVG, and Google Fonts.
