defmodule NewtTerrarium.Repo do
  use Ecto.Repo,
    otp_app: :terrarium,
    adapter: Ecto.Adapters.Postgres
end
