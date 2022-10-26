defmodule Matchmaker.MatchSessions.Invitation do
  use Matchmaker.Schema

  alias Matchmaker.Accounts.User
  alias Matchmaker.MatchSessions.{MatchSession, Participant}

  schema "match_sessions_invitations" do
    field :role, :string, default: "user"
    field :status, :string, default: "pending"
    field :email, :string
    belongs_to :match_session, MatchSession
    belongs_to :invitee, User
    belongs_to :inviter, Participant

    timestamps()
  end

  def changeset(invitation, attrs \\ %{}) do
    invitation
    |> cast(attrs, [:status, :email, :role])
    |> validate_required([:status, :email])
    |> validate_inclusion(:status, ~w/pending declined accepted expired/)
  end
end
