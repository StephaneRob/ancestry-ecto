
ExUnit.start()

Code.require_file("test_project.exs", __DIR__)

alias Ancestry.TestProject
alias Ancestry.TestProject.{Repo, Page}

defmodule TestProject.Helpers do
  def cleanup do
    Ecto.Migrator.down  TestProject.Repo, 0, TestProject.Migration, log: false
    Ecto.Migrator.up    TestProject.Repo, 0, TestProject.Migration, log: false

    %Page{}
    |> Page.changeset(%{ancestry: nil})
    |> Repo.insert()
    %Page{}
    |> Page.changeset(%{ancestry: "1"})
    |> Repo.insert()
    %Page{}
    |> Page.changeset(%{ancestry: "1/2"})
    |> Repo.insert()
    %Page{}
    |> Page.changeset(%{ancestry: "1/2/3"})
    |> Repo.insert()
    %Page{}
    |> Page.changeset(%{ancestry: nil})
    |> Repo.insert()
    %Page{}
    |> Page.changeset(%{ancestry: "1"})
    |> Repo.insert()
    %Page{}
    |> Page.changeset(%{ancestry: "4"})
    |> Repo.insert()
  end
end

# Start Ecto
Ecto.Adapters.Postgres.ensure_all_started(TestProject.Repo, :temporary)
Ecto.Adapters.Postgres.storage_down(TestProject.Repo.config)
Ecto.Adapters.Postgres.storage_up(TestProject.Repo.config)
TestProject.Repo.start_link
