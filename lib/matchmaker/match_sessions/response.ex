defmodule Matchmaker.MatchSessions.Response do
  use Matchmaker.Schema

  alias Matchmaker.MatchSessions.{MatchSession, Participant}
  alias Matchmaker.Answers.Answer

  schema "responses" do
    field :value, :string
    belongs_to :match_session, MatchSession
    belongs_to :participant, Participant
    belongs_to :answer, Answer

    timestamps()
  end

  def changeset(changeset_or_response, attrs \\ %{}) do
    changeset_or_response
    |> cast(attrs, [:value])
  end
end
