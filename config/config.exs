# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :behemoth,
  ecto_repos: [Behemoth.Repo]

# Configures the endpoint
config :behemoth, BehemothWeb.Endpoint,
  url: [scheme: "https", port: 4001],
  secret_key_base: "PIAJ+0L6UoL7aSHsLVxuX5j+RPHmCdpUZ3at+fGBKvh3WpMSk7VQAYW9lfdsqy+S",
  https: [
    port: 4001,
    cipher_suite: :strong,
    keyfile: "priv/cert/selfsigned_key.pem",
    certfile: "priv/cert/selfsigned.pem"
  ],
  render_errors: [view: BehemothWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Behemoth.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures the guardian
config :behemoth, Behemoth.Guardian,
  issuer: "behemoth",
  secret_key: "secret_key"

# Swagger integration to Phoenix framework
config :behemoth, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: BehemothWeb.Router
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
