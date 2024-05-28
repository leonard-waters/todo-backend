defmodule BackendWeb.ItemController do
  use BackendWeb, :controller

  alias Backend.ToDo
  alias Backend.ToDo.Item

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"list_id" => list_id, "item" => item_params}) do
    updated_item_params = Map.put(item_params, "list_id", list_id)

    with {:ok, %Item{} = item} <- ToDo.create_item(updated_item_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lists/#{list_id}/items/#{item.id}")
      |> render(:show, item: item)
    end
  end

  def show(conn, %{"id" => id}) do
    with %Item{} = item <- ToDo.get_item!(id) do
      render(conn, :show, item: item)
    end
  end

  def mark_done(conn, %{"id" => id}) do
    %Item{} = item = ToDo.get_item!(id)

    with {:ok, %Item{} = item} <- ToDo.mark_item_done(item) do
      render(conn, :show, item: item)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = ToDo.get_item!(id)

    with {:ok, %Item{}} <- ToDo.delete_item(item) do
      send_resp(conn, :no_content, "")
    end
  end
end
