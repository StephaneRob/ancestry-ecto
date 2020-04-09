defmodule AncestryEcto.ChildrenTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.{Children, Page}

  describe "w/ default option" do
    test "list children ids", %{
      options: options,
      pages: %{page1: page1, page6: page6, page2: page2}
    } do
      assert Children.ids(page1, options) == [page6.id, page2.id]
    end

    test "list children", %{
      options: options,
      pages: %{page1: page1, page6: page6, page2: page2}
    } do
      page6_id = page6.id
      page2_id = page2.id
      assert [%Page{id: ^page6_id}, %Page{id: ^page2_id}] = Children.list(page1, options)
    end

    test "children?/2", %{
      options: options,
      pages: %{page1: page1, page6: page6}
    } do
      assert Children.children?(page1, options)
      refute Children.children?(page6, options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]
    test "list children ids", %{
      options: options,
      pages: %{page1: page1, page6: page6, page2: page2}
    } do
      assert Children.ids(page1, options) |> Enum.sort() == [page2.id, page6.id]
    end

    test "list children", %{
      options: options,
      pages: %{page1: page1, page6: page6, page2: page2}
    } do
      page6_id = page6.id
      page2_id = page2.id

      assert [%Page{id: ^page2_id}, %Page{id: ^page6_id}] =
               Children.list(page1, options) |> Enum.sort(&(&1.id < &2.id))
    end

    test "children?/2", %{
      options: options,
      pages: %{page1: page1, page6: page6}
    } do
      assert Children.children?(page1, options)
      refute Children.children?(page6, options)
    end
  end

  describe "w/ custom ancestry column and custom attribute columtn" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page2: page2}
    } do
      assert Children.ids(page1, options) |> Enum.sort(&(&1 < &2)) ==
               [page2.reference, page6.reference] |> Enum.sort(&(&1 < &2))
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page2: page2}
    } do
      page6_id = page6.id
      page2_id = page2.id

      assert [%Page{id: ^page2_id}, %Page{id: ^page6_id}] =
               Children.list(page1, options) |> Enum.sort(&(&1.id < &2.id))
    end

    test "children?/2", %{
      options: options,
      pages: %{page1: page1, page6: page6}
    } do
      assert Children.children?(page1, options)
      refute Children.children?(page6, options)
    end
  end
end
