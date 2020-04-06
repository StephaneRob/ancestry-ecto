defmodule Ancestry do
  @moduledoc """
  Ancestry
  """

  @doc """
  List all roots records
  """
  @callback roots() :: [Ecto.Schema.t()]

  @doc """
  Check if record is root (has no ancestry)
  """
  @callback root?(record :: Ecto.Schema.t()) :: boolean()

  @doc """
  List ancestors ids of the record
  """
  @callback ancestor_ids(record :: Ecto.Schema.t()) :: [String.t() | Integer.t()]

  @doc """
  List ancestors of the record
  """
  @callback ancestors(record :: Ecto.Schema.t()) :: [Ecto.Schema.t()]

  @doc """
  Parent id of the record, nil for a root node
  """
  @callback parent_id(record :: Ecto.Schema.t()) :: nil | String.t() | Integer.t()

  @doc """
  Parent of the record, nil for a root node
  """
  @callback parent(record :: Ecto.Schema.t()) :: nil | Ecto.Schema.t()

  @doc """
  Direct children of the record
  """
  @callback children(record :: Ecto.Schema.t()) :: [Ecto.Schema.t()]

  @doc """
  Direct children ids of the record
  """
  @callback children_ids(record :: Ecto.Schema.t()) :: [String.t() | Integer.t()]

  @doc """
  Check if record has children
  """
  @callback children?(record :: Ecto.Schema.t()) :: boolean()

  @doc """
  Direct and indirect children of the record
  """
  @callback descendants(record :: Ecto.Schema.t()) :: [Ecto.Schema.t()]

  @doc """
  Direct and indirect children ids of the record
  """
  @callback descendant_ids(record :: Ecto.Schema.t()) :: [String.t() | Integer.t()]

  @doc """
  Siblings of the record, the record itself is included
  """
  @callback siblings(record :: Ecto.Schema.t()) :: [Ecto.Schema.t()]

  @doc """
  Sibling ids of the record, the record itself is included
  """
  @callback siblings_ids(record :: Ecto.Schema.t()) :: [String.t() | Integer.t()]

  @doc """
    Delete record and apply strategy to children
  """
  @callback delete(record :: Ecto.Schema.t()) ::
              {:ok, Ecto.Schema.t()} | {:error, Ecto.Schema.t()}

  defmacro __using__(options) do
    quote bind_quoted: [options: options] do
      @module options[:schema] || __MODULE__
      @app options[:app] || [@module |> Module.split() |> List.first()] |> Module.concat()

      @opts [
        module: @module,
        repo: options[:repo] || @app |> Module.concat("Repo"),
        column: options[:column] || :ancestry,
        attribute: options[:attribute] || {:id, :integer},
        orphan_strategy: options[:orphan_strategy] || :rootify
      ]

      alias Ancestry.{Ancestors, Children, Descendants, Parent, Repo, Root, Siblings}

      def roots do
        Root.list(@opts)
      end

      def root?(model) do
        Root.root?(model, @opts)
      end

      def ancestor_ids(model) do
        Ancestors.ids(model, @opts)
      end

      def ancestors(model) do
        Ancestors.list(model, @opts)
      end

      def parent_id(model) do
        Parent.id(model, @opts)
      end

      def parent(model) do
        Parent.get(model, @opts)
      end

      def children(model) do
        Children.list(model, @opts)
      end

      def children_ids(model) do
        Children.ids(model, @opts)
      end

      def children?(model) do
        Children.children?(model, @opts)
      end

      def descendants(model) do
        Descendants.list(model, @opts)
      end

      def descendant_ids(model) do
        Descendants.ids(model, @opts)
      end

      def siblings(model) do
        Siblings.list(model, @opts)
      end

      def siblings_ids(model) do
        Siblings.ids(model, @opts)
      end

      def delete(model) do
        Repo.delete(model, @opts)
      end
    end
  end
end
