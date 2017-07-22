require Logger
alias GangsServer.Game

defmodule Game.LogHandler do
  use GenEvent

  def handle_event({:message, message}, _state) do
    Logger.debug "Game: Received #{inspect(message)}"
    {:ok, nil}
  end

  def handle_event({:connected, user}, _state) do
    Logger.debug "Game: Connected #{user}"
    {:ok, nil}
  end

  def handle_event({:disconnected, user}, _state) do
    Logger.debug "Game: Disconnected #{user}"
    {:ok, nil}
  end
end
