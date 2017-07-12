require Logger
alias GangsServer.{Messaging, Message}

defmodule Messaging.Handler do
  def handle(%Message.User{name: name}) do
    Logger.info "User '#{name}' connected"
  end

  def handle(_), do: :ok
end
