defmodule Doll.Websites.Sticker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stickers" do
    field :type, :string
    field :background_color, :string
    field :x, :integer
    field :y, :integer
    field :width, :integer
    field :height, :integer
    belongs_to :parent, Doll.Websites.Sticker
    belongs_to :website, Doll.Websites.Website, references: :id, foreign_key: :website_id
    has_many :children, Doll.Websites.Sticker, foreign_key: :sticker_id

    timestamps()
  end

  def changeset(sticker, attrs) do
    sticker
    |> cast(attrs, [:x, :y, :type, :parent_id, :website_id, :width, :height, :background_color])
    |> validate_required([:x, :y])
  end
end
