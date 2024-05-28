defmodule Backend.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
