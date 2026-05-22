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

### BudgetOverride
A per-month override for an expense category's budget limit.

| Field | Type | Notes |
|---|---|---|
| id | bigint | PK |
| expense_category_id | bigint | FK → ExpenseCategory |
| year | integer | |
| month | integer | 1–12 |
| limit | decimal | budget limit for this month |

> **Rule — Budget Resolution:** For a given month, if a `BudgetOverride` exists → use its `limit`. Otherwise → use `ExpenseCategory.budget_limit`. If neither is set, no budget tracking for that category.

---

### SavingsGoal
A named savings target with a deadline, scoped to a profile.

| Field | Type | Notes |
|---|---|---|
| id | bigint | PK |
| profile_id | bigint | FK → Profile |
| name | string | e.g. "Travel to Africa" |
| target_amount | decimal | how much to save |
| deadline | date | target date |
| tracking_mode | enum | `:auto` or `:manual` |

> **Rule — Tracking Modes:**
> - `:manual` — progress is the sum of explicit `SavingsContribution` entries.
> - `:auto` — progress is computed from cumulative monthly surplus (positive net balance months only) for the current year.

---

### SavingsContribution
A manual contribution toward a savings goal for a specific month.

| Field | Type | Notes |
|---|---|---|
| id | bigint | PK |
| savings_goal_id | bigint | FK → SavingsGoal |
| year | integer | |
| month | integer | 1–12 |
| amount | decimal | contributed amount |
| note | string | optional |

> Unique per goal + year + month.

---

### MonthTemplate
A saved pattern of sporadic entries that can be re-applied to future months.

| Field | Type | Notes |
|---|---|---|
| id | bigint | PK |
| profile_id | bigint | FK → Profile |
| name | string | unique per profile |

---

### MonthTemplateItem
A single entry within a month template, storing the snapshot of a sporadic entry.

| Field | Type | Notes |
|---|---|---|
| id | bigint | PK |
| month_template_id | bigint | FK → MonthTemplate |
| kind | string | "income" or "expense" |
| category_name | string | name of the category at save time |
| name | string | name of the source/type at save time |
| amount | decimal | amount at save time |
| note | string | optional |

> When applying a template, items are matched by kind + category_name + name to existing sporadic sources/types. Items with no match are skipped. Existing entries in the target month are not overwritten.

---

### ProfileShare
Grants another user access to a profile.

| Field | Type | Notes |
|---|---|---|
| id | bigint | PK |
| profile_id | bigint | FK → Profile |
| user_id | bigint | FK → User |
| role | string | "viewer" or "editor" |

> Unique per profile + user. Owner cannot share with themselves.

> **Rule — Access Resolution:** `list_profiles` and `get_profile!` include profiles where the user is either the owner OR has a ProfileShare record. Write operations should check `can_edit_profile?` which returns true for owners and editors.

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
