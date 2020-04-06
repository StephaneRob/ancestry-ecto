defmodule Ancestry.Parent do
  @moduledoc false

  import Ancestry.Utils

  alias Ancestry.Ancestors

  def id(model, opts) do
    case Ancestors.ids(model, opts) do
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
end
