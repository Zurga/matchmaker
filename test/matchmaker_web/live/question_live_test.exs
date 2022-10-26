defmodule MatchmakerWeb.QuestionLiveTest do
  use MatchmakerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Matchmaker.MatchSessionsFixtures

  alias Matchmaker.Answers

  setup :register_and_log_in_user

  test "a question can be accepted and rejected", %{conn: conn, user: user} do
    match_session = match_session_fixture(user)

    1..50
    |> Enum.map(&Answers.create_answer(match_session.answer_set, %{title: "Answer #{&1}"}))

    {:ok, question_live, html} = live(conn, Routes.questions_path(conn, :index, match_session.id))
    assert html =~ "Answer 1"

    for idx <- 2..50 do
      assert question_live
             |> element("button", (idx / 2 == 0 && "Accept") || "Reject")
             |> render_click() =~
               "Answer #{idx}"
    end

    assert question_live
           |> element("button", "Reject")
           |> render_click() =~
             "You are done"
  end
end
