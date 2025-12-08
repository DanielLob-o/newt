defmodule Newt do
  @moduledoc """
  Command center for spawning IoT bots.
  """

  def spawn_bot(device_id) do
    # Start the device under our DynamicSupervisor
    DynamicSupervisor.start_child(Newt.BotSupervisor, {Newt.Device, device_id})
  end

  def spawn_fleet(count) do
    1..count
    |> Enum.each(fn i -> spawn_bot("sensor_#{i}") end)
  end
end
