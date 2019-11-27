defmodule BehemothWeb.Api.V1.Fishing.TechniqueController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Fishing

  action_fallback BehemothWeb.FallbackController

  swagger_path :index do
    get("/api/v1/fishing/techniques")

    tag("Fishing.Technique")
    description("Список техник ловли рыб с возможностью фильтрации")

    parameter(:name, :query, :string, "Наименование")

    security([%{Bearer: []}])

    response(code(:ok), %{"data" => %{"techniques" => Schema.ref(:Techniques)}})
  end

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, params) do
    techniques = Fishing.list_techniques(params)
    render(conn, "index.json", techniques: techniques)
  end

  # credo:disable-for-next-line Credo.Check.Refactor.ABCSize
  def swagger_definitions do
    %{
      Technique:
        swagger_schema do
          title("Fishing.Technique")
          description("Техника ловли")

          properties do
            id(:integer, "Id", required: true)
            name(:string, "Наименование", required: true)
          end

          example(%{id: 1, name: "спиннинг"})
        end,
      Techniques:
        swagger_schema do
          title("Fishing.Techniques")
          description("Список техник ловли")

          type(:array)
          items(Schema.ref(:Technique))
        end
    }
  end
end
