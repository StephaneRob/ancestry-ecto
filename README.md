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

### Usage
Add an `ancestry` string field in your model

```bash
mix ecto.gen.migration add_ancestry_to_<model>
```

Add index to migration

```elixir
defmodule Migration do
  use Ecto.Migration

  def change do
    create table(:<model>) do
      add :ancestry, :string

      timestamps()
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

### TODO

- [ ] roots
- [ ] ancestors
- [ ] children
- [ ] descendants
- [ ] siblings
- [ ] tests

## License

This package is available as open source under the terms of the [MIT License](LICENSE.md).
