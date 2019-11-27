defmodule Behemoth.Repo.Migrations.CreateAccountUsers do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:"account.users") do
      add :phone, :bigint, null: false
      add :birthday, :date
      add :gender, :integer
      add :first_name, :string
      add :last_name, :string
      add :city_id, references(:"geo.cities")

      timestamps()
    end

    create unique_index(:"account.users", :phone)
  end
end
