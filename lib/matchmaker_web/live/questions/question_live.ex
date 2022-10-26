defmodule MatchmakerWeb.QuestionsLive do
  use MatchmakerWeb, :live_view

  alias Matchmaker.MatchSessions
  alias MatchmakerWeb.Components.{SwipeLayout, TournamentLayout}

  data(answers, :list)

  def render(assigns) do
    ~F"""
      {#if length(@answers) >= 1}
        <div class="answer-container">
          <h3>{@match_session.question.title}</h3>
          {#case @match_session.type}
            {#match "swipe"}
              <SwipeLayout answers={@answers} id="answers" />
            {#match "tournament"}
              <TournamentLayout answers={@answers} id="answers" />
          {/case}
        </div>
      {#else}
        <h2>You are done!</h2>
      {/if}
    """
  end

  @impl true
  def mount(
        _,
        _,
        %{assigns: %{match_session: match_session, participant: participant}} = socket
      ) do
    answers = MatchSessions.get_unseen_answers(match_session, participant)

    {:ok, assign(socket, answers: answers, temporary_assigns: [matched_with: nil])}
  end

  @impl true
  def handle_info(
        {:process_responses, responses},
        %{assigns: %{answers: answers, match_session: match_session, participant: participant}} =
          socket
      ) do
    processed_answers = process_responses(socket, responses)

    socket =
      update(socket, :answers, fn answers ->
        for answer <- processed_answers do
          List.delete(answers, answer)
        end
        |> maybe_get_new_answers(match_session, participant)
      end)

    {:noreply, socket}
  end

  if Mix.env() == :dev do
    @impl true
    def handle_event(
          "reset-answers",
          _,
          %{assigns: %{participant: participant, match_session: match_session}} = socket
        ) do
      for response <- MatchSessions.list_responses(participant) do
        MatchSessions.delete_response(response)
      end

      answers = MatchSessions.get_unseen_answers(match_session, participant)
      {:noreply, assign(socket, :answers, answers)}
    end
  end

  def receive_match(response, participants) do
    send(self(), {:match_response, response, participants})
  end

  def handle_info({:match_response, response, participants}, socket) do
    {:noreply, assign(socket, matched_with: {response, participants})}
  end

  defp maybe_get_new_answers(answers, match_session, participant) when length(answers) < 6,
    do: MatchSessions.get_unseen_answers(match_session, participant)

  defp maybe_get_new_answers(answers, _match_session, _participant), do: answers

  defp process_responses(
         %{assigns: %{participant: participant, answers: answers, match_session: match_session}},
         responses
       ) do
    # MatchSessions.check_for_match(match_session, response, &receive_match/2)
    for {answer_id, response} <- responses do
      answer = Enum.find(answers, &(&1.id == answer_id))
      {:ok, response} = MatchSessions.create_response(participant, answer, %{value: response})
      answer
    end
  end
end
