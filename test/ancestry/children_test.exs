defmodule Ancestry.Test.ChildrenTest do
  use ExUnit.Case
  doctest Ancestry

  alias Ancestry.TestProject
  alias Ancestry.TestProject.{Repo, Page}

  setup do
    TestProject.Helpers.cleanup
    :ok
  end

  test "get children" do
    page = Repo.get(Page, 3)
    assert length(Page.children(page)) == 1
    page = Repo.get(Page, 1)
    assert length(Page.children(page)) == 2
  end

  test "get child ids" do
    page = Repo.get(Page, 1)
    assert Page.child_ids(page) == [2, 6]
  end

  test "Check if page has children" do
    page = Repo.get(Page, 1)
    assert Page.children?(page) == true

    page = Repo.get(Page, 4)
    assert Page.children?(page) == false
  end
end
