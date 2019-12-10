defmodule BehemothWeb.Api.V1.Fishing.FishAccountUserController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Account.User
  alias Behemoth.Contexts.Fishing
  alias Behemoth.Contexts.Fishing.FishAccountUser

  action_fallback BehemothWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, Behemoth.Guardian.Plug.current_resource(conn, key: :user)]
    apply(__MODULE__, action_name(conn), args)
  end

  swagger_path :create do
    post("/api/v1/fishing/fishes_account_users")

    tag("Fishing")
    description("Создание связи рыбы и пользователя")

    security([%{Bearer: []}])

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:fish_id, :formData, :integer, "Id рыбы", required: true)
    parameter(:user_id, :formData, :integer, "Id пользователя", required: true)

    response(code(:created), %{"data" => %{"user" => Schema.ref(:User)}})
    response(code(:unprocessable_entity), %{"errors" => %{"phone" => ["has already been taken"]}})
  end

  @spec create(Conn.t(), map, %User{}) :: Conn.t()
  def create(conn, %{"fish_id" => _fish_id, "user_id" => _user_id} = params, %User{} = current_user) do
    with :ok <- Bodyguard.permit(FishAccountUser, :create, current_user, params),
         {:ok, %FishAccountUser{} = fish_account_user} <- Fishing.create_fish_account_user(params) do
      conn
      |> put_status(:created)
      |> render("show.json", fish_account_user: fish_account_user)
    end
  end

  swagger_path :delete do
    tag("Fishing")
    description("Удаление связи рыбы и пользователя")

    security([%{Bearer: []}])

    consumes("application/x-www-form-urlencoded")

    parameter(:fish_id, :formData, :integer, "Id рыбы", required: true)
    parameter(:user_id, :formData, :integer, "Id пользователя", required: true)

    response(code(:no_content), "")
    response(code(:forbidden), %{"errors" => "not authorized"})
    response(code(:forbidden), %{"errors" => "forbidden"})
  end

  @spec delete(Conn.t(), map, %User{}) :: Conn.t()
  def delete(conn, %{"fish_id" => _fish_id, "user_id" => _user_id} = params, %User{} = current_user) do
    with %FishAccountUser{} = fish_account_user <- Fishing.get_fish_account_user(params),
         :ok <- Bodyguard.permit(FishAccountUser, :delete, current_user, fish_account_user),
         {_, nil} <- Fishing.delete_fish_account_user(params) do
      send_resp(conn, :no_content, "")
    end
  end
end
