defmodule MatchmakerWeb.InvitationLive.Index do
  use MatchmakerWeb, :live_view

  alias Matchmaker.MatchSessions
  data(invitations, :list)

  def render(assigns) do
    ~F"""
    <details open>
      <summary>Open invitations</summary>
      <ul>
        {#for invitation <- @invitations}
          <li>
            <span>{invitation.match_session.question.title}</span>
            <button phx-click="invitation-response" phx-value-response="accept" phx-value-invitation={invitation.id}>Accept</button>
            <button phx-click="invitation-response" phx-value-response="reject" phx-value-invitation={invitation.id}>Reject</button>
          </li>
        {/for}
      </ul>
    </details>
    """
  end

  def mount(assigns, _session, socket) do
    invitations = MatchSessions.list_open_invitations(socket.assigns.current_user)
    {:ok, assign(socket, invitations: invitations)}
  end

  def handle_event(
        "invitation-response",
        %{"response" => value, "invitation" => invitation_id},
        socket
      ) do
    invitation = Enum.find(socket.assigns.invitations, &(&1.id == invitation_id))
    MatchSessions.join_match_session(invitation, socket.assigns.current_user, value == "accept")

    {:noreply,
     update(socket, :invitations, fn invitations -> List.delete(invitations, invitation) end)}
  end
end
