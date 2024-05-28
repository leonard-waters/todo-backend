defmodule BackendWeb.ListJSON do
  alias Backend.ToDo.{Item, List}

  @doc """
  Renders a single list.
  """
  def show(%{list: list}) do
    %{data: data(list)}
  end

  def show(%{error: error}) do
    %{error: error}
  end

  defp data(%List{items: items} = list) when length(items) > 0 do
    %{
      id: list.id,
      name: list.name,
      items: for(item <- list.items, do: data(item))
    }
  end

  defp data(%List{} = list) do
    %{
      id: list.id,
      name: list.name,
      items: []
    }
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
