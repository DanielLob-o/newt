defmodule NewtTerrariumWeb.DeviceChannelTest do
  use NewtTerrariumWeb.ChannelCase

  alias Terrarium.Terrarium

  test "device joins and updates attributes" do
    # 1. Connect to the socket
    {:ok, _, socket} =
      NewtTerrariumWeb.UserSocket
      |> socket("user_id", %{})
      |> subscribe_and_join(NewtTerrariumWeb.DeviceChannel, "device:lobby")

    # 2. Simulate the device sending data
    payload = %{"id" => "test_device", "temp" => 50}
    push(socket, "update_attributes", payload)

    # 3. Wait a tiny bit for the GenServer to process (Cast is async)
    :timer.sleep(10)

    # 4. Check the Terrarium state directly
    state = Terrarium.get_state()
    IO.inspect(state, label: "Current Terrarium State")

    # 5. Assert that the data is really there
    assert state["group_1"]["test_device"]["temp"] == 50
  end
end
