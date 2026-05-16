# IDCAL — Domain Model & Business Rules

## Entities

---

### User
The authenticated account. Owns everything below.

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| email | string | unique, used for login |
| password_hash | string | via mix phx.gen.auth |
| inserted_at | datetime | |

---

### Profile
A named financial identity. A User can have multiple Profiles (e.g., "Personal", "Freelance Business").

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| user_id | uuid | FK → User |
| nickname | string | display name for the profile |
| inserted_at | datetime | |

> **Rule:** All financial data (income, expenses) is scoped to a Profile, not directly to the User.

---

### IncomeCategory
User-defined categories to classify income sources.

Examples: `Salary`, `Freelance`, `Investment`, `Gift`

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| profile_id | uuid | FK → Profile |
| name | string | unique per profile |

---

### IncomeSource
A named source of income, belonging to a category.

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| profile_id | uuid | FK → Profile |
| income_category_id | uuid | FK → IncomeCategory |
| name | string | e.g. "Client XPTO", "Day Job" |
| recurrence | enum | `:monthly` or `:sporadic` |
| base_amount | decimal | default value for monthly recurrence; nil for sporadic |

---

### IncomeEntry
A concrete income value tied to a specific month/year.

Used for:
- Sporadic income (single occurrence)
- Monthly income with a **value override** for a specific month

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| income_source_id | uuid | FK → IncomeSource |
| year | integer | e.g. 2025 |
| month | integer | 1–12 |
| amount | decimal | actual value for that month |
| note | string | optional annotation |

> **Rule — Monthly Income Resolution:**
> For a given month, if an `IncomeEntry` exists for a monthly source → use that value.
> If no entry exists → use `IncomeSource.base_amount`.
> Sporadic sources only contribute when an `IncomeEntry` explicitly exists for that month.

---

### ExpenseCategory
User-defined top-level categories for grouping expense types.

Examples: `Necessities`, `Leisure`, `Health`

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| profile_id | uuid | FK → Profile |
| name | string | unique per profile |

---

### ExpenseType
A named kind of expense, belonging to a category.

Examples: `Electricity Bill` (Necessities), `Bar do Gaúcho` (Leisure)

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| profile_id | uuid | FK → Profile |
| expense_category_id | uuid | FK → ExpenseCategory |
| name | string | |
| recurrence | enum | `:monthly` or `:sporadic` |
| base_amount | decimal | default for monthly; nil for sporadic |

---

### ExpenseEntry
A concrete expense tied to a specific month/year.

Same dual purpose as IncomeEntry: sporadic occurrences or monthly overrides.

| Field | Type | Notes |
|---|---|---|
| id | uuid | PK |
| expense_type_id | uuid | FK → ExpenseType |
| year | integer | |
| month | integer | 1–12 |
| amount | decimal | actual value |
| note | string | optional |

> **Rule — Monthly Expense Resolution:** Same logic as income. Monthly types use `base_amount` unless overridden by an `ExpenseEntry`. Sporadic types only count when an entry exists.

---

## Core Calculation: Monthly Balance

```elixir
def monthly_balance(profile, year, month) do
  income  = resolve_total_income(profile, year, month)
  expense = resolve_total_expenses(profile, year, month)
  income - expense
end
```

This is computed dynamically — no stored balance field. The database is the source of truth; balances are derived.

---

## Business Rules Summary

1. Every income source and expense type belongs to a **profile**, not directly to a user.
2. A profile belongs to exactly one user.
3. Categories (both income and expense) are **user-created** and scoped per profile.
4. Expense types are **always tied to a category** — no category-less expenses.
5. Income sources are **always tied to an income category**.
6. Monthly recurrence uses `base_amount` as default; individual month entries override it.
7. Sporadic entries are only valid when an explicit `IncomeEntry` or `ExpenseEntry` exists.
8. Balance is never stored — always computed from entries.
9. A user can have multiple profiles (they are independent ledgers).
