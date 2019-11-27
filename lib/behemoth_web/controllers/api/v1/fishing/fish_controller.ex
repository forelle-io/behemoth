defmodule BehemothWeb.Api.V1.Fishing.FishController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Fishing

  action_fallback BehemothWeb.FallbackController

  swagger_path :index do
    get("/api/v1/fishing/fishes")

    tag("Fishing")
    description("Список рыб с возможностью фильтрации")

    parameter(:name, :query, :string, "Наименование")

    security([%{Bearer: []}])

    response(code(:ok), %{"data" => %{"fishes" => Schema.ref(:Fishes)}})
  end

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, params) do
    fishes = Fishing.list_fishes(params)
    render(conn, "index.json", fishes: fishes)
  end

  # credo:disable-for-next-line Credo.Check.Refactor.ABCSize
  def swagger_definitions do
    %{
      Fish:
        swagger_schema do
          title("Fishing.Fish")
          description("Рыба")

          properties do
            id(:integer, "Id", required: true)
            name(:string, "Наименование", required: true)
          end

          example(%{id: 1, name: "щука"})
        end,
      Fishes:
        swagger_schema do
          title("Fishing.Fishes")
          description("Список рыб")

          type(:array)
          items(Schema.ref(:Technique))
        end
    }
  end
end
