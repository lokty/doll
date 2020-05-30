defmodule DollWeb.StickerLive.FormComponent do
  use DollWeb, :live_component

  alias Doll.Websites

  @impl true
  def update(%{sticker: sticker} = assigns, socket) do
    changeset = Websites.change_sticker(sticker)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"sticker" => sticker_params}, socket) do
    changeset =
      socket.assigns.sticker
      |> Websites.change_sticker(sticker_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"sticker" => sticker_params}, socket) do
    save_sticker(socket, socket.assigns.action, sticker_params)
  end

  defp save_sticker(socket, :edit, sticker_params) do
    case Websites.update_sticker(socket.assigns.sticker, sticker_params) do
      {:ok, _sticker} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sticker updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_sticker(socket, :new, sticker_params) do
    case Websites.create_sticker(sticker_params) do
      {:ok, _sticker} ->
        {:noreply,
         socket
         |> put_flash(:info, "Sticker created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
