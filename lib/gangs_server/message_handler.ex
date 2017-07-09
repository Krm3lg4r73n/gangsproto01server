require Logger

defmodule GangsServer.MessageHandler do
  def handle(%GangsServer.Messages.User{name: name}) do
    Logger.info "User '#{name}' connected"
  end

  def handle(_), do: :ok
end
