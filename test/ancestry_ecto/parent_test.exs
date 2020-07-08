defmodule AncestryEcto.ParentTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.Parent

  describe "w/ default option" do
    test "id/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page4: page4, page3: page3}
    } do
      refute Parent.id(page1, options)
      assert Parent.id(page6, options) == page1.id
      assert Parent.id(page4, options) == page3.id
    end

    test "get/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page4: page4, page3: page3}
    } do
      refute Parent.get(page1, options)
      assert Parent.get(page6, options) == page1
      assert Parent.get(page4, options) == page3
    end

    test "any?/2", %{
      options: options,
      pages: %{page1: page1, page6: page6}
    } do
      refute Parent.any?(page1, options)
      assert Parent.any?(page6, options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "id/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page4: page4, page3: page3}
    } do
      refute Parent.id(page1, options)
      assert Parent.id(page6, options) == page1.id
      assert Parent.id(page4, options) == page3.id
    end

    # @tag custom_options: [column: :custom_ancestry]
    test "get/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page4: page4, page3: page3}
    } do
      refute Parent.get(page1, options)
      assert Parent.get(page6, options) == page1
      assert Parent.get(page4, options) == page3
    end
  end

  describe "w/ custom ancestry column and custom attribute column" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "id/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page4: page4, page3: page3}
    } do
      refute Parent.id(page1, options)
      assert Parent.id(page6, options) == page1.reference
      assert Parent.id(page4, options) == page3.reference
    end

    test "get/2", %{
      options: options,
      pages: %{page1: page1, page6: page6, page4: page4, page3: page3}
    } do
      refute Parent.get(page1, options)
      assert Parent.get(page6, options) == page1
      assert Parent.get(page4, options) == page3
    end
  end
end
