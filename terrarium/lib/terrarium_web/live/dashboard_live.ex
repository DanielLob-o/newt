defmodule NewtTerrariumWeb.DashboardLive do
  use NewtTerrariumWeb, :live_view
  alias Terrarium.Terrarium

  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(NewtTerrarium.PubSub, "dashboard")
    {:ok, assign(socket, :groups, Terrarium.get_state())}
  end

  def handle_info({:terrarium_updated, new_state}, socket) do
    {:noreply, assign(socket, :groups, new_state)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-slate-50 p-8">
      <header class="mb-8 flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-extrabold text-slate-900 tracking-tight">Terrarium Monitor</h1>
          <p class="text-slate-500 mt-1">Live telemetry from connected devices</p>
        </div>
        <div class="px-3 py-1 bg-green-100 text-green-700 text-sm font-bold rounded-full flex items-center gap-2">
          <span class="relative flex h-3 w-3">
            <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
            <span class="relative inline-flex rounded-full h-3 w-3 bg-green-500"></span>
          </span>
          Live Connected
        </div>
      </header>

      <div :if={@groups == %{}} class="text-center py-20 border-2 border-dashed border-slate-300 rounded-xl">
        <p class="text-slate-500 text-lg">Waiting for devices...</p>
      </div>

      <div :for={{group_id, devices} <- @groups} class="mb-12">
        <h2 class="text-xl font-bold text-slate-700 mb-4 border-b pb-2 flex items-center gap-2">
          <span class="text-indigo-500">#</span> <%= group_id %>
        </h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          <div :for={{device_id, attrs} <- devices} class="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden hover:shadow-md transition-all">

            <div class="bg-slate-50 px-5 py-3 border-b border-slate-100 flex justify-between items-center">
              <h3 class="font-bold text-slate-800"><%= device_id %></h3>
              <div class="text-xs text-slate-400 font-mono">ID: <%= device_id %></div>
            </div>

            <div class="p-5">
              <dl class="grid grid-cols-2 gap-y-6 gap-x-4">
                <div :for={{key, val} <- attrs}>
                  <dt class="text-[10px] uppercase tracking-wider font-bold text-slate-500 mb-1">
                    <%= key %>
                  </dt>
                  <dd class="text-2xl font-semibold text-slate-900 leading-none">
                    <%= format_value(val) %>
                  </dd>
                </div>
              </dl>
            </div>

          </div>
        </div>
      </div>
    </div>
    """
  end

  # --- HELPER FUNCTIONS ---

  # Removes quotes from strings, rounds floats, handles booleans cleanly
  defp format_value(val) when is_binary(val), do: val
  defp format_value(val) when is_float(val), do: Float.round(val, 2)
  defp format_value(true), do: "ON"
  defp format_value(false), do: "OFF"
  defp format_value(nil), do: "--"
  defp format_value(val), do: inspect(val)
end
