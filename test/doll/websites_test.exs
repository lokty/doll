defmodule Doll.WebsitesTest do
  use Doll.DataCase

  alias Doll.Websites

  describe "websites" do
    alias Doll.Websites.Website

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def website_fixture(attrs \\ %{}) do
      {:ok, website} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Websites.create_website()

      website
    end

    test "list_websites/0 returns all websites" do
      website = website_fixture()
      assert Websites.list_websites() == [website]
    end

    test "get_website!/1 returns the website with given id" do
      website = website_fixture()
      assert Websites.get_website!(website.id) == website
    end

    test "create_website/1 with valid data creates a website" do
      assert {:ok, %Website{} = website} = Websites.create_website(@valid_attrs)
      assert website.name == "some name"
    end

    test "create_website/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_website(@invalid_attrs)
    end

    test "update_website/2 with valid data updates the website" do
      website = website_fixture()
      assert {:ok, %Website{} = website} = Websites.update_website(website, @update_attrs)
      assert website.name == "some updated name"
    end

    test "update_website/2 with invalid data returns error changeset" do
      website = website_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_website(website, @invalid_attrs)
      assert website == Websites.get_website!(website.id)
    end

    test "delete_website/1 deletes the website" do
      website = website_fixture()
      assert {:ok, %Website{}} = Websites.delete_website(website)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_website!(website.id) end
    end

    test "change_website/1 returns a website changeset" do
      website = website_fixture()
      assert %Ecto.Changeset{} = Websites.change_website(website)
    end
  end

  describe "stickers" do
    alias Doll.Websites.Sticker

    @valid_attrs %{type: "some type", x: 120.5, y: 120.5}
    @update_attrs %{type: "some updated type", x: 456.7, y: 456.7}
    @invalid_attrs %{type: nil, x: nil, y: nil}

    def sticker_fixture(attrs \\ %{}) do
      {:ok, sticker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Websites.create_sticker()

      sticker
    end

    test "list_stickers/0 returns all stickers" do
      sticker = sticker_fixture()
      assert Websites.list_stickers() == [sticker]
    end

    test "get_sticker!/1 returns the sticker with given id" do
      sticker = sticker_fixture()
      assert Websites.get_sticker!(sticker.id) == sticker
    end

    test "create_sticker/1 with valid data creates a sticker" do
      assert {:ok, %Sticker{} = sticker} = Websites.create_sticker(@valid_attrs)
      assert sticker.type == "some type"
      assert sticker.x == 120.5
      assert sticker.y == 120.5
    end

    test "create_sticker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Websites.create_sticker(@invalid_attrs)
    end

    test "update_sticker/2 with valid data updates the sticker" do
      sticker = sticker_fixture()
      assert {:ok, %Sticker{} = sticker} = Websites.update_sticker(sticker, @update_attrs)
      assert sticker.type == "some updated type"
      assert sticker.x == 456.7
      assert sticker.y == 456.7
    end

    test "update_sticker/2 with invalid data returns error changeset" do
      sticker = sticker_fixture()
      assert {:error, %Ecto.Changeset{}} = Websites.update_sticker(sticker, @invalid_attrs)
      assert sticker == Websites.get_sticker!(sticker.id)
    end

    test "delete_sticker/1 deletes the sticker" do
      sticker = sticker_fixture()
      assert {:ok, %Sticker{}} = Websites.delete_sticker(sticker)
      assert_raise Ecto.NoResultsError, fn -> Websites.get_sticker!(sticker.id) end
    end

    test "change_sticker/1 returns a sticker changeset" do
      sticker = sticker_fixture()
      assert %Ecto.Changeset{} = Websites.change_sticker(sticker)
    end
  end
end
