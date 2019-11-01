defmodule KommissarWeb.PageController do
  use KommissarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
