defmodule AncestryEcto.ChangesetTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.Changeset

  describe "w/ default option" do
    test "should populate ancestry column", %{
      options: options,
      pages: %{page1: page1, page5: page5, page3: page3}
    } do
      parent_id = page1.id
      changeset = page5 |> Ecto.Changeset.change()
      assert changeset = Changeset.cast(changeset, %{"parent_id" => parent_id}, options)
      path = "#{parent_id}"
      assert %{ancestry: ^path} = changeset.changes

      parent_id = page3.id
      changeset = page5 |> Ecto.Changeset.change()
      assert changeset = Changeset.cast(changeset, %{"parent_id" => parent_id}, options)
      path = "#{page3.ancestry}/#{parent_id}"
      assert %{ancestry: ^path} = changeset.changes
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "should populate ancestry column", %{
      options: options,
      pages: %{page1: page1, page5: page5, page3: page3}
    } do
      parent_id = page1.id
      changeset = page5 |> Ecto.Changeset.change()
      assert changeset = Changeset.cast(changeset, %{"parent_id" => parent_id}, options)
      path = "#{parent_id}"
      assert %{custom_ancestry: ^path} = changeset.changes

      parent_id = page3.id
      changeset = page5 |> Ecto.Changeset.change()
      assert changeset = Changeset.cast(changeset, %{"parent_id" => parent_id}, options)
      path = "#{page3.custom_ancestry}/#{parent_id}"
      assert %{custom_ancestry: ^path} = changeset.changes
    end
  end

  describe "w/ custom ancestry column and custom attribute columtn" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "should populate ancestry column", %{
      options: options,
      pages: %{page1: page1, page5: page5, page3: page3}
    } do
      parent_reference = page1.reference
      changeset = page5 |> Ecto.Changeset.change()

      assert changeset =
               Changeset.cast(changeset, %{"parent_reference" => parent_reference}, options)

      path = "#{parent_reference}"
      assert %{custom_ancestry_custom_attribute: ^path} = changeset.changes

      parent_reference = page3.reference
      changeset = page5 |> Ecto.Changeset.change()

      assert changeset =
               Changeset.cast(changeset, %{"parent_reference" => parent_reference}, options)

      path = "#{page3.custom_ancestry_custom_attribute}/#{parent_reference}"
      assert %{custom_ancestry_custom_attribute: ^path} = changeset.changes
    end
  end
end
