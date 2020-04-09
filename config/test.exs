import Config

config :logger, level: :info

config :ancestry_ecto,
  ecto_repos: [AncestryEcto.TestRepo]

config :ancestry_ecto, AncestryEcto.TestRepo,
  database: "ancestry_test",
  pool: Ecto.Adapters.SQL.Sandbox
