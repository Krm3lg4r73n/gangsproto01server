require Logger
alias GangsServer.Auth

defmodule Auth.LogHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    Logger.debug "Auth: Received #{inspect(message)}"
    {:ok, nil}
  end

  def handle_event({:connected, conn}, _state) do
    Logger.debug "Auth: Connected #{inspect(conn)}"
    {:ok, nil}
  end

  def handle_event({:disconnected, conn}, _state) do
    Logger.debug "Auth: Disconnected #{inspect(conn)}"
    {:ok, nil}
  end
end
