defmodule AncestryEcto.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: AncestryEcto.TestRepo
  use AncestryEcto.PageFactory
end
