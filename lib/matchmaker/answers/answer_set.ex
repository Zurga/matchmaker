defmodule Matchmaker.Answers.AnswerSet do
  use Matchmaker.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "answer_sets" do
    field :description, :string
    field :title, :string
    has_many :answers, Matchmaker.Answers.Answer

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
