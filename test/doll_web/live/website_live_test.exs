defmodule DollWeb.WebsiteLiveTest do
  use DollWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Doll.Websites

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp fixture(:website) do
    {:ok, website} = Websites.create_website(@create_attrs)
    website
  end

  defp create_website(_) do
    website = fixture(:website)
    %{website: website}
  end

  describe "Index" do
    setup [:create_website]

    test "lists all websites", %{conn: conn, website: website} do
      {:ok, _index_live, html} = live(conn, Routes.website_index_path(conn, :index))

      assert html =~ "Listing Websites"
      assert html =~ website.name
    end

    test "saves new website", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.website_index_path(conn, :index))

      assert index_live |> element("a", "New Website") |> render_click() =~
               "New Website"

      assert_patch(index_live, Routes.website_index_path(conn, :new))

      assert index_live
             |> form("#website-form", website: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#website-form", website: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.website_index_path(conn, :index))

      assert html =~ "Website created successfully"
      assert html =~ "some name"
    end

    test "updates website in listing", %{conn: conn, website: website} do
      {:ok, index_live, _html} = live(conn, Routes.website_index_path(conn, :index))

      assert index_live |> element("#website-#{website.id} a", "Edit") |> render_click() =~
               "Edit Website"

      assert_patch(index_live, Routes.website_index_path(conn, :edit, website))

      assert index_live
             |> form("#website-form", website: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#website-form", website: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.website_index_path(conn, :index))

      assert html =~ "Website updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes website in listing", %{conn: conn, website: website} do
      {:ok, index_live, _html} = live(conn, Routes.website_index_path(conn, :index))

      assert index_live |> element("#website-#{website.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#website-#{website.id}")
    end
  end

  describe "Show" do
    setup [:create_website]

    test "displays website", %{conn: conn, website: website} do
      {:ok, _show_live, html} = live(conn, Routes.website_show_path(conn, :show, website))

      assert html =~ "Show Website"
      assert html =~ website.name
    end

    test "updates website within modal", %{conn: conn, website: website} do
      {:ok, show_live, _html} = live(conn, Routes.website_show_path(conn, :show, website))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Website"

      assert_patch(show_live, Routes.website_show_path(conn, :edit, website))

      assert show_live
             |> form("#website-form", website: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#website-form", website: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.website_show_path(conn, :show, website))

      assert html =~ "Website updated successfully"
      assert html =~ "some updated name"
    end
  end
end
