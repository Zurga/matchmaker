defmodule Matchmaker.MatchSessions do
  @moduledoc """
  The MatchSessions context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias Matchmaker.Repo

  alias Matchmaker.Accounts.User
  alias Matchmaker.Answers.Answer
  alias Matchmaker.MatchSessions.{MatchSession, Participant, Response, Invitation}

  @doc """
  Returns the list of match_sessions.

  ## Examples

      iex> list_match_sessions()
      [%MatchSession{}, ...]

  """
  def list_match_sessions(%User{id: id}) do
    participants = from(p in Participant, select: p.match_session_id, where: p.user_id == ^id)

    from(m in MatchSession, where: m.id in subquery(participants))
    |> Repo.all()
    |> Repo.preload([:question])
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
  def get_match_session!(id),
    do:
      Repo.get!(MatchSession, id)
      |> preload_match_session()

  @doc """
  Creates a match_session.

  ## Examples

      iex> create_match_session(%{field: value})
      {:ok, %MatchSession{}}

      iex> create_match_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_match_session(user, attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:match_session, MatchSession.changeset(%MatchSession{}, attrs))
    |> Multi.insert(:participant, fn %{match_session: match_session} ->
      Ecto.build_assoc(match_session, :participants, %{user: user, role: "admin"})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{match_session: match_session}} ->
        {:ok, preload_match_session(match_session)}

      {:error, _operation, value, _changes} ->
        {:error, value}
    end
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
  Checks whether a MatchSession has ended.
  """
  def match_session_ended?(%{id: id}) do
    %{participants: participants, answer_set: %{answers: answers}} =
      match_session = get_match_session!(id)

    with false <- match_session.has_ended do
      answers_count = length(answers)

      participants
      |> Enum.map(fn participant -> length(participant.responses) end)
      |> Enum.all?(fn count -> count == answers_count end)
    end
  end

  @doc """
  Returns the list of responses for a given participant.

  ## Examples

      iex> list_responses(participant)
      [%Response{}, ...]

  """
  def list_responses(%Participant{id: id}) do
    from(r in Response, where: r.participant_id == ^id)
    |> Repo.all()
  end

  @doc """
  Gets a single response.

  Raises `Ecto.NoResultsError` if the Response does not exist.

  ## Examples

      iex> get_response!(123)
      %Response{}

      iex> get_response!(456)
      ** (Ecto.NoResultsError)

  """
  def get_response!(id), do: Repo.get!(Response, id)

  @doc """
  Creates a response.

  ## Examples

      iex> create_response(%{field: value})
      {:ok, %Response{}}

      iex> create_response(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_response(%Participant{} = participant, answer, attrs) do
    Ecto.build_assoc(participant, :responses, %{answer: answer, match_session_id: participant.match_session_id})
    |> Response.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a response.

  ## Examples

      iex> update_response(response, %{field: new_value})
      {:ok, %Response{}}

      iex> update_response(response, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_response(%Response{} = response, attrs) do
    response
    |> Response.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a response.

  ## Examples

      iex> delete_response(response)
      {:ok, %Response{}}

      iex> delete_response(response)
      {:error, %Ecto.Changeset{}}

  """
  def delete_response(%Response{} = response) do
    Repo.delete(response)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking response changes.

  ## Examples

      iex> change_response(response)
      %Ecto.Changeset{data: %Response{}}

  """
  def change_response(%Response{} = response, attrs \\ %{}) do
    Response.changeset(response, attrs)
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
  def create_participant(match_session, user, attrs \\ %{})

  def create_participant(match_session, user, attrs) when is_binary(match_session) do
    get_match_session!(match_session)
    |> create_participant(user, attrs)
  end

  def create_participant(%MatchSession{} = match_session, user, attrs) do
    %Participant{}
    |> Participant.changeset(attrs)
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

  @doc """
  Returns the list of open invitations.

  ## Examples

      iex> list_open_invitations()
      [%Invitation{}, ...]

  """
  def list_open_invitations(%User{id: id}) do
    from(i in Invitation, where: i.invitee_id == ^id, where: i.status == "pending")
    |> Repo.all()
    |> Repo.preload(match_session: [:question])
  end

  @doc """
  Gets a single invitation.

  Raises `Ecto.NoResultsError` if the Invitation does not exist.

  ## Examples

      iex> get_invitation!(123)
      %Invitation{}

      iex> get_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invitation!(id), do: Repo.get!(Invitation, id)

  @doc """
  Creates a invitation.

  ## Examples

      iex> create_invitation(%{field: value})
      {:ok, %Invitation{}}

      iex> create_invitation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invitation(match_session, user, attrs \\ %{})

  def create_invitation(match_session, user, attrs) when is_binary(match_session) do
    get_match_session!(match_session)
    |> create_invitation(user, attrs)
  end

  def create_invitation(
        %MatchSession{} = match_session,
        %{role: "admin"} = participant,
        %User{} = user
      ) do
    Ecto.build_assoc(match_session, :invitations, %{invitee: user, inviter: participant})
    |> Repo.insert()
  end

  @doc """
  Whether or not a User wants to join a MatchSession
  """
  def join_match_session(
        %Invitation{email: email, invitee_id: user_id} = invitation,
        %User{email: user_email, id: id} = user,
        response \\ true
      )
      when user_email == email or user_id == id do
    if response do
      create_participant(invitation.match_session_id, user)
    else
      change_invitation(invitation, %{status: "declined"})
    end
  end

  @doc """
  Updates a invitation.

  ## Examples

      iex> update_invitation(invitation, %{field: new_value})
      {:ok, %Invitation{}}

      iex> update_invitation(invitation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invitation(%Invitation{} = invitation, attrs) do
    invitation
    |> Invitation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invitation.

  ## Examples

      iex> delete_invitation(invitation)
      {:ok, %Invitation{}}

      iex> delete_invitation(invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invitation changes.

  ## Examples

      iex> change_invitation(invitation)
      %Ecto.Changeset{data: %Invitation{}}

  """
  def change_invitation(%Invitation{} = invitation, attrs \\ %{}) do
    Invitation.changeset(invitation, attrs)
  end

  def get_unseen_answers(%MatchSession{answer_set: %{id: answer_set_id}, type: "swipe"}, %Participant{id: participant_id}) do
    seen = from(r in Response, select: r.answer_id, where: r.participant_id == ^participant_id)

    from(a in Answer,
      where: a.id not in subquery(seen),
      where: a.answer_set_id == ^answer_set_id,
      limit: 20
    )
    |> Repo.all()
  end

  def get_unseen_answers(%MatchSession{answer_set: %{id: answer_set_id}, type: "tournament"}, %Participant{id: participant_id}) do

  end

  def get_matching_answers(%MatchSession{type: "swipe", participants: participants, id: id} = match_session) do
    amount_of_participants = length(participants)

    responses =
      from(r in Response,
        select: {r.answer_id, r.participant_id},
        where: r.match_session_id == ^id,
        where: r.value == "1"
      )
      |> Repo.all()
    # IO.puts "from participants"
    # responses =
    #   from(r in Response,
    #     select: {r.answer_id, r.participant_id},
    #     where: r.participant_id in ^participant_ids,
    #     where: r.value == "1"
    #   )
      # |> Repo.all()
      |> Enum.reduce(%{}, fn {answer, id} = response, acc ->
        Map.update(acc, answer, [id], &[id | &1])
      end)
      |> Enum.reduce([], fn {answer, participants}, acc ->
        if length(participants) == amount_of_participants do
          [answer | acc]
        else
          acc
        end
      end)


    from(a in Answer, select: a.title, where: a.id in ^responses, order_by: a.title)
    |> Repo.all()
  end

  defp preload_match_session(match_session),
    do:
      Repo.preload(match_session, [
        :question,
        participants: [:user, :responses],
        answer_set: [:answers]
      ])
end
