import Config

# Do not print debug messages in production
config :logger, level: :info

config :app, AppWeb.Endpoint,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json"
