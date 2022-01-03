defmodule Matchmaker.Repo.Migrations.CreateAnswers do
  use Ecto.Migration

  def change do
    create table(:answers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :data, :map
      add :answer_set_id, references(:answer_sets, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
