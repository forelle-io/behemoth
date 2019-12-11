defmodule Behemoth.Contexts.Fishing do
  @moduledoc """
  Контекст Рыбной ловли
  """
  import Ecto.Query, warn: false

  alias Behemoth.Contexts.Fishing.{Fish, FishAccountUser, Technique, TechniqueAccountUser}
  alias Behemoth.Repo

  def list_fishes, do: Repo.all(Fish)

  def list_fishes(params) do
    case params do
      %{"name" => name} ->
        name
        |> Fish.search_by_name_with_like_query()
        |> Repo.all()

      _ ->
        list_fishes()
    end
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

  def list_techniques, do: Repo.all(Technique)

  def list_techniques(params) do
    case params do
      %{"name" => name} ->
        name
        |> Technique.search_by_name_with_like_query()
        |> Repo.all()

      _ ->
        list_techniques()
    end
  end

  def get_technique!(id), do: Repo.get!(Technique, id)

  def get_technique(id) do
    case Repo.get(Technique, id) do
      %Technique{} = technique -> technique
      nil -> {:error, :not_found}
    end
  end

  def create_technique(attrs \\ %{}) do
    %Technique{}
    |> Technique.changeset(attrs)
    |> Repo.insert()
  end

  def delete_technique(%Technique{} = technique) do
    Repo.delete(technique)
  end

  def change_technique(%Technique{} = technique) do
    Technique.changeset(technique, %{})
  end

  def get_fish_account_user(%{"user_id" => user_id, "fish_id" => fish_id}) do
    case Repo.get_by(FishAccountUser, user_id: user_id, fish_id: fish_id) do
      %FishAccountUser{} = fish_account_user ->
        fish_account_user

      nil ->
        {:error, :not_found}
    end
  end

  def create_fish_account_user(attrs \\ %{}) do
    %FishAccountUser{}
    |> FishAccountUser.changeset(attrs)
    |> Repo.insert()
  end

  def delete_fish_account_user(%{"user_id" => user_id, "fish_id" => fish_id}) do
    fish_id
    |> FishAccountUser.get_fish_account_user_query(user_id)
    |> Repo.delete_all()
  end

  def create_technique_account_user(attrs \\ %{}) do
    %TechniqueAccountUser{}
    |> TechniqueAccountUser.changeset(attrs)
    |> Repo.insert()
  end

  def get_technique_account_user(%{"user_id" => user_id, "technique_id" => technique_id}) do
    case Repo.get_by(TechniqueAccountUser, user_id: user_id, technique_id: technique_id) do
      %TechniqueAccountUser{} = technique_account_user ->
        technique_account_user

      nil ->
        {:error, :not_found}
    end
  end

  def delete_technique_account_user(%{"user_id" => user_id, "technique_id" => technique_id}) do
    technique_id
    |> TechniqueAccountUser.get_technique_account_user_query(user_id)
    |> Repo.delete_all()
  end

end
