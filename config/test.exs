import Config

config :logger, level: :info

config :ancestry,
  ecto_repos: [Ancestry.TestRepo]

config :ancestry, Ancestry.TestRepo,
  database: "ancestry_test",
  pool: Ecto.Adapters.SQL.Sandbox
