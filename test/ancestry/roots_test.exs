defmodule Ancestry.Test.RootsTest do
  use ExUnit.Case
  doctest Ancestry

  alias Ancestry.TestProject
  alias Ancestry.TestProject.{Page, Repo}

  setup do
    TestProject.Helpers.cleanup
    :ok
  end

  test "get all roots elements" do
    roots = Page.roots
    assert length(roots) == 2
  end

  test "Check if page is root" do
    page = Repo.get(Page, 1)
    page2 = Repo.get(Page, 2)
    assert Page.root?(page) == true
    assert Page.root?(page2) == false
  end
end
