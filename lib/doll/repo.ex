defmodule Doll.Repo do
  use Ecto.Repo,
    otp_app: :doll,
    adapter: Ecto.Adapters.Postgres
end
