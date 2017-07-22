alias GangsServer.{Auth, Store}

defmodule Auth.EventManager do
  def child_spec do
    import Supervisor.Spec
    worker(GenEvent, [[name: __MODULE__]])
  end

  def register(handler, state \\ nil), do: GenEvent.add_handler(__MODULE__, handler, state)

  def fire_message(%Auth.Message{} = message) do
    GenEvent.notify(__MODULE__, {:message, message})
  end

  def fire_user_connected(%Store.Schemas.User{} = user) do
    GenEvent.notify(__MODULE__, {:connected, user})
  end

  def fire_user_disconnected(%Store.Schemas.User{} = user) do
    GenEvent.notify(__MODULE__, {:disconnected, user})
  end
end
