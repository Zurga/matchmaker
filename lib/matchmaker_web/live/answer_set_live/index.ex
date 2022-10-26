defmodule MatchmakerWeb.AnswerSetLive.Index do
  use MatchmakerWeb, :live_view

  alias Matchmaker.Answers
  alias Matchmaker.Answers.AnswerSet

  alias MatchmakerWeb.Components.Table
  alias MatchmakerWeb.Components.Table.Column

  alias Surface.Components.Link

  @impl true
  def render(assigns) do
    ~F"""
    <Table items={answer_set <- @answer_sets}>
      <Column title="Title">
        {answer_set.title}
      </Column>
      <Column title="Actions">
        <Link to={Routes.answer_set_index_path(@socket, :edit, answer_set.id)} >Edit</Link>
      </Column>
    </Table>
    """
  end
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :answer_sets, list_answer_sets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Answer set")
    |> assign(:answer_set, Answers.get_answer_set!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Answer set")
    |> assign(:answer_set, %AnswerSet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Answer sets")
    |> assign(:answer_set, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    answer_set = Answers.get_answer_set!(id)
    {:ok, _} = Answers.delete_answer_set(answer_set)

    {:noreply, assign(socket, :answer_sets, list_answer_sets())}
  end

  defp list_answer_sets do
    Answers.list_answer_sets()
  end
end
