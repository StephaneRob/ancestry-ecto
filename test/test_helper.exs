{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
AncestryEcto.TestRepo.start_link([])
Ecto.Adapters.SQL.Sandbox.mode(AncestryEcto.TestRepo, :manual)
