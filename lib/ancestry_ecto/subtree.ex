defmodule AncestryEcto.Subtree do
  @moduledoc false

  import AncestryEcto.Utils

  alias AncestryEcto.{Children, Descendant}

  def list(model, options, opts) do
    case Keyword.get(options, :arrange) do
      nil ->
        flat_list(model, opts)

      _ ->
        arranged_list(model, opts)
    end
  end

  defp arranged_list(model, opts) do
    case Children.any?(model, opts) do
      true ->
        %{model => build_children(model, opts)}

      false ->
        %{model => %{}}
    end
  end

  defp flat_list(model, opts) do
    [model | Descendant.list(model, opts)]
  end

  def ids(model, opts) do
    for child <- flat_list(model, opts), do: Map.get(child, attribute_column(opts))
  end

  defp build_children(model, opts) do
    model
    |> Children.list(opts)
    |> Enum.into(%{}, fn child ->
      case Children.any?(child, opts) do
        true ->
          {child, build_children(child, opts)}

        false ->
          {child, %{}}
      end
    end)
  end
end
