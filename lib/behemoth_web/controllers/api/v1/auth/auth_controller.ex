defmodule BehemothWeb.Api.V1.Auth.AuthController do
  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  swagger_path :ping do
    get("/api/v1/auth/ping")
    description("Проверка валидности доступа к закрытым токеном функциям  API")

    response(code(:ok), %{"message" => "pong"})
    response(code(:unauthorized), %{"error" => "Correct auth token must be provided."})
  end

  @spec ping(Conn.t, map) :: Conn.t
  def ping(%Plug.Conn{} = conn, _params), do: json(conn, %{"message" => "pong"})
end
