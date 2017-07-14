defmodule Ancestry.TestProject do

  ## Mocked 'Repo' for our project

  defmodule Repo do
    use Ecto.Repo, otp_app: :ancestry
  end


  ## Fake model to test against

  defmodule Page do
    use Ecto.Schema
    use Ancestry

    import Ecto.Changeset

    schema "pages" do
      field :ancestry, :string

      timestamps()
    end

    def changeset(struct, params) do
      struct
      |> cast(params, [:ancestry])
    end
  end


  ## Migration for our Test Model
  defmodule Migration do
    use Ecto.Migration

    def change do
      create table(:pages) do
        add :ancestry, :string

        timestamps()
      end
      create index(:pages, [:ancestry])
    end
  end

end
