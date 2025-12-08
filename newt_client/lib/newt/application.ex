defmodule Newt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Newt.Worker.start_link(arg)
      # {Newt.Worker, arg}
      {DynamicSupervisor, strategy: :one_for_one, name: Newt.BotSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Newt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
