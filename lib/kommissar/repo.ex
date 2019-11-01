defmodule Kommissar.Repo do
  use Ecto.Repo,
    otp_app: :kommissar,
    adapter: Ecto.Adapters.Postgres
end
