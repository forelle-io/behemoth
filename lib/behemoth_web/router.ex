defmodule BehemothWeb.Router do
  use BehemothWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BehemothWeb do
    pipe_through :api
  end
end
