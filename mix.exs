defmodule Behemoth.Mixfile do
  use Mix.Project

  def project do
    [
      app: :behemoth,
      version: "0.0.1",
      elixir: ">= 1.8.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext, :phoenix_swagger] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Behemoth.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix зависимости
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_swagger,
       git: "https://github.com/xerions/phoenix_swagger.git", branch: "possibly-return-json-response-from-swagger-ui"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # Базы данных
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      # Безопасность
      {:guardian, "~> 2.0.0"},
      # I18N
      {:gettext, "~> 0.11"},
      # Сервера
      {:plug_cowboy, "~> 2.0"},
      # Протоколы, форматы
      {:jason, "~> 1.0"},
      {:decimal, "~> 1.8.0"},
      # Линтеры
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
