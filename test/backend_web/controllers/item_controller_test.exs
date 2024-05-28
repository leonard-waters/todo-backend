defmodule BackendWeb.ItemControllerTest do
  use BackendWeb.ConnCase

  import Backend.Factory

  @create_attrs %{
    done: false,
    body: "Some body"
  }

  @invalid_attrs %{done: nil, body: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create item" do
    setup [:create_list]

    test "renders item when data is valid and it returns in the list", %{
      conn: conn,
      list: %{id: list_id}
    } do
      conn = post(conn, ~p"/api/lists/#{list_id}/items", item: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, ~p"/api/lists/#{list_id}")

      assert [
               %{
                 "id" => ^id,
                 "body" => "Some body",
                 "done" => false,
                 "list_id" => ^list_id
               }
             ] = json_response(conn, 200)["data"]["items"]
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = post(conn, ~p"/api/lists/#{list.id}/items", item: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "mark item as done" do
    setup [:create_item]

    test "renders item after marking as done", %{conn: conn, item: %{id: id} = item} do
      conn = patch(conn, ~p"/api/lists/#{item.list_id}/items/#{id}/done")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lists/#{item.list_id}")

      assert [
               %{
                 "id" => ^id,
                 "body" => "Some body",
                 "done" => true
               }
             ] = json_response(conn, 200)["data"]["items"]
    end

    test "renders item when item is already done without an error", %{
      conn: conn,
      item: %{id: id} = item
    } do
      conn = patch(conn, ~p"/api/lists/#{item.list_id}/items/#{id}/done")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/lists/#{item.list_id}")

      assert [
               %{
                 "id" => ^id,
                 "body" => "Some body",
                 "done" => true
               }
             ] = json_response(conn, 200)["data"]["items"]

      conn = patch(conn, ~p"/api/lists/#{item.list_id}/items/#{id}/done")
      assert %{"id" => ^id} = json_response(conn, 200)["data"]
    end
  end

  describe "delete item" do
    setup [:create_item]

    test "deletes chosen item", %{conn: conn, item: item} do
      conn = delete(conn, ~p"/api/lists/#{item.list_id}/items/#{item.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/lists/#{item.list_id}/items/#{item.id}")
      end
    end
  end

  defp create_item(_) do
    list = insert(:list)
    item = insert(:item, list: list)
    %{item: item}
  end

  defp create_list(_) do
    %{list: insert(:list)}
  end
end
