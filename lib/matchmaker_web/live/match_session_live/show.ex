defmodule MatchmakerWeb.MatchSessionLive.Show do
  use MatchmakerWeb, :live_view

  alias Matchmaker.{Answers, MatchSessions}

  alias MatchmakerWeb.MatchSessionLive.FormComponent, as: MatchSessionForm
  alias MatchmakerWeb.InvitationLive.FormComponent, as: InvitationForm

  def render(assigns) do
    ~F"""
    <h1>Show Match session</h1>

    {#if @live_action in [:edit]}
      <details open>
        <summary><strong>Edit the Match Session</strong></summary>
        <MatchSessionForm
          id={@match_session.id}
          title={@page_title}
          action={@live_action}
          match_session={@match_session}
          current_user={@current_user}
          answer_sets={list_answer_sets(@current_user) |> IO.inspect(label: :matchsessinshow)}
          return_to={Routes.match_session_show_path(@socket, :show, @match_session)}
        />
      </details>
      <details>
        <summary><strong>Invite other users</strong></summary>
        <InvitationForm id="invite" match_session={@match_session} participant={@participant} />
      </details>
    {#else}
    <ul>
    <div>{@match_session.question.title}
    {#for participant <- @match_session.participants }
      <span>{participant.user.nickname}</span>
    {/for}
    </div>
    </ul>

    <span>{live_patch "Edit", to: Routes.match_session_show_path(@socket, :edit, @match_session), class: "button"}</span> |
    <span>{live_redirect "Back", to: Routes.match_session_index_path(@socket, :index)}</span>
    {/if}
    """
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply, assign(socket, :page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Show Match session"
  defp page_title(:edit), do: "Edit Match session"
  defp list_answer_sets(user) do
    Answers.list_public_and_user_answer_sets(user)
  end
end
