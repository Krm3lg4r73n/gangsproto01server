alias GangsServer.Messaging

defmodule Messaging.EventManager do
  def child_spec do
    import Supervisor.Spec
    worker(GenEvent, [[name: __MODULE__]])
  end

  def register(handler, state \\ nil), do: GenEvent.add_handler(__MODULE__, handler, state)

  def fire_message(%Messaging.Message{} = message) do
    GenEvent.notify(__MODULE__, {:message, message})
  end

  def refire(event) do
    GenEvent.notify(__MODULE__, event)
  end
end
