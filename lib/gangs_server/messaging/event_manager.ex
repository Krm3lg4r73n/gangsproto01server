alias GangsServer.Messaging

defmodule Messaging.EventManager do
  def child_spec do
    import Supervisor.Spec
    worker(GenEvent, [[name: __MODULE__]])
  end

  def register(handler, state \\ nil), do: GenEvent.add_handler(__MODULE__, handler, state)

  def fire(message), do: GenEvent.notify(__MODULE__, {:message, message})
end
