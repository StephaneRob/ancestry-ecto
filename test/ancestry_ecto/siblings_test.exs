defmodule AncestryEcto.SiblingTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.{Page, Sibling}

  describe "w/ default option" do
    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page4: page4, page5: page5}
    } do
      assert Sibling.ids(page4, options) |> Enum.sort() == [page4.id] |> Enum.sort()
      assert Sibling.ids(page1, options) |> Enum.sort() == [page5.id, page1.id] |> Enum.sort()
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page4: page4, page5: page5}
    } do
      page1_id = page1.id
      page4_id = page4.id
      page5_id = page5.id

      assert [%Page{id: ^page4_id}] = Sibling.list(page4, options)

      assert [
               %Page{id: ^page5_id},
               %Page{id: ^page1_id}
             ] = Sibling.list(page1, options) |> Enum.sort(&(&1.id > &2.id))
    end

    test "any?/2", %{
      options: options,
      pages: %{page2: page2, page4: page4}
    } do
      refute Sibling.any?(page4, options)
      assert Sibling.any?(page2, options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page4: page4, page5: page5}
    } do
      assert Sibling.ids(page4, options) |> Enum.sort() == [page4.id] |> Enum.sort()
      assert Sibling.ids(page1, options) |> Enum.sort() == [page5.id, page1.id] |> Enum.sort()
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page4: page4, page5: page5}
    } do
      page1_id = page1.id
      page4_id = page4.id
      page5_id = page5.id

      assert [%Page{id: ^page4_id}] = Sibling.list(page4, options)

      assert [
               %Page{id: ^page5_id},
               %Page{id: ^page1_id}
             ] = Sibling.list(page1, options) |> Enum.sort(&(&1.id > &2.id))
    end
  end

  describe "w/ custom ancestry column and custom attribute column" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page4: page4, page5: page5}
    } do
      assert Sibling.ids(page4, options) |> Enum.sort() == [page4.reference] |> Enum.sort()

      assert Sibling.ids(page1, options) |> Enum.sort() ==
               [page5.reference, page1.reference] |> Enum.sort()
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page4: page4, page5: page5}
    } do
      page1_id = page1.id
      page4_id = page4.id
      page5_id = page5.id

      assert [%Page{id: ^page4_id}] = Sibling.list(page4, options)

      assert [
               %Page{id: ^page5_id},
               %Page{id: ^page1_id}
             ] = Sibling.list(page1, options) |> Enum.sort(&(&1.id > &2.id))
    end
  end
end
