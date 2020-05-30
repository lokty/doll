defmodule Doll.Websites do

  @topic inspect(__MODULE__)
  @moduledoc """
  The Websites context.
  """

  import Ecto.Query, warn: false
  alias Doll.Repo

  alias Doll.Websites.Website

  @doc """
  Returns the list of websites.

  ## Examples

      iex> list_websites()
      [%Website{}, ...]

  """
  def list_websites do
    Repo.all(Website)
  end

  @doc """
  Gets a single website.

  Raises `Ecto.NoResultsError` if the Website does not exist.

  ## Examples

      iex> get_website!(123)
      %Website{}

      iex> get_website!(456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(id) do
    (
      from w in Website,
      where: w.id == ^id,
      preload: [:stickers],
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}) do
    %Website{}
    |> Website.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%Website{} = website, attrs) do
    website
    |> Website.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website) do
    Repo.delete(website)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{data: %Website{}}

  """
  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end

  alias Doll.Websites.Sticker

  @doc """
  Returns the list of stickers.

  ## Examples

      iex> list_stickers()
      [%Sticker{}, ...]

  """
  def list_stickers do
    Repo.all(Sticker)
  end

  @doc """
  Gets a single sticker.

  Raises `Ecto.NoResultsError` if the Sticker does not exist.

  ## Examples

      iex> get_sticker!(123)
      %Sticker{}

      iex> get_sticker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sticker!(id), do: Repo.get!(Sticker, id)

  @doc """
  Creates a sticker.

  ## Examples

      iex> create_sticker(%{field: value})
      {:ok, %Sticker{}}

      iex> create_sticker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sticker(attrs \\ %{}) do
    %Sticker{}
    |> Sticker.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:sticker, :created])
  end

  @doc """
  Updates a sticker.

  ## Examples

      iex> update_sticker(sticker, %{field: new_value})
      {:ok, %Sticker{}}

      iex> update_sticker(sticker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sticker(%Sticker{} = sticker, attrs) do
    sticker
    |> Sticker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sticker.

  ## Examples

      iex> delete_sticker(sticker)
      {:ok, %Sticker{}}

      iex> delete_sticker(sticker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sticker(%Sticker{} = sticker) do
    Repo.delete(sticker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sticker changes.

  ## Examples

      iex> change_sticker(sticker)
      %Ecto.Changeset{data: %Sticker{}}

  """
  def change_sticker(%Sticker{} = sticker, attrs \\ %{}) do
    Sticker.changeset(sticker, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Doll.PubSub, @topic)
  end

  defp broadcast_change({:ok, result}, event) do
    Phoenix.PubSub.broadcast(Doll.PubSub, @topic, {__MODULE__, event, result})
    IO.inspect(event, label: "event broadcasted")

    {:ok, result}
  end
end
