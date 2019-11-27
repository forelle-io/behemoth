defmodule Behemoth.Contexts.Account do
  @moduledoc false

  import Ecto.Query, warn: false

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Repo

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    case Repo.get(User, id) do
      %User{} = user -> user
      nil -> {:error, :not_found}
    end
  end

  def get_user_by_phone(phone) do
    case Repo.get_by(User, phone: phone) do
      %User{} = user -> user
      nil -> {:error, :not_found}
    end
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
