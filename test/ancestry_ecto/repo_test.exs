defmodule AncestryEcto.RepoTest do
  use AncestryEcto.Case, async: true

  alias AncestryEcto.{Page, TestRepo, Repo}

  describe "delete/2" do
    test "with rootify", %{
      options: options,
      pages: %{page1: page1, page2: page2, page3: page3, page4: page4, page6: page6}
    } do
      assert Repo.delete(page1, options)
      assert page2 = TestRepo.get(Page, page2.id)
      assert page2.ancestry == ""

      assert page3 = TestRepo.get(Page, page3.id)
      assert page3.ancestry == "#{page2.id}"

      assert page4 = TestRepo.get(Page, page4.id)
      assert page4.ancestry == "#{page2.id}/#{page3.id}"

      assert page6 = TestRepo.get(Page, page6.id)
      assert page6.ancestry == ""
    end

    @tag custom_options: [orphan_strategy: :destroy]
    test "w/ destroy", %{
      options: options,
      pages: %{page1: page1, page2: page2, page3: page3, page4: page4, page6: page6}
    } do
      assert Repo.delete(page1, options)
      refute TestRepo.get(Page, page2.id)
      refute TestRepo.get(Page, page3.id)
      refute TestRepo.get(Page, page4.id)
      refute TestRepo.get(Page, page6.id)
    end

    @tag custom_options: [orphan_strategy: :adopt]
    test "w/ adopt", %{
      options: options,
      pages: %{page1: page1, page2: page2, page3: page3, page4: page4, page6: page6}
    } do
      assert Repo.delete(page1, options)
      assert page2 = TestRepo.get(Page, page2.id)
      assert page2.ancestry == ""

      assert page3 = TestRepo.get(Page, page3.id)
      assert page3.ancestry == "#{page2.id}"

      assert page4 = TestRepo.get(Page, page4.id)
      assert page4.ancestry == "#{page2.id}/#{page3.id}"

      assert page6 = TestRepo.get(Page, page6.id)
      assert page6.ancestry == ""
    end

    @tag custom_options: [orphan_strategy: :adopt]
    test "w/ adopt bis", %{
      options: options,
      pages: %{page1: page1, page2: page2, page3: page3, page4: page4}
    } do
      assert Repo.delete(page2, options)
      refute TestRepo.get(Page, page2.id)

      assert page3 = TestRepo.get(Page, page3.id)
      assert page3.ancestry == "#{page1.id}"

      assert page4 = TestRepo.get(Page, page4.id)
      assert page4.ancestry == "#{page1.id}/#{page3.id}"
    end

    @tag custom_options: [orphan_strategy: :restrict]
    test "w/ restrict", %{
      options: options,
      pages: %{page2: page2}
    } do
      assert_raise AncestryEcto.RestrictError,
                   "Cannot delete record because it has descendants.",
                   fn ->
                     assert Repo.delete(page2, options)
                   end
    end
  end
end
