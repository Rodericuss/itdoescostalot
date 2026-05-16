# IDCAL — Design Guidelines & Page Map

## Visual Mood

**Reference:** Early RuneScape (2007-era) — cartoonish, medieval, warm and slightly dark.
**Execution:** CSS-only. No proprietary assets. Fully reproducible with Tailwind + custom CSS + Google Fonts + inline SVG.

---

## Color Palette

| Role | Color | Hex |
|---|---|---|
| Background (primary) | Dark parchment | `#1a1208` |
| Background (panel) | Warm brown | `#2e1f0e` |
| Border | Aged gold | `#7a5c1e` |
| Text (primary) | Cream | `#f0dfa0` |
| Text (muted) | Faded parchment | `#a08050` |
| Accent — income/positive | Emerald green | `#3d8b3d` |
| Accent — expense/negative | Deep crimson | `#8b1a1a` |
| Accent — highlight | Bright gold | `#d4a017` |
| Button (primary) | Amber brown | `#6b3d0f` |
| Button hover | Lighter amber | `#8b5213` |

---

## Typography

```html
<!-- Google Fonts to load -->
<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700&family=IM+Fell+English&display=swap" rel="stylesheet">
```

| Use | Font | Weight |
|---|---|---|
| Headings (H1, H2) | `Cinzel` | 700 |
| Subheadings, labels | `Cinzel` | 400 |
| Body, numbers, paragraphs | `IM Fell English` | 400 |
| Monospace (amounts) | `Courier New` or `monospace` | — |

---

## UI Component Style

**Panels / Cards:**
- Heavy border: `3px solid #7a5c1e`
- Inner shadow to simulate depth
- Slightly rounded corners (`border-radius: 4px`) — chunky, not modern-sleek
- Background: `#2e1f0e`

**Buttons:**
- Flat with thick border, no gradient
- Hover: background lightens, border turns bright gold
- Active: slight inset shadow (pressed effect)

**Inputs:**
- Dark background, cream text, gold border
- Focus: border turns bright gold

**Tables:**
- Alternating row shading (dark/slightly lighter)
- Header row: gold text on dark background

**Charts:**
- Use Chart.js via a LiveView JS hook
- Bar chart colors: income bars in `#3d8b3d`, expense bars in `#8b1a1a`
- Background: transparent (panel takes care of it)
- Grid lines: `#7a5c1e` at low opacity

---

## Page Map

### `/register` — Registration
- Simple form: email, password, confirm password
- Styled as a "Create your adventurer" screen

### `/log_in` — Login
- Form: email, password
- Medieval flavor text: "Enter the Vault"

### `/profiles` — Profile Selection
- Grid of profile cards (nickname + stats preview)
- Button: "Create New Profile"

### `/profiles/new` — Create Profile
- Form: nickname input

### `/profiles/:id` — Profile Dashboard (main hub)
- Year selector (current year default)
- Annual overview: 12 month cards
- Bar chart: income vs expenses per month
- Line chart: cumulative balance
- Sidebar or tab nav to: Income | Expenses | Categories | Settings

### `/profiles/:id/income` — Income Management
- List of income categories with their sources
- Inline forms to add/edit categories and sources
- Quick entry to add a monthly override or sporadic entry

### `/profiles/:id/expenses` — Expense Management
- Same structure mirrored for expenses
- Category → Types → Entries hierarchy

### `/profiles/:id/month/:year/:month` — Monthly Detail
- Income breakdown table
- Expense breakdown table (grouped by category)
- Net balance display
- Category pie chart for expenses

### `/profiles/:id/settings` — Profile Settings
- Rename or delete profile
