defmodule MatchmakerWeb.PageControllerTest do
  use MatchmakerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "html"
  end
end
