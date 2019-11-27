defmodule BehemothWeb.Api.V1.Account.UserController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Account
  alias Behemoth.Contexts.Account.User

  action_fallback BehemothWeb.FallbackController

  def action(conn, _) do
    action_name = action_name(conn)

    args =
      if action_name in [:index, :create] do
        [conn, conn.params]
      else
        [conn, conn.params, Behemoth.Guardian.Plug.current_resource(conn, key: :user)]
      end

    apply(__MODULE__, action_name, args)
  end

  swagger_path :index do
    get("/api/v1/account/users")

    tag("Account")
    description("Список пользователей")

    security([%{Bearer: []}])

    response(code(:ok), %{"data" => %{"users" => Schema.ref(:Users)}})
  end

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  swagger_path :create do
    post("/api/v1/account/users")

    tag("Account")
    description("Создание пользователя")

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:is_adulthood, :formData, :boolean, "Подтверждение совершеннолетия", required: true)
    parameter(:"user[phone]", :formData, :integer, "Телефон", required: true)
    parameter(:"user[first_name]", :formData, :string, "Имя", required: true)
    parameter(:"user[last_name]", :formData, :string, "Фамилия", required: true)

    response(code(:created), %{"data" => %{"user" => Schema.ref(:User)}})
    response(code(:unprocessable_entity), %{"errors" => %{"phone" => ["has already been taken"]}})
  end

  @spec create(Conn.t(), map) :: Conn.t()
  def create(conn, %{"user" => user_params, "is_adulthood" => "true"}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def create(_conn, %{"user" => _user_params, "is_adulthood" => _is_adulthood}) do
    {:error, :unprocessable_entity}
  end

  swagger_path :update do
    put("/api/v1/account/users/{id}")

    tag("Account")
    description("Обновление пользователя")

    security([%{Bearer: []}])

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:id, :path, :integer, "Id пользователя")
    parameter(:"user[first_name]", :query, :date, "Имя")
    parameter(:"user[last_name]", :query, :date, "Фамилия")
    parameter(:"user[birthday]", :query, :date, "Дата рождения")
    parameter(:"user[gender]", :formData, :integer, "Пол")

    response(code(:ok), %{"data" => %{"user" => Schema.ref(:User)}})
    response(code(:forbidden), %{"errors" => "not authorized"})
    response(code(:not_found), %{"errors" => "not found"})
    response(code(:unauthorized), %{"errors" => "unauthorized"})
  end

  @spec update(Conn.t(), map, %User{}) :: Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}, %User{} = current_user) do
    with %User{} = user <- Account.get_user(id),
         :ok <- Bodyguard.permit(User, :update, current_user, user),
         {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  swagger_path :show do
    get("/api/v1/account/users/{id}")

    tag("Account")
    description("Получение информации о пользователе")

    security([%{Bearer: []}])

    parameter(:id, :path, :integer, "Id пользователя", required: true)

    response(code(:ok), %{"data" => %{"user" => Schema.ref(:User)}})
  end

  @spec show(Conn.t(), map, %User{}) :: Conn.t()
  def show(conn, %{"id" => id}, %User{} = _current_user) do
    with %User{} = user <- Account.get_user(id) do
      render(conn, "show.json", user: user)
    end
  end

  swagger_path :delete do
    tag("Account")
    description("Удаление пользователя")

    security([%{Bearer: []}])

    parameter(:id, :path, :integer, "Id пользователя", required: true)

    response(code(:no_content), "")
    response(code(:forbidden), %{"errors" => "not authorized"})
    response(code(:not_found), %{"errors" => "not found"})
    response(code(:forbidden), %{"errors" => "forbidden"})
  end

  @spec delete(Conn.t(), map, %User{}) :: Conn.t()
  def delete(conn, %{"id" => id}, %User{} = current_user) do
    with %User{} = user <- Account.get_user(id),
         :ok <- Bodyguard.permit(User, :delete, current_user, user),
         {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  # credo:disable-for-next-line Credo.Check.Refactor.ABCSize
  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("Account.User")
          description("Пользователь")

          properties do
            id(:integer, "Id", required: true)
            phone(:integer, "Телефон", required: true)
            first_name(:string, "Имя")
            last_name(:string, "Фамилия")
            gender(:string, "Пол")
            birthday(:date, "Дата рождения")
            inserted_at(:timestamp, "Дата и время создания", required: true)
            updated_at(:timestamp, "Дата и время обновления", required: true)
          end

          example(%{
            id: 1,
            phone: 79_999_999_999,
            first_name: "Alexey",
            last_name: "Solovyev",
            gender: "male",
            birthday: "1994-05-03",
            inserted_at: "2019-05-31 08:33:46",
            updated_at: "2019-05-31 08:34:17"
          })
        end,
      Users:
        swagger_schema do
          title("Account.Users")
          description("Список пользователей")

          type(:array)
          items(Schema.ref(:User))
        end
    }
  end
end
