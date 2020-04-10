defmodule AncestryEcto.Test.RootsTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.{Page, Root, TestRepo}

  describe "w/ default option" do
    test "get all roots elements", %{options: options} do
      assert length(Root.list(options)) == 2
    end

    test "Check if page is root", %{options: options, refs: %{ref1: ref1, ref2: ref2}} do
      page1 = TestRepo.get_by!(Page, reference: ref1)
      assert Root.root?(page1, options)
      page2 = TestRepo.get_by!(Page, reference: ref2)
      refute Root.root?(page2, options)
    end
  end

  describe "w/ custom ancestry column" do
    @describetag custom_options: [column: :custom_ancestry]

    test "get all roots elements", %{options: options} do
      assert length(Root.list(options)) == 2
    end

    test "Check if page is root", %{options: options, refs: %{ref1: ref1, ref2: ref2}} do
      page1 = TestRepo.get_by!(Page, reference: ref1)
      assert Root.root?(page1, options)
      page2 = TestRepo.get_by!(Page, reference: ref2)
      refute Root.root?(page2, options)
    end
  end

  describe "w/ custom ancestry column and custom attribute columtn" do
    @describetag custom_options: [
                   column: :custom_ancestry_custom_attribute,
                   attribute: {:reference, :string}
                 ]

    test "get all roots elements", %{options: options} do
      assert length(Root.list(options)) == 2
    end

    test "Check if page is root", %{options: options, refs: %{ref1: ref1, ref2: ref2}} do
      page1 = TestRepo.get_by!(Page, reference: ref1)
      assert Root.root?(page1, options)
      page2 = TestRepo.get_by!(Page, reference: ref2)
      refute Root.root?(page2, options)
    end
  end
end
