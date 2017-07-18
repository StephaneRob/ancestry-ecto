# Ancestry

_WIP_

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ancestry` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ancestry, "~> 0.1.0"}]
end
```

Add an `ancestry` string field in your model

```bash
mix ecto.gen.migration add_ancestry_to_<model>
```

Add index to migration

```elixir
defmodule Migration do
  use Ecto.Migration

  def change do
    alter table(:[table]) do
      add :ancestry, :string
    end
    create index(:<model>, [:ancestry])
  end
end
```

```bash
mix ecto.migrate
```

Add `use Ancestry` to your model ex:

```elixir
defmodule Page do
  use Ecto.Schema
  use Ancestry

  import Ecto.Changeset

  schema "pages" do
    field :ancestry, :string
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:ancestry])
  end
end

```

### Options

```elixir
use Ancestry,
  repo: MyApp.Repo,
  model: Myapp.Page,
  orphan_strategy: :rootify
```

- repo
- model
- orphan_strategy : Instruct Ancestry what to do with children of an element that is destroyed
  - `:destroy`: All children are destroyed as well (default)
  - `:rootify`: The children of the destroyed node become root nodes
  - `:restrict`: An AncestryException is raised if any children exist
  - `:adopt`: The orphan subtree is added to the parent of the deleted node, If the deleted node is Root, then rootify the orphan subtree.

### Usage

```elixir
MyModule.MyModel.roots
MyModule.MyModel.root?(model)
MyModule.MyModel.ancestor_ids(model)
MyModule.MyModel.ancestors(model)
MyModule.MyModel.parent_id(model)
MyModule.MyModel.parent(model)
MyModule.MyModel.children(model)
MyModule.MyModel.child_ids(model)
MyModule.MyModel.siblings(model)
MyModule.MyModel.sibling_ids(model)
MyModule.MyModel.descendants_ids(model)
MyModule.MyModel.descendants(model)
```

### TODO

- [ ] roots
- [ ] ancestors
- [ ] children
- [ ] descendants
- [ ] siblings
- [ ] tests

## License

This package is available as open source under the terms of the [MIT License](LICENSE.md).
