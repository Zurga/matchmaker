defmodule Matchmaker.Repo.Migrations.AddMatchSessionToResponse do
  use Ecto.Migration
  import Ecto.Query

  def change do

    alter table("responses") do
      add :match_session_id, references(:match_sessions, on_delete: :nothing, type: :binary_id)
    end

    create index(:responses, [:match_session_id])
    flush()
    from(r in "responses",
      join: p in "participants",
      on: r.participant_id == p.id,
      select: [r.id, p.match_session_id]
    )
    |> Matchmaker.Repo.all()
    |> Enum.map(fn [response, match_session] ->
      from(r in "responses",
        update: [set: [match_session_id: ^match_session]],
        where: r.id == ^response,
        select: r.id
      )
      |> Matchmaker.Repo.update_all([])
    end)
  end
end
