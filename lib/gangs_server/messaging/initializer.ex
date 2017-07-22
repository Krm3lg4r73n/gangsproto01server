alias GangsServer.{TCP, Messaging}

defmodule Messaging.Initializer do
  use GenServer

  @message_handler [
    # Messaging.LogHandler,
    Messaging.ParsingHandler,
  ]

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    register_handlers()
    {:ok, nil}
  end

  defp register_handlers do
    Enum.each(@message_handler, &TCP.EventManager.register/1)
  end
end
