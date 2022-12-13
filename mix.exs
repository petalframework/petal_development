defmodule PetalDevelopment.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.0-rc.0", override: true},
    ]
  end

  defp aliases do
    [
      setup: "cmd --app petal_boilerplate mix setup"
    ]
  end
end
