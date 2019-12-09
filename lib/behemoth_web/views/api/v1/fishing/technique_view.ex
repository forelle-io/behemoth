defmodule BehemothWeb.Api.V1.Fishing.TechniqueView do
  @moduledoc false

  use BehemothWeb, :view

  def render("index.json", %{techniques: techniques}) do
    %{data: render_many(techniques, __MODULE__, "technique.json")}
  end

  def render("show.json", %{technique: technique}) do
    %{data: render_one(technique, __MODULE__, "technique.json")}
  end

  def render("technique.json", %{technique: technique}) do
    %{
      id: technique.id,
      name: technique.name
    }
  end
end
