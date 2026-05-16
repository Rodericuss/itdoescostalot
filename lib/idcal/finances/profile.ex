defmodule Idcal.Finances.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :nickname, :string
    belongs_to :user, Idcal.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:nickname])
    |> validate_required([:nickname])
    |> validate_length(:nickname, min: 1, max: 60)
  end
end
