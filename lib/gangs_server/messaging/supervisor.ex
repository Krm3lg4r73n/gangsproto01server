alias GangsServer.Messaging

defmodule Messaging.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Messaging.EventManager.child_spec,
      worker(Messaging.Initializer, [[name: Messaging.Initializer]])
    ]

    supervise(children, strategy: :rest_for_one)
  end

end
