alias GangsServer.TCP

defmodule TCP.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      supervisor(TCP.Connection.Supervisor, [[name: TCP.Connection.Supervisor]]),
      worker(Task, [TCP.Server, :listen, [4040]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
