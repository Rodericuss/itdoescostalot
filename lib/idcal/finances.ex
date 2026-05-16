defmodule Idcal.Finances do
  @moduledoc """
  The Finances context — profiles and all financial data scoped to them.
  """

  import Ecto.Query, warn: false
  alias Idcal.Repo
  alias Idcal.Accounts.Scope
  alias Idcal.Finances.{Profile, IncomeCategory, IncomeSource, IncomeEntry}

  ## Profiles

  @doc "Lists all profiles owned by the scoped user."
  def list_profiles(%Scope{} = scope) do
    Profile
    |> where(user_id: ^scope.user.id)
    |> order_by(asc: :nickname)
    |> Repo.all()
  end

  @doc "Fetches a profile owned by the scoped user. Raises if not found."
  def get_profile!(%Scope{} = scope, id) do
    Profile
    |> where(user_id: ^scope.user.id)
    |> Repo.get!(id)
  end

  @doc "Creates a profile owned by the scoped user."
  def create_profile(%Scope{} = scope, attrs) do
    %Profile{user_id: scope.user.id}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc "Updates a profile."
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc "Deletes a profile and all its financial data."
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc "Returns a changeset for tracking profile changes."
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  ## Income categories

  @doc "Lists income categories of a profile, with their sources preloaded."
  def list_income_categories(%Profile{} = profile) do
    IncomeCategory
    |> where(profile_id: ^profile.id)
    |> order_by(asc: :name)
    |> preload(
      sources: ^from(s in IncomeSource, order_by: s.name, preload: [entries: ^from(e in IncomeEntry, order_by: [desc: e.year, desc: e.month])])
    )
    |> Repo.all()
  end

  @doc "Fetches an income category belonging to the profile."
  def get_income_category!(%Profile{} = profile, id) do
    IncomeCategory
    |> where(profile_id: ^profile.id)
    |> Repo.get!(id)
  end

  def create_income_category(%Profile{} = profile, attrs) do
    %IncomeCategory{profile_id: profile.id}
    |> IncomeCategory.changeset(attrs)
    |> Repo.insert()
  end

  def update_income_category(%IncomeCategory{} = category, attrs) do
    category
    |> IncomeCategory.changeset(attrs)
    |> Repo.update()
  end

  def delete_income_category(%IncomeCategory{} = category) do
    Repo.delete(category)
  end

  def change_income_category(%IncomeCategory{} = category, attrs \\ %{}) do
    IncomeCategory.changeset(category, attrs)
  end

  ## Income sources

  @doc "Fetches an income source belonging to the profile."
  def get_income_source!(%Profile{} = profile, id) do
    IncomeSource
    |> where(profile_id: ^profile.id)
    |> Repo.get!(id)
  end

  def create_income_source(%Profile{} = profile, attrs) do
    %IncomeSource{profile_id: profile.id}
    |> IncomeSource.changeset(attrs)
    |> Repo.insert()
  end

  def update_income_source(%IncomeSource{} = source, attrs) do
    source
    |> IncomeSource.changeset(attrs)
    |> Repo.update()
  end

  def delete_income_source(%IncomeSource{} = source) do
    Repo.delete(source)
  end

  def change_income_source(%IncomeSource{} = source, attrs \\ %{}) do
    IncomeSource.changeset(source, attrs)
  end

  ## Income entries

  @doc "Lists all entries of an income source, newest month first."
  def list_income_entries(%IncomeSource{} = source) do
    IncomeEntry
    |> where(income_source_id: ^source.id)
    |> order_by(desc: :year, desc: :month)
    |> Repo.all()
  end

  def get_income_entry!(%IncomeSource{} = source, id) do
    IncomeEntry
    |> where(income_source_id: ^source.id)
    |> Repo.get!(id)
  end

  def create_income_entry(%IncomeSource{} = source, attrs) do
    %IncomeEntry{income_source_id: source.id}
    |> IncomeEntry.changeset(attrs)
    |> Repo.insert()
  end

  def update_income_entry(%IncomeEntry{} = entry, attrs) do
    entry
    |> IncomeEntry.changeset(attrs)
    |> Repo.update()
  end

  def delete_income_entry(%IncomeEntry{} = entry) do
    Repo.delete(entry)
  end

  def change_income_entry(%IncomeEntry{} = entry, attrs \\ %{}) do
    IncomeEntry.changeset(entry, attrs)
  end

  ## Income resolution

  @doc """
  Resolves the income contributed by each source for a given month.

  Returns a list of `{source, amount}` tuples. A monthly source uses its
  `base_amount` unless an entry overrides it; a sporadic source contributes
  only when an entry exists for that month.
  """
  def income_breakdown_for_month(%Profile{} = profile, year, month) do
    sources =
      IncomeSource
      |> where(profile_id: ^profile.id)
      |> order_by(asc: :name)
      |> Repo.all()

    entries = entries_by_source(IncomeEntry, sources, year, month)

    Enum.flat_map(sources, fn source ->
      case resolve_amount(source, Map.get(entries, source.id)) do
        nil -> []
        amount -> [{source, amount}]
      end
    end)
  end

  @doc "Total income for a profile in the given month."
  def resolve_income_for_month(%Profile{} = profile, year, month) do
    profile
    |> income_breakdown_for_month(year, month)
    |> Enum.reduce(Decimal.new(0), fn {_source, amount}, acc -> Decimal.add(acc, amount) end)
  end

  # Shared by income/expense resolution: map source_id => entry for the month.
  defp entries_by_source(schema, sources, year, month) do
    source_ids = Enum.map(sources, & &1.id)
    fk = if schema == IncomeEntry, do: :income_source_id, else: :expense_type_id

    schema
    |> where([e], field(e, ^fk) in ^source_ids and e.year == ^year and e.month == ^month)
    |> Repo.all()
    |> Map.new(fn entry -> {Map.get(entry, fk), entry} end)
  end

  # Resolves one source's amount for a month given an optional override entry.
  defp resolve_amount(source, entry) do
    cond do
      entry != nil -> entry.amount
      source.recurrence == :monthly -> source.base_amount
      true -> nil
    end
  end
end
