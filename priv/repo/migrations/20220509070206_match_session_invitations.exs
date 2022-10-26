defmodule Matchmaker.Repo.Migrations.MatchSessionInvitations do
  use Ecto.Migration

  def change do
    create table(:match_sessions_invitations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :status, :string, default: "pending"
      add :role, :string, default: "user"
      add :email, :string
      add :match_session_id, references("match_sessions", on_delete: :delete_all, type: :binary_id)
      add :invitee_id, references("users", on_delete: :delete_all, type: :binary_id)
      add :inviter_id, references("participants", on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
    create index(:match_sessions_invitations, [:invitee_id])
    create index(:match_sessions_invitations, [:inviter_id])
    create index(:match_sessions_invitations, [:match_session_id])
  end
end
