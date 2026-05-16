defmodule IdcalWeb.ProfileLive.Form do
  use IdcalWeb, :live_view

  alias Idcal.Finances
  alias Idcal.Finances.Profile

  @impl true
  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    profile = %Profile{}

    socket
    |> assign(:page_title, gettext("Forge a New Ledger"))
    |> assign(:profile, profile)
    |> assign(:form, to_form(Finances.change_profile(profile)))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    profile = Finances.get_profile!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, gettext("Rename Ledger"))
    |> assign(:profile, profile)
    |> assign(:form, to_form(Finances.change_profile(profile)))
  end

  @impl true
  def handle_event("validate", %{"profile" => params}, socket) do
    changeset = Finances.change_profile(socket.assigns.profile, params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"profile" => params}, socket) do
    save_profile(socket, socket.assigns.live_action, params)
  end

  defp save_profile(socket, :new, params) do
    case Finances.create_profile(socket.assigns.current_scope, params) do
      {:ok, profile} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Ledger \"%{name}\" was forged.", name: profile.nickname))
         |> push_navigate(to: ~p"/profiles/#{profile}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
    end
  end

  defp save_profile(socket, :edit, params) do
    case Finances.update_profile(socket.assigns.profile, params) do
      {:ok, profile} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Ledger renamed."))
         |> push_navigate(to: ~p"/profiles/#{profile}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-md">
        <div class="panel p-6 space-y-4">
          <h1 class="font-cinzel font-bold text-2xl text-gold">{@page_title}</h1>

          <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4">
            <div>
              <label class="font-cinzel text-sm text-gold">{gettext("Nickname")}</label>
              <input
                type="text"
                name={@form[:nickname].name}
                value={Phoenix.HTML.Form.normalize_value("text", @form[:nickname].value)}
                class="input-medieval w-full mt-1"
                placeholder={gettext("e.g. Personal, Freelance Coffers")}
                autocomplete="off"
              />
              <p
                :for={msg <- Enum.map(@form[:nickname].errors, &translate_error/1)}
                class="text-expense text-sm mt-1"
              >
                {msg}
              </p>
            </div>

            <div class="flex gap-2">
              <button type="submit" class="btn-medieval">{gettext("Save")}</button>
              <.link navigate={~p"/profiles"} class="btn-medieval">{gettext("Cancel")}</.link>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
