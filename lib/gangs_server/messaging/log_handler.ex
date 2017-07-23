require Logger
alias GangsServer.Messaging

defmodule Messaging.LogHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    Logger.debug "Messaging: Received #{inspect(message)}"
    {:ok, nil}
  end

  def handle_event({:connected, conn}, _state) do
    Logger.debug "Messaging: Connected #{inspect(conn)}"
    {:ok, nil}
  end

  def handle_event({:disconnected, conn}, _state) do
    Logger.debug "Messaging: Disconnected #{inspect(conn)}"
    {:ok, nil}
  end
end
