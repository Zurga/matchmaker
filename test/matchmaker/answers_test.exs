defmodule Matchmaker.AnswersTest do
  use Matchmaker.DataCase

  alias Matchmaker.Answers
  import Matchmaker.MatchSessionsFixtures

  describe "answers" do
    alias Matchmaker.Answers.Answer

    import Matchmaker.AnswersFixtures

    @invalid_attrs %{data: %{}, description: "", title: ""}

    test "list_answers/0 returns all answers" do
      answer = answer_fixture()
      assert Answers.list_answers() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Answers.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      valid_attrs = %{data: %{}, description: "some description", title: "some title"}
      answer_set = answer_set_fixture()
      assert {:ok, %Answer{} = answer} = Answers.create_answer(answer_set, valid_attrs)
      assert answer.data == %{}
      assert answer.description == "some description"
      assert answer.title == "some title"
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Answers.create_answer(answer_set_fixture(), @invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()

      update_attrs = %{
        data: %{},
        description: "some updated description",
        title: "some updated title"
      }

      assert {:ok, %Answer{} = answer} = Answers.update_answer(answer, update_attrs)
      assert answer.data == %{}
      assert answer.description == "some updated description"
      assert answer.title == "some updated title"
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Answers.update_answer(answer, @invalid_attrs)
      assert answer == Answers.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Answers.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Answers.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Answers.change_answer(answer)
    end
  end

  describe "answer_sets" do
    alias Matchmaker.Answers.AnswerSet

    import Matchmaker.AnswersFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_answer_sets/0 returns all answer_sets" do
      answer_set = answer_set_fixture()
      assert Answers.list_answer_sets() == [answer_set]
    end

    test "get_answer_set!/1 returns the answer_set with given id" do
      answer_set = answer_set_fixture()
      assert Answers.get_answer_set!(answer_set.id) == answer_set
    end

    test "create_answer_set/1 with valid data creates a answer_set" do
      match_session = match_session_fixture()
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %AnswerSet{} = answer_set} = Answers.create_answer_set(valid_attrs)
      assert answer_set.description == "some description"
      assert answer_set.title == "some title"
    end

    test "create_answer_set/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Answers.create_answer_set(@invalid_attrs)
    end

    test "update_answer_set/2 with valid data updates the answer_set" do
      answer_set = answer_set_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %AnswerSet{} = answer_set} =
               Answers.update_answer_set(answer_set, update_attrs)

      assert answer_set.description == "some updated description"
      assert answer_set.title == "some updated title"
    end

    test "update_answer_set/2 with invalid data returns error changeset" do
      answer_set = answer_set_fixture()
      assert {:error, %Ecto.Changeset{}} = Answers.update_answer_set(answer_set, @invalid_attrs)
      assert answer_set == Answers.get_answer_set!(answer_set.id)
    end

    test "delete_answer_set/1 deletes the answer_set" do
      answer_set = answer_set_fixture()
      assert {:ok, %AnswerSet{}} = Answers.delete_answer_set(answer_set)
      assert_raise Ecto.NoResultsError, fn -> Answers.get_answer_set!(answer_set.id) end
    end

    test "change_answer_set/1 returns a answer_set changeset" do
      answer_set = answer_set_fixture()
      assert %Ecto.Changeset{} = Answers.change_answer_set(answer_set)
    end
  end
end
