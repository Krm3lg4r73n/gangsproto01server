alias GangsServer.TCP

defmodule TCP.EventManager do
  def child_spec do
    import Supervisor.Spec
    worker(GenEvent, [[name: __MODULE__]])
  end

  def register(handler, state \\ nil), do: GenEvent.add_handler(__MODULE__, handler, state)

  def fire_message(%TCP.Message{} = message) do
    GenEvent.notify(__MODULE__, {:message, message})
  end

  def fire_connected(connection) do
    GenEvent.notify(__MODULE__, {:connected, connection})
  end

  def fire_disconnected(connection) do
    GenEvent.notify(__MODULE__, {:disconnected, connection})
  end
end
