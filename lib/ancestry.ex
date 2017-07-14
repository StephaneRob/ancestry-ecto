defmodule Ancestry do
  defmacro __using__(options) do
    quote do

      import Ecto
      import Ecto.Query

      alias Ecto.Multi

      options = unquote(options)
      @model options[:model] || __MODULE__
      @app options[:app] || [@model |> Module.split |> List.first] |> Module.concat
      @repo options[:repo] || @app |> Module.concat("Repo")
      @orphan_stategy options[:orphan_strategy] || :destroy


      def delete(model) do
        multi =
          Multi.new
          |> Multi.delete(:delete_model, model)
          |> Multi.run(:orphan, __MODULE__, :apply_orphan_strategy, [])
        @repo.transaction(multi)
      end

      # ---- Callbacks
      def apply_orphan_strategy(_, model) do
        if model.id do
          case @orphan_stategy do
           :rootify ->
             rootify_children(model)
           :destroy ->
             destroy_children(model)
           :adopt ->
             adopt_children(model)
          end
        end
         {:ok, model}
      end

      defp rootify_children(model) do
      end

      defp destroy_children(model) do
      end

      defp adopt_children(model) do
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
        |> Ecto.Changeset.change(ancestry: child_ancestry(parent))
      end
      def set_parent!(model, parent) do
        set_parent(model, parent)
        |> @repo.update
      end

      # ---- Children
      def children(model) do
        query = from u in @model,
          where: u.ancestry == ^child_ancestry(model),
          order_by: u.inserted_at
        @repo.all(query)
      end

      def child_ids(model) do
        for child <- children(model), do: Map.get(child, :id)
      end

      def children?(model) do
        (children(model)|> length) > 0
      end

      # ---- Siblings
      def siblings(model) do
        query = from u in @model,
          where: u.ancestry == ^"#{model.ancestry}",
          order_by: u.inserted_at
        @repo.all(query)
      end

      def sibling_ids(model) do
        for sibling <- siblings(model), do: Map.get(sibling, :id)
      end

      def siblings?(model) do
        (siblings(model) |> length) > 0
      end

      # ---- Descendants
      def descendants_ids(model) do
        query_string = case root?(model) do
          true -> "#{model.id}"
          false -> "#{model.ancestry}/#{model.id}"
        end
        query = from u in @model,
          where: like(u.ancestry, ^"#{query_string}/%"),
          order_by: u.inserted_at
        @repo.all(query)
      end

      def descendants(model) do
        ids = descendants_ids(model)
        case descendants_ids(model) do
          nil -> nil
          desce ->
            query = from u in @model,
              where: u.id in ^ids,
              order_by: u.inserted_at
            @repo.all(query)
        end
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
