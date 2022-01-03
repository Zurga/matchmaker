defmodule Matchmaker.QuestionsTest do
  use Matchmaker.DataCase
  import Matchmaker.AccountsFixtures

  alias Matchmaker.Questions

  describe "questions" do
    alias Matchmaker.Questions.Question

    import Matchmaker.QuestionsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Questions.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Questions.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      valid_attrs = %{description: "some description", title: "some title"}
      user = user_fixture()
      assert {:ok, %Question{} = question} = Questions.create_question(user, valid_attrs)
      assert question.description == "some description"
      assert question.title == "some title"
    end

    test "create_question/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.create_question(user, @invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Question{} = question} = Questions.update_question(question, update_attrs)
      assert question.description == "some updated description"
      assert question.title == "some updated title"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_question(question, @invalid_attrs)
      assert question == Questions.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Questions.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Questions.change_question(question)
    end
  end
end
