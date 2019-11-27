defmodule BehemothWeb.Api.V1.Geo.CityView do
  @moduledoc false

  use BehemothWeb, :view

  def render("index.json", %{cities: cities}) do
    %{data: render_many(cities, __MODULE__, "city.json")}
  end

  def render("show.json", %{city: city}) do
    %{data: render_one(city, __MODULE__, "city.json")}
  end

  def render("city.json", %{city: city}) do
    %{
      id: city.id,
      name: city.name
    }
  end
end
