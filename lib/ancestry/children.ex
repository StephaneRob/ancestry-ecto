defmodule Ancestry.Children do
  @moduledoc false

  import Ecto.Query
  import Ancestry.Utils

  alias Ancestry.Root

  def list(model, opts) do
    query(model, opts)
    |> repo(opts).all()
  end

  def ids(model, opts) do
    for child <- list(model, opts) do
      Map.get(child, attribute_column(opts))
    end
  end

  def children?(model, opts) do
    list(model, opts) |> Enum.any?()
  end

  def query(model, opts) do
    from(u in module(opts),
      where: field(u, ^column(opts)) == ^ancestry(model, opts)
    )
  end

  def ancestry(model, opts) do
    reference = Map.get(model, attribute_column(opts))

    case Root.root?(model, opts) do
      true -> "#{reference}"
      false -> "#{Map.get(model, column(opts))}/#{reference}"
    end
  end
end
