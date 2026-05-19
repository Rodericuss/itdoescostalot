defmodule IdcalWeb.ExpenseLive.Index do
  use IdcalWeb, :live_view

  alias Idcal.Finances
  alias Idcal.Finances.{ExpenseCategory, ExpenseType, ExpenseEntry}

  @impl true
  def mount(%{"id" => profile_id}, _session, socket) do
    profile = Finances.get_profile!(socket.assigns.current_scope, profile_id)
    categories = Finances.list_expense_categories(profile)

    {:ok,
     socket
     |> assign(:page_title, gettext("Expenses"))
     |> assign(:profile, profile)
     |> assign(:categories, categories)
     |> assign(:category_form, nil)
     |> assign(:editing_category, nil)
     |> assign(:type_form, nil)
     |> assign(:type_category_id, nil)
     |> assign(:editing_type, nil)
     |> assign(:entry_form, nil)
     |> assign(:entry_type, nil)
     |> assign(:editing_entry, nil)}
  end

  @impl true
  def handle_event("new_category", _params, socket) do
    changeset = Finances.change_expense_category(%ExpenseCategory{})
    {:noreply, assign(socket, :category_form, to_form(changeset))}
  end

  def handle_event("cancel_category", _params, socket) do
    {:noreply, assign(socket, category_form: nil, editing_category: nil)}
  end

  def handle_event("save_category", %{"expense_category" => params}, socket) do
    profile = socket.assigns.profile

    result =
      if socket.assigns.editing_category do
        Finances.update_expense_category(socket.assigns.editing_category, params)
      else
        Finances.create_expense_category(profile, params)
      end

    case result do
      {:ok, _category} ->
        {:noreply,
         socket
         |> assign(:categories, Finances.list_expense_categories(profile))
         |> assign(:category_form, nil)
         |> assign(:editing_category, nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :category_form, to_form(changeset))}
    end
  end

  def handle_event("edit_category", %{"id" => id}, socket) do
    category = Finances.get_expense_category!(socket.assigns.profile, id)
    changeset = Finances.change_expense_category(category)

    {:noreply,
     socket
     |> assign(:editing_category, category)
     |> assign(:category_form, to_form(changeset))}
  end

  def handle_event("delete_category", %{"id" => id}, socket) do
    category = Finances.get_expense_category!(socket.assigns.profile, id)
    {:ok, _} = Finances.delete_expense_category(category)

    {:noreply,
     socket
     |> assign(:categories, Finances.list_expense_categories(socket.assigns.profile))
     |> put_flash(:info, gettext("Category deleted."))}
  end

  def handle_event("new_type", %{"category-id" => category_id}, socket) do
    changeset = Finances.change_expense_type(%ExpenseType{expense_category_id: category_id})

    {:noreply,
     socket
     |> assign(:type_form, to_form(changeset))
     |> assign(:type_category_id, category_id)}
  end

  def handle_event("cancel_type", _params, socket) do
    {:noreply, assign(socket, type_form: nil, type_category_id: nil, editing_type: nil)}
  end

  def handle_event("save_type", %{"expense_type" => params}, socket) do
    profile = socket.assigns.profile

    result =
      if socket.assigns.editing_type do
        Finances.update_expense_type(socket.assigns.editing_type, params)
      else
        Finances.create_expense_type(profile, params)
      end

    case result do
      {:ok, _type} ->
        {:noreply,
         socket
         |> assign(:categories, Finances.list_expense_categories(profile))
         |> assign(:type_form, nil)
         |> assign(:type_category_id, nil)
         |> assign(:editing_type, nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :type_form, to_form(changeset))}
    end
  end

  def handle_event("edit_type", %{"id" => id}, socket) do
    type = Finances.get_expense_type!(socket.assigns.profile, id)
    changeset = Finances.change_expense_type(type)

    {:noreply,
     socket
     |> assign(:editing_type, type)
     |> assign(:type_form, to_form(changeset))
     |> assign(:type_category_id, type.expense_category_id)}
  end

  def handle_event("delete_type", %{"id" => id}, socket) do
    type = Finances.get_expense_type!(socket.assigns.profile, id)
    {:ok, _} = Finances.delete_expense_type(type)

    {:noreply,
     socket
     |> assign(:categories, Finances.list_expense_categories(socket.assigns.profile))
     |> put_flash(:info, gettext("Expense type deleted."))}
  end

  def handle_event("new_entry", %{"type-id" => type_id}, socket) do
    type = Finances.get_expense_type!(socket.assigns.profile, type_id)
    today = Date.utc_today()

    changeset =
      Finances.change_expense_entry(%ExpenseEntry{
        expense_type_id: type.id,
        year: today.year,
        month: today.month
      })

    {:noreply,
     socket
     |> assign(:entry_form, to_form(changeset))
     |> assign(:entry_type, type)}
  end

  def handle_event("cancel_entry", _params, socket) do
    {:noreply, assign(socket, entry_form: nil, entry_type: nil, editing_entry: nil)}
  end

  def handle_event("save_entry", %{"expense_entry" => params}, socket) do
    type = socket.assigns.entry_type

    result =
      if socket.assigns.editing_entry do
        Finances.update_expense_entry(socket.assigns.editing_entry, params)
      else
        Finances.create_expense_entry(type, params)
      end

    case result do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> assign(:categories, Finances.list_expense_categories(socket.assigns.profile))
         |> assign(:entry_form, nil)
         |> assign(:entry_type, nil)
         |> assign(:editing_entry, nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :entry_form, to_form(changeset))}
    end
  end

  def handle_event("edit_entry", %{"type-id" => type_id, "id" => entry_id}, socket) do
    type = Finances.get_expense_type!(socket.assigns.profile, type_id)
    entry = Finances.get_expense_entry!(type, entry_id)
    changeset = Finances.change_expense_entry(entry)

    {:noreply,
     socket
     |> assign(:editing_entry, entry)
     |> assign(:entry_form, to_form(changeset))
     |> assign(:entry_type, type)}
  end

  def handle_event("delete_entry", %{"type-id" => type_id, "id" => entry_id}, socket) do
    type = Finances.get_expense_type!(socket.assigns.profile, type_id)
    entry = Finances.get_expense_entry!(type, entry_id)
    {:ok, _} = Finances.delete_expense_entry(entry)

    {:noreply,
     socket
     |> assign(:categories, Finances.list_expense_categories(socket.assigns.profile))
     |> put_flash(:info, gettext("Entry deleted."))}
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
          <h1 class="font-cinzel-decorative font-bold text-3xl text-[#8b1a1a] mt-1">💸 {gettext("Expenses")}</h1>
        </div>
        <button phx-click="new_category" class="btn-medieval">
          🏷️ {gettext("New Category")}
        </button>
      </div>

      <%!-- Category form --%>
      <div :if={@category_form} class="panel p-5">
        <h2 class="panel-title text-lg mb-3">
          {if @editing_category, do: gettext("Edit Category"), else: gettext("New Category")}
        </h2>
        <.form for={@category_form} phx-submit="save_category" class="flex items-end gap-3">
          <.input field={@category_form[:name]} label={gettext("Name")} placeholder={gettext("e.g. Necessities, Leisure")} />
          <button type="submit" class="btn-medieval">{gettext("Save")}</button>
          <button type="button" phx-click="cancel_category" class="btn-medieval btn-danger">{gettext("Cancel")}</button>
        </.form>
      </div>

      <%!-- Empty state --%>
      <div :if={@categories == [] && !@category_form} class="panel p-10 text-center">
        <div class="text-5xl mb-3">🏚️</div>
        <p class="italic-fell text-muted mt-3">
          {gettext("No expense categories yet — create one to start tracking your spending.")}
        </p>
      </div>

      <%!-- Category list --%>
      <div :for={category <- @categories} class="panel p-5 space-y-4">
        <div class="flex items-center justify-between">
          <h2 class="panel-title text-xl">⚜️ {category.name}</h2>
          <div class="flex gap-2">
            <button phx-click="new_type" phx-value-category-id={category.id} class="btn-medieval text-sm">
              ⛏️ {gettext("Add Type")}
            </button>
            <button phx-click="edit_category" phx-value-id={category.id} class="btn-medieval text-sm">
              <.icon name="hero-pencil-square" class="size-4" />
            </button>
            <button
              phx-click="delete_category"
              phx-value-id={category.id}
              class="btn-medieval btn-danger text-sm"
              data-confirm={gettext("Delete this category and all its types?")}
            >
              <.icon name="hero-trash" class="size-4" />
            </button>
          </div>
        </div>

        <%!-- Type form for this category --%>
        <div :if={@type_form && to_string(@type_category_id) == to_string(category.id)} class="ml-4 border-l-2 border-[#7a5c1e] pl-4">
          <h3 class="font-cinzel text-gold text-sm mb-2">
            {if @editing_type, do: gettext("Edit Type"), else: gettext("New Type")}
          </h3>
          <.form for={@type_form} phx-submit="save_type" class="space-y-2">
            <input type="hidden" name="expense_type[expense_category_id]" value={category.id} />
            <div class="flex flex-wrap items-end gap-3">
              <.input field={@type_form[:name]} label={gettext("Name")} placeholder={gettext("e.g. Electricity, Gym")} />
              <.input
                field={@type_form[:recurrence]}
                type="select"
                label={gettext("Recurrence")}
                options={[{gettext("Monthly"), :monthly}, {gettext("Sporadic"), :sporadic}]}
              />
              <.input field={@type_form[:base_amount]} type="number" label={gettext("Base Amount")} placeholder="0.00" step="0.01" min="0" />
            </div>
            <div class="flex gap-2">
              <button type="submit" class="btn-medieval">{gettext("Save")}</button>
              <button type="button" phx-click="cancel_type" class="btn-medieval btn-danger">{gettext("Cancel")}</button>
            </div>
          </.form>
        </div>

        <%!-- Types list --%>
        <div :if={category.types != []} class="ml-4 space-y-3">
          <div :for={type <- category.types} class="border-l-2 border-[#7a5c1e] pl-4">
            <div class="flex items-center justify-between">
              <div>
                <span class="text-cream font-cinzel">{type.name}</span>
                <span class={[
                  "ml-2 text-xs px-2 py-0.5 rounded",
                  if(type.recurrence == :monthly, do: "bg-[#8b1a1a]/20 text-[#8b1a1a]", else: "bg-[#d4a017]/20 text-[#d4a017]")
                ]}>
                  {if type.recurrence == :monthly, do: gettext("Monthly"), else: gettext("Sporadic")}
                </span>
                <span :if={type.base_amount} class="ml-2 text-muted text-sm">
                  {gettext("Base:")} {Decimal.to_string(type.base_amount)}
                </span>
              </div>
              <div class="flex gap-2">
                <button phx-click="new_entry" phx-value-type-id={type.id} class="btn-medieval text-xs">
                  <.icon name="hero-plus" class="size-3" /> {gettext("Entry")}
                </button>
                <button phx-click="edit_type" phx-value-id={type.id} class="btn-medieval text-xs">
                  <.icon name="hero-pencil-square" class="size-3" />
                </button>
                <button
                  phx-click="delete_type"
                  phx-value-id={type.id}
                  class="btn-medieval btn-danger text-xs"
                  data-confirm={gettext("Delete this expense type and all its entries?")}
                >
                  <.icon name="hero-trash" class="size-3" />
                </button>
              </div>
            </div>

            <%!-- Entry form for this type --%>
            <div :if={@entry_form && @entry_type && @entry_type.id == type.id} class="mt-3 ml-4 border-l-2 border-[#8b1a1a] pl-3">
              <h4 class="font-cinzel text-[#8b1a1a] text-sm mb-2">
                {if @editing_entry, do: gettext("Edit Entry"), else: gettext("New Entry")}
              </h4>
              <.form for={@entry_form} phx-submit="save_entry" class="space-y-2">
                <input type="hidden" name="expense_entry[expense_type_id]" value={type.id} />
                <div class="flex flex-wrap items-end gap-3">
                  <.input field={@entry_form[:year]} type="number" label={gettext("Year")} min="1970" max="9999" />
                  <.input field={@entry_form[:month]} type="number" label={gettext("Month")} min="1" max="12" />
                  <.input field={@entry_form[:amount]} type="number" label={gettext("Amount")} placeholder="0.00" step="0.01" min="0" />
                  <.input field={@entry_form[:note]} label={gettext("Note")} placeholder={gettext("optional")} />
                </div>
                <div class="flex gap-2">
                  <button type="submit" class="btn-medieval">{gettext("Save")}</button>
                  <button type="button" phx-click="cancel_entry" class="btn-medieval btn-danger">{gettext("Cancel")}</button>
                </div>
              </.form>
            </div>

            <%!-- Entries table --%>
            <.entries_table :if={type.entries != [] && Ecto.assoc_loaded?(type.entries)} entries={type.entries} type={type} />
          </div>
        </div>

        <p :if={category.types == []} class="ml-4 italic-fell text-muted text-sm">
          🕸️ {gettext("No expense types yet.")}
        </p>
      </div>
    </Layouts.app>
    """
  end

  defp entries_table(assigns) do
    ~H"""
    <div class="mt-2 ml-4 overflow-x-auto">
      <table class="w-full text-sm">
        <thead>
          <tr class="text-gold font-cinzel text-xs border-b border-[#7a5c1e]">
            <th class="text-left py-1 px-2">{gettext("Year")}</th>
            <th class="text-left py-1 px-2">{gettext("Month")}</th>
            <th class="text-right py-1 px-2">{gettext("Amount")}</th>
            <th class="text-left py-1 px-2">{gettext("Note")}</th>
            <th class="py-1 px-2"></th>
          </tr>
        </thead>
        <tbody>
          <tr :for={entry <- @entries} class="border-b border-[#7a5c1e]/30 hover:bg-[#2e1f0e]">
            <td class="py-1 px-2 text-cream">{entry.year}</td>
            <td class="py-1 px-2 text-cream">{entry.month}</td>
            <td class="py-1 px-2 text-right text-[#8b1a1a] font-mono">{Decimal.to_string(entry.amount)}</td>
            <td class="py-1 px-2 text-muted">{entry.note || "—"}</td>
            <td class="py-1 px-2 flex gap-1 justify-end">
              <button phx-click="edit_entry" phx-value-type-id={@type.id} phx-value-id={entry.id} class="text-muted hover:text-gold">
                <.icon name="hero-pencil-square" class="size-4" />
              </button>
              <button
                phx-click="delete_entry"
                phx-value-type-id={@type.id}
                phx-value-id={entry.id}
                class="text-muted hover:text-[#8b1a1a]"
                data-confirm={gettext("Delete this entry?")}
              >
                <.icon name="hero-trash" class="size-4" />
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
