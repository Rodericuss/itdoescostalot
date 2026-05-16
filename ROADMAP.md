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

- [ ] Migrations + schemas: `IncomeCategory`, `IncomeSource`, `IncomeEntry`
- [ ] Context functions: CRUD for all three
- [ ] LiveView: `/profiles/:id/income`
  - List categories with their sources
  - Inline forms for adding categories, sources, entries
- [ ] Resolver function: `resolve_income_for_month(profile, year, month)`

**Deliverable:** User can fully manage income data.

---

## Phase 4 — Expense Domain

- [ ] Migrations + schemas: `ExpenseCategory`, `ExpenseType`, `ExpenseEntry`
- [ ] Context functions: CRUD for all three
- [ ] LiveView: `/profiles/:id/expenses`
  - Same UX pattern as income
- [ ] Resolver function: `resolve_expenses_for_month(profile, year, month)`

**Deliverable:** User can fully manage expense data.

---

## Phase 5 — Monthly Detail View

- [ ] LiveView: `/profiles/:id/month/:year/:month`
- [ ] Income breakdown table (source → value)
- [ ] Expense breakdown table (category → type → value)
- [ ] Net balance display (color-coded)
- [ ] Basic donut chart for expense categories (Chart.js via JS hook)

**Deliverable:** User can inspect any month in detail.

---

## Phase 6 — Annual Dashboard

- [ ] LiveView: `/profiles/:id` (main dashboard)
- [ ] Year selector
- [ ] 12 month cards with income / expense / balance
- [ ] Bar chart: income vs expenses per month (Chart.js hook)
- [ ] Line chart: cumulative balance across the year
- [ ] Click on month card → navigate to monthly detail

**Deliverable:** Full visual financial map of the year.

---

## Phase 7 — Polish & UX

- [ ] Form validation with clear error messages
- [ ] Confirm dialogs for destructive actions (delete category, profile)
- [ ] Empty state screens (no income yet, no expenses yet)
- [ ] Responsive layout (mobile-friendly)
- [ ] Loading states for chart rendering

---

## Phase 8 — Internationalization (i18n)

- [ ] Configure Gettext locales: `en-US` (default) and `pt-BR`
- [ ] Wrap all user-facing strings in `gettext/1` — no hardcoded text
- [ ] Generate and fill `pt-BR` `.po` files using GLOSSARY.md as the term map
- [ ] Language switcher (button or modal) in the top bar, on every page
- [ ] Persist chosen locale in session/cookie; plug to set locale per request
- [ ] Localize month names and currency/number formatting per locale

**Deliverable:** User can switch between English and Portuguese at any time.

---

## Phase 9 — (Future / Optional)

- [ ] Budget goals per category
- [ ] CSV export of monthly data
- [ ] Dark/light theme toggle (keep medieval palette, just adjust brightness)
- [ ] Multiple currencies per profile
