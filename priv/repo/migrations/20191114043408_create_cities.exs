defmodule Behemoth.Repo.Migrations.CreateCities do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:"geo.cities") do
      add :name, :string, null: false
      add :index, :integer
      add :region_type, :string
      add :region_name, :string

      timestamps()
    end

    create index(:"geo.cities", [:name])
  end
end
