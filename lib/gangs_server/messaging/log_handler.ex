require Logger
alias GangsServer.Messaging

defmodule Messaging.LogHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    Logger.debug "Messaging: Received #{inspect(message)}"
    {:ok, nil}
  end

  def handle_event({:connected, connection}, _state) do
    Logger.debug "Messaging: Connected #{inspect(connection)}"
    {:ok, nil}
  end

  def handle_event({:disconnected, connection}, _state) do
    Logger.debug "Messaging: Disconnected #{inspect(connection)}"
    {:ok, nil}
  end
end
