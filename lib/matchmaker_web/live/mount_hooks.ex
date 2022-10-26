defmodule MatchmakerWeb.MountHooks do
  import Phoenix.LiveView, only: [assign: 3]
  alias Matchmaker.Accounts

  defmodule SetCurrentUser do
    @moduledoc """
    Will set the current user in the assigns of the socket based on the user_token in the session.
    """
    def on_mount(_, _params, %{"user_token" => user_token}, socket) do
      user = Accounts.get_user_by_session_token(user_token)
      socket = assign(socket, :current_user, user)
      {:cont, socket}
    end
  end
end
