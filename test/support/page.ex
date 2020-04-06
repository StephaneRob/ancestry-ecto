defmodule Ancestry.Page do
  @moduledoc false

  use Ecto.Schema
  use Ancestry, repo: Ancestry.TestRepo

  schema "pages" do
    field(:ancestry, :string)
    field(:reference, Ecto.UUID)
    field(:custom_ancestry, :string)
    field(:custom_ancestry_custom_attribute, :string)

    timestamps()
  end
end
