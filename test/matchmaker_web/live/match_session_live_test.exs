defmodule MatchmakerWeb.MatchSessionLiveTest do
  use MatchmakerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Matchmaker.MatchSessionsFixtures

  @create_attrs %{
    question: %{
      title: "Test",
      description: "Test question"
    },
    answer_set: %{
      title: "Test Answer set",
      description: "Test Answer set",
      answers: "Answer 1\n Answer 2"
    }
  }
  @update_attrs %{}
  @invalid_attrs %{
    question: %{title: ""}
  }

  defp create_match_session(input) do
    match_session = match_session_fixture(input.user)
    %{match_session: match_session}
  end

  setup :register_and_log_in_user

  describe "Index" do
    setup [:create_match_session]

    test "lists all match_sessions", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.match_session_index_path(conn, :index))

      assert html =~ "Listing Match sessions"
    end

    test "saves new match_session", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.match_session_index_path(conn, :index))

      assert index_live |> element("a", "+ New Match session") |> render_click() =~
               "Question"

      assert_patch(index_live, Routes.match_session_index_path(conn, :new))

      assert index_live
             |> form("form", match_session: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("form", match_session: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.match_session_index_path(conn, :index))

      assert html =~ "Match session created successfully"
    end

    test "updates match_session in listing", %{conn: conn, match_session: match_session} do
      {:ok, index_live, _html} = live(conn, Routes.match_session_index_path(conn, :index))

      assert index_live
             |> element("#match_session-#{match_session.id} a", "Edit")
             |> render_click() =~
               "Edit Match session"

      assert_patch(index_live, Routes.match_session_index_path(conn, :edit, match_session))

      assert index_live
             |> form("#match_session-form", match_session: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#match_session-form", match_session: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.match_session_index_path(conn, :index))

      assert html =~ "Match session updated successfully"
    end

    test "deletes match_session in listing", %{conn: conn, match_session: match_session} do
      {:ok, index_live, _html} = live(conn, Routes.match_session_index_path(conn, :index))

      assert index_live
             |> element("#match_session-#{match_session.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#match_session-#{match_session.id}")
    end
  end

  describe "Show" do
    setup [:create_match_session]

    test "displays match_session", %{conn: conn, match_session: match_session} do
      {:ok, _show_live, html} =
        live(conn, Routes.match_session_show_path(conn, :show, match_session))

      assert html =~ "Show Match session"
    end

    test "updates match_session within modal", %{conn: conn, match_session: match_session} do
      {:ok, show_live, _html} =
        live(conn, Routes.match_session_show_path(conn, :show, match_session))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit"

      assert_patch(show_live, Routes.match_session_show_path(conn, :edit, match_session))

      assert show_live
             |> form("#match_session-form", match_session: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#match_session-form", match_session: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.match_session_show_path(conn, :show, match_session))

      assert html =~ "Match session updated successfully"
    end
  end
end
