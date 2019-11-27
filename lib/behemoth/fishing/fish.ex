defmodule Behemoth.Contexts.Fishing.Fish do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

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
end
