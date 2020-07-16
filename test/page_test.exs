defmodule AncestryEcto.PageTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.Page

  test "Page should have functions" do
    functions = Page.__info__(:functions)

    assert {:ancestor_ids, 1} in functions
    assert {:ancestors, 1} in functions
    assert {:cast_ancestry, 2} in functions
    assert {:child_ids, 1} in functions
    assert {:children, 1} in functions
    assert {:children?, 1} in functions
    assert {:delete, 1} in functions
    assert {:descendant_ids, 1} in functions
    assert {:descendants, 1} in functions
    assert {:has_parent?, 1} in functions
    assert {:has_siblings?, 1} in functions
    assert {:parent, 1} in functions
    assert {:parent_id, 1} in functions
    assert {:root?, 1} in functions
    assert {:roots, 0} in functions
    assert {:sibling_ids, 1} in functions
    assert {:siblings, 1} in functions
    assert {:subtree, 1} in functions
    assert {:subtree, 2} in functions
    assert {:subtree_ids, 1} in functions
  end

  test "root?/1", %{pages: %{page1: page1}} do
    assert Page.root?(page1)
  end

  test "roots/0", %{pages: %{page1: page1, page5: page5}} do
    assert pages = Page.roots()
    assert length(pages) == 2
    assert page1 in pages
    assert page5 in pages
  end
end
