defmodule Matchmaker.MatchSessions.Participant do
  use Matchmaker.Schema
  import Ecto.Changeset

  schema "participants" do
    field :role, :string, default: "user"
    belongs_to :user, Matchmaker.Accounts.User
    belongs_to :match_session, Matchmaker.MatchSessions.MatchSession
    has_many :responses, Matchmaker.MatchSessions.Response

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [])
    |> validate_required([])
  end
end
