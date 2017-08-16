require Logger
alias GangsServer.Game

defmodule Game.UserSystem.Logger do
  def handle_message(message, user_pid) do
    Logger.info "Received #{inspect(message)} from user #{inspect(user_pid)}"
  end
  def handle_attach(user_pid) do
    Logger.info "Logger attached to user #{inspect(user_pid)}"
  end

  def handle_detach(user_pid) do
    Logger.info "Logger detached from user #{inspect(user_pid)}"
  end
end
