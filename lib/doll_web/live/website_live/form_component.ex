defmodule DollWeb.WebsiteLive.FormComponent do
  use DollWeb, :live_component

  alias Doll.Websites

  @impl true
  def update(%{website: website} = assigns, socket) do
    changeset = Websites.change_website(website)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"website" => website_params}, socket) do
    changeset =
      socket.assigns.website
      |> Websites.change_website(website_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"website" => website_params}, socket) do
    save_website(socket, socket.assigns.action, website_params)
  end

  defp save_website(socket, :edit, website_params) do
    case Websites.update_website(socket.assigns.website, website_params) do
      {:ok, _website} ->
        {:noreply,
         socket
         |> put_flash(:info, "Website updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_website(socket, :new, website_params) do
    case Websites.create_website(website_params) do
      {:ok, _website} ->
        {:noreply,
         socket
         |> put_flash(:info, "Website created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
