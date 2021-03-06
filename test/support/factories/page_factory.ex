defmodule AncestryEcto.PageFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      def page_factory do
        %AncestryEcto.Page{
          reference: Ecto.UUID.generate()
        }
      end
    end
  end
end
