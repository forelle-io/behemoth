defmodule BehemothWeb.Api.V1.PageController do
  @moduledoc false
  use BehemothWeb, :controller

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, _params) do
    json(conn, %{application: "Behemoth", environment: Mix.env()})
  end
end
