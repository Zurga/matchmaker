defmodule Matchmaker.Repo.Migrations.CreateMatchSessions do
  use Ecto.Migration

  def change do
    create table(:match_sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :public, :boolean
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :answer_set_id, references(:answer_sets, on_delete: :nothing, type: :binary_id)
      add :question_id, references(:questions, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:match_sessions, [:user_id])
    create index(:match_sessions, [:answer_set_id])
    create index(:match_sessions, [:question_id])
  end
end
