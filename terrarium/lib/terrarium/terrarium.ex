defmodule Terrarium.Terrarium do
  use GenServer
  alias Terrarium.Device

  # --- Client API ---

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def update_device(device_id, attrs) do
    GenServer.cast(__MODULE__, {:update_device, device_id, attrs})
  end

  def disconnect_device(device_id) do
    GenServer.cast(__MODULE__, {:disconnect_device, device_id})
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  # --- Server Callbacks ---

  @impl true
  def init(_) do
    # State is just a flat map: %{ "device_abc" => %Device{...} }
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:update_device, device_id, new_attrs}, state) do
    # If exist, fetch, else create a new one
    device =
      case Map.get(state, device_id) do
        nil -> Device.new(device_id, new_attrs)
        existing -> existing
      end

    # Update attributes and timestamps
    updated_device = %{device |
      attrs: Map.merge(device.attrs, new_attrs),
      connected: true,
      last_seen: DateTime.utc_now()
    }

    # Update the global state map directly
    new_state = Map.put(state, device_id, updated_device)

    broadcast_update(new_state)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:disconnect_device, device_id}, state) do
    new_state =
      case Map.get(state, device_id) do
        nil ->
          state # Device didn't exist, do nothing

        device ->
          updated_device = %{device | connected: false, last_seen: DateTime.utc_now()}
          Map.put(state, device_id, updated_device)
      end

    broadcast_update(new_state)
    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  defp broadcast_update(state) do
    Phoenix.PubSub.broadcast(
      NewtTerrarium.PubSub,
      "devices",
      {:terrarium_updated, state}
    )
  end
end
