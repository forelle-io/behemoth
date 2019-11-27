defmodule Behemoth.Contexts.Fishing.Technique do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

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
end
