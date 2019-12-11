defmodule BehemothWeb.Api.V1.Fishing.TechniqueAccountUserController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing
  alias Behemoth.Contexts.Fishing.TechniqueAccountUser

  action_fallback BehemothWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, Behemoth.Guardian.Plug.current_resource(conn, key: :user)]
    apply(__MODULE__, action_name(conn), args)
  end

  swagger_path :create do
    post("/api/v1/fishing/techniques_account_users")

    tag("Fishing")
    description("Создание связи между техникой ловли и пользователем")

    security([%{Bearer: []}])

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:technique_id, :formData, :integer, "Id техники ловли", required: true)
    parameter(:user_id, :formData, :integer, "Id пользователя", required: true)

    response(code(:created), %{"data" => %{"technique_id" => 1, "user_id" => 1}})
    response(code(:unauthorized), %{"errors" => "unauthorized"})
    response(code(:forbidden), %{"errors" => "forbidden"})
    response(code(:unprocessable_entity), %{"errors" => %{"technique_id" => ["does not exist"]}})
  end

  @spec create(Conn.t(), map, %User{}) :: Conn.t()
  def create(conn, %{"technique_id" => _technique_id, "user_id" => _user_id} = params, %User{} = current_user) do
    with :ok <- Bodyguard.permit(TechniqueAccountUser, :create, current_user, params),
         {:ok, %TechniqueAccountUser{} = technique_account_user} <- Fishing.create_technique_account_user(params) do
      conn
      |> put_status(:created)
      |> render("show.json", technique_account_user: technique_account_user)
    end
  end

  swagger_path :delete do
    tag("Fishing")
    description("Удаление связи между техникой ловли и пользователем")

    security([%{Bearer: []}])

    consumes("application/x-www-form-urlencoded")

    parameter(:technique_id, :formData, :integer, "Id техники ловли", required: true)
    parameter(:user_id, :formData, :integer, "Id пользователя", required: true)

    response(code(:no_content), "")
    response(code(:unauthorized), %{"errors" => "unauthorized"})
    response(code(:forbidden), %{"errors" => "forbidden"})
  end

  @spec delete(Conn.t(), map, %User{}) :: Conn.t()
  def delete(conn, %{"technique_id" => _technique_id, "user_id" => _user_id} = params, %User{} = current_user) do
    with %TechniqueAccountUser{} = technique_account_user <- Fishing.get_technique_account_user(params),
         :ok <- Bodyguard.permit(TechniqueAccountUser, :delete, current_user, technique_account_user),
         {_, nil} <- Fishing.delete_technique_account_user(params) do
      send_resp(conn, :no_content, "")
    end
  end
end
