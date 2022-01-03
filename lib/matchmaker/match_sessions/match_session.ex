defmodule Matchmaker.MatchSessions.MatchSession do
  use Matchmaker.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "match_sessions" do
    field :public, :boolean, default: false
    belongs_to :user, Matchmaker.Accounts.User
    belongs_to :answer_set, Matchmaker.Answers.AnswerSet
    belongs_to :question, Matchmaker.Questions.Question

    has_many :participants, Matchmaker.MatchSessions.Participant
    timestamps()
  end

  @doc false
  def changeset(match_session, attrs) do
    match_session
    |> cast(attrs, [:public])
    |> maybe_put_assoc([:user, :answer_set, :question], attrs)
    |> validate_required([:public])
  end
end
