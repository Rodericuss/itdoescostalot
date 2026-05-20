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
| Income (UI label) | Coffers | Cofres |
| Expense (UI label) | Tributes | Tributos |
| Income category | Guild (income) | Guilda (cofres) |
| Expense category | Guild (expense) | Guilda (tributos) |
| Income source | Wellspring | Nascente |
| Expense type | Levy | Taxa |
| Entry (monthly value) | Record | Registro |
| Base amount | Base Tithe | Dízimo Base |
| Amount | Amount | Valor |
| Note | Note | Observação |
| Month / Year | Month / Year | Mês / Ano |
| Balance | Balance | Saldo |
| Net balance | Net Purse | Bolsa Líquida |
| Cumulative balance | Amassed Hoard | Tesouro Acumulado |
| Surplus (positive) | Surplus | Superávit |
| Deficit (negative) | Deficit | Déficit |
| Recurrence | Recurrence | Recorrência |
| Monthly (recurrence) | Monthly | Mensal |
| Sporadic (recurrence) | Sporadic | Esporádico |
| Recurring | Recurring | Recorrente |
| Override (a month's value) | Override | Substituição |
| Total | Total | Total |
| Tracking start | Chronicle Begins | Início da Crônica |
| Nickname (profile) | Title | Título |
| Budget limit | Gold Limit | Limite de Ouro |
| Budget override | Budget Override | Substituição de Orçamento |
| Savings goal | Quest | Missão |
| Contribution | Contribution | Contribuição |
| Target amount | Target Amount | Valor Alvo |
| Deadline | Deadline | Prazo |

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
| Coffers vs Tributes | Cofres vs Tributos |
| Amassed Hoard | Tesouro Acumulado |
| Net Purse | Bolsa Líquida |
| Tally every coin | Contabilize cada moeda |
| Chart the realm | Mapeie o reino |
| The Adventurer's Path | O Caminho do Aventureiro |
| Add Wellspring | Adicionar Nascente |
| Add Levy | Adicionar Taxa |
| Guild disbanded. | Guilda dissolvida. |
| Wellspring dried up. | Nascente secou. |
| Levy abolished. | Taxa abolida. |
| Record expunged. | Registro expurgado. |
| Chronicle Begins | Início da Crônica |
| Forge a ledger | Forje um livro-razão |
| Inscribe monthly records | Inscreva registros mensais |
| Behold your treasury map | Contemple o mapa do tesouro |
| No ledgers yet — forge your first to begin tracking your coin. | Nenhum livro-razão ainda — forje o primeiro para começar a acompanhar suas moedas. |
| Quest abandoned. | Missão abandonada. |
| Quest complete! Thy goal hath been achieved! | Missão concluída! Teu objetivo foi alcançado! |
| No quests yet — embark on one to start saving toward your goal. | Nenhuma missão ainda — embarque em uma para começar a poupar rumo ao seu objetivo. |
| To reach thy goal, thou must save X per month. | Para alcançar teu objetivo, deves poupar X por mês. |
| The deadline hath passed and the quest remains unfinished. | O prazo já passou e a missão permanece inacabada. |
| Abandon this quest? | Abandonar esta missão? |

---

## Month Names

| English | Portuguese | Abbreviation (EN) | Abbreviation (PT) |
|---|---|---|---|
| January | Janeiro | Jan | Jan |
| February | Fevereiro | Feb | Fev |
| March | Março | Mar | Mar |
| April | Abril | Apr | Abr |
| May | Maio | May | Mai |
| June | Junho | Jun | Jun |
| July | Julho | Jul | Jul |
| August | Agosto | Aug | Ago |
| September | Setembro | Sep | Set |
| October | Outubro | Oct | Out |
| November | Novembro | Nov | Nov |
| December | Dezembro | Dec | Dez |

---

## Translation Rules

1. Currency/number formatting follows the active locale (`pt-BR` uses `.` for thousands and `,` for decimals).
2. Month names are localized (January → Janeiro, etc.).
3. Validation/error messages are translated via Gettext too.
4. Missing `pt-BR` translations fall back to `en-US`.
5. New user-facing strings must be added here (if a domain/flavor term) and to the `.po` files.
