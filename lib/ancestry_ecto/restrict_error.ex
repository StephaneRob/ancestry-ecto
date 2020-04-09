defmodule AncestryEcto.RestrictError do
  defexception message: "Cannot delete record because it has descendants."
end
