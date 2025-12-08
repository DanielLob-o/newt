defmodule NewtTerrariumWeb.DashboardLive do
  use NewtTerrariumWeb, :live_view
  alias Terrarium.Terrarium

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(NewtTerrarium.PubSub, "devices")
    # Mount the current devices
    {:ok, assign(socket, :devices, Terrarium.get_state())}
  end

  def handle_info({:terrarium_updated, new_state}, socket) do
    {:noreply, assign(socket, :devices, new_state)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="min-h-screen bg-gray-50 p-10">
        <div class="max-w-7xl mx-auto">
          <h1 class="text-2xl font-bold text-gray-900 mb-6">Device Registry</h1>

          <div class="bg-white shadow-sm rounded-lg border border-gray-200 overflow-hidden">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Device ID</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Last Seen</th>
                  <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Current Attributes</th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr :for={{device_id, device} <- sort_devices(@devices)}>

                  <td class="px-6 py-4 whitespace-nowrap">
                    <div class="flex items-center">
                      <span class={["h-3 w-3 rounded-full mr-2", if(device.connected, do: "bg-green-500 animate-pulse", else: "bg-gray-400")]}></span>
                      <span class={["text-sm font-medium", if(device.connected, do: "text-green-700", else: "text-gray-500")]}>
                        <%= if device.connected, do: "Online", else: "Offline" %>
                      </span>
                    </div>
                  </td>

                  <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">
                    <%= device_id %>
                  </td>

                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 font-mono">
                    <%= format_time(device.last_seen) %>
                  </td>

                  <td class="px-6 py-4 text-sm text-gray-600">
                    <div class="flex flex-wrap gap-2">
                      <%= for {k, v} <- device.attrs do %>
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded text-xs font-medium bg-blue-100 text-blue-800">
                          <%= k %>: <%= format_val(v) %>
                        </span>
                      <% end %>
                    </div>
                  </td>

                </tr>
                <tr :if={map_size(@devices) == 0}>
                  <td colspan="4" class="px-6 py-10 text-center text-gray-500">
                    No devices connected yet. Use Postman to connect!
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp sort_devices(devices) do
    # Sort online devices to the top
    Enum.sort_by(devices, fn {_id, device} -> device.connected != true end)
  end

  defp format_time(nil), do: "--"
  defp format_time(dt), do: Calendar.strftime(dt, "%H:%M:%S UTC")

  defp format_val(v) when is_float(v), do: Float.round(v, 2)
  defp format_val(v), do: inspect(v)
end
