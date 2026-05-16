# IDCAL — Glossary (EN ↔ PT-BR)

Canonical term map for the bilingual site. Every translation (Gettext `.po` files,
UI strings, flavor text) must stay consistent with this table.

- **Default locale:** `en-US`
- **Second locale:** `pt-BR`
- When a term has both a plain meaning and a medieval-flavored label, both are listed.

---

## Domain Terms

| Concept | English (en-US) | Portuguese (pt-BR) |
|---|---|---|
| User account | User | Usuário |
| Profile (ledger) | Profile / Ledger | Perfil / Livro-razão |
| Income | Income | Receita |
| Expense | Expense | Despesa |
| Income category | Income Category | Categoria de Receita |
| Expense category | Expense Category | Categoria de Despesa |
| Income source | Income Source | Fonte de Renda |
| Expense type | Expense Type | Tipo de Despesa |
| Entry (monthly value) | Entry | Lançamento |
| Base amount | Base Amount | Valor Base |
| Amount | Amount | Valor |
| Note | Note | Observação |
| Month / Year | Month / Year | Mês / Ano |
| Balance | Balance | Saldo |
| Net balance | Net Balance | Saldo Líquido |
| Cumulative balance | Cumulative Balance | Saldo Acumulado |
| Surplus (positive) | Surplus | Superávit |
| Deficit (negative) | Deficit | Déficit |
| Recurrence | Recurrence | Recorrência |
| Monthly (recurrence) | Monthly | Mensal |
| Sporadic (recurrence) | Sporadic | Esporádico |
| Recurring | Recurring | Recorrente |
| Override (a month's value) | Override | Substituição |
| Total | Total | Total |

---

## UI / Navigation

| Concept | English (en-US) | Portuguese (pt-BR) |
|---|---|---|
| Dashboard | Dashboard | Painel |
| Annual dashboard | Annual Dashboard | Painel Anual |
| Monthly summary | Monthly Summary | Resumo Mensal |
| Settings | Settings | Configurações |
| Register | Register | Cadastrar |
| Log in | Log in | Entrar |
| Log out | Log out | Sair |
| Save | Save | Salvar |
| Cancel | Cancel | Cancelar |
| Edit | Edit | Editar |
| Delete | Delete | Excluir |
| Add | Add | Adicionar |
| Language | Language | Idioma |
| Year selector | Year | Ano |

---

## Medieval Flavor Strings

Flavor text keeps the RuneScape-era medieval mood. Portuguese versions preserve the tone.

| English (en-US) | Portuguese (pt-BR) |
|---|---|
| It Does Cost A Lot | Custa Caro Sim |
| Enter the Vault (log in) | Entrar no Cofre |
| Create your Adventurer (register) | Crie seu Aventureiro |
| Your Ledgers | Seus Livros-razão |
| Forge a New Ledger | Forjar um Novo Livro-razão |
| New Ledger | Novo Livro-razão |
| Rename Ledger | Renomear Livro-razão |
| Open (a ledger) | Abrir |
| All Ledgers | Todos os Livros-razão |
| Coffers / Treasury | Cofres / Tesouro |
| Bounty (sporadic income) | Recompensa |
| Track every coin | Acompanhe cada moeda |
| Map your year | Mapeie seu ano |
| No ledgers yet — forge your first to begin tracking your coin. | Nenhum livro-razão ainda — forje o primeiro para começar a acompanhar suas moedas. |

---

## Translation Rules

1. Currency/number formatting follows the active locale (`pt-BR` uses `.` for thousands and `,` for decimals).
2. Month names are localized (January → Janeiro, etc.).
3. Validation/error messages are translated via Gettext too.
4. Missing `pt-BR` translations fall back to `en-US`.
5. New user-facing strings must be added here (if a domain/flavor term) and to the `.po` files.
