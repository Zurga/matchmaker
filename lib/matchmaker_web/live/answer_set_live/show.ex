defmodule MatchmakerWeb.AnswerSetLive.Show do
  use MatchmakerWeb, :live_view

  alias Matchmaker.Answers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:answer_set, Answers.get_answer_set!(id))}
     |> assign(answer_sets: list_answer_sets(socket.assigns.current_user))
  end

  defp page_title(:show), do: "Show Answer set"
  defp page_title(:edit), do: "Edit Answer set"
  defp list_answer_sets(user) do
    Answers.list_public_and_user_answer_sets(user)
    |> IO.inspect(label: :answers)
  end
end
