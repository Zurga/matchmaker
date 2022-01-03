defmodule Matchmaker.MatchSessionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Matchmaker.MatchSessions` context.
  """
  import Matchmaker.{AccountsFixtures, QuestionsFixtures, AnswersFixtures}

  @doc """
  Generate a match_session.
  """
  def match_session_fixture(attrs \\ %{}) do
    user = user_fixture()
    question = question_fixture()
    answer_set = answer_set_fixture()

    {:ok, match_session} =
      attrs
      |> Enum.into(%{
        user: user,
        answer_set: answer_set,
        question: question
      })
      |> Matchmaker.MatchSessions.create_match_session()

    match_session
  end

  @doc """
  Generate a rejected_answer.
  """
  def rejected_answer_fixture() do
    answer = answer_fixture()
    participant = participant_fixture()
    {:ok, rejected_answer} = Matchmaker.MatchSessions.create_rejected_answer(participant, answer)

    rejected_answer
  end

  @doc """
  Generate a accepted_answer.
  """
  def accepted_answer_fixture() do
    answer = answer_fixture()
    participant = participant_fixture()
    {:ok, accepted_answer} = Matchmaker.MatchSessions.create_accepted_answer(participant, answer)

    accepted_answer
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
