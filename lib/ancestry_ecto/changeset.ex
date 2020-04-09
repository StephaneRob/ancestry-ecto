defmodule AncestryEcto.Changeset do
  import AncestryEcto.Utils

  def cast(changeset, attrs, opts) do
    parent_reference =
      Map.get(
        attrs,
        :"parent_#{attribute_column(opts)}",
        Map.get(attrs, "parent_#{attribute_column(opts)}")
      )

    parent = repo(opts).get_by(module(opts), [{attribute_column(opts), parent_reference}])

    path =
      case Map.get(parent, column(opts)) do
        path when path in ["", nil] ->
          "#{Map.get(parent, attribute_column(opts))}"

        path ->
          "#{path}/#{Map.get(parent, attribute_column(opts))}"
      end

    Ecto.Changeset.change(changeset, [{column(opts), path}])
  end
end
