defmodule Behemoth.Contexts.Fishing do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Behemoth.Repo

  alias Behemoth.Contexts.Fishing.Fish

  #структура рыб -------------------------------------------------------------------
  def list_fishes do
    Repo.all(Fish)
  end

  def get_fish!(id), do: Repo.get!(Fish, id)

  def get_fish(id) do
    case Repo.get(Fish, id) do
      %Fish{} = fish -> fish
      nil -> {:error, :not_found}
    end
  end

  def create_fish(attrs \\ %{}) do
    %Fish{}
    |> Fish.changeset(attrs)
    |> Repo.insert()
  end

  def delete_fish(%Fish{} = fish) do
    Repo.delete(fish)
  end

  def change_fish(%Fish{} = fish) do
    Fish.changeset(fish, %{})
  end
end
