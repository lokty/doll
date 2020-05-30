defmodule DollWeb.StickerLive.Show do
  use DollWeb, :live_view

  alias Doll.Websites

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sticker, Websites.get_sticker!(id))}
  end

  defp page_title(:show), do: "Show Sticker"
  defp page_title(:edit), do: "Edit Sticker"
end
