# IDCAL — Implementation Roadmap

## Phase 1 — Project Foundation

- [x] `mix phx.new idcal --live` (Phoenix LiveView project)
- [x] Configure PostgreSQL repo
- [x] Run `mix phx.gen.auth` for authentication (User, sessions, tokens)
- [x] Set up Tailwind CSS with custom medieval theme (colors, fonts, base components)
- [x] Load Google Fonts (Cinzel, IM Fell English) in root layout
- [x] Basic Layout: nav bar, sidebar, content area — styled

**Deliverable:** App runs, user can register and log in. Medieval visual shell is in place.

---

## Phase 2 — Profiles

- [x] Migration + schema: `Profile` (user_id, nickname)
- [x] Context: `Finances.create_profile/2`, `list_profiles/1`, `delete_profile/1`
- [x] LiveView: `/profiles` — list and select profiles
- [x] LiveView: `/profiles/new` — create profile form
- [x] Profile stored in session or URL param for scoping

**Deliverable:** User can create and switch between profiles.

---

## Phase 3 — Income Domain

- [x] Migrations + schemas: `IncomeCategory`, `IncomeSource`, `IncomeEntry`
- [x] Context functions: CRUD for all three
- [x] LiveView: `/profiles/:id/income`
  - List categories with their sources
  - Inline forms for adding categories, sources, entries
- [x] Resolver function: `resolve_income_for_month(profile, year, month)`

**Deliverable:** User can fully manage income data.

---

## Phase 4 — Expense Domain

- [x] Migrations + schemas: `ExpenseCategory`, `ExpenseType`, `ExpenseEntry`
- [x] Context functions: CRUD for all three
- [x] LiveView: `/profiles/:id/expenses`
  - Same UX pattern as income
- [x] Resolver function: `resolve_expenses_for_month(profile, year, month)`

**Deliverable:** User can fully manage expense data.

---

## Phase 5 — Monthly Detail View

- [x] LiveView: `/profiles/:id/month/:year/:month`
- [x] Income breakdown table (source → value)
- [x] Expense breakdown table (category → type → value)
- [x] Net balance display (color-coded)
- [x] Basic donut chart for expense categories (Chart.js via JS hook)

**Deliverable:** User can inspect any month in detail.

---

## Phase 6 — Annual Dashboard

- [x] LiveView: `/profiles/:id` (main dashboard)
- [x] Year selector
- [x] 12 month cards with income / expense / balance
- [x] Bar chart: income vs expenses per month (Chart.js hook)
- [x] Line chart: cumulative balance across the year
- [x] Click on month card → navigate to monthly detail

**Deliverable:** Full visual financial map of the year.

---

## Phase 7 — Polish & UX

- [x] Form validation with clear error messages
- [x] Confirm dialogs for destructive actions (delete category, profile)
- [x] Empty state screens (no income yet, no expenses yet)
- [x] Responsive layout (mobile-friendly)
- [x] Loading states for chart rendering
- [x] Input validation (year/month params, year range 1970–9999)

---

## Phase 8 — Internationalization (i18n)

- [x] Configure Gettext locales: `en-US` (default) and `pt-BR`
- [x] Wrap all user-facing strings in `gettext/1` — no hardcoded text
- [x] Generate and fill `pt-BR` `.po` files using GLOSSARY.md as the term map
- [x] Language switcher (button or modal) in the top bar, on every page
- [x] Persist chosen locale in session/cookie; plug to set locale per request
- [x] Localize month names and currency/number formatting per locale

**Deliverable:** User can switch between English and Portuguese at any time.

---

## Phase 9 — Budgeting & Goals

- [x] Budget targets per expense category (monthly gold limit + progress bar)
- [x] Savings goals: named goal with target amount and deadline, tracked month over month

**Deliverable:** User can set spending limits per guild and save toward goals.

---

## Phase 10 — Insights & Analytics

- [x] Trend analysis: compare month vs previous month, or vs same month last year (% change)
- [x] Expense averages: rolling average per category over last 6 months
- [x] Income vs Expense ratio over time (single metric tracked monthly)
- [x] Category drilldown: click donut chart category to see individual types and entries

**Deliverable:** User gains actionable insight into spending patterns.

---

## Phase 11 — Forecasting & Planning

- [x] Cash flow projection: project next 3–6–12 months using recurring data
- [x] "What if" scenarios: toggle sources/types on/off or adjust amounts to see projected impact without saving

**Deliverable:** User can see the future financial trajectory and test hypothetical changes.

---

## Phase 12 — Data Management

- [x] CSV export of monthly data
- [x] CSV import: parse bank statements to auto-populate sporadic entries
- [x] Duplicate/clone month: copy all sporadic entries from one month to another
- [x] Templates: save a month's entry pattern and apply it to future months

**Deliverable:** User can move data in and out efficiently and reduce repetitive entry.

---

## Phase 13 — Notifications & Reminders

- [x] Monthly check-in reminder email ("Hark! The month hath ended. Review thy ledger.")
- [x] Budget alert: notify when approaching or exceeding a category budget

**Deliverable:** App reaches out to the user to stay on top of finances.

---

## Phase 14 — Multi-user & Social

- [x] Shared profiles: two users can share a profile (couples managing joint finances)
- [x] Profile comparison: side-by-side view of two profiles (e.g. Personal vs Freelance)

**Deliverable:** Profiles can be collaborative and comparable.

---

## Phase 15 — UX Enhancements

- [x] Quick entry mode: minimal form to log a sporadic expense fast (category → type → amount → done)
- [x] Pinned/favorite categories at the top
- [x] Notes search: search entries by note text
- [x] Recurring entry calendar view with highlighted gaps
- [x] Dark/light theme toggle (keep medieval palette, just adjust brightness)
- [x] Multiple currencies per profile
