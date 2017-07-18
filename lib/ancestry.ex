defmodule Ancestry do
  defmacro __using__(options) do
    quote do

      import Ecto
      import Ecto.Query

      alias Ecto.{Multi, Changeset}

      options = unquote(options)
      @model options[:model] || __MODULE__
      @app options[:app] || [@model |> Module.split |> List.first] |> Module.concat
      @repo options[:repo] || @app |> Module.concat("Repo")
      @orphan_stategy options[:orphan_strategy] || :rootify

      # ---- Delete a model and apply_orphan_strategy
      def delete(model) do
        multi =
          Multi.new
          |> Multi.delete(:delete_model, model)
          |> Multi.run(:orphan, __MODULE__, :apply_orphan_strategy, [])
        @repo.transaction(multi)
      end

      # ---- Callbacks
      def apply_orphan_strategy(%{delete_model: model}) do
        if model.id do
          case @orphan_stategy do
            :rootify ->
              rootify_children(model)
            :destroy ->
              destroy_children(model)
            :adopt ->
              adopt_children(model)
            :restrict ->
              restrict_children(model)
          end
        end
         {:ok, model}
      end

      defp rootify_children(model) do
        child_ancestry = child_ancestry(model)
        for descendant <- descendants(model) do
          new_ancestry = case descendant.ancestry do
             ^child_ancestry -> nil
             _ ->
               descendant.ancestry
               |> String.replace(~r/^#{child_ancestry}\//, "")
          end
          descendant
          |> Changeset.change(ancestry: new_ancestry)
          |> @repo.update
        end
      end

      defp destroy_children(model) do
        descendants_query(model)
        |> @repo.delete_all
      end

      defp adopt_children(model) do
        for descendant <- descendants(model) do
          new_ancestry = ancestor_ids(descendant)
            |> Enum.reject(fn(x) -> x == model.id end)
            |> Enum.join("/")
          new_ancestry = case new_ancestry do
            "" -> nil
            _ -> new_ancestry
          end
          descendant
          |> Changeset.change(ancestry: new_ancestry)
          |> @repo.update
        end
      end

      def restrict_children(model) do
        if children?(model), do: raise Ancestry.RestrictError
      end

      def update_descendants_with_new_ancestry(model) do
        for descendant <- descendants(model) do
          ancestry = descendant.ancestry
            |> String.replace(~r/^#{child_ancestry(model)}/, "")
          descendant
          |> Changeset.change(:ancestry, ancestry)
        end
      end

      # ---- Root
      def roots do
        query = from u in @model,
          where: is_nil(u.ancestry) or u.ancestry == "",
          order_by: u.inserted_at
        @repo.all(query)
      end

      def root?(model) do
        case model.ancestry do
          "" -> true
          nil -> true
          _ -> false
        end
      end

      # ---- Ancestors
      def ancestor_ids(model) do
        model.ancestry
        |> parse_ancestry_column
      end

      def ancestors(model) do
        ids = ancestor_ids(model)
        case ancestor_ids(model) do
          nil -> nil
          ancestors ->
            query = from u in @model,
              where: u.id in ^ids,
              order_by: u.inserted_at
            @repo.all(query)
        end
      end

      # ---- Parent
      def parent_id(model) do
        case ancestor_ids(model) do
          nil -> nil
          ancestors ->
             ancestors
             |> List.last
        end
      end

      def parent(model) do
        case parent_id(model) do
          nil -> nil
          id ->
            @repo.get!(@model, id)
        end
      end

      def set_parent(model, parent) do
        model
        |> Changeset.change(ancestry: child_ancestry(parent))
      end

      def set_parent!(model, parent) do
        set_parent(model, parent)
        |> @repo.update
      end

      # ---- Children
      def children_query(model) do
        query = from u in @model,
          where: u.ancestry == ^child_ancestry(model),
          order_by: u.inserted_at
      end

      def children(model) do
        children_query(model)
        |> @repo.all
      end

      def child_ids(model) do
        for child <- children(model), do: Map.get(child, :id)
      end

      def children?(model) do
        (children(model)|> length) > 0
      end

      # ---- Siblings
      def siblings_query(model) do
        query = from u in @model,
          where: u.ancestry == ^"#{model.ancestry}",
          order_by: u.inserted_at
      end

      def siblings(model) do
        siblings_query(model)
        |> @repo.all
      end

      def sibling_ids(model) do
        for sibling <- siblings(model), do: Map.get(sibling, :id)
      end

      def siblings?(model) do
        (siblings(model) |> length) > 0
      end

      # ---- Descendants
      def descendants_query(model) do
        query_string = case root?(model) do
          true -> "#{model.id}"
          false -> "#{model.ancestry}/#{model.id}"
        end
        query = from u in @model,
          where: like(u.ancestry, ^"#{query_string}%")
      end

      def descendants(model) do
        query = from u in descendants_query(model),
          order_by: u.inserted_at
        @repo.all(query)
      end

      def descendant_ids(model) do
        for descendant <- descendants(model), do: Map.get(descendant, :id)
      end

      defp child_ancestry(model) do
        case root?(model) do
          true -> "#{model.id}"
          false -> "#{model.ancestry}/#{model.id}"
        end
      end

      defp parse_ancestry_column(nil), do: nil
      defp parse_ancestry_column(ancestry) do
        ancestry
        |> String.split("/")
        |> Enum.map(fn(x) -> String.to_integer(x) end)
      end

    end
  end
end
