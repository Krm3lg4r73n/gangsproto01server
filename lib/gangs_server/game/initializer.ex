alias GangsServer.{Auth, Game}

defmodule Game.Initializer do
  use GenServer

  @message_handler [
    Game.LogHandler,
    Game.LobbyHandler,
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
      &Auth.EventManager.register/1
    )
  end
end
