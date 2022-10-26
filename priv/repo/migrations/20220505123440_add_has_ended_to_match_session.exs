defmodule Matchmaker.Repo.Migrations.AddHasEndedToMatchSession do
  use Ecto.Migration

  def change do
    alter table "match_sessions" do
      add :has_ended, :boolean
      add :due_datetime, :utc_datetime
    end
  end
end
