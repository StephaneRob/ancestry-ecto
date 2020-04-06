defmodule Ancestry.DescendantsTest do
  use Ancestry.Case

  alias Ancestry.{Page, Descendants}

  describe "w/ default option" do
    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert Descendants.ids(page4, options) == []
      assert Descendants.ids(page1, options) == [page2.id, page3.id, page4.id, page6.id]
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      page2_id = page2.id
      page3_id = page3.id
      page4_id = page4.id
      page6_id = page6.id

      assert [] = Descendants.list(page4, options)

      assert [
               %Page{id: ^page2_id},
               %Page{id: ^page3_id},
               %Page{id: ^page4_id},
               %Page{id: ^page6_id}
             ] = Descendants.list(page1, options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert Descendants.ids(page4, options) == []
      assert Descendants.ids(page1, options) == [page2.id, page3.id, page4.id, page6.id]
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      page2_id = page2.id
      page3_id = page3.id
      page4_id = page4.id
      page6_id = page6.id

      assert [] = Descendants.list(page4, options)

      assert [
               %Page{id: ^page2_id},
               %Page{id: ^page3_id},
               %Page{id: ^page4_id},
               %Page{id: ^page6_id}
             ] = Descendants.list(page1, options)
    end
  end

  describe "w/ custom ancestry column and custom attribute column" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert Descendants.ids(page4, options) == []

      assert Descendants.ids(page1, options) == [
               page2.reference,
               page3.reference,
               page4.reference,
               page6.reference
             ]
    end

    test "list/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      page2_id = page2.id
      page3_id = page3.id
      page4_id = page4.id
      page6_id = page6.id

      assert [] = Descendants.list(page4, options)

      assert [
               %Page{id: ^page2_id},
               %Page{id: ^page3_id},
               %Page{id: ^page4_id},
               %Page{id: ^page6_id}
             ] = Descendants.list(page1, options)
    end
  end
end
