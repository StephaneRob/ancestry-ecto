defmodule AncestryEcto.AncestorTest do
  use AncestryEcto.Case

  alias AncestryEcto.{Page, Ancestors}

  describe "w/ default option" do
    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3}
    } do
      assert Ancestors.ids(page4, options) == [page1.id, page2.id, page3.id]
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3}
    } do
      page1_id = page1.id
      page2_id = page2.id
      page3_id = page3.id

      assert [%Page{id: ^page1_id}, %Page{id: ^page2_id}, %Page{id: ^page3_id}] =
               Ancestors.list(page4, options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3}
    } do
      assert Ancestors.ids(page4, options) == [page1.id, page2.id, page3.id]
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3}
    } do
      page1_id = page1.id
      page2_id = page2.id
      page3_id = page3.id

      assert [%Page{id: ^page1_id}, %Page{id: ^page2_id}, %Page{id: ^page3_id}] =
               Ancestors.list(page4, options)
    end
  end

  describe "w/ custom ancestry column and custom attribute column" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3}
    } do
      assert Ancestors.ids(page4, options) == [page1.reference, page2.reference, page3.reference]
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3}
    } do
      page1_id = page1.id
      page2_id = page2.id
      page3_id = page3.id

      assert [%Page{id: ^page1_id}, %Page{id: ^page2_id}, %Page{id: ^page3_id}] =
               Ancestors.list(page4, options)
    end
  end
end
