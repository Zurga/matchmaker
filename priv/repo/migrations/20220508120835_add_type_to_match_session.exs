defmodule Matchmaker.Repo.Migrations.AddTypeToMatchSession do
  use Ecto.Migration

  def change do
    alter table(:match_sessions) do
      add :type, :string, default: "swipe"
    end
  end
end
