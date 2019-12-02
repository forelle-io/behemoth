defmodule Behemoth.Contexts.Geo.City do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__

  schema "geo.cities" do
    field :name, :string
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "geo_cities_name_index")
  end

  def search_by_name_with_like_query(name) do
    from c in City, where: like(c.name, ^"%#{name}%")
  end
end
