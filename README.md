# AncestryEcto

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
  use AncestryEcto

  import Ecto.Changeset

  schema "my_models" do
    field(:ancestry, :string)
  end
end

```

### Usage

- repo : running ecto repo (optional, **default: `YourApp.Repo`**)
- column : column where the tree will be persisted (optional, **default `:ancestry`**)
- attribute : column used to reference recors (optional, **default `{:id, :integer}`**)
- schema : (optional, **default current module**)
- orphan_strategy : Instruct Ancestry what to do with children of an element that is destroyed
  - `:destroy`: All children are destroyed as well
  - `:rootify`: The children of the destroyed node become root nodes (**default**)
  - `:restrict`: An AncestryException is raised if any children exist
  - `:adopt`: The orphan subtree is added to the parent of the deleted node, If the deleted node is Root, then rootify the orphan subtree.

For the following setup

```elixir
# Implicit options
# repo: MyApp.Repo
# column: :ancestry
# attribute: {:id, :integer}
# schema: Myapp.Page
# orphan_strategy: :rootify

defmodule MyApp.Page do
  use Ecto.Schema
  use AncestryEcto

  schema "pages" do
    field(:ancestry)
    field(:title)

    timestamps()
  end
end
```

#### Available functions

| method           | return value                                                               | usage example                       |
| ---------------- | -------------------------------------------------------------------------- | ----------------------------------- |
| `roots`          | all root node                                                              | `MyApp.Page.roots`                  |
| `is_root?`       | true if the record is a root node, false otherwise                         | `MyApp.Page.is_root?(record)`       |
| `parent`         | parent of the record, nil for a root node                                  | `MyApp.Page.parent(record)`         |
| `parent_id`      | parent id of the record, nil for a root node                               | `MyApp.Page.parent_id(record)`      |
| `ancestors`      | ancestors of the record, starting with the root and ending with the parent | `MyApp.Page.ancestors(record)`      |
| `ancestor_ids`   | ancestor ids of the record                                                 | `MyApp.Page.ancestor_ids(record)`   |
| `children`       | direct children of the record                                              | `MyApp.Page.children(record)`       |
| `child_ids`      | direct children's ids                                                      | `MyApp.Page.child_ids(record)`      |
| `siblings`       | siblings of the record, the record itself is included\*                    | `MyApp.Page.siblings(record)`       |
| `sibling_ids`    | sibling ids                                                                | `MyApp.Page.sibling_ids(record)`    |
| `descendants`    | direct and indirect children of the record                                 | `MyApp.Page.descendants(record)`    |
| `descendant_ids` | direct and indirect children's ids of the record                           | `MyApp.Page.descendant_ids(record)` |

### Changeset usage

`cast_ancestry/2` allows to cast automatically `"parent_ATTRIBUTE"` param into ancestry.

```elixir
defmodule MyApp.Page do
  use Ecto.Schema
  use AncestryEcto

  schema "pages" do
    field(:ancestry)
    field(:title)

    timestamps()
  end

  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title])
    |> cast_ancestry(attrs)
  end
end
```

ex:

```elixir
# If page id 10 has ancestry "5"
iex> Page.changeset(%{}, %{"title" => "Hello world!", "parent_id" => 10})
%Ecto.Changeset{
  action: nil,
  changes: %{title: "Hello world!", ancestry: "5/10"},
  ...
}
```
