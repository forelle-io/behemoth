defmodule Begemoth.Contexts.Auth.SmsCode do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__
  alias Ecto.Changeset

  schema "auth.sms_codes" do
    field :struct_type, :string
    field :struct_id, :integer
    field :auth_code, :string
    field :confirmed_at, :naive_datetime

    timestamps()
  end

  @doc false
  def create_changeset(sms_code, attrs) do
    sms_code
    |> cast(attrs, [:struct_type, :struct_id])
    |> validate_required([:struct_type, :struct_id])
    |> generate_auth_code()
  end

  @doc false
  def update_changeset(sms_code, attrs) do
    sms_code
    |> cast(attrs, [:confirmed_at])
    |> validate_required([:struct_type, :struct_id, :auth_code])
  end

  def last_sms_code_query(struct_type, struct_id) do
    from sms_code in SmsCode,
      where:
        sms_code.struct_type == ^struct_type and
        sms_code.struct_id == ^struct_id,
      order_by: [desc: sms_code.id],
      limit: 1
  end

  defp generate_auth_code(%Changeset{} = changeset) do
    case changeset do
      %{valid?: true} ->
        put_change(changeset, :auth_code, generate_auth_code())

      _ ->
        changeset
    end
  end

  defp generate_auth_code, do: generate_auth_code(4)

  defp generate_auth_code(length) when is_integer(length) do
    uppercase_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("", trim: true)

    1..length
    |> Enum.reduce([], fn _i, acc ->
      [Enum.random(uppercase_chars) | acc]
    end)
    |> Enum.join("")
  end

  def last_unconfirmed_sms_code_query(struct_type, struct_id) do
    from sms_code in SmsCode,
      where:
          sms_code.struct_type == ^struct_type and
          sms_code.struct_id == ^struct_id and
          is_nil(sms_code.confirmed_at),
      order_by: [desc: sms_code.id],
      limit: 1
  end
end
