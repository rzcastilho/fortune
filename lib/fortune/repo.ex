defmodule Fortune.Repo do
  use Ecto.Repo,
    otp_app: :fortune,
    adapter: Ecto.Adapters.Postgres
end
