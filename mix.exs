defmodule AncestryEcto.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ancestry_ecto,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: "Ancestry for Ecto.",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "ancestry-ecto",
      package: package(),
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:ecto, "~> 3.4.0"},
      {:ecto_sql, "~> 3.0", only: [:dev, :test]},
      {:postgrex, ">= 0.0.0", only: [:dev, :test]},
      {:ex_machina, "~> 2.4", only: :test},
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.3.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      # Ensures database is reset before tests are run
      test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp package do
    [
      maintainers: ["Stéphane Robino"],
      licenses: ["BSD-2-Clause"],
      links: %{"GitHub" => "https://github.com/StephaneRob/ancestry-ecto"}
    ]
  end
end
