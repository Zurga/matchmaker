defmodule MatchmakerWeb.MatchSessionLive.Index do
  use MatchmakerWeb, :live_view

  alias Matchmaker.MatchSessions
  alias Matchmaker.MatchSessions.MatchSession
  alias Matchmaker.Questions.Question
  alias Matchmaker.Answers.AnswerSet

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :match_sessions, list_match_sessions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    match_session = MatchSessions.get_match_session!(id)

     socket
     |> assign(:page_title, "Edit Match session")
     |> assign(:match_session, match_session)
     |> assign_new(:question, fn -> match_session.question end)
     |> assign_new(:answer_set, fn -> match_session.answer_set end)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Match session")
    |> assign(:match_session, %MatchSession{})
    |> assign(:question, %Question{})
    |> assign(:answer_set, %AnswerSet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Match sessions")
    |> assign(:match_session, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    match_session = MatchSessions.get_match_session!(id)
    {:ok, _} = MatchSessions.delete_match_session(match_session)

    {:noreply, assign(socket, :match_sessions, list_match_sessions())}
  end

  defp list_match_sessions do
    MatchSessions.list_match_sessions()
  end
end
