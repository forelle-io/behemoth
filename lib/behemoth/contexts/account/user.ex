defmodule Behemoth.Contexts.Account.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "account.users" do
    field :phone, :integer
    field :birthday, :date
    field :gender, :integer
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :birthday, :gender, :first_name, :last_name])
    |> validate_required([:phone, :birthday, :gender, :first_name, :last_name])
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :birthday, :gender, :first_name, :last_name])
    |> validate_required([:phone])
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:birthday, :gender, :first_name, :last_name])
    |> validate_required([:phone])
  end
end
