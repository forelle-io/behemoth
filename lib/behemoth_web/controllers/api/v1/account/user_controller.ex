defmodule BehemothWeb.Api.V1.Account.UserController do
  @moduledoc false

  use BehemothWeb, :controller
  use PhoenixSwagger

  import Plug.Conn.Status, only: [code: 1]

  alias Behemoth.Contexts.Account
  alias Behemoth.Contexts.Account.User

  action_fallback BehemothWeb.FallbackController

  swagger_path :index do
    get("/api/v1/account/users")

    tag("Account.User")
    description("Список пользователей")

    response(code(:ok), %{"data" => %{"users" => Schema.ref(:Users)}})
  end

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, _params) do
    users = Account.list_users()
    render(conn, "index.json", users: users)
  end

  swagger_path :create do
    post("/api/v1/account/users")

    tag("Account.User")
    description("Создание пользователя")

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:"user[phone]", :formData, :integer, "Телефон", required: true)
    parameter(:"user[first_name]", :formData, :string, "Имя")
    parameter(:"user[last_name]", :formData, :string, "Фамилия")
    parameter(:"user[gender]", :formData, :integer, "Пол")
    parameter(:"user[birthday]", :formData, :date, "Дата рождения")

    response(code(:created), %{"data" => %{"user" => Schema.ref(:User)}})
  end

  @spec create(Conn.t(), map) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  swagger_path :update do
    put("/api/v1/account/users/{id}")

    tag("Account.User")
    description("Обновление пользователя")

    consumes("application/x-www-form-urlencoded")
    produces("application/json")

    parameter(:id, :path, :integer, "Id пользователя")
    parameter(:"user[first_name]", :formData, :date, "Имя")
    parameter(:"user[birthday]", :formData, :date, "Фамилия")
    parameter(:"user[birthday]", :formData, :date, "Дата рождения")
  end

  @spec create(Conn.t(), map) :: Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    with %User{} = user <- Account.get_user(id),
         {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  swagger_path :show do
    get("/api/v1/account/users/{id}")

    tag("Account.User")
    description("Получение информации о пользователе")

    parameter(:id, :path, :integer, "Id пользователя", required: true)

    response(code(:ok), %{"data" => %{"user" => Schema.ref(:User)}})
  end

  @spec show(Conn.t(), map) :: Conn.t()
  def show(conn, %{"id" => id}) do
    with %User{} = user <- Account.get_user(id) do
      render(conn, "show.json", user: user)
    end
  end

  swagger_path :delete do
    tag("Account.User")
    description("Удаление пользователя")

    parameter(:id, :path, :integer, "Id пользователя", required: true)

    response(code(:no_content), "")
  end

  @spec delete(Conn.t(), map) :: Conn.t()
  def delete(conn, %{"id" => id}) do
    with %User{} = user <- Account.get_user(id),
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
