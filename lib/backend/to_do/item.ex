defmodule Backend.ToDo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :body, :string
    field :done, :boolean, default: false

    belongs_to :list, Backend.ToDo.List, foreign_key: :list_id, references: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:body, :done, :list_id])
    |> validate_required([:body, :done, :list_id])
  end
end
