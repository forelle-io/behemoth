defmodule BehemothWeb.Api.V1.Geo.CityController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Geo

  action_fallback BehemothWeb.FallbackController

  swagger_path :index do
    get("/api/v1/geo/cities")

    tag("Geo.City")
    description("Список городов с возможностью фильтрации")

    parameter(:name, :query, :string, "Наименование")

    security([%{Bearer: []}])

    response(code(:ok), %{"data" => %{"cities" => Schema.ref(:Cities)}})
  end

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, params) do
    cities = Geo.list_cities(params)
    render(conn, "index.json", cities: cities)
  end

  # credo:disable-for-next-line Credo.Check.Refactor.ABCSize
  def swagger_definitions do
    %{
      City:
        swagger_schema do
          title("Geo.City")
          description("Город")

          properties do
            id(:integer, "Id", required: true)
            name(:string, "Наименование", required: true)
          end

          example(%{
            id: 1,
            name: "Москва"
          })
        end,
      Cities:
        swagger_schema do
          title("Geo.Cities")
          description("Список городов")

          type(:array)
          items(Schema.ref(:City))
        end
    }
  end
end
