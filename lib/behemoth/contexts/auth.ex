defmodule Behemoth.Contexts.Auth do
  @moduledoc """
  Контекст Аутентификации
  """

  import Ecto.Query, warn: false

  alias Behemoth.Repo

  alias Begemoth.Contexts.Auth.SmsCode

  def list_sms_codes do
    Repo.all(SmsCode)
  end

  def last_unconfirmed_sms_code(struct_type, struct_id, auth_code) do
    sms_code =
      struct_type
      |> SmsCode.last_sms_code_query(struct_id)
      |> Repo.one()

    case sms_code do
      %SmsCode{auth_code: ^auth_code, confirmed_at: nil} = sms_code -> sms_code
      _ -> {:error, :not_found}
    end
  end

  def last_unconfirmed_sms_code(struct_type, struct_id) do
    sms_code =
      struct_type
      |> SmsCode.last_unconfirmed_sms_code_query(struct_id)
      |> Repo.one()
  end

  def get_sms_code!(id), do: Repo.get!(SmsCode, id)

  def create_sms_code(attrs \\ %{}) do
    %SmsCode{}
    |> SmsCode.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_sms_code(%SmsCode{} = sms_code, attrs) do
    sms_code
    |> SmsCode.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_sms_code(%SmsCode{} = sms_code) do
    Repo.delete(sms_code)
  end
end
