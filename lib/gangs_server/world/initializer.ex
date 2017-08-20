alias GangsServer.World

defmodule World.Initializer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    World.Manager.start_all()
    {:ok, nil}
  end
end
