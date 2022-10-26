defmodule Matchmaker.MatchSessions.MatchSession do
  use Matchmaker.Schema

  schema "match_sessions" do
    field :public, :boolean, default: false
    field :has_ended, :boolean, default: false
    field :due_datetime, :utc_datetime
    field :type, :string, default: "swipe"

    belongs_to :answer_set, Matchmaker.Answers.AnswerSet, on_replace: :delete
    belongs_to :question, Matchmaker.Questions.Question, on_replace: :delete

    has_many :participants, Matchmaker.MatchSessions.Participant, on_delete: :delete_all
    has_many :invitations, Matchmaker.MatchSessions.Invitation, on_delete: :delete_all
    has_many :responses, Matchmaker.MatchSessions.Response, on_delete: :nothing
    timestamps()
  end

  @doc false
  def changeset(match_session, attrs) do
    match_session
    |> cast(attrs, [:public, :has_ended, :due_datetime, :type])
    |> maybe_put_assoc([:answer_set, :question, :participants], attrs)
    |> validate_required([:public])
    |> validate_inclusion(:type, ["swipe", "tournament"])
  end
end
