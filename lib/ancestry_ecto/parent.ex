defmodule AncestryEcto.Parent do
  @moduledoc false

  import AncestryEcto.Utils

  alias AncestryEcto.Ancestor

  def id(model, opts) do
    case Ancestor.ids(model, opts) do
      [] ->
        nil

      ids ->
        ids
        |> List.last()
    end
  end

  def get(model, opts) do
    case id(model, opts) do
      nil ->
        nil

      id ->
        repo(opts).get_by!(module(opts), [{attribute_column(opts), id}])
    end
  end

  def any?(model, opts) do
    case id(model, opts) do
      nil -> false
      _ -> true
    end
  end
end
