# Ancestry

![](https://github.com/StephaneRob/ancestry-ecto/workflows/tests/badge.svg)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ancestry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ancestry_ecto, "~> 0.1.0"}]
end
```

Create a migration to add an `ancestry` column. Can be configured with `column` option.

```bash
mix ecto.gen.migration add_ancestry_to_pages
```

Add index to migration

```elixir
defmodule Migration do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :ancestry, :string
    end

    create index(:pages, [:ancestry])
  end
end
```

```bash
mix ecto.migrate
```

Start using ancestry in your schema:

```elixir
defmodule MyModel do
  use Ecto.Schema
  use Ancestry

  import Ecto.Changeset

  schema "my_models" do
    field(:ancestry, :string)
  end
end

```

### Available options

```elixir

use Ancestry,
  repo: MyApp.Repo,
  column: :ancestry,

  model: Myapp.Page,
  orphan_strategy: :rootify
```

- repo : running ecto repo (optional, **default: `YourApp.Repo`**)
- column : column where the tree will be persisted (optional, **default `:ancestry`**)
- attribute : column used to reference recors (optional, **default `{:id, :integer}`**)
- schema : (optional, **default current module**)
- orphan_strategy : Instruct Ancestry what to do with children of an element that is destroyed
  - `:destroy`: All children are destroyed as well
  - `:rootify`: The children of the destroyed node become root nodes (**default**)
  - `:restrict`: An AncestryException is raised if any children exist
  - `:adopt`: The orphan subtree is added to the parent of the deleted node, If the deleted node is Root, then rootify the orphan subtree.

### Usage

```elixir
MyModel.roots
MyModel.root?(model)
MyModel.ancestor_ids(model)
MyModel.ancestors(model)
MyModel.parent_id(model)
MyModel.parent(model)
MyModel.children(model)
MyModel.child_ids(model)
MyModel.siblings(model)
MyModel.sibling_ids(model)
MyModel.descendants_ids(model)
MyModel.descendants(model)
```
