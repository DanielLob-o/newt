defmodule NewtTerrarium.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NewtTerrariumWeb.Telemetry,
      NewtTerrarium.Repo,
      {DNSCluster, query: Application.get_env(:terrarium, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: NewtTerrarium.PubSub},
      # Start a worker by calling: NewtTerrarium.Worker.start_link(arg)
      # {NewtTerrarium.Worker, arg},
      # Start to serve requests, typically the last entry
      NewtTerrariumWeb.Endpoint,
      Terrarium.Terrarium
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NewtTerrarium.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NewtTerrariumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
