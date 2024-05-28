defmodule Backend.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :body, :string
      add :done, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:list_id])
  end
end
