defmodule AncestryEcto.Sibling do
  @moduledoc false

  import Ecto.Query
  import AncestryEcto.Utils

  def list(model, opts) do
    query(model, opts)
    |> repo(opts).all
  end

  def ids(model, opts) do
    for sibling <- list(model, opts), do: Map.get(sibling, attribute_column(opts))
  end

  def siblings?(model, opts) do
    list(model, opts) |> Enum.any?()
  end

  defp query(model, opts) do
    case Map.get(model, column(opts)) do
      nil ->
        from(u in module(opts),
          where: is_nil(field(u, ^column(opts)))
        )

      value ->
        from(u in module(opts),
          where: field(u, ^column(opts)) == ^value
        )
    end
  end
end
