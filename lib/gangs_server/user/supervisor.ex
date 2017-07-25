alias GangsServer.User

defmodule User.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      worker(User.Initializer, [[name: User.Initializer]]),
      worker(User.ConnectionRegistry, [[name: User.ConnectionRegistry]]),
      worker(User.UserRegistry, [[name: User.UserRegistry]]),
      supervisor(User.Process.Supervisor, [[name: User.Process.Supervisor]]),
    ]

    supervise(children, strategy: :rest_for_one)
  end

end
