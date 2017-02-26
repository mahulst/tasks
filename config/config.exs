# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :tasks,
  ecto_repos: [Tasks.Repo]

# Configures the endpoint
config :tasks, Tasks.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W3EtjoLj70ow9zw8AbId3irIqfq7+CMhI31MQWHT9fowdS/WbaUlUE06n6rPAal6",
  render_errors: [view: Tasks.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Tasks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
    issuer: "PhoenixTrello",
    ttl: { 3, :days },
    verify_issuer: true,
    secret_key: "asfasdfasdfasdfasdfasdfasdfasfas",
    serializer: Tasks.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
