defmodule MatchmakerWeb.ResultsLiveTest do
  use MatchmakerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Matchmaker.MatchSessionsFixtures

  alias Matchmaker.Answers

  setup :register_and_log_in_user

  test "results can be displayed for multiple users", %{conn: conn, user: user} do
    match_session = match_session_fixture(user)

    1..5
    |> Enum.map(&Answers.create_answer(match_session.answer_set, %{title: "Answer #{&1}"}))

    {:ok, question_live, _} = live(conn, Routes.questions_path(conn, :index, match_session.id))

    %{conn: other_conn, user: other_user} =
      register_and_log_in_user(%{conn: Phoenix.ConnTest.build_conn()})

    Matchmaker.MatchSessions.create_participant(match_session, other_user)

    {:ok, other_question_live, _} =
      live(other_conn, Routes.questions_path(conn, :index, match_session.id))

    for live_sess <- [question_live, other_question_live] do
      assert live_sess
             |> element("button", "Accept")
             |> render_click() =~
               "Answer 2"

      assert live_sess
             |> element("button", "Reject")
             |> render_click() =~
               "Answer 3"
    end

    Matchmaker.MatchSessions.get_matching_answers(match_session)
    for participant <- match_session.participants, do: Matchmaker.MatchSessions.list_responses(participant)
    |> IO.inspect()
    for conn <- [conn, other_conn] do
      {:ok, view, _html} = live(conn, Routes.results_path(conn, :index, match_session.id))

      html =
        view
        |> element("details#matching")
        |> render()

      assert html =~ "Answer 1"
      refute html =~ "Answer 2"
    end
  end
end
