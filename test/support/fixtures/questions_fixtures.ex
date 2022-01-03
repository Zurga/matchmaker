defmodule Matchmaker.QuestionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Matchmaker.Questions` context.
  """

  import Matchmaker.AccountsFixtures

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    user = user_fixture()

    attrs =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })

    {:ok, question} = Matchmaker.Questions.create_question(user, attrs)

    question
  end
end
