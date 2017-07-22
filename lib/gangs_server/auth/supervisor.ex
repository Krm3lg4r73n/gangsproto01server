alias GangsServer.Auth

defmodule Auth.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Auth.EventManager.child_spec(),
      worker(Auth.Initializer, [[name: Auth.Initializer]]),
      worker(Auth.Dictionary, [[name: Auth.Dictionary]]),
    ]

    supervise(children, strategy: :rest_for_one)
  end

end
