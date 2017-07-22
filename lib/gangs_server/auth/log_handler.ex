require Logger
alias GangsServer.Auth

defmodule Auth.LogHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    Logger.debug "Auth: Received #{inspect(message)}"
    {:ok, nil}
  end

  def handle_event({:connected, connection}, _state) do
    Logger.debug "Auth: Connected #{inspect(connection)}"
    {:ok, nil}
  end

  def handle_event({:disconnected, connection}, _state) do
    Logger.debug "Auth: Disconnected #{inspect(connection)}"
    {:ok, nil}
  end
end
