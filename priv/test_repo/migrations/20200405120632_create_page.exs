defmodule Ancestry.TestRepo.Migrations.CreatePage do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add(:ancestry, :string)
      add(:reference, :uuid)
      add(:custom_ancestry, :string)
      add(:custom_ancestry_custom_attribute, :string)

      timestamps()
    end

    create(index(:pages, [:ancestry]))
  end
end
