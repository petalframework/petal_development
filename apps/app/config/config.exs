# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :app,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QolXTsIrTjUo8h0b/b6o6+gA8R5dUwOt6bzt8XInaawQlByebuY6SB7dotyEA6EE",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "DPpTA/xM"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Stripe payments
config :stripity_stripe, api_key: System.get_env("STRIPE_SECRET")

# Store images on Cloudinary
# config :cloudex,
#   api_key: System.get_env("CLOUDINARY_API_KEY"),
#   secret: System.get_env("CLOUDINARY_SECRET"),
#   cloud_name: System.get_env("CLOUDINARY_CLOUD_NAME")

config :surface, :components, [
  {
    Surface.Components.Markdown,
    default_class: "prose dark:prose-dark mx-auto",
    default_opts: [
      code_class_prefix: "language-"
    ]
  }
]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally.
# View sent emails in your browser: "/dev/sent_emails".
# View email templates: "/dev/emails".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :app, App.Mailer, adapter: Bamboo.LocalAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
