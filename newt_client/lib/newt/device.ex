defmodule Newt.Device do
  use Slipstream

  def start_link(device_id) do
    # Name the process so we can find it easily in Observer
    Slipstream.start_link(__MODULE__, device_id, name: {:global, device_id})
  end

  @impl true
  def init(device_id) do
    # 1. Configuration
    config = [
      uri: "ws://localhost:4000/socket/websocket"
    ]

    # 2. Connect
    socket = connect!(config)

    # 3. Store ID in state
    {:ok, assign(socket, :device_id, device_id)}
  end

  @impl true
  def handle_connect(socket) do
    topic = "device:#{socket.assigns.device_id}"
    IO.puts("🔌 [#{socket.assigns.device_id}] Connected. Joining #{topic}...")

    socket = join(socket, topic)

    {:ok, socket}
  end

  @impl true
  def handle_join(topic, _payload, socket) do
    IO.puts("✅ [#{socket.assigns.device_id}] Joined #{topic}")

    # Start the data loop
    schedule_telemetry()
    {:ok, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    # 1. Create fake data
    data = %{
      "temperature" => Float.round(20.0 + :rand.uniform() * 10, 2),
      "battery" => :rand.uniform(100),
      "status" => "active"
    }

    push(socket, "device:#{socket.assigns.device_id}", "update_attributes", data)

    IO.puts("📡 [#{socket.assigns.device_id}] Sent data")

    schedule_telemetry()
    {:noreply, socket}
  end

  @impl true
  def handle_disconnect(_reason, socket) do
    IO.puts("⚠️  [#{socket.assigns.device_id}] Disconnected. Retrying...")
    # Slipstream handles the reconnection backoff automatically
    {:ok, socket}
  end

  defp schedule_telemetry do
    Process.send_after(self(), :tick, Enum.random(2000..5000))
  end
end
