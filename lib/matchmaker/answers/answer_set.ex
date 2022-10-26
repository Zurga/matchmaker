defmodule Matchmaker.Answers.AnswerSet do
  use Matchmaker.Schema

  alias Matchmaker.{Accounts, Answers, MatchSessions}

  schema "answer_sets" do
    field :description, :string
    field :title, :string
    field :public, :boolean

    belongs_to :user, Accounts.User
    has_many :answers, Answers.Answer
    has_many :match_sessions, MatchSessions.MatchSession

    timestamps()
  end

  @doc false
  def changeset(answer_set, attrs) do
    answer_set
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
    |> maybe_put_assoc(:answers, attrs)
  end
end
