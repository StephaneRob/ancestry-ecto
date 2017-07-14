defmodule Ancestry.Test.AncestorsTest do
  use ExUnit.Case
  doctest Ancestry

  alias Ancestry.TestProject
  alias Ancestry.TestProject.{Repo, Page}

  setup do
    TestProject.Helpers.cleanup
    :ok
  end

  test "get ancestor_ids" do
    page = Repo.get(Page, 3)
    assert Page.ancestor_ids(page) == [1, 2]
  end

  test "get all ancestor" do
    page = Repo.get(Page, 3)
    assert length(Page.ancestors(page)) == 2
  end
end
