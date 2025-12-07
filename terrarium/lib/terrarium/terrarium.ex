defmodule Terrarium.Terrarium do
  use GenServer

  # Client API (Public Interface)
  # Start the GenServer
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Channels call here to update data
  def update_attributes(group_id, pid, attrs) do
    GenServer.cast(__MODULE__, {:update_attributes, group_id, pid, attrs})
  end

  # (for debugging)
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  # --- Server Callbacks (Internal Logic) ---

  @impl true
  def init(_) do
    # The initial state is an empty map %{}
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:update_attributes, group_id, pid, new_attrs}, state) do
    # Get the map of devices for this group (default to empty map)

    group_devices = Map.get(state, group_id, %{})

    # Get the specific device's CURRENT attributes (default to empty map)
    current_device_attrs = Map.get(group_devices, pid, %{})

    # MERGE the new attributes over the old ones (Patching)
    updated_device_attrs = Map.merge(current_device_attrs, new_attrs)

    # Update the group map
    updated_group = Map.put(group_devices, pid, updated_device_attrs)

    # Update the global state
    new_state = Map.put(state, group_id, updated_group)

    # Optional: Print to console to prove it works
    IO.inspect(new_state, label: "Terrarium State Updated")

    Phoenix.PubSub.broadcast(
      NewtTerrarium.PubSub,
      "dashboard",
      {:terrarium_updated, new_state}
    )

    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
