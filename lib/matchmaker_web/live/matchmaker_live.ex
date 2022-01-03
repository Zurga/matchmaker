defmodule MatchmakerWeb.MatchmakerLive do
  use MatchmakerWeb, :live_view
  alias MatchmakerWeb.QuestionFormComponent

  alias Matchmaker.Questions.Question

  def render(assigns) do
    ~H"""
    <section>
      <button phx-click={show_modal("#new-question-modal")}>New Question</button>
      <.modal id="new-question-modal">
      <:header>Create a new question to have answered</:header>
      <.live_component
        id={:new_question}
        module={QuestionFormComponent}
        current_user={@current_user}
        question={%Question{}}
        action={:new}
        return_to={Routes.match_maker_path(@socket, :new)}
        />
      </.modal>
    </section>
    """
  end

  def mount(_, _params, socket) do
    match_sessions = list_match_sessions()

    {:ok, assign(socket, :match_session, match_sessions)}
  end

  defp list_match_sessions do
    Matchmaker.MatchSessions.list_match_sessions()
  end
end
