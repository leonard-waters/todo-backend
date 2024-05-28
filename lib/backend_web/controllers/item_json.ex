defmodule BackendWeb.ItemJSON do
  alias Backend.ToDo.Item

  @doc """
  Renders a single item.
  """
  def show(%{item: item}) do
    %{data: data(item)}
  end

  def show(%{error: error}) do
    %{error: error}
  end

  defp data(%Item{} = item) do
    %{
      id: item.id,
      body: item.body,
      done: item.done,
      list_id: item.list_id
    }
  end
end
