alias GangsServer.Store

defmodule Store.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      supervisor(Store.Repo, []),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
