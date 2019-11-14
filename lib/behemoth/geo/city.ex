defmodule Behemoth.Contexts.Geo.City do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "geo.cities" do
    field :index, :integer
    field :name, :string
    field :region_type, :string
    field :region_name, :string

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :index, :region_type, :region_name])
    |> validate_required([:name])
  end
end
