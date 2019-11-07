defmodule KommissarWeb.PageControllerTest do
  use KommissarWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Kommissar"
  end
end
