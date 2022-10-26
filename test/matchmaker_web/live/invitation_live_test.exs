defmodule MatchmakerWeb.InvitationLiveTest do
  use MatchmakerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Matchmaker.MatchSessionsFixtures

  setup :register_and_log_in_user

  test "invitations can be accepted", %{conn: conn, user: user} do
    match_session = match_session_fixture(user)

    {:ok, match_session_show, _html} =
      live(conn, Routes.match_session_show_path(conn, :edit, match_session.id))

    %{conn: other_conn, user: other_user} =
      register_and_log_in_user(%{conn: Phoenix.ConnTest.build_conn()})

    Matchmaker.MatchSessions.create_invitation(
      match_session,
      hd(match_session.participants),
      other_user
    )

    {:ok, invitation_show, html} = live(other_conn, Routes.invitation_index_path(conn, :index))
    assert html =~ "some title"

    refute invitation_show
           |> element("button", "Accept")
           |> render_click() =~ "some title"
  end
end
