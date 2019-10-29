defmodule Behemoth.Repo.Migrations.CreateAuthSmsCodes do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:"auth.sms_codes") do
      add :struct_type, :string
      add :struct_id, :integer
      add :auth_code, :string
      add :confirmed_at, :naive_datetime

      timestamps()
    end
  end
end
