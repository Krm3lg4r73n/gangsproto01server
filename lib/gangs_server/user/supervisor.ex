alias GangsServer.User

defmodule User.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(User.Initializer, [[name: User.Initializer]]),
      supervisor(User.Process.Supervisor, [[name: User.Process.Supervisor]]),
      worker(User.Registry, [[name: User.Registry]]),
    ]

    supervise(children, strategy: :rest_for_one)
  end

end
