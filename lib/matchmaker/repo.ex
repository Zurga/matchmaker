defmodule Matchmaker.Repo do
  use Ecto.Repo,
    otp_app: :matchmaker,
    adapter: Ecto.Adapters.Postgres
end
