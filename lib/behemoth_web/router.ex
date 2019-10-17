defmodule BehemothWeb.Router do
  use BehemothWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BehemothWeb.Api, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      scope "/auth", Auth, as: :auth do
        get "/ping", AuthController, :ping
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
        ## Возможности: описание скоро будет доступно
        """
      },
      securityDefinitions: %{
        api_auth: %{
          type: "apiKey",
          name: "Authorization",
          in: "header"
        }
      }
    }
  end
end
