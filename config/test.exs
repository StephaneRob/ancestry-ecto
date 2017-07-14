use Mix.Config

# Print only warnings and errors during test
config :logger, level: :info

config :ancestry,
  ecto_repos: [Ancestry.TestProject.Repo]

config :ancestry, Ancestry.TestProject.Repo,
  adapter:  Ecto.Adapters.Postgres,
  pool:     Ecto.Adapters.SQL.Sandbox,
  database: "ancestry_test",
  hostname: "localhost"
