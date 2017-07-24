alias GangsServer.Game

defmodule Game.Initializer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    {:ok, nil}
  end
end
