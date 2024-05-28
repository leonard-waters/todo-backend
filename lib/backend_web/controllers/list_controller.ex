defmodule BackendWeb.ListController do
  use BackendWeb, :controller

  alias Backend.ToDo
  alias Backend.ToDo.List

  action_fallback BackendWeb.FallbackController

  def create(conn, %{"list" => list_params}) do
    with {:ok, %List{} = list} <- ToDo.create_list(list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/lists/#{list.id}")
      |> render(:show, list: list)
    end
  end

  def show(conn, %{"id" => id}) do
    with %List{} = list <- ToDo.get_list!(id) do
      render(conn, :show, list: list)
    end
  end
end
