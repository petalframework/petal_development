import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      Environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      Environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  web_host =
    System.get_env("WEB_HOST") ||
      raise """
      Environment variable WEB_HOST is missing.
      It should be your domain. Eg. "example.com" or "my_subdomain.example.com"
      """

  config :app, App.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  config :app, AppWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    url: [
      scheme: "https",
      host: web_host,
      port: 443
    ],
    secret_key_base: secret_key_base

  config :email_checker,
    default_dns: :system,
    also_dns: [],
    validations: [EmailChecker.Check.Format, EmailChecker.Check.MX],
    smtp_retries: 2,
    timeout_milliseconds: :infinity

  config :app, App.Mailer, adapter: Bamboo.SesAdapter

  # This is required for Amazon SES (used by the mailer)
  config :ex_aws,
    json_codec: Jason,
    region: {:system, "AWS_REGION"},
    access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
    secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :app, AppWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.
end
