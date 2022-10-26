defmodule MatchmakerWeb.InvitationLive.FormComponent do
  use MatchmakerWeb, :live_component

  alias Matchmaker.Accounts
  alias Matchmaker.MatchSessions
  alias Matchmaker.MatchSessions.Invitation

  alias Surface.Components.Form
  alias Surface.Components.Form.{Inputs, Select, TextInput, Label}

  prop(match_session, :map, required: true)
  prop(participant, :map, required: true)
  data(changeset, :changeset)

  @impl true
  def render(assigns) do
    ~F"""
        <Form for={@changeset} change="validate" submit="save">
          <Label field={:email}>Email</Label>
          <TextInput field={:email} title={:email} />
          <Label field={:role}>Role</Label>
          <Select field={:role} options={[{"Admin", "admin"}, {"User", "user"}]} />
          <button type="submit">Invite</button>
        </Form>
    """
  end

  @impl true
  def update(assigns, socket) do
    invitation = %Invitation{}
    changeset = MatchSessions.change_invitation(invitation)

    {:ok,
     assign(socket, assigns)
     |> assign(invitation: invitation, changeset: changeset)}
  end

  @impl true
  def handle_event("validate", %{"invitation" => invitation_params}, socket) do
    changeset = MatchSessions.change_invitation(%Invitation{}, invitation_params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event(
        "save",
        %{"invitation" => %{"email" => email}},
        %{assigns: %{match_session: match_session, participant: participant}} = socket
      ) do
    socket =
      with user <- Accounts.get_user_by_email(email),
        IO.inspect(user),
        IO.inspect(participant),
           {:ok, _} <- MatchSessions.create_invitation(match_session, participant, user) do
        socket
        |> put_flash(:info, "User invited")
      else
        {:error, %Ecto.Changeset{} = changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end
end
