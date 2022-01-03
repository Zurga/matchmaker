defmodule Matchmaker.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :match_session_id, references(:match_sessions, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:participants, [:user_id])
    create index(:participants, [:match_session_id])
  end
end
