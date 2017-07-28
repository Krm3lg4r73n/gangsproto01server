require Logger
alias GangsServer.{User, Messaging}

defmodule User.LogHandler do
  use GenEvent

  def handle_event({:message, %Messaging.Message{message: message}}, _state) do
    Logger.debug "User: Received #{inspect(message)}"
    {:ok, nil}
  end

  def handle_event({:connected, conn}, _state) do
    Logger.debug "User: Connected #{inspect(conn)}"
    {:ok, nil}
  end

  def handle_event({:disconnected, conn}, _state) do
    Logger.debug "User: Disconnected #{inspect(conn)}"
    {:ok, nil}
  end
end
