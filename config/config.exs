# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kommissar,
  ecto_repos: [Kommissar.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :kommissar, KommissarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jhXk45f2GAgPjdOkyzT5AjIUuUHJQ5rbia0YyaAHwXwBzHEPt/HlkFsAzV8Ik/To",
  render_errors: [view: KommissarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kommissar.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kommissar, Kommissar.Accounts,
  salt: "E3teu3BS1qxN3O0J8DVHU9VV0pIt6EiePeVmp5kdEd4dsz6t2N/U2MgZn6PmxgzQ"

config :kommissar, KommissarWeb.Guardian,
  issuer: "kommissar",
  secret_key: "wcoLB0AwnMiAL06ajgw9fnENO2RrLDbJ2U5sxJfqIQqpHQ5/W7xAUGHiPQ2bNT79"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
