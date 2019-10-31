defmodule BehemothWeb.Router do
  use BehemothWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BehemothWeb.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      scope "/account", Account, as: :account do
        resources "/users", UserController
      end

      scope "/auth", Auth, as: :auth do
        get "/authenticate/ping", AuthenticateController, :ping
        post "/gateway/send_sms", GatewayController, :send_sms
      end
    end
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :behemoth, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Behemoth API",
        description: """
        Аутентификация пользователя осуществляется посредством токена доступа, который необходимо получить через запрос
        `[GET] /api/v1/auth/authenticate/user`. Полученный токен передается в заголовке `Authorization: Bearer token`.
        """
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          in: "header"
        }
      }
    }
  end
end
