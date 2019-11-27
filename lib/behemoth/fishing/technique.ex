defmodule Behemoth.Contexts.Fishing.Technique do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__

  schema "fishing.techniques" do
    field :name, :string
  end

  @doc false
  def changeset(technique, attrs) do
    technique
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: "fishing_techniques_name_index")
  end

  def search_by_name_with_like_query(name) do
    from t in Technique, where: like(t.name, ^"%#{name}%")
  end
end
