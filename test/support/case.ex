defmodule AncestryEcto.Case do
  @moduledoc false

  use ExUnit.CaseTemplate
  alias AncestryEcto.{Factory, Page, TestRepo}

  @options [
    module: Page,
    repo: TestRepo,
    column: :ancestry,
    attribute: {:id, :integer},
    orphan_strategy: :rootify
  ]

  @ref1 Ecto.UUID.generate()
  @ref2 Ecto.UUID.generate()
  @ref3 Ecto.UUID.generate()
  @ref4 Ecto.UUID.generate()
  @ref5 Ecto.UUID.generate()
  @ref6 Ecto.UUID.generate()

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

    page1 = Factory.insert(:page, reference: @ref1)

    page2 =
      Factory.insert(:page,
        reference: @ref2,
        ancestry: "#{page1.id}",
        custom_ancestry: "#{page1.id}",
        custom_ancestry_custom_attribute: "#{page1.reference}"
      )

    page3 =
      Factory.insert(:page,
        reference: @ref3,
        ancestry: "#{page1.id}/#{page2.id}",
        custom_ancestry: "#{page1.id}/#{page2.id}",
        custom_ancestry_custom_attribute: "#{page1.reference}/#{page2.reference}"
      )

    page4 =
      Factory.insert(:page,
        reference: @ref4,
        ancestry: "#{page1.id}/#{page2.id}/#{page3.id}",
        custom_ancestry: "#{page1.id}/#{page2.id}/#{page3.id}",
        custom_ancestry_custom_attribute:
          "#{page1.reference}/#{page2.reference}/#{page3.reference}"
      )

    page5 = Factory.insert(:page, reference: @ref5)

    page6 =
      Factory.insert(:page,
        reference: @ref6,
        ancestry: "#{page1.id}",
        custom_ancestry: "#{page1.id}",
        custom_ancestry_custom_attribute: "#{page1.reference}"
      )

    {:ok,
     options: @options |> Keyword.merge(tags[:custom_options] || []),
     pages: %{
       page1: page1,
       page2: page2,
       page3: page3,
       page4: page4,
       page5: page5,
       page6: page6
     },
     refs: %{
       ref1: @ref1,
       ref2: @ref2,
       ref3: @ref3,
       ref4: @ref4,
       ref5: @ref5,
       ref6: @ref6
     }}
  end
end
