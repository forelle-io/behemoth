defmodule Behemoth.Repo.Migrations.CreateFishAccountUser do
  use Ecto.Migration

  def change do
    create table(:"fishing.fishes_account_users", primary_key: false) do
      add :fish_id, references(:"fishing.fishes", on_delete: :delete_all), null: false, primary: true

      add :user_id, references(:"account.users", on_delete: :delete_all), null: false, primary: true
    end

    create index(:"fishing.fishes_account_users", [:user_id])
    create index(:"fishing.fishes_account_users", [:fish_id])

    create unique_index(:"fishing.fishes_account_users", [:user_id, :fish_id])
  end
end
