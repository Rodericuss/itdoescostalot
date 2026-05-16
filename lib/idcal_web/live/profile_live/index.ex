defmodule IdcalWeb.ProfileLive.Index do
  use IdcalWeb, :live_view

  alias Idcal.Finances

  @impl true
  def mount(_params, _session, socket) do
    profiles = Finances.list_profiles(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, gettext("Your Ledgers"))
     |> assign(:profiles, profiles)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    profile = Finances.get_profile!(socket.assigns.current_scope, id)
    {:ok, _} = Finances.delete_profile(profile)

    {:noreply,
     socket
     |> put_flash(:info, gettext("Ledger \"%{name}\" was destroyed.", name: profile.nickname))
     |> assign(:profiles, Finances.list_profiles(socket.assigns.current_scope))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex items-center justify-between">
        <h1 class="font-cinzel font-bold text-3xl text-gold">{gettext("Your Ledgers")}</h1>
        <.link navigate={~p"/profiles/new"} class="btn-medieval">
          <.icon name="hero-plus" class="size-5" /> {gettext("New Ledger")}
        </.link>
      </div>

      <div :if={@profiles == []} class="panel p-10 text-center">
        <Layouts.coin_icon class="size-12 text-muted mx-auto" />
        <p class="text-muted italic mt-3">
          {gettext("No ledgers yet — forge your first to begin tracking your coin.")}
        </p>
      </div>

      <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <div :for={profile <- @profiles} class="panel p-5 flex flex-col gap-3">
          <h2 class="panel-title text-xl">{profile.nickname}</h2>
          <div class="flex gap-2 mt-auto">
            <.link navigate={~p"/profiles/#{profile}"} class="btn-medieval flex-1 justify-center">
              {gettext("Open")}
            </.link>
            <.link
              navigate={~p"/profiles/#{profile}/settings"}
              class="btn-medieval"
              title={gettext("Rename")}
            >
              <.icon name="hero-pencil-square" class="size-5" />
            </.link>
            <button
              class="btn-medieval btn-danger"
              phx-click="delete"
              phx-value-id={profile.id}
              data-confirm={
                gettext("Destroy the ledger \"%{name}\"? All its data is lost forever.",
                  name: profile.nickname
                )
              }
              title={gettext("Delete")}
            >
              <.icon name="hero-trash" class="size-5" />
            </button>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
