defmodule Matchmaker.Repo.Migrations.CreateRejectedAnswer do
  use Ecto.Migration

  def change do
    create table(:rejected_answers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :participant_id, references(:participants, on_delete: :nothing, type: :binary_id)
      add :answer_id, references(:answers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:rejected_answers, [:participant_id])
    create index(:rejected_answers, [:answer_id])
  end
end
