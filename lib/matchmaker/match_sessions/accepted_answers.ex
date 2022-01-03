defmodule Matchmaker.MatchSessions.AcceptedAnswer do
  use Matchmaker.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accepted_answers" do

    belongs_to :participant, Matchmaker.MatchSessions.Participant
    belongs_to :answer, Matchmaker.Answers.Answer

    timestamps()
  end

  @doc false
  def changeset(accepted_answer, attrs) do
    accepted_answer
    |> cast(attrs, [])
    |> validate_required([])
  end
end
