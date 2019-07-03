defmodule Example.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

        children = [
          supervisor(Cluster.Supervisor, [topologies, [name: Example.ClusterSupervisor]]),
          supervisor(Example.Database, []),
          supervisor(ExampleWeb.Endpoint, []),
        ]

#    children = [
#      # Start the Ecto repository
#      #      Rumbl.Repo,
#      # Start the endpoint when the application starts
#      #      RumblWeb.Endpoint
#      # Starts a worker by calling: Rumbl.Worker.start_link(arg)
#      # {Rumbl.Worker, arg},
#      supervisor(Example.Database, []),
#      supervisor(ExampleWeb.Endpoint, [])
#    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    ExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
