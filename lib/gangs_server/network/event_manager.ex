alias GangsServer.Network

defmodule Network.EventManager do
  def child_spec do
    import Supervisor.Spec
    worker(GenEvent, [[name: __MODULE__]])
  end

  def register(handler, state \\ nil), do: GenEvent.add_handler(__MODULE__, handler, state)

  def fire_message(%Network.Message{} = message) do
    GenEvent.notify(__MODULE__, {:message, message})
  end

  def fire_connect(conn) do
    GenEvent.notify(__MODULE__, {:connect, conn})
  end

  def fire_disconnect(conn) do
    GenEvent.notify(__MODULE__, {:disconnect, conn})
  end
end
