defmodule Backend.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Backend.Repo

  def list_factory do
    %Backend.ToDo.List{
      name: "Some list"
    }
  end

  def item_factory do
    %Backend.ToDo.Item{
      body: "Some body",
      list: build(:list)
    }
  end

  def done_item_factory do
    struct!(item_factory(), %{done: true})
  end
end
