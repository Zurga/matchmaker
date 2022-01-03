defmodule MatchmakerWeb.MatchSessionLive.Show do
  use MatchmakerWeb, :live_view

  alias Matchmaker.MatchSessions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    match_session = MatchSessions.get_match_session!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:match_session, match_session)}
  end

  defp page_title(:show), do: "Show Match session"
  defp page_title(:edit), do: "Edit Match session"
end
