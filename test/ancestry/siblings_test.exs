defmodule Ancestry.Test.SiblingsTest do
  use ExUnit.Case
  doctest Ancestry

  alias Ancestry.TestProject
  alias Ancestry.TestProject.{Repo, Page}

  setup do
    TestProject.Helpers.cleanup
    :ok
  end

  test "get siblings" do
    page = Repo.get(Page, 2)
    assert Page.sibling_ids(page) == [2, 6]
  end
end
