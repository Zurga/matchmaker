defmodule Matchmaker.Repo.Migrations.CreateResponse do
  use Ecto.Migration

  def change do
    create table(:responses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :value, :text
      add :participant_id, references(:participants, on_delete: :nothing, type: :binary_id)
      add :answer_id, references(:answers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:responses, [:participant_id])
    create index(:responses, [:answer_id])
  end
end
