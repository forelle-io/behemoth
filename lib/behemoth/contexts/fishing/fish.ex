defmodule Behemoth.Contexts.Fishing.Fish do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.FishAccountUser
  alias Behemoth.Contexts.Fishing
  alias Ecto.Changeset
  alias __MODULE__

  schema "fishing.fishes" do
    field :name, :string

    many_to_many :users, User,
      join_through: FishAccountUser,
      on_replace: :delete
  end

  @doc false
  def changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "fishing_fishes_name_index")
  end

  def search_by_name_with_like_query(name) do
    from f in Fish, where: ilike(f.name, ^"%#{name}%")
  end

  def fishes_modify_changes(%Changeset{changes: changes} = changeset) do
    case changes do
      %{fishes_ids: nil} ->
        changeset

      %{fishes_ids: []} ->
        put_assoc(changeset, :fishes, [])

      %{fishes_ids: fishes_ids} ->
        put_assoc(changeset, :fishes, Fishing.list_fishes(fishes_ids))

      _ ->
        changeset
    end
  end

  def list_fishes_query(ids) do
    from f in Fish,
      where: f.id in ^ids
  end
end
