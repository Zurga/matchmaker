defmodule Matchmaker.MatchSessions.Participant do
  use Matchmaker.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "participants" do

    belongs_to :user, Matchmaker.Accounts.User
    belongs_to :match_session, Matchmaker.MatchSessions.MatchSession

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [])
    |> validate_required([])
  end
end
