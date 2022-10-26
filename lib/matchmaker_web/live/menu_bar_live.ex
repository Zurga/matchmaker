defmodule MatchmakerWeb.MenuBarLive do
  use MatchmakerWeb, :live_view_without_layout

  alias Matchmaker.MatchSessions
  alias MatchmakerWeb.Components.Menu
  alias MatchmakerWeb.Components.Menu.{Item, Brand}

  alias Surface.Components.Link
  data(current_user, :map)
  data(unseen_invitations, :integer, default: 0)

  @impl true
  def render(assigns) do
    ~F"""
      {#if @current_user}
        <Menu>
          <Item><Link to={Routes.match_session_index_path(@socket, :index)}>Matchings</Link> </Item>
          <Item><Link to={Routes.answer_set_index_path(@socket, :index)}>Answers</Link> </Item>
          <Item><Link to={Routes.invitation_index_path(@socket, :index)}>Invitations {@unseen_invitations}</Link> </Item>
          <Item><Link to={Routes.user_settings_path(@socket, :edit)}>Settings</Link> </Item>
          <Item><Link to={Routes.user_session_path(@socket, :delete)} method={:delete}>Log out</Link> </Item>
          <Brand><strong>Matchmaker</strong></Brand>
        </Menu>
      {#else}
        <Menu>
        <Item><Link to={Routes.user_registration_path(@socket, :new) }>Register</Link></Item>
        <Item><Link to={Routes.user_session_path(@socket, :new) }>Log in</Link></Item>
        </Menu>
      {/if}

    """
  end

  @impl true
  def mount(_params, %{"current_user" => current_user}, socket) do
    if current_user do
    Phoenix.PubSub.subscribe(Matchmaker.PubSub, "notifications:#{current_user.id}")
    end

    {:ok,
     assign(socket,
       current_user: current_user,
       unseen_invitations: count_unseen_invitations(current_user)
     )}
  end

  @impl true
  def handle_info(:invite, socket) do
    {:noreply, update(socket, :unseen_invitations, &(&1 + 1))}
  end

  def count_unseen_invitations(nil), do: nil
  def count_unseen_invitations(user) do
    length(MatchSessions.list_open_invitations(user))
  end
end
