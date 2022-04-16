defmodule AreteServer.Repo do
  use Ecto.Repo,
    otp_app: :arete_server,
    adapter: Ecto.Adapters.Postgres
end
