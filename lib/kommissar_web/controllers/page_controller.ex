defmodule KommissarWeb.PageController do
  use KommissarWeb, :controller

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> render("index.html")
  end
end
