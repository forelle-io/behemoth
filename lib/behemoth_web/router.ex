defmodule BehemothWeb.Router do
  use BehemothWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guardian_user_pipeline do
    plug BehemothWeb.Plugs.Api.V1.GuardianUserPipeline
  end

  pipeline :ensure_user_authenticated do
    plug Guardian.Plug.EnsureAuthenticated, key: :user, claims: %{"typ" => "access"}
  end

  scope "/api", BehemothWeb.Api, as: :api do
    pipe_through [:api, :guardian_user_pipeline]

    scope "/v1", V1, as: :v1 do
      scope "/account", Account, as: :account do
        pipe_through :ensure_user_authenticated

        resources "/users", UserController, only: [:index, :update, :show, :delete]
      end

      scope "/account", Account, as: :account do
        resources "/users", UserController, only: [:create]
      end

      scope "/auth", Auth, as: :auth do
        pipe_through :ensure_user_authenticated

        get "/authenticate/ping", AuthenticateController, :ping
      end

      scope "/auth", Auth, as: :auth do
        get "/authenticate/user", AuthenticateController, :user
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
        Получение JWT - токена осущесвляется через запрос `[GET] /api/v1/auth/authenticate/user`.
        После выдачи системой JWT - токена, его необходимо передавать в заголовке `Authorization: Bearer token`.

        Возможности:
        * Получение JWT - токена по телефону
        * Создание / Редактирование / Удаление / Просмотр / Получение списка пользователя (пользователей)
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
