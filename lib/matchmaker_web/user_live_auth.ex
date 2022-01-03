defmodule MatchmakerWeb.UserLiveAuth do
  import Phoenix.LiveView
  alias Matchmaker.Accounts
  def on_mount(:default, _params, %{"user_token" => user_token} = _session, socket) do
    user = user_token && Accounts.get_user_by_session_token(user_token)

    {:cont, assign(socket, :current_user, user)}
  end
end
