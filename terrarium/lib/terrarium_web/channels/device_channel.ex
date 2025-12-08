defmodule NewtTerrariumWeb.DeviceChannel do
  use NewtTerrariumWeb, :channel

  @impl true
  def join("device:" <> device_id, payload, socket) do
    if authorized?(payload) do
      # Store device_id in socket for later use
      socket = assign(socket, :device_id, device_id)
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    # Initial connection: just register the device ID
    Terrarium.Terrarium.update_device(socket.assigns.device_id, %{})
    {:noreply, socket}
  end

  @impl true
  def handle_in("update_attributes", payload, socket) do
    # Pass data to GenServer
    Terrarium.Terrarium.update_device(socket.assigns.device_id, payload)
    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    if socket.assigns[:device_id] do
      Terrarium.Terrarium.disconnect_device(socket.assigns.device_id)
    end
    :ok
  end

  defp authorized?(_payload), do: true
end
