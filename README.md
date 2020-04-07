# Ancestry

![](https://github.com/StephaneRob/ancestry-ecto/workflows/tests/badge.svg)

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
    alter table(:my_models) do
      add :ancestry, :string
    end
    create index(:my_models, [:ancestry])
  end
end
```

```bash
mix ecto.migrate
```

Add `use Ancestry` to your model ex:

```elixir
defmodule MyModel do
  use Ecto.Schema
  use Ancestry

  import Ecto.Changeset

  schema "my_models" do
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

### Roadmap

- [ ] roots
- [ ] ancestors
- [ ] children
- [ ] descendants
- [ ] siblings
- [ ] tests
- [ ] orphan strategies
  - [ ] rootify
  - [ ] destroy
  - [ ] adopt
  - [ ] restrict

## License

This package is available as open source under the terms of the [MIT License](LICENSE.md).
