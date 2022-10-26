defmodule Matchmaker.MatchSessionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Matchmaker.MatchSessions` context.
  """
  import Matchmaker.{AccountsFixtures, QuestionsFixtures, AnswersFixtures}

  @doc """
  Generate a match_session.
  """
  def match_session_fixture(user \\ false, attrs \\ %{}) do
    user =
      if user do
        user
      else
        user_fixture()
      end

    question =
      attrs
      |> Map.get(:question, %{})
      |> question_fixture()

    answer_set =
      attrs
      |> Map.get(:answer_set, %{})
      |> answer_set_fixture()

    attrs =
      attrs
      |> Map.get(:match_session, %{})
      |> Enum.into(%{
        answer_set: answer_set,
        question: question
      })

    {:ok, match_session} = Matchmaker.MatchSessions.create_match_session(user, attrs)

    match_session
  end

  @doc """
  Generate a response.
  """
  def response_fixture(participant, answer, attrs \\ %{accepted: true}) do
    {:ok, response} = Matchmaker.MatchSessions.create_response(participant, answer, attrs)

    response
  end

  @doc """
  Generate a participant.
  """
  def participant_fixture(attrs \\ %{}) do
    match_session = match_session_fixture()
    user = user_fixture()
    {:ok, participant} = Matchmaker.MatchSessions.create_participant(match_session, user)

    participant
  end
end
