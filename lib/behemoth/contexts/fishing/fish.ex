defmodule Behemoth.Contexts.Fishing.Fish do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.FishAccountUser

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
    # TODO: Полнотекстовый поиск
    from ff in Fish, where: ilike(ff.name, ^"%#{name}%")
  end
end
