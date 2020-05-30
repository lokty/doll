defmodule Doll.Repo.Migrations.AddNewFieldsToStickers do
  use Ecto.Migration

  def change do
    alter table(:stickers) do
      add :background_color, :string
      add :width, :integer
      add :height, :integer
    end
  end
end
