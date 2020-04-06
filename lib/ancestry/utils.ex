defmodule Ancestry.Utils do
  @moduledoc false

  [:module, :repo, :column, :attribute, :orphan_strategy]
  |> Enum.map(fn opt ->
    def unquote(opt)(opts) do
      Keyword.get(opts, unquote(opt))
    end
  end)

  def attribute_type(opts) do
    {_, type} = attribute(opts)
    type
  end

  def attribute_column(opts) do
    {column, _} = attribute(opts)
    column
  end
end
