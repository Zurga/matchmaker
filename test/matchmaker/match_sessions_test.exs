defmodule Matchmaker.MatchSessionsTest do
  use Matchmaker.DataCase

  alias Matchmaker.Answers
  alias Matchmaker.MatchSessions
  alias Matchmaker.MatchSessions.{MatchSession, Participant, Response}

  import Matchmaker.{
    MatchSessionsFixtures,
    AccountsFixtures,
    QuestionsFixtures,
    AnswersFixtures
  }

  describe "match_sessions" do
    @invalid_attrs %{public: "aostha"}

    test "list_match_sessions/0 returns all match_sessions for a user" do
      match_session = match_session_fixture()
      %{participants: [%{user: user}]} = match_session
      assert Enum.map(MatchSessions.list_match_sessions(user), & &1.id) == [match_session.id]
    end

    test "get_match_session!/1 returns the match_session with given id" do
      match_session = match_session_fixture()

      assert MatchSessions.get_match_session!(match_session.id) == match_session
    end

    test "create_match_session/1 with valid data creates a match_session" do
      user = user_fixture()
      question = question_fixture()
      answer_set = answer_set_fixture()
      valid_attrs = %{owner: user, question: question, answer_set: answer_set}

      assert {:ok, %MatchSession{} = match_session} =
               MatchSessions.create_match_session(user, valid_attrs)

      assert match_session.participants != []
      assert length(match_session.participants) == 1
    end

    test "delete_match_session/1 deletes the match_session" do
      match_session = match_session_fixture()
      assert {:ok, %MatchSession{}} = MatchSessions.delete_match_session(match_session)

      assert_raise Ecto.NoResultsError, fn ->
        MatchSessions.get_match_session!(match_session.id)
      end
    end

    test "change_match_session/1 returns a match_session changeset" do
      match_session = match_session_fixture()
      assert %Ecto.Changeset{} = MatchSessions.change_match_session(match_session)
    end
  end

  describe "response" do
    setup do
      answer = answer_fixture()
      participant = participant_fixture()
      response = response_fixture(participant, answer)
      %{participant: participant, response: response}
    end

    test "list_response/1 returns all response", %{participant: participant, response: response} do
      assert Enum.map(MatchSessions.list_responses(participant), & &1.id) == [response.id]
    end

    test "get_response!/1 returns the response with given id", %{response: response} do
      assert MatchSessions.get_response!(response.id).id == response.id
    end

    test "delete_response/1 deletes the response", %{response: response} do
      assert {:ok, %Response{}} = MatchSessions.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> MatchSessions.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset", %{response: response} do
      assert %Ecto.Changeset{} = MatchSessions.change_response(response)
    end
  end

  describe "participants" do
    test "list_participants/0 returns all participants" do
      participant_fixture()
      assert Enum.map(MatchSessions.list_participants(), & &1.id) != []
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

    test "participants can be invited to join the match_session" do
      match_session = match_session_fixture()
      participant = hd(match_session.participants)
      %{id: id} = other_user = user_fixture()

      assert {:ok, invitation} =
               MatchSessions.create_invitation(
                 match_session,
                 participant,
                 other_user
               )

      assert invitation.invitee_id == id
      assert invitation.inviter_id == participant.id

      {:ok, _} = MatchSessions.join_match_session(invitation, other_user, true)
    end

    # TODO write test to invite user by email
  end

  describe "answers and responses" do
    test "unseen answers are returned for a participant" do
      %{participants: [participant]} = match_session = match_session_fixture()

      1..100
      |> Enum.map(&Answers.create_answer(match_session.answer_set, %{title: "Answer #{&1}"}))

      [to_answer | _rest] = unseen = MatchSessions.get_unseen_answers(match_session, participant)
      assert 20 == length(unseen)

      MatchSessions.create_response(participant, to_answer, %{accepted: true})
      assert to_answer not in MatchSessions.get_unseen_answers(match_session, participant)
    end
  end
end
