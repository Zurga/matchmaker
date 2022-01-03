defmodule Matchmaker.AnswersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Matchmaker.Answers` context.
  """

  @doc """
  Generate a answer.
  """
  def answer_fixture(attrs \\ %{}) do
    answer_set = answer_set_fixture()

    attrs =
      Enum.into(attrs, %{
        data: %{},
        description: "some description",
        title: "some title",
        answer_set: answer_set
      })

    {:ok, answer} = Matchmaker.Answers.create_answer(answer_set, attrs)

    answer
  end

  @doc """
  Generate a answer_set.
  """
  def answer_set_fixture(attrs \\ %{}) do
    {:ok, answer_set} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Matchmaker.Answers.create_answer_set()

    answer_set
  end
end
