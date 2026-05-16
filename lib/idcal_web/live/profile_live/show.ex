defmodule IdcalWeb.ProfileLive.Show do
  use IdcalWeb, :live_view

  alias Idcal.Finances

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    profile = Finances.get_profile!(socket.assigns.current_scope, id)

    {:ok,
     socket
     |> assign(:page_title, profile.nickname)
     |> assign(:profile, profile)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="flex items-center justify-between">
        <div>
          <.link navigate={~p"/profiles"} class="text-muted hover:text-gold font-cinzel text-sm">
            &larr; {gettext("All Ledgers")}
          </.link>
          <h1 class="font-cinzel font-bold text-3xl text-gold mt-1">{@profile.nickname}</h1>
        </div>
        <.link navigate={~p"/profiles/#{@profile}/settings"} class="btn-medieval">
          <.icon name="hero-cog-6-tooth" class="size-5" /> {gettext("Settings")}
        </.link>
      </div>

      <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        <.link navigate={~p"/profiles/#{@profile}/income"} class="panel p-5 hover:border-[#3d8b3d] transition-colors">
          <h2 class="panel-title text-lg text-[#3d8b3d]">{gettext("Income")}</h2>
          <p class="text-muted text-sm mt-1">{gettext("Manage your income categories and sources.")}</p>
        </.link>
      </div>

      <div class="panel p-10 text-center">
        <Layouts.coin_icon class="size-12 text-muted mx-auto" />
        <p class="text-muted italic mt-3">
          {gettext("The annual dashboard for this ledger will appear here.")}
        </p>
      </div>
    </Layouts.app>
    """
  end
end
