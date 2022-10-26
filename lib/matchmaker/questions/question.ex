defmodule Matchmaker.Questions.Question do
  use Matchmaker.Schema

  schema "questions" do
    field :description, :string
    field :title, :string
    belongs_to :user, Matchmaker.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
