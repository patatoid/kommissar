defmodule KommissarWeb.UserController do
  use KommissarWeb, :controller

  alias Kommissar.Accounts
  alias Kommissar.Accounts.User
  alias KommissarWeb.Guardian

  action_fallback KommissarWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    with %User{} = user <- Accounts.get_user_by(username: username, password: password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> render("token.json", token: token, user: user)
    else
      _error ->
        {:error, :unauthorized}
    end
  end

  def me(conn, _) do
    case Guardian.Plug.current_resource(conn, key: :impersonate) do
      %User{} = user ->
        render(conn, "show.json", user: user)
      nil -> {:error, :unauthorized}
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
