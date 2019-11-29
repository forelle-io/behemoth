defmodule Behemoth.Repo.Migrations.CreateGeoCities do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:"geo.cities") do
      add :name, :string, null: false
    end

    create unique_index(:"geo.cities", :name)
  end
end
