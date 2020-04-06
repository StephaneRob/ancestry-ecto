{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start()
Ancestry.TestRepo.start_link([])
Ecto.Adapters.SQL.Sandbox.mode(Ancestry.TestRepo, :manual)
