defmodule Matchmaker.MatchSessionsTest do
  use Matchmaker.DataCase

  alias Matchmaker.MatchSessions

  describe "match_sessions" do
    alias Matchmaker.MatchSessions.MatchSession

    import Matchmaker.{MatchSessionsFixtures, AccountsFixtures, QuestionsFixtures, AnswersFixtures}

    @invalid_attrs %{}

    test "list_match_sessions/0 returns all match_sessions" do
      match_session = match_session_fixture()
      assert Enum.map(MatchSessions.list_match_sessions(), & &1.id) == [match_session.id]
    end

    test "get_match_session!/1 returns the match_session with given id" do
      match_session = match_session_fixture()
      assert MatchSessions.get_match_session!(match_session.id) |> Repo.preload([:answer_set, :owner, :question]) == match_session
    end

    test "create_match_session/1 with valid data creates a match_session" do
      user = user_fixture()
      question = question_fixture()
      answer_set = answer_set_fixture()
      valid_attrs = %{owner: user, question: question, answer_set: answer_set}
      assert {:ok, %MatchSession{} = match_session} = MatchSessions.create_match_session(valid_attrs)
    end

    test "delete_match_session/1 deletes the match_session" do
      match_session = match_session_fixture()
      assert {:ok, %MatchSession{}} = MatchSessions.delete_match_session(match_session)
      assert_raise Ecto.NoResultsError, fn -> MatchSessions.get_match_session!(match_session.id) end
    end

    test "change_match_session/1 returns a match_session changeset" do
      match_session = match_session_fixture()
      assert %Ecto.Changeset{} = MatchSessions.change_match_session(match_session)
    end
  end

  describe "rejected_answer" do
    alias Matchmaker.MatchSessions.RejectedAnswer

    import Matchmaker.MatchSessionsFixtures

    @invalid_attrs %{}

    test "list_rejected_answers/0 returns all rejected_answer" do
      rejected_answer = rejected_answer_fixture()
      assert Enum.map(MatchSessions.list_rejected_answers(), & &1.id) == [rejected_answer.id]
    end

    test "get_rejected_answer!/1 returns the rejected_answer with given id" do
      rejected_answer = rejected_answer_fixture()
      assert MatchSessions.get_rejected_answer!(rejected_answer.id).id == rejected_answer.id
    end

    test "delete_rejected_answer/1 deletes the rejected_answer" do
      rejected_answer = rejected_answer_fixture()
      assert {:ok, %RejectedAnswer{}} = MatchSessions.delete_rejected_answer(rejected_answer)
      assert_raise Ecto.NoResultsError, fn -> MatchSessions.get_rejected_answer!(rejected_answer.id) end
    end

    test "change_rejected_answer/1 returns a rejected_answer changeset" do
      rejected_answer = rejected_answer_fixture()
      assert %Ecto.Changeset{} = MatchSessions.change_rejected_answer(rejected_answer)
    end
  end

  describe "accepted_answer" do
    alias Matchmaker.MatchSessions.AcceptedAnswer

    import Matchmaker.MatchSessionsFixtures

    @invalid_attrs %{}

    test "list_accepted_answer/0 returns all accepted_answer" do
      accepted_answer = accepted_answer_fixture()
      assert Enum.map(MatchSessions.list_accepted_answers(), & &1.id) == [accepted_answer.id]
    end

    test "get_accepted_answer!/1 returns the accepted_answer with given id" do
      accepted_answer = accepted_answer_fixture()
      assert MatchSessions.get_accepted_answer!(accepted_answer.id).id == accepted_answer.id
    end

    test "delete_accepted_answer/1 deletes the accepted_answer" do
      accepted_answer = accepted_answer_fixture()
      assert {:ok, %AcceptedAnswer{}} = MatchSessions.delete_accepted_answer(accepted_answer)
      assert_raise Ecto.NoResultsError, fn -> MatchSessions.get_accepted_answer!(accepted_answer.id) end
    end

    test "change_accepted_answer/1 returns a accepted_answer changeset" do
      accepted_answer = accepted_answer_fixture()
      assert %Ecto.Changeset{} = MatchSessions.change_accepted_answer(accepted_answer)
    end
  end

  describe "participants" do
    alias Matchmaker.MatchSessions.Participant

    import Matchmaker.MatchSessionsFixtures

    @invalid_attrs %{}

    test "list_participants/0 returns all participants" do
      participant = participant_fixture()
      assert Enum.map(MatchSessions.list_participants(), & &1.id) == [participant.id]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert MatchSessions.get_participant!(participant.id).id == participant.id
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = MatchSessions.delete_participant(participant)
      assert_raise Ecto.NoResultsError, fn -> MatchSessions.get_participant!(participant.id) end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = MatchSessions.change_participant(participant)
    end
  end
end
