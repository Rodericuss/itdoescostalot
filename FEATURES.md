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

## F18 — CSV Export

- Download monthly financial data as CSV from the month detail view
- CSV includes Type (Income/Expense), Category, Name, and Amount columns
- File named `idcal_{nickname}_{year}_{month}.csv`
- Accessible via Export CSV button on `/profiles/:id/month/:year/:month`

---

## F19 — CSV Import

- Import sporadic expense entries from CSV file on the expenses page
- CSV format: Category, Type, Amount, Note (optional); first row skipped as header
- Auto-creates categories and types on the fly if they don't exist
- Transaction-wrapped: all rows succeed or none are inserted
- Accessible via Import CSV toggle on `/profiles/:id/expenses`

---

## F20 — Clone Month

- Copy all sporadic income and expense entries from the current month to the next month
- Skips entries that already exist in the target month (no duplicates)
- Clone button on the month detail view with confirmation dialog
- Reports the number of entries cloned

---

## F21 — Month Templates

- Save the current month's sporadic entry pattern as a named template (pergaminho)
- Templates capture kind, category name, type name, and amount for each sporadic entry
- Apply a saved template to any month, creating entries for matching sources/types
- Skips entries that already exist in the target month
- Delete templates when no longer needed
- Template panel toggled via Templates button on the month detail view

---

## F22 — Monthly Check-in Reminder

- Scheduled daily check runs via GenServer in the supervision tree
- On the 1st of each month, sends reminder email to all users to review the previous month
- Medieval-flavored email: "Hark! The month hath ended — review thy ledger."
- Uses Swoosh mailer (same as auth emails)

---

## F23 — Budget Alerts

- Alert banners appear on the monthly detail view when expense categories approach (80%+) or exceed (100%+) their budget limit
- Warning style (gold) for 80-99%, exceeded style (crimson) for 100%+
- Budget alert emails sent automatically on the 1st of each month alongside reminders
- Only profiles with categories at 80%+ utilization receive alert emails

---

## F24 — Shared Profiles

- Profile owner can invite other users by email to share a ledger
- Two roles: Viewer (read-only) and Editor (full access)
- Owner can promote, demote, or remove shared users from the profile settings page
- Shared profiles appear in the user's profile list alongside owned profiles
- Cannot share with yourself; duplicate shares are rejected

---

## F25 — Profile Comparison

- Side-by-side view comparing two profiles for the same year
- Each profile shows annual totals: coffers, tributes, net purse
- Monthly breakdown table shows balance per month for both profiles plus difference
- Year navigation to compare across different years
- Compare button appears on the profile list when 2+ profiles exist
- Accessible via `/profiles/compare`

---

## F26 — Quick Entry Mode

- Minimal form to log a sporadic expense fast: category, type, amount, month, note
- Auto-creates category and type on the fly if they don't exist
- Accessible via `/profiles/:id/quick` (Quick button on dashboard)

---

## F27 — Pinned/Favorite Categories

- Income and expense categories can be pinned
- Pinned categories sort to the top of their list
- Pin/unpin toggle button on each category header
- Visual indicator (pin icon) for pinned categories

---

## F28 — Notes Search

- Search income and expense entries by note text
- Live search with debounce (300ms)
- Results show type, category, name, period, amount, and note
- Accessible via `/profiles/:id/search` (Search button on dashboard)

---

## F29 — Recurring Entry Calendar

- Calendar grid showing all recurring (monthly) income sources and expense types
- Columns for each month, rows for each item
- Check mark for months with overrides, dot for months using base amount
- Year navigation
- Accessible via `/profiles/:id/calendar` (Calendar button on dashboard)

---

## F30 — Dark/Light Theme Toggle

- Theme preference stored per profile (dark or light)
- Configurable in profile settings
- Default: dark (medieval palette)

---

## F31 — Multiple Currencies

- Currency stored per profile (BRL, USD, EUR, GBP, JPY, CAD, AUD, CHF)
- Configurable in profile settings
- Default: BRL

---

## Out of Scope (for now)

- Currency conversion between profiles
- Mobile native app
