defmodule Matchmaker.Answers do
  @moduledoc """
  The Answers context.
  """

  import Ecto.Query, warn: false
  alias Matchmaker.Repo

  alias Matchmaker.Answers.Answer

  @doc """
  Returns the list of answers.

  ## Examples

      iex> list_answers()
      [%Answer{}, ...]

  """
  def list_answers do
    Repo.all(Answer)
  end

  @doc """
  Gets a single answer.

  Raises `Ecto.NoResultsError` if the Answer does not exist.

  ## Examples

      iex> get_answer!(123)
      %Answer{}

      iex> get_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer!(id), do: Repo.get!(Answer, id)

  @doc """
  Creates a answer.

  ## Examples

      iex> create_answer(%{field: value})
      {:ok, %Answer{}}

      iex> create_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer(answer_set, attrs \\ %{}) do
    Ecto.build_assoc(answer_set, :answers, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer.

  ## Examples

      iex> update_answer(answer, %{field: new_value})
      {:ok, %Answer{}}

      iex> update_answer(answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer.

  ## Examples

      iex> delete_answer(answer)
      {:ok, %Answer{}}

      iex> delete_answer(answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer changes.

  ## Examples

      iex> change_answer(answer)
      %Ecto.Changeset{data: %Answer{}}

  """
  def change_answer(%Answer{} = answer, attrs \\ %{}) do
    Answer.changeset(answer, attrs)
  end

  alias Matchmaker.Answers.AnswerSet

  @doc """
  Returns the list of answers_sets.

  ## Examples

      iex> list_answers_sets()
      [%AnswerSet{}, ...]

  """
  def list_answers_sets do
    Repo.all(AnswerSet)
  end

  @doc """
  Gets a single answer_set.

  Raises `Ecto.NoResultsError` if the Answer set does not exist.

  ## Examples

      iex> get_answer_set!(123)
      %AnswerSet{}

      iex> get_answer_set!(456)
      ** (Ecto.NoResultsError)

  """
  def get_answer_set!(id), do: Repo.get!(AnswerSet, id)

  @doc """
  Creates a answer_set.

  ## Examples

      iex> create_answer_set(%{field: value})
      {:ok, %AnswerSet{}}

      iex> create_answer_set(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_answer_set(attrs \\ %{}) do
    %AnswerSet{}
    |> AnswerSet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a answer_set.

  ## Examples

      iex> update_answer_set(answer_set, %{field: new_value})
      {:ok, %AnswerSet{}}

      iex> update_answer_set(answer_set, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_answer_set(%AnswerSet{} = answer_set, attrs) do
    answer_set
    |> AnswerSet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a answer_set.

  ## Examples

      iex> delete_answer_set(answer_set)
      {:ok, %AnswerSet{}}

      iex> delete_answer_set(answer_set)
      {:error, %Ecto.Changeset{}}

  """
  def delete_answer_set(%AnswerSet{} = answer_set) do
    Repo.delete(answer_set)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking answer_set changes.

  ## Examples

      iex> change_answer_set(answer_set)
      %Ecto.Changeset{data: %AnswerSet{}}

  """
  def change_answer_set(%AnswerSet{} = answer_set, attrs \\ %{}) do
    AnswerSet.changeset(answer_set, attrs)
  end
end
