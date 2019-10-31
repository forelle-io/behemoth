defmodule BehemothWeb.Api.V1.Auth.GatewayController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Account
  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Auth
  alias Begemoth.Contexts.Auth.SmsCode

  action_fallback Behemoth.FallbackController

  swagger_path :send_sms do
    post("/api/v1/auth/gateway/send_sms")

    tag("Auth.Gateway")
    description("Отправка СМС сообщения")

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:struct_type, :formData, :string, "Тип аккаунта", required: true)
    parameter(:phone, :formData, :integer, "Телефон", required: true)

    response(code(:created), %{"data" => %{"phone" => "79999999999"}})
    response(code(:not_found), %{"errors" => "not found"})
  end

  def send_sms(conn, %{"struct_type" => "user", "phone" => phone}) do
    with %User{id: user_id, phone: phone} <- Account.get_user_by_phone(phone),
         {:ok, %SmsCode{auth_code: auth_code}} <-
           Auth.create_sms_code(%{"struct_type" => "user", "struct_id" => user_id}) do
      conn
      |> put_status(:created)
      |> json(%{"data" => %{"phone" => phone, "auth_code" => auth_code}})
    end
  end
end
