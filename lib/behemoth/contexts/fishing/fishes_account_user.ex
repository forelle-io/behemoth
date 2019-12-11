defmodule Behemoth.Contexts.Fishing.FishAccountUser do
  @moduledoc false
  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.Fish
  alias Behemoth.Policies.Fishing.FishAccountUserPolicy

  defdelegate authorize(action, user, params), to: FishAccountUserPolicy

  @primary_key false

  schema "fishing.fishes_account_users" do
    belongs_to :fishes, Fish, foreign_key: :fish_id, primary_key: true
    belongs_to :users, User, foreign_key: :user_id, primary_key: true
  end

  @doc false
  def changeset(fish_account_user, attrs) do
    fish_account_user
    |> cast(attrs, [:fish_id, :user_id])
    |> validate_required([:fish_id, :user_id])
    |> foreign_key_constraint(:fish_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id_fish_id, name: "fishing_fishes_account_users_user_id_fish_id_index")
  end

  def get_fish_account_user_query(fish_id, user_id) do
    from ffau in FishAccountUser,
      where: ffau.fish_id == ^fish_id and ffau.user_id == ^user_id
  end
end
