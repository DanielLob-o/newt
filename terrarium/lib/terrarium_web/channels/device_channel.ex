defmodule NewtTerrariumWeb.DeviceChannel do
  use NewtTerrariumWeb, :channel

  @impl true
  def join("device:" <> _device_id, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("update_attributes", payload, socket) do
    # Extract the device ID (using the unique socket ID or a payload field)
    # For now, assume the device sends its ID in the payload
    device_id = Map.get(payload, "id", "unknown_device")

    # CALL THE TERRARIUM
    Terrarium.Terrarium.update_attributes("group_1", device_id, payload)

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
