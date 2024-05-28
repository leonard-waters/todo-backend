defmodule Backend.ToDoTest do
  use Backend.DataCase

  import Backend.Factory

  alias Backend.ToDo

  describe "lists" do
    alias Backend.ToDo.List

    @invalid_attrs %{name: nil}

    test "get_list!/1 returns the list with given id" do
      list = insert(:list, items: [])
      assert ToDo.get_list!(list.id) == list
    end

    test "get_list!/1 returns the list with expected item ids" do
      list = insert(:list, %{name: "Some list"})
      items = insert_list(3, :item, %{body: "Some body", done: false, list: list})
      item_ids = Enum.map(items, & &1.id)

      assert %List{items: actual_items} = ToDo.get_list!(list.id)

      Enum.each(actual_items, fn item ->
        assert item.list_id == list.id
        assert item.id in item_ids
      end)
    end

    test "create_list/1 with valid data creates a list" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %List{} = list} = ToDo.create_list(valid_attrs)
      assert list.name == "some name"
    end

    test "create_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ToDo.create_list(@invalid_attrs)
    end
  end

  describe "items" do
    alias Backend.ToDo.Item

    @invalid_attrs %{done: nil, body: nil, list_id: nil}

    test "create_item/1 with valid data creates a item" do
      %{id: list_id} = insert(:list)
      valid_attrs = %{done: false, body: "some body", list_id: list_id}

      assert {:ok, %Item{} = item} = ToDo.create_item(valid_attrs)
      assert item.done == false
      assert item.body == "some body"
      assert item.list_id == list_id
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ToDo.create_item(@invalid_attrs)
    end

    test "mark_item_done/1 with valid data updates the item" do
      %{id: list_id} = list = insert(:list)
      valid_attrs = %{done: false, body: "some body", list: list}
      item = insert(:item, valid_attrs)

      assert {:ok, %Item{} = item} = ToDo.mark_item_done(item)
      assert item.done == true
      assert item.body == "some body"
      assert item.list_id == list_id
    end

    test "delete_item/1 deletes the item" do
      item = insert(:item)
      assert {:ok, %Item{}} = ToDo.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> ToDo.get_item!(item.id) end
    end
  end
end
