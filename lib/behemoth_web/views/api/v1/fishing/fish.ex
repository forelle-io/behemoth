defmodule BehemothWeb.Api.V1.Fishing.FishView do
  @moduledoc false

  use BehemothWeb, :view

  def render("index.json", %{fishes: fishes}) do
    %{data: render_many(fishes, __MODULE__, "fish.json")}
  end

  def render("show.json", %{fish: fish}) do
    %{data: render_one(fish, __MODULE__, "fish.json")}
  end

  def render("fish.json", %{fish: fish}) do
    %{
      id: fish.id,
      name: fish.name
    }
  end
end
