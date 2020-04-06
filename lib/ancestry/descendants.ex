defmodule Ancestry.Descendants do
  @moduledoc false

  import Ecto.Query
  import Ancestry.Utils

  alias Ancestry.Children

  def list(model, opts) do
    query(model, opts)
    |> repo(opts).all
  end

  def ids(model, opts) do
    for child <- list(model, opts), do: Map.get(child, attribute_column(opts))
  end

  def children?(model, opts) do
    list(model, opts) |> Enum.any?()
  end

  def query(model, opts) do
    from(u in module(opts),
      where:
        field(u, ^column(opts)) == ^Children.ancestry(model, opts) or
          like(field(u, ^column(opts)), ^"#{Children.ancestry(model, opts)}/%")
    )
  end
end
