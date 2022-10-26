defmodule MatchmakerWeb.ResultsLive do
  use MatchmakerWeb, :live_view

  alias Matchmaker.MatchSessions

  data(answers, :list)

  @impl true
  def render(assigns) do
    ~F"""
    <details id="matching" open>
    <summary>Matching answers</summary>
      <ul>
        {#for answer <- @matching_answers}
          <li>{answer}</li>
        {/for}
      </ul>
    </details>
    <details>
    <summary>Your answers</summary>
      <ul>
        {#for %{value: "1"} = response <- @participant.responses}
          <li>{response.answer.title}</li>
        {/for}
      </ul>
    </details>
    """
  end

  @impl true
  def mount(_, _, %{assigns: %{match_session: match_session, participant: participant}} = socket) do
    matching_answers = MatchSessions.get_matching_answers(match_session)

    participant = Matchmaker.Repo.preload(participant, [responses: [:answer]])
    {:ok,
     socket
     |> assign(matching_answers: matching_answers, participant: participant)}
  end
end
