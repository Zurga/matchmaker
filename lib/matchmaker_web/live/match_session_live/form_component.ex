defmodule MatchmakerWeb.MatchSessionLive.FormComponent do
  use MatchmakerWeb, :live_component

  alias Matchmaker.MatchSessions.MatchSession
  alias Matchmaker.Questions.Question
  alias Matchmaker.Answers.AnswerSet
  alias Matchmaker.{MatchSessions, Questions, Answers}

  alias MatchmakerWeb.AnswerSetLive.FormComponent, as: AnswerSetForm

  alias Surface.Components.Form
  alias Surface.Components.Form.{Inputs, Select, Label}

  prop(current_user, :map, required: true)
  prop(match_session, :map)
  prop(answer_set, :map, default: %AnswerSet{})
  prop(question, :map, default: %Question{})
  prop(title, :string)
  prop(action, :atom)
  prop(answer_sets, :list, default: [])

  data(changeset, :changeset)
  data(new_answer_set, :boolean, default: false)

  @impl true
  def render(assigns) do
    ~F"""
    <div>
      <Form id="match_session-form" for={@changeset} change="validate" submit="save">
        <fieldset name="question">
          <legend>Question</legend>
          <Inputs for={:question} :let={form: f}>
            <.input form={f} field={:title} />
            <.input input={:textarea} form={f} field={:description}/>
          </Inputs>
        </fieldset>
        {#if @new_answer_set and @answer_sets != []}
          <AnswerSetForm answer_set={@answer_set} id="answer_set"/>
        {#else}
          <Label field={:answer_set}>Select an answer set from the list:</Label>
          <Select field={:existing_answer_set} options={to_options(@answer_sets) |> IO.inspect()} />
          <button phx-click="new_answer_set" phx-target={@myself}>
          <Label>Or create a new one</Label>
          </button>
        {/if}
        <Label field={:type}>Type of session</Label>
        <Select field={:type} options={[{"Swipe", "swipe"}, {"Tournament", "tournament"}]} />
        <div>
          {submit "Save", phx_disable_with: "Saving..."}
        </div>
      </Form>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     assign(socket, assigns)
     |> assign(changeset: MatchSessions.change_match_session(assigns.match_session))
     |> then(fn socket ->
       if socket.assigns.id == :new do
         socket
         |> assign(question: %Question{})
         |> assign(answer_set: %AnswerSet{})
       else
         socket
       end
     end)}
  end

  @impl true
  def handle_event("new_answer_set", _, socket) do
    {:noreply, assign(socket, new_answer_set: socket.assigns.new_answer_set != true)}
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
    case MatchSessions.create_match_session(socket.assigns.current_user, match_session_params) do
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
         %{"question" => question_params} = match_session_params,
         %{
           question: question,
           answer_set: answer_set,
           answer_sets: answer_sets
         } = assigns
       ) do
    question = Questions.change_question(question, question_params)

    answer_set =
      case match_session_params do
        %{"answer_set" => answer_set_params} ->
          answer_set_params =
            if answers = Map.get(answer_set_params, "answers") do
              Map.put(
                answer_set_params,
                "answers",
                String.split(answers, "\n")
                |> Enum.filter(&(&1 != ""))
                |> Enum.map(&%{title: &1, description: "test"})
              )
            else
              answer_set_params
            end

          Answers.change_answer_set(answer_set, answer_set_params)

        %{"existing_answer_set" => id} ->
          Enum.find(answer_sets, &(&1.id == id))
      end

    match_session_params
    |> Map.put("question", question)
    |> Map.put("answer_set", answer_set)
  end

  defp format_answers(answers) do
    Enum.map_join(answers, "\n", & &1.title)
  end
end
