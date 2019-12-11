defmodule Behemoth.Contexts.Fishing.TechniqueAccountUser do
  @moduledoc false
  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing.Technique
  alias Behemoth.Policies.Fishing.TechniqueAccountUserPolicy

  defdelegate authorize(action, user, params), to: TechniqueAccountUserPolicy

  @primary_key false

  schema "fishing.techniques_account_users" do
    belongs_to :techniques, Technique, foreign_key: :technique_id, primary_key: true
    belongs_to :users, User, foreign_key: :user_id, primary_key: true
  end

  @doc false
  def changeset(technique_account_user, attrs) do
    technique_account_user
    |> cast(attrs, [:technique_id, :user_id])
    |> validate_required([:technique_id, :user_id])
    |> foreign_key_constraint(:technique_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:user_id_technique_id, name: "fishing_techniques_account_users_user_id_technique_id_index")
  end

  def get_technique_account_user_query(technique_id, user_id) do
    from ftau in TechniqueAccountUser,
      where: ftau.technique_id == ^technique_id and ftau.user_id == ^user_id
  end
end
