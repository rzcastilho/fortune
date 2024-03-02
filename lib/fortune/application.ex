defmodule Fortune.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FortuneWeb.Telemetry,
      Fortune.Repo,
      {DNSCluster, query: Application.get_env(:fortune, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Fortune.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Fortune.Finch},
      # Start a worker by calling: Fortune.Worker.start_link(arg)
      # {Fortune.Worker, arg},
      # Start to serve requests, typically the last entry
      FortuneWeb.Endpoint,
      {DynamicSupervisor, strategy: :one_for_one, name: Fortune.DynamicStreamsSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fortune.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FortuneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
