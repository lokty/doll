defmodule Doll.Repo.Migrations.CreateStickers do
  use Ecto.Migration

  def change do
    create table(:stickers) do
      add :x, :integer
      add :y, :integer
      add :type, :string
      add :parent_id, references(:stickers, on_delete: :nothing)
      add :website_id, references(:websites, on_delete: :nothing)

      timestamps()
    end
    create index(:stickers, [:parent_id])
    create index(:stickers, [:website_id])
  end
end
