defmodule Backend.ToDo do
  @moduledoc """
  The ToDo context.
  """

  import Ecto.Query, warn: false

  alias Backend.Repo
  alias Backend.ToDo.Item
  alias Backend.ToDo.List

  @doc """
  Gets a single list.

  Raises `Ecto.NoResultsError` if the List does not exist.

  ## Examples

      iex> get_list!(123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_list!(id), do: Repo.get!(List, id) |> Repo.preload([:items])

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items("123")
      [%Item{}, ...]

  """
  def list_items(list_id) do
    Repo.all(from i in Item, where: i.list_id == ^list_id)
  end

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Marks an item as complete by updating the done attr to `true`.

  ## Examples

      iex> change_item(item)
      {:ok, %Item{done: true}}

  """
  def mark_item_done(%Item{} = item) do
    item
    |> Item.changeset(%{done: true})
    |> Repo.update()
  end
end
