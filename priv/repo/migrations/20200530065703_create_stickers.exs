defmodule Doll.Repo.Migrations.CreateStickers do
  use Ecto.Migration

  def change do
    create table(:stickers) do
      add :x, :integer
      add :y, :integer
      add :type, :string
      add :parent_id, references(:stickers)
      add :website_id, references(:websites)

      timestamps()
    end
    create index(:stickers, [:parent_id])
    create index(:stickers, [:website_id])
  end
end
