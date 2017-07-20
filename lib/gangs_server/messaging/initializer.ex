alias GangsServer.Messaging

defmodule Messaging.Initializer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(_) do
    register_listeners()
    {:ok, nil}
  end

  defp register_listeners do
    Messaging.Handler
    |> Messaging.EventManager.register
  end
end
