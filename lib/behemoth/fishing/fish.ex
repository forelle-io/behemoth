defmodule Behemoth.Contexts.Fishing.Fish do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__

  schema "fishing.fishes" do
    field :name, :string
  end

  @doc false
  def changeset(fish, attrs) do
    fish
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "fishing_fishes_name_index")
  end

  def search_by_name_with_like_query(name) do
    from f in Fish, where: like(f.name, ^"%#{name}%")
  end
end
