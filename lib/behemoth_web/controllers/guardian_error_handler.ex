defmodule BehemothWeb.GuardianErrorHandler do
  @moduledoc false

  import Phoenix.Controller
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts)
      when type in [:unauthorized, :unauthenticated, :invalid_token] do
    conn
    |> put_status(:unauthorized)
    |> put_view(BehemothWeb.ErrorView)
    |> render("401.json")
  end

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:no_resource_found, _reason}, _opts) do
    conn
    |> put_status(:not_found)
    |> put_view(BehemothWeb.ErrorView)
    |> render("404.json")
  end
end
