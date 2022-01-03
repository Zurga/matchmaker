defmodule Matchmaker.MatchSessions do
  @moduledoc """
  The MatchSessions context.
  """

  import Ecto.Query, warn: false
  alias Matchmaker.Repo

  alias Matchmaker.MatchSessions.{MatchSession, Participant, AcceptedAnswer, RejectedAnswer}

  @doc """
  Returns the list of match_sessions.

  ## Examples

      iex> list_match_sessions()
      [%MatchSession{}, ...]

  """
  def list_match_sessions do
    Repo.all(MatchSession)
  end

  @doc """
  Gets a single match_session.

  Raises `Ecto.NoResultsError` if the Match session does not exist.

  ## Examples

      iex> get_match_session!(123)
      %MatchSession{}

      iex> get_match_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_match_session!(id), do: Repo.get!(MatchSession, id) |> Repo.preload([:question, :answer_set, :user])

  @doc """
  Creates a match_session.

  ## Examples

      iex> create_match_session(%{field: value})
      {:ok, %MatchSession{}}

      iex> create_match_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match_session(attrs \\ %{}) do
    %MatchSession{}
    |> MatchSession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a match_session.

  ## Examples

      iex> update_match_session(match_session, %{field: new_value})
      {:ok, %MatchSession{}}

      iex> update_match_session(match_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_match_session(%MatchSession{} = match_session, attrs) do
    match_session
    |> MatchSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a match_session.

  ## Examples

      iex> delete_match_session(match_session)
      {:ok, %MatchSession{}}

      iex> delete_match_session(match_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_match_session(%MatchSession{} = match_session) do
    Repo.delete(match_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking match_session changes.

  ## Examples

      iex> change_match_session(match_session)
      %Ecto.Changeset{data: %MatchSession{}}

  """
  def change_match_session(%MatchSession{} = match_session, attrs \\ %{}) do
    MatchSession.changeset(match_session, attrs)
  end

  @doc """
  Returns the list of rejected_answer.

  ## Examples

      iex> list_rejected_answers()
      [%RejectedAnswer{}, ...]

  """
  def list_rejected_answers do
    Repo.all(RejectedAnswer)
  end

  @doc """
  Gets a single rejected_answer.

  Raises `Ecto.NoResultsError` if the Rejected answer does not exist.

  ## Examples

      iex> get_rejected_answer!(123)
      %RejectedAnswer{}

      iex> get_rejected_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rejected_answer!(id), do: Repo.get!(RejectedAnswer, id)

  @doc """
  Creates a rejected_answer.

  ## Examples

      iex> create_rejected_answer(%{field: value})
      {:ok, %RejectedAnswer{}}

      iex> create_rejected_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rejected_answer(%Participant{} = participant, answer) do
    %RejectedAnswer{}
    |> RejectedAnswer.changeset(%{})
    |> Ecto.Changeset.put_assoc(:participant, participant)
    |> Ecto.Changeset.put_assoc(:answer, answer)
    |> Repo.insert()
  end

  @doc """
  Updates a rejected_answer.

  ## Examples

      iex> update_rejected_answer(rejected_answer, %{field: new_value})
      {:ok, %RejectedAnswer{}}

      iex> update_rejected_answer(rejected_answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rejected_answer(%RejectedAnswer{} = rejected_answer, attrs) do
    rejected_answer
    |> RejectedAnswer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rejected_answer.

  ## Examples

      iex> delete_rejected_answer(rejected_answer)
      {:ok, %RejectedAnswer{}}

      iex> delete_rejected_answer(rejected_answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rejected_answer(%RejectedAnswer{} = rejected_answer) do
    Repo.delete(rejected_answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rejected_answer changes.

  ## Examples

      iex> change_rejected_answer(rejected_answer)
      %Ecto.Changeset{data: %RejectedAnswer{}}

  """
  def change_rejected_answer(%RejectedAnswer{} = rejected_answer, attrs \\ %{}) do
    RejectedAnswer.changeset(rejected_answer, attrs)
  end

  @doc """
  Returns the list of accepted_answer.

  ## Examples

      iex> list_accepted_answer()
      [%AcceptedAnswer{}, ...]

  """
  def list_accepted_answers do
    Repo.all(AcceptedAnswer)
  end

  @doc """
  Gets a single accepted_answer.

  Raises `Ecto.NoResultsError` if the Accepted answer does not exist.

  ## Examples

      iex> get_accepted_answer!(123)
      %AcceptedAnswer{}

      iex> get_accepted_answer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_accepted_answer!(id), do: Repo.get!(AcceptedAnswer, id)

  @doc """
  Creates a accepted_answer.

  ## Examples

      iex> create_accepted_answer(%{field: value})
      {:ok, %AcceptedAnswer{}}

      iex> create_accepted_answer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_accepted_answer(participant, answer) do
    %AcceptedAnswer{}
    |> AcceptedAnswer.changeset(%{})
    |> Ecto.Changeset.put_assoc(:participant, participant)
    |> Ecto.Changeset.put_assoc(:answer, answer)
    |> Repo.insert()
  end

  @doc """
  Updates a accepted_answer.

  ## Examples

      iex> update_accepted_answer(accepted_answer, %{field: new_value})
      {:ok, %AcceptedAnswer{}}

      iex> update_accepted_answer(accepted_answer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_accepted_answer(%AcceptedAnswer{} = accepted_answer, attrs) do
    accepted_answer
    |> AcceptedAnswer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a accepted_answer.

  ## Examples

      iex> delete_accepted_answer(accepted_answer)
      {:ok, %AcceptedAnswer{}}

      iex> delete_accepted_answer(accepted_answer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_accepted_answer(%AcceptedAnswer{} = accepted_answer) do
    Repo.delete(accepted_answer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking accepted_answer changes.

  ## Examples

      iex> change_accepted_answer(accepted_answer)
      %Ecto.Changeset{data: %AcceptedAnswer{}}

  """
  def change_accepted_answer(%AcceptedAnswer{} = accepted_answer, attrs \\ %{}) do
    AcceptedAnswer.changeset(accepted_answer, attrs)
  end

  @doc """
  Returns the list of participants.

  ## Examples

      iex> list_participants()
      [%Participant{}, ...]

  """
  def list_participants do
    Repo.all(Participant)
  end

  @doc """
  Gets a single participant.

  Raises `Ecto.NoResultsError` if the Participant does not exist.

  ## Examples

      iex> get_participant!(123)
      %Participant{}

      iex> get_participant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participant!(id), do: Repo.get!(Participant, id)

  @doc """
  Creates a participant.

  ## Examples

      iex> create_participant(%{field: value})
      {:ok, %Participant{}}

      iex> create_participant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participant(match_session, user) do
    %Participant{}
    |> Participant.changeset(%{})
    |> Ecto.Changeset.put_assoc(:match_session, match_session)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a participant.

  ## Examples

      iex> update_participant(participant, %{field: new_value})
      {:ok, %Participant{}}

      iex> update_participant(participant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participant(%Participant{} = participant, attrs) do
    participant
    |> Participant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a participant.

  ## Examples

      iex> delete_participant(participant)
      {:ok, %Participant{}}

      iex> delete_participant(participant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participant(%Participant{} = participant) do
    Repo.delete(participant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participant changes.

  ## Examples

      iex> change_participant(participant)
      %Ecto.Changeset{data: %Participant{}}

  """
  def change_participant(%Participant{} = participant, attrs \\ %{}) do
    Participant.changeset(participant, attrs)
  end
end
