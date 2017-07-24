alias GangsServer.{Messaging, User}

defmodule User.Initializer do
  use GenServer

  @message_handler [
    User.LogHandler,
    User.AuthHandler,
  ]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(_) do
    register_handlers()
    {:ok, nil}
  end

  defp register_handlers do
    Enum.each(
      @message_handler,
      &Messaging.EventManager.register/1
    )
  end
end
