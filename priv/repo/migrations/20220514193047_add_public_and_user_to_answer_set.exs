defmodule Matchmaker.Repo.Migrations.AddPublicAndUserToAnswerSet do
  use Ecto.Migration
  import Ecto.Query

  def change do
    alter table("answer_sets") do
      add :public, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
    end
    create index(:answer_sets, [:user_id])
  end
end
