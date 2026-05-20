# IDCAL — Features & Acceptance Criteria

## F01 — Authentication

- User can register with email + password
- User can log in and log out
- Protected routes redirect unauthenticated users to login
- Implemented via `mix phx.gen.auth`

---

## F02 — Profile Management

- User can create one or more profiles with a nickname
- User can switch between profiles
- User can rename or delete a profile
- All financial data is scoped to the active profile

---

## F03 — Income Category Management

- User can create income categories (e.g. "Freelance", "Salary")
- User can rename or delete categories
- Deleting a category is blocked if income sources exist under it (or cascades with confirmation)

---

## F04 — Income Source Management

- User can create an income source with:
  - Name
  - Category
  - Recurrence type: `monthly` or `sporadic`
  - Base amount (required for monthly, optional/nil for sporadic)
- User can edit or delete income sources

---

## F05 — Income Entry (Monthly Values)

- For a monthly income source, user can add an override entry for a specific month/year with a custom amount
- For a sporadic income source, user can add an entry for a specific month/year with an amount and optional note
- User can edit or delete entries
- If no entry exists for a monthly source in a given month → system uses `base_amount`

---

## F06 — Expense Category Management

- User can create expense categories (e.g. "Necessities", "Leisure")
- User can rename or delete categories (same deletion rules as income categories)

---

## F07 — Expense Type Management

- User can create an expense type with:
  - Name
  - Category (required)
  - Recurrence: `monthly` or `sporadic`
  - Base amount (required for monthly, optional for sporadic)
- User can edit or delete expense types

---

## F08 — Expense Entry (Monthly Values)

- Same behavior as income entries, mirrored for expenses
- User can add a specific value for a month (override or sporadic)
- Optional note per entry

---

## F09 — Monthly Summary View

- User sees a summary for a selected month/year:
  - Total income (broken down by source)
  - Total expenses (broken down by category and type)
  - Net balance = income − expenses
  - Color-coded: green for positive, red for negative
- All values are resolved dynamically (base + overrides)

---

## F10 — Annual Dashboard (Main Visual Feature)

- User sees all 12 months of the selected year in one view
- Each month shows:
  - Total income
  - Total expenses
  - Net balance
- Bar chart or area chart: income vs expenses per month
- Line chart overlay: cumulative balance across the year
- Month cards with color coding (surplus = gold/green, deficit = red)
- Clicking a month card navigates to its monthly summary (F09)

---

## F11 — Category Breakdown Chart

- Pie or donut chart showing expenses broken down by category for a selected month or year
- Helps identify where money is going at a glance

---

## F12 — Real-time Updates (LiveView)

- All forms and updates happen in-page via LiveView — no full page reloads
- Charts update reactively when entries are added/edited

---

## F13 — Bilingual Site (i18n)

- Site is available in two locales: `en-US` (English) and `pt-BR` (Brazilian Portuguese)
- A language switcher (button or modal) is present in the top bar, available on every page
- Selecting a locale updates all user-facing text without losing the current page/state
- Chosen locale persists across sessions (stored in session/cookie)
- All strings — UI labels, domain terms, medieval flavor text, validation messages — are translatable
- Implemented via Phoenix Gettext; translations follow the EN ↔ PT term map in GLOSSARY.md
- Default locale: `en-US` (falls back to it for any missing translation)

---

## F14 — Budget Targets

- User can set a global budget limit (Gold Limit) on each expense category
- Budget limits can be overridden per month (same pattern as base_amount + entries)
- Budget progress bars appear on the expense management page, monthly detail view, and dashboard month cards
- Progress bar turns red when spending exceeds the limit, gold when approaching (80%+)
- Dashboard month cards show a warning when any guild exceeds its limit

---

## F15 — Savings Goals (Quests)

- User can create named savings goals with a target amount and deadline
- Each goal has a tracking mode: manual contributions or auto (from monthly surplus)
- Manual mode: user logs explicit contributions per month
- Auto mode: progress is computed from cumulative positive net balance
- Progress bar shows percentage saved toward target
- Dashboard displays required monthly savings to reach the goal by deadline
- Status messages for: on track, quest complete, deadline passed

---

## F16 — Insights & Analytics

- Trend analysis: compare current month vs previous month and vs same month last year (% change for income and expenses)
- Rolling 6-month expense averages by category (guild)
- Income/expense ratio chart across the year (line chart, 1.0 = break even)
- Category drilldown: click an expense category in the monthly view to expand and see individual types and entries
- All analytics accessible via `/profiles/:id/insights` with month navigation

---

## F17 — Forecasting & Planning

- Cash flow projection for the next 3, 6, or 12 months using recurring (monthly) income sources and expense types
- Mixed bar + line chart showing projected income, expenses, and cumulative balance
- Monthly breakdown table with income, expenses, net purse, and amassed hoard
- "What if" scenarios: toggle any recurring source or type on/off without saving
- Adjust projected amounts inline to model hypothetical changes
- Reset button to return to baseline projections
- Accessible via `/profiles/:id/forecast`

---

## Out of Scope (for now)

- Currency conversion
- Import from bank statements
- Recurring reminders or notifications
- Mobile native app
