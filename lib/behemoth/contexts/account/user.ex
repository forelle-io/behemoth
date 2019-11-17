defmodule Behemoth.Contexts.Account.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Behemoth.Policies.Account.UserPolicy

  defdelegate authorize(action, user, params), to: UserPolicy

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
    |> validate_required([:phone])
    |> validate_number(:phone, greater_than_or_equal_to: 70_000_000_000, less_than_or_equal_to: 79_999_999_999)
    |> unique_constraint(:phone, name: "account_users_phone_index")
  end

  @doc false
  def create_changeset(user, attrs) do
    changeset(user, attrs)
  end

  @doc false
  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:birthday, :gender, :first_name, :last_name])
    |> validate_required([:phone])
  end
end
