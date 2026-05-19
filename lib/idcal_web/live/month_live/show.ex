defmodule IdcalWeb.MonthLive.Show do
  use IdcalWeb, :live_view

  alias Idcal.Finances

  @month_names ~w(January February March April May June July August September October November December)

  @impl true
  def mount(%{"id" => profile_id, "year" => year_str, "month" => month_str}, _session, socket) do
    profile = Finances.get_profile!(socket.assigns.current_scope, profile_id)

    with {year, ""} <- Integer.parse(year_str),
         {month, ""} <- Integer.parse(month_str),
         true <- month in 1..12,
         true <- year in 1970..9999 do
      mount_with_data(socket, profile, year, month)
    else
      _ -> {:ok, push_navigate(socket, to: ~p"/profiles/#{profile_id}")}
    end
  end

  defp mount_with_data(socket, profile, year, month) do

    income_breakdown = Finances.income_breakdown_for_month(profile, year, month)
    expense_groups = Finances.expense_breakdown_grouped_by_category(profile, year, month)

    total_income =
      Enum.reduce(income_breakdown, Decimal.new(0), fn {_, amt}, acc -> Decimal.add(acc, amt) end)

    total_expenses =
      Enum.reduce(expense_groups, Decimal.new(0), fn {_, _, cat_total}, acc ->
        Decimal.add(acc, cat_total)
      end)

    balance = Decimal.sub(total_income, total_expenses)

    {:ok,
     socket
     |> assign(:page_title, "#{month_name(month)} #{year}")
     |> assign(:profile, profile)
     |> assign(:year, year)
     |> assign(:month, month)
     |> assign(:income_breakdown, income_breakdown)
     |> assign(:expense_groups, expense_groups)
     |> assign(:total_income, total_income)
     |> assign(:total_expenses, total_expenses)
     |> assign(:balance, balance)
     |> assign(:chart_data, expense_chart_data(expense_groups))}
  end

  defp month_name(m), do: Enum.at(@month_names, m - 1)

  defp expense_chart_data(expense_groups) do
    labels = Enum.map(expense_groups, fn {cat, _, _} -> cat.name end)

    amounts =
      Enum.map(expense_groups, fn {_, _, total} -> Decimal.to_float(total) end)

    colors = [
      "#8b1a1a", "#d4a017", "#3d8b3d", "#7a5c1e", "#a08050",
      "#6b3d0f", "#4a7c4a", "#c45c1e", "#2e6e8b", "#8b5213"
    ]

    Jason.encode!(%{
      labels: labels,
      datasets: [
        %{
          data: amounts,
          backgroundColor: Enum.take(colors, length(labels)),
          borderColor: "#7a5c1e",
          borderWidth: 1
        }
      ]
    })
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex items-center justify-between">
        <div>
          <.link navigate={~p"/profiles/#{@profile}"} class="text-muted hover:text-gold font-cinzel text-sm">
            &larr; {@profile.nickname}
          </.link>
          <h1 class="font-cinzel-decorative font-bold text-3xl text-gold mt-1">
            📅 {gettext("%{month} %{year}", month: month_name(@month), year: @year)}
          </h1>
        </div>
        <div class="flex gap-2">
          <.link navigate={prev_month_path(@profile, @year, @month)} class="btn-medieval text-sm">
            &larr;
          </.link>
          <.link navigate={next_month_path(@profile, @year, @month)} class="btn-medieval text-sm">
            &rarr;
          </.link>
        </div>
      </div>

      <%!-- Net Balance --%>
      <div class="panel p-5 text-center">
        <p class="font-cinzel text-muted text-sm">⚖️ {gettext("Net Balance")}</p>
        <p class={[
          "font-mono text-3xl font-bold mt-1",
          if(Decimal.compare(@balance, 0) == :lt, do: "text-[#8b1a1a]", else: "text-[#3d8b3d]")
        ]}>
          {format_amount(@balance)}
        </p>
        <div class="flex justify-center gap-8 mt-3 text-sm">
          <span class="text-[#3d8b3d]">{gettext("Income:")} {format_amount(@total_income)}</span>
          <span class="text-[#8b1a1a]">{gettext("Expenses:")} {format_amount(@total_expenses)}</span>
        </div>
      </div>

      <div class="grid gap-6 lg:grid-cols-2">
        <%!-- Income breakdown --%>
        <div class="panel p-5">
          <h2 class="panel-title text-lg text-[#3d8b3d] mb-3">🪙 {gettext("Income")}</h2>
          <div :if={@income_breakdown == []} class="italic-fell text-muted text-sm">
            🕸️ {gettext("No income this month.")}
          </div>
          <table :if={@income_breakdown != []} class="w-full text-sm">
            <thead>
              <tr class="text-gold font-cinzel text-xs border-b border-[#7a5c1e]">
                <th class="text-left py-1 px-2">{gettext("Source")}</th>
                <th class="text-left py-1 px-2">{gettext("Category")}</th>
                <th class="text-right py-1 px-2">{gettext("Amount")}</th>
              </tr>
            </thead>
            <tbody>
              <tr :for={{source, amount} <- @income_breakdown} class="border-b border-[#7a5c1e]/30">
                <td class="py-1 px-2 text-cream">{source.name}</td>
                <td class="py-1 px-2 text-muted">{source.income_category.name}</td>
                <td class="py-1 px-2 text-right text-[#3d8b3d] font-mono">{format_amount(amount)}</td>
              </tr>
            </tbody>
            <tfoot>
              <tr class="border-t-2 border-[#7a5c1e]">
                <td colspan="2" class="py-2 px-2 font-cinzel text-gold">{gettext("Total")}</td>
                <td class="py-2 px-2 text-right text-[#3d8b3d] font-mono font-bold">{format_amount(@total_income)}</td>
              </tr>
            </tfoot>
          </table>
        </div>

        <%!-- Expense breakdown (grouped by category) --%>
        <div class="panel p-5">
          <h2 class="panel-title text-lg text-[#8b1a1a] mb-3">💸 {gettext("Expenses")}</h2>
          <div :if={@expense_groups == []} class="italic-fell text-muted text-sm">
            🕸️ {gettext("No expenses this month.")}
          </div>
          <div :for={{category, items, cat_total} <- @expense_groups} class="mb-4">
            <div class="flex justify-between items-center border-b border-[#7a5c1e] pb-1 mb-1">
              <span class="font-cinzel text-gold text-sm">{category.name}</span>
              <span class="text-[#8b1a1a] font-mono text-sm">{format_amount(cat_total)}</span>
            </div>
            <table class="w-full text-sm">
              <tr :for={{type, amount} <- items} class="border-b border-[#7a5c1e]/20">
                <td class="py-0.5 px-2 text-cream">{type.name}</td>
                <td class="py-0.5 px-2 text-right text-[#8b1a1a] font-mono">{format_amount(amount)}</td>
              </tr>
            </table>
          </div>
          <div :if={@expense_groups != []} class="border-t-2 border-[#7a5c1e] pt-2 flex justify-between">
            <span class="font-cinzel text-gold">{gettext("Total")}</span>
            <span class="text-[#8b1a1a] font-mono font-bold">{format_amount(@total_expenses)}</span>
          </div>
        </div>
      </div>

      <%!-- Expense donut chart --%>
      <div :if={@expense_groups != []} class="panel p-5">
        <h2 class="panel-title text-lg mb-3">🥧 {gettext("Expense Categories")}</h2>
        <div class="max-w-sm mx-auto">
          <canvas
            id="expense-donut"
            phx-hook="ChartHook"
            data-chart-type="doughnut"
            data-chart-data={@chart_data}
            data-chart-options={chart_options()}
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp format_amount(decimal) do
    decimal
    |> Decimal.round(2)
    |> Decimal.to_string(:normal)
  end

  defp chart_options do
    Jason.encode!(%{
      plugins: %{
        legend: %{
          position: "bottom",
          labels: %{color: "#f0dfa0", font: %{family: "Cinzel"}}
        }
      },
      cutout: "50%"
    })
  end

  defp prev_month_path(profile, year, 1), do: ~p"/profiles/#{profile}/month/#{year - 1}/12"
  defp prev_month_path(profile, year, month), do: ~p"/profiles/#{profile}/month/#{year}/#{month - 1}"

  defp next_month_path(profile, year, 12), do: ~p"/profiles/#{profile}/month/#{year + 1}/1"
  defp next_month_path(profile, year, month), do: ~p"/profiles/#{profile}/month/#{year}/#{month + 1}"
end
