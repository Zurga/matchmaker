defmodule MatchmakerWeb.MatchSessionLive.FormComponent do
  use MatchmakerWeb, :live_component

  alias Matchmaker.{MatchSessions, Questions, Answers}

  @impl true
  def update(%{match_session: match_session} = assigns, socket) do
    changeset = MatchSessions.change_match_session(match_session)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:question, fn -> match_session.question end)
     |> assign_new(:answer_set, fn -> match_session.answer_set end)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event(
        "validate",
        %{"match_session" => match_session_params},
        socket
      ) do
    match_session_params = setup_match_session_params(match_session_params, socket.assigns)

    changeset =
      MatchSessions.change_match_session(
        socket.assigns.match_session,
        match_session_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"match_session" => match_session_params}, socket) do
    match_session_params = setup_match_session_params(match_session_params, socket.assigns)
    save_match_session(socket, socket.assigns.action, match_session_params)
  end

  defp save_match_session(socket, :edit, match_session_params) do
    case MatchSessions.update_match_session(socket.assigns.match_session, match_session_params) do
      {:ok, _match_session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Match session updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_match_session(socket, :new, match_session_params) do
    case MatchSessions.create_match_session(match_session_params) do
      {:ok, _match_session} ->
        {:noreply,
         socket
         |> put_flash(:info, "Match session created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp setup_match_session_params(
         %{"question" => question_params, "answer_set" => answer_set_params} =
           match_session_params,
         %{
           question: question,
           current_user: current_user,
           answer_set: answer_set
         }
       ) do
    answers = Map.get(match_session_params, "answers", [])
    question = Questions.change_question(question, question_params)

    answer_set_params =
      Map.put(
        answer_set_params,
        "answers",
        String.split(answers, "\n")
        |> Enum.map(&%{title: &1, description: "test"})
      )

    answer_set = Answers.change_answer_set(answer_set, answer_set_params)

    match_session_params
    |> Map.put("user", current_user)
    |> Map.put("question", question)
    |> Map.put("answer_set", answer_set)
    |> IO.inspect()
  end
end
