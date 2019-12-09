defmodule BehemothWeb.PageController do
  @moduledoc false

  use BehemothWeb, :controller

  import BehemothWeb.PageView, only: [application_name: 0]

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, _params) do
    json(conn, %{application: application_name()})
  end
end
