defmodule AncestryEcto.Ancestor do
  @moduledoc false

  import Ecto.Query
  import AncestryEcto.Utils

  def ids(model, opts) do
    model
    |> Map.get(column(opts))
    |> parse_ancestry_column(opts)
  end

  def list(model, opts) do
    case ids(model, opts) do
      [] ->
        []

      ids ->
        query =
          from(u in module(opts),
            where: field(u, ^attribute_column(opts)) in ^ids
          )

        repo(opts).all(query)
    end
  end

  defp parse_ancestry_column("", _), do: []
  defp parse_ancestry_column(nil, _), do: []

  defp parse_ancestry_column(ancestry, opts) do
    ancestry
    |> String.split("/")
    |> Enum.map(fn x -> to_type(x, attribute_type(opts)) end)
  end

  defp to_type(string, :integer), do: String.to_integer(string)
  defp to_type(string, _), do: string
end
