defmodule DollWeb.StickerLiveTest do
  use DollWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Doll.Websites

  @create_attrs %{type: "some type", x: 120.5, y: 120.5}
  @update_attrs %{type: "some updated type", x: 456.7, y: 456.7}
  @invalid_attrs %{type: nil, x: nil, y: nil}

  defp fixture(:sticker) do
    {:ok, sticker} = Websites.create_sticker(@create_attrs)
    sticker
  end

  defp create_sticker(_) do
    sticker = fixture(:sticker)
    %{sticker: sticker}
  end

  describe "Index" do
    setup [:create_sticker]

    test "lists all stickers", %{conn: conn, sticker: sticker} do
      {:ok, _index_live, html} = live(conn, Routes.sticker_index_path(conn, :index))

      assert html =~ "Listing Stickers"
      assert html =~ sticker.type
    end

    test "saves new sticker", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.sticker_index_path(conn, :index))

      assert index_live |> element("a", "New Sticker") |> render_click() =~
               "New Sticker"

      assert_patch(index_live, Routes.sticker_index_path(conn, :new))

      assert index_live
             |> form("#sticker-form", sticker: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#sticker-form", sticker: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.sticker_index_path(conn, :index))

      assert html =~ "Sticker created successfully"
      assert html =~ "some type"
    end

    test "updates sticker in listing", %{conn: conn, sticker: sticker} do
      {:ok, index_live, _html} = live(conn, Routes.sticker_index_path(conn, :index))

      assert index_live |> element("#sticker-#{sticker.id} a", "Edit") |> render_click() =~
               "Edit Sticker"

      assert_patch(index_live, Routes.sticker_index_path(conn, :edit, sticker))

      assert index_live
             |> form("#sticker-form", sticker: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#sticker-form", sticker: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.sticker_index_path(conn, :index))

      assert html =~ "Sticker updated successfully"
      assert html =~ "some updated type"
    end

    test "deletes sticker in listing", %{conn: conn, sticker: sticker} do
      {:ok, index_live, _html} = live(conn, Routes.sticker_index_path(conn, :index))

      assert index_live |> element("#sticker-#{sticker.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sticker-#{sticker.id}")
    end
  end

  describe "Show" do
    setup [:create_sticker]

    test "displays sticker", %{conn: conn, sticker: sticker} do
      {:ok, _show_live, html} = live(conn, Routes.sticker_show_path(conn, :show, sticker))

      assert html =~ "Show Sticker"
      assert html =~ sticker.type
    end

    test "updates sticker within modal", %{conn: conn, sticker: sticker} do
      {:ok, show_live, _html} = live(conn, Routes.sticker_show_path(conn, :show, sticker))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sticker"

      assert_patch(show_live, Routes.sticker_show_path(conn, :edit, sticker))

      assert show_live
             |> form("#sticker-form", sticker: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#sticker-form", sticker: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.sticker_show_path(conn, :show, sticker))

      assert html =~ "Sticker updated successfully"
      assert html =~ "some updated type"
    end
  end
end
