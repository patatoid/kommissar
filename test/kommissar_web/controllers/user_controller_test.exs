defmodule KommissarWeb.UserControllerTest do
  use KommissarWeb.ConnCase

  alias Kommissar.Accounts
  alias Kommissar.Accounts.User
  alias KommissarWeb.Guardian

  @create_attrs %{
    password: "some password",
    username: "some username"
  }
  @update_attrs %{
    password: "some updated password",
    username: "some updated username"
  }
  @invalid_attrs %{password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login" do
    setup [:create_user]

    test "renders 401 when not authorized", %{conn: conn} do
      conn = post(
        conn,
        Routes.user_path(conn, :login),
        %{"username" => "bad username", "password" => "bad password"}
      )
      assert response(conn, 401)
    end

    test "renders user when user is authenticated", %{conn: conn, user: %User{id: id} = user} do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = conn
             |> put_req_header("authorization", "Bearer #{token}")
             |> post(
               Routes.user_path(conn, :login),
               %{"username" => "some username", "password" => "some password"}
             )
      assert %{"access_token" => token, "data" => %{"id" => ^id}} = json_response(conn, 200)
      assert token
    end
  end

  describe "me" do
    setup [:create_user]

    test "renders 401 when not authorized", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :me))
      assert response(conn, 401)
    end

    test "renders user when user is authenticated", %{conn: conn, user: %User{id: id} = user} do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = conn
             |> put_req_header("authorization", "Bearer #{token}")
             |> get(Routes.user_path(conn, :me))
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
