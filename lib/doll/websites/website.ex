defmodule Doll.Websites.Website do
  use Ecto.Schema
  import Ecto.Changeset

  schema "websites" do
    field :name, :string
    has_many :stickers, Doll.Websites.Sticker, foreign_key: :website_id

    timestamps()
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
