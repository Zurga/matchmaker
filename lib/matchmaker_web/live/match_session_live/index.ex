defmodule MatchmakerWeb.MatchSessionLive.Index do
  use MatchmakerWeb, :live_view

  alias Matchmaker.Answers
  alias Matchmaker.MatchSessions
  alias Matchmaker.MatchSessions.MatchSession

  @impl true
  def render(assigns) do
    ~F"""
    {#if @live_action in [:new, :edit]}
      <.live_component
        module={MatchmakerWeb.MatchSessionLive.FormComponent}
        id={@match_session && @match_session.id || :new}
        title={@page_title}
        action={@live_action}
        match_session={@match_session && @match_session || %MatchSession{}}
        answer_sets={@answer_sets}
        current_user={@current_user}
        return_to={Routes.match_session_index_path(@socket, :index)}
      />

    {#else}
      <h1>Listing Match sessions</h1>

      {live_patch "+ New Match session", role: "button", to: Routes.match_session_index_path(@socket, :new)}
      <div class="grid">
        {#for match_sessions <- Enum.chunk_every(@match_sessions, 3) |> Enum.zip() |> Enum.map(&Tuple.to_list/1)}
          <div>
            {#for match_session <- match_sessions}
              <article id={"match_session-#{match_session.id}"}>
                <span><strong>{match_session.question.title}</strong></span>
                <div class="grid">
                  <div>
                    {live_redirect "Answer", role: "button", to: Routes.questions_path(@socket, :index, match_session.id)}
                  </div>
                  <div>
                    {live_redirect "Show", role: "button", to: Routes.match_session_show_path(@socket, :show, match_session.id)}
                  </div>
                  <div>
                    {live_patch "Edit", role: "button", to: Routes.match_session_show_path(@socket, :edit, match_session)}
                  </div>
                </div>
              </article>
            {/for}
          </div>
        {/for}
      </div>
    {/if}
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    {:ok,
     assign(socket,
       match_sessions: list_match_sessions(current_user),
       answer_sets: list_answer_sets(current_user)
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    match_session = MatchSessions.get_match_session!(id)

    socket
    |> assign(:page_title, "Edit Match session")
    |> assign(:match_session, match_session)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Match session")
    |> assign(:match_session, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Match sessions")
    |> assign(:match_session, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    match_session = MatchSessions.get_match_session!(id)
    {:ok, _} = MatchSessions.delete_match_session(match_session)

    {:noreply, assign(socket, :match_sessions, list_match_sessions(socket.assigns.current_user))}
  end

  defp list_match_sessions(user) do
    MatchSessions.list_match_sessions(user)
  end

  defp list_answer_sets(user) do
    Answers.list_public_and_user_answer_sets(user)
  end
end
