defmodule Matchmaker.Answers.Answer do
  use Matchmaker.Schema

  schema "answers" do
    field :data, :map
    field :description, :string
    field :title, :string

    belongs_to :answer_set, Matchmaker.Answers.AnswerSet

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:title, :description, :data])
    |> validate_required(:title)
    |> validate_length(:title, min: 3)
  end
end
