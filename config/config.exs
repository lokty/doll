# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :doll,
  ecto_repos: [Doll.Repo]

# Configures the endpoint
config :doll, DollWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PmWzGSEEL8hElHDjonkRytmnYUIzwt78z9D7gn7rCMz8fBwCVL0sAUV5xlfe4gSH",
  render_errors: [view: DollWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Doll.PubSub,
  live_view: [signing_salt: "4JxYLl3p"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
