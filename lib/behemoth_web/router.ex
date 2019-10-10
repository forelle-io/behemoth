defmodule BehemothWeb.Router do
  use BehemothWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BehemothWeb do
    pipe_through :api
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Behemoth"
      }
    }
  end
end
