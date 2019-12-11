defmodule Behemoth.Contexts.Fishing.Technique do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.TechniqueAccountUser

  schema "fishing.techniques" do
    field :name, :string

    many_to_many :users, User,
      join_through: TechniqueAccountUser,
      on_replace: :delete
  end

  @doc false
  def changeset(technique, attrs) do
    technique
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "fishing_techniques_name_index")
  end

  def search_by_name_with_like_query(name) do
    # TODO: Полнотекстовый поиск
    from ft in Technique, where: ilike(ft.name, ^"%#{name}%")
  end
end
