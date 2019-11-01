defmodule BehemothWeb.Api.V1.Auth.AuthenticateController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Account
  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Auth
  alias Behemoth.Contexts.Auth.SmsCode

  swagger_path :ping do
    get("/api/v1/auth/authenticate/ping")

    tag("Auth.Authenticate")
    description("Проверка валидности доступа к закрытым токеном функциям  API")

    security([%{Bearer: []}])

    response(code(:ok), %{"message" => "pong"})
    response(code(:unauthorized), %{"error" => "Correct auth token must be provided."})
  end

  @spec ping(Conn.t(), map) :: Conn.t()
  def ping(%Plug.Conn{} = conn, _params), do: json(conn, %{"message" => "pong"})

  swagger_path :user do
    get("/api/v1/auth/authenticate/user")

    tag("Auth.Authenticate")
    description("Аутентификация")

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:phone, :query, :integer, "Телефон")
    parameter(:auth_code, :query, :string, "Код подтверждения")

    response(code(:ok), %{"data" => %{"jwt_token" => "UxMiI2InR5cCImIkpXVCJ9.eyJhdW..."}})
    response(code(:not_found), %{"errors" => "not found"})
  end

  @spec user(Conn.t(), map) :: Conn.t()
  def user(conn, %{"phone" => phone, "auth_code" => auth_code}) do
    with %User{id: user_id} = user <- Account.get_user_by_phone(phone),
         %SmsCode{} = sms_code <- Auth.last_unconfirmed_sms_code("user", user_id, auth_code),
         {:ok, %SmsCode{}} <- Auth.update_sms_code(sms_code, %{confirmed_at: DateTime.utc_now()}),
         {:ok, jwt_token, _claims} <- Behemoth.Guardian.encode_and_sign(user) do
      json(conn, %{"data" => %{"jwt_token" => jwt_token}})
    end
  end
end
