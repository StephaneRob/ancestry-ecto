defmodule Ancestry.Root do
  @moduledoc false

  import Ecto.Query

  import Ancestry.Utils

  def list(opts) do
    query =
      from(e in module(opts),
        where: field(e, ^column(opts)) == "" or is_nil(field(e, ^column(opts))),
        order_by: e.inserted_at
      )

    repo(opts).all(query)
  end

  def root?(model, opts) do
    case Map.get(model, column(opts)) do
      value when value in ["", nil] -> true
      _ -> false
    end
  end
end
