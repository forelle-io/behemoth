defmodule Behemoth.Contexts.Geo do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Behemoth.Repo

  alias Behemoth.Contexts.Geo.City

  def list_cities do
    Repo.all(City)
  end

  def get_city!(id), do: Repo.get!(City, id)

  def get_city(id) do
    case Repo.get(City, id) do
      %City{} = city -> city
      nil -> {:error, :not_found}
    end
  end

  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  def change_city(%City{} = city) do
    City.changeset(city, %{})
  end
end
