defmodule Behemoth.Repo.Migrations.CreateFishingTechiquesAccountUsers do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:"fishing.techniques_account_users", primary_key: false) do
      add :technique_id, references(:"fishing.techniques", on_delete: :delete_all), null: false, primary: true

      add :user_id, references(:"account.users", on_delete: :delete_all), null: false, primary: true
    end

    create index(:"fishing.techniques_account_users", [:user_id])
    create index(:"fishing.techniques_account_users", [:technique_id])

    create unique_index(:"fishing.techniques_account_users", [:user_id, :technique_id])
  end
end
