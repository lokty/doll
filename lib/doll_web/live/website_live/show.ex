defmodule DollWeb.WebsiteLive.Show do
  use DollWeb, :live_view

  alias Doll.Websites

  def mount(_params, _session, socket) do
    Websites.subscribe()
    {
      :ok,
      socket
      |> assign(:moving_sticker, nil)
      |> assign(:drag_origin_x, 0)
      |> assign(:drag_origin_y, 0)
    }
  end

  def handle_params(%{"id" => id}, _, socket) do
    website = Websites.get_website!(id)
    stickers = website.stickers

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:website, website)
     |> assign(:stickers, stickers)
    }
  end

  def handle_event("add_sticker", _, socket) do
    Websites.create_sticker(%{x: 100, y: 100, website_id: socket.assigns.website.id})
    {:noreply, socket}
  end

  def handle_event("started_drag", %{"id" => sticker_id}, socket) do
    {:noreply, socket |> assign(:moving_sticker, sticker_id)}
  end

  def handle_event("stopped_drag", %{"id" => sticker_id}, socket) do
    {:noreply, socket |> assign(:moving_sticker, nil)}
  end

  def handle_event("drag_move", %{"id" => sticker_id, "movementX" => movement_x, "movementY" => movement_y}, socket) do
    if socket.assigns.moving_sticker do
      sticker = Websites.get_sticker!(sticker_id)
      attrs = %{
        x: sticker.x + movement_x,
        y: sticker.y + movement_y,
      }
      case Websites.update_sticker(sticker, attrs) do
        {:ok, sticker} ->
          new_stickers =
            socket.assigns.stickers
            |> Enum.reduce([], fn old_sticker, acc ->
              if sticker.id == old_sticker.id do
                [sticker | acc]
              else
                [old_sticker | acc]
              end
            end)
          {:noreply, socket |> assign(:stickers, new_stickers)}

        {:error, _changeset} ->
          {:noreply, socket}
        true -> socket
      end
    else
      {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Website"
  defp page_title(:edit), do: "Edit Website"

  def handle_info({Websites, [:sticker, _], _}, socket) do
    website = Websites.get_website!(socket.assigns.website.id)

    {:noreply, assign(socket, website: website)}
  end
end
