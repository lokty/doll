defmodule DollWeb.WebsiteLive.Show do
  use DollWeb, :live_view

  alias Doll.Websites

  def mount(_params, _session, socket) do
    Websites.subscribe()
    {
      :ok,
      socket
      |> assign(:active_sticker, nil)
      |> assign(:drag_origin, nil)
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
    Websites.create_sticker(%{
      x: 100,
      y: 100,
      website_id: socket.assigns.website.id
    })
    {:noreply, socket}
  end

  def handle_event("delete_sticker", %{"id" => id}, socket) do
    Websites.delete_sticker_by_id(id)
    # new_stickers = Enum.filter(socket.assigns.stickers, fn old_sticker ->
    #   id != old_sticker.id
    # end)
    # {:noreply, socket |> assign(:stickers, new_stickers)}
    {:noreply, socket}
  end

  def handle_event("started_drag", %{"id" => sticker_id, "clientX" => client_x, "clientY" => client_y}, socket) do
    if !socket.assigns.active_sticker && sticker_id do
      sticker = Websites.get_sticker!(sticker_id)
      drag_origin = %{x: client_x, y: client_y}
      {
        :noreply,
        socket
        |> assign(:active_sticker, sticker)
        |> assign(:drag_origin, drag_origin)
      }
    else
      {:noreply, socket}
    end
  end

  def handle_event("stopped_drag", _, socket) do
    active_sticker = socket.assigns.active_sticker
    if active_sticker do
      new_sticker = Enum.find(socket.assigns.stickers, nil, fn sticker ->
        active_sticker.id == sticker.id
      end)
      if active_sticker do
        attrs = %{
          x: new_sticker.x,
          y: new_sticker.y
        }
        Websites.update_sticker(active_sticker, attrs)

        {
          :noreply,
          socket
          |> assign(:active_sticker, nil)
          |> assign(:drag_origin, nil)
        }
      else
        {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event(
    "drag_move",
    %{
      "clientX" => client_x,
      "clientY" => client_y
    },
    socket
  ) do
    active_sticker = socket.assigns.active_sticker
    if active_sticker do
      drag_origin = socket.assigns.drag_origin
      shift_x = drag_origin.x - client_x
      shift_y = drag_origin.y - client_y

      sticker = socket.assigns.active_sticker
      attrs = %{
        x: sticker.x - shift_x,
        y: sticker.y - shift_y,
      }

      new_sticker = sticker
        |> struct(%{x: attrs.x})
        |> struct(%{y: attrs.y})

      new_stickers =
        socket.assigns.stickers
        |> Enum.reduce([], fn old_sticker, acc ->
          if new_sticker.id == old_sticker.id do
            [new_sticker | acc]
          else
            [old_sticker | acc]
          end
        end)

      {
        :noreply,
        socket
        |> assign(:stickers, new_stickers)
      }
    else
      {:noreply, socket}
    end
  end

  defp page_title(:show), do: "Show Website"
  defp page_title(:edit), do: "Edit Website"

  def handle_info({Websites, [:sticker, _], _}, socket) do
    website = Websites.get_website!(socket.assigns.website.id)

    {:noreply, assign(socket, website: website, stickers: website.stickers)}
  end
end
