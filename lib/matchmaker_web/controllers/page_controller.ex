defmodule MatchmakerWeb.PageController do
  use MatchmakerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
