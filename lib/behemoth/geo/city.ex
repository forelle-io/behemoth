defmodule Behemoth.Contexts.Geo.City do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

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
end
