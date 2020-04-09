defmodule AncestryEcto.Repo do
  @moduledoc false

  alias Ecto.Multi

  import AncestryEcto.Utils
  alias AncestryEcto.{Ancestors, Children, Descendants}

  def delete(model, opts) do
    multi =
      Multi.new()
      |> Multi.delete(:delete, model)
      |> Multi.run(:apply_orphan_strategy, __MODULE__, :apply_orphan_strategy, [
        orphan_strategy(opts),
        opts
      ])

    repo(opts).transaction(multi)
  end

  def apply_orphan_strategy(_repo, %{delete: model}, :restrict, opts) do
    case Children.children?(model, opts) do
      true ->
        raise(AncestryEcto.RestrictError)

      _ ->
        {:ok, nil}
    end
  end

  def apply_orphan_strategy(repo, %{delete: model}, :destroy, opts) do
    Descendants.query(model, opts)
    |> repo.delete_all

    {:ok, nil}
  end

  def apply_orphan_strategy(repo, %{delete: model}, :adopt, opts) do
    updates =
      for descendant <- Descendants.list(model, opts) do
        new_ancestry =
          descendant
          |> Ancestors.ids(opts)
          |> Enum.reject(fn x -> x == model.id end)
          |> Enum.join("/")

        descendant
        |> Ecto.Changeset.change([{column(opts), new_ancestry}])
        |> repo.update
      end

    case Enum.find(updates, fn {k, _} -> k == :error end) do
      nil ->
        {:ok, nil}

      error ->
        error
    end
  end

  def apply_orphan_strategy(repo, %{delete: model}, :rootify, opts) do
    model_ancestry = Children.ancestry(model, opts)

    updates =
      for descendant <- Descendants.list(model, opts) do
        new_ancestry = descendant_ancestry(descendant.ancestry, model_ancestry)

        changeset =
          descendant
          |> Ecto.Changeset.change([{column(opts), new_ancestry}])

        repo.update(changeset)
      end

    case Enum.find(updates, fn {k, _} -> k == :error end) do
      nil ->
        {:ok, nil}

      error ->
        error
    end
  end

  defp descendant_ancestry(ancestry, model_ancestry) when ancestry == model_ancestry, do: ""

  defp descendant_ancestry(ancestry, model_ancestry) do
    ancestry
    |> String.replace(~r/^#{model_ancestry}\//, "")
  end
end
