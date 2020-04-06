defmodule Ancestry.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Ancestry.TestRepo
  use Ancestry.PageFactory
end
