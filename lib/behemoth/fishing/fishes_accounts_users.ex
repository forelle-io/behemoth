defmodule Behemoth.Contexts.Fishing.FishAccountsUser do
  @moduledoc false
  use Ecto.Schema

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.Fish

  @primary_key false

  schema "fishing.fishes_accounts_users" do
    belongs_to(:fishes, Fish, foreign_key: :fish_id)
    belongs_to(:users, User, foreign_key: :user_id)
  end
end
