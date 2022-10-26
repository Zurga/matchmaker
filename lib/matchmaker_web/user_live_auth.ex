defmodule MatchmakerWeb.UserLiveAuth do
  import Phoenix.LiveView
  alias Matchmaker.Accounts
  alias Matchmaker.MatchSessions

  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    user = user_token && Accounts.get_user_by_session_token(user_token)

    {:cont, assign(socket, :current_user, user)}
  end

  def on_mount(
        :match_session,
        %{"id" => match_session_id},
        %{"user_token" => user_token} = _session,
        socket
      ) do
    user = user_token && Accounts.get_user_by_session_token(user_token)

    match_session = MatchSessions.get_match_session!(match_session_id)

    participant =
      match_session.participants
      |> Enum.find(&(&1.user_id == user.id))

    {:cont,
     assign(socket,
       current_user: user,
       match_session: match_session,
       participant: participant
     )}
  end
end
