defmodule BackendWeb.ListControllerTest do
  use BackendWeb.ConnCase

  import Backend.Factory

  @create_attrs %{
    name: "Some list"
  }

  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show" do
    setup [:create_list_with_items]

    test "renders list when list_id is known", %{conn: conn, list: %{id: id}} do
      num_items = 3
      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "name" => "Some list",
               "items" => items
             } = json_response(conn, 200)["data"]

      assert length(items) == num_items
    end
  end

  describe "create list" do
    test "renders list without items", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", list: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "name" => "Some list",
               "items" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", list: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      list = Backend.ToDo.get_list!(id)
      _ = insert_list(3, :item, %{body: "Some body", done: false, list: list})

      conn = get(conn, ~p"/api/lists/#{id}")

      assert %{
               "id" => ^id,
               "name" => "Some list",
               "items" => items
             } = json_response(conn, 200)["data"]

      assert length(items) == 3
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/lists", list: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_list_with_items(_) do
    list = insert(:list)
    _items = insert_list(3, :item, %{body: "Some body", done: false, list: list})
    %{list: list}
  end
end
