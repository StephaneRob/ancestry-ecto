defmodule AncestryEcto.SubtreeTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.{Page, Subtree}

  describe "w/ default option" do
    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert Subtree.ids(page4, options) == [page4.id]
      assert Subtree.ids(page1, options) == [page1.id, page2.id, page3.id, page4.id, page6.id]
    end

    test "list/3", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      page1_id = page1.id
      page2_id = page2.id
      page3_id = page3.id
      page4_id = page4.id
      page6_id = page6.id

      assert [%Page{id: ^page4_id}] = Subtree.list(page4, [], options)

      assert [
               %Page{id: ^page1_id},
               %Page{id: ^page2_id},
               %Page{id: ^page3_id},
               %Page{id: ^page4_id},
               %Page{id: ^page6_id}
             ] = Subtree.list(page1, [], options)
    end

    test "list/2 w/ arrange true", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert match?(
               %{
                 ^page3 => %{
                   ^page4 => %{}
                 }
               },
               Subtree.list(page3, [arrange: true], options)
             )

      assert %{
               ^page1 => %{
                 ^page2 => %{
                   ^page3 => %{
                     ^page4 => %{}
                   }
                 },
                 ^page6 => %{}
               }
             } = Subtree.list(page1, [arrange: true], options)

      assert %{
               ^page4 => %{}
             } = Subtree.list(page4, [arrange: true], options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "ids/2", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert Subtree.ids(page4, options) == [page4.id]
      assert Subtree.ids(page1, options) == [page1.id, page2.id, page3.id, page4.id, page6.id]
    end

    test "list/3", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      page1_id = page1.id
      page2_id = page2.id
      page3_id = page3.id
      page4_id = page4.id
      page6_id = page6.id

      assert [
               %Page{id: ^page4_id}
             ] = Subtree.list(page4, [], options)

      assert [
               %Page{id: ^page1_id},
               %Page{id: ^page2_id},
               %Page{id: ^page3_id},
               %Page{id: ^page4_id},
               %Page{id: ^page6_id}
             ] = Subtree.list(page1, [], options)
    end

    test "list/2 w/ arrange true", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert match?(
               %{
                 ^page3 => %{
                   ^page4 => %{}
                 }
               },
               Subtree.list(page3, [arrange: true], options)
             )

      assert %{
               ^page1 => %{
                 ^page2 => %{
                   ^page3 => %{
                     ^page4 => %{}
                   }
                 },
                 ^page6 => %{}
               }
             } = Subtree.list(page1, [arrange: true], options)
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
      assert Subtree.ids(page4, options) == [page4.reference]

      assert Subtree.ids(page1, options) == [
               page1.reference,
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
      page1_id = page1.id
      page2_id = page2.id
      page3_id = page3.id
      page4_id = page4.id
      page6_id = page6.id

      assert [
               %Page{id: ^page4_id}
             ] = Subtree.list(page4, [], options)

      assert [
               %Page{id: ^page1_id},
               %Page{id: ^page2_id},
               %Page{id: ^page3_id},
               %Page{id: ^page4_id},
               %Page{id: ^page6_id}
             ] = Subtree.list(page1, [], options)
    end

    test "list/2 w/ arrange true", %{
      options: options,
      pages: %{page1: page1, page2: page2, page4: page4, page3: page3, page6: page6}
    } do
      assert match?(
               %{
                 ^page3 => %{
                   ^page4 => %{}
                 }
               },
               Subtree.list(page3, [arrange: true], options)
             )

      assert %{
               ^page1 => %{
                 ^page2 => %{
                   ^page3 => %{
                     ^page4 => %{}
                   }
                 },
                 ^page6 => %{}
               }
             } = Subtree.list(page1, [arrange: true], options)
    end
  end
end
