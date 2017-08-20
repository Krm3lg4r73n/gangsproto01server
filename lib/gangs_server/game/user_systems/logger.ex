require Logger
alias GangsServer.Game

defmodule Game.UserSystem.Logger do
  def handle_message(message, _state) do
    Logger.info "Received #{inspect(message)} from user #{inspect(self())}"
  end
  def handle_attach() do
    Logger.info "Logger attached to user #{inspect(self())}"
  end

  def handle_detach(_state) do
    Logger.info "Logger detached from user #{inspect(self())}"
  end
end
