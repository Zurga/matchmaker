defmodule Matchmaker.Repo.Migrations.MatchSessionParticipantUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index("participants", [:user_id, :match_session_id])
  end
end
