defmodule Matchmaker.Answers.Answer do
  use Matchmaker.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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
    |> validate_required([:title, :description, :data])
  end
end
