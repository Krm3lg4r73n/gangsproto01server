alias GangsServer.Messaging

defmodule Messaging.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(Messaging.ConnectionState, [[name: Messaging.ConnectionState]]),
      worker(Messaging.Pipeline, [[name: Messaging.Pipeline]]),
    ]

    supervise(children, strategy: :rest_for_one)
  end

end
